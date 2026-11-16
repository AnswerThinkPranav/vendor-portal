package com.ezc.aragenPR.webapp.sap.vendor;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.ezc.aragenPR.webapp.dto.vendorreg.FinanceReviewFields;
import com.ezc.aragenPR.webapp.dto.vendorreg.SapValidationResult;
import com.ezc.aragenPR.webapp.dto.vendorreg.VendorRegistrationDetails;
import com.ezc.aragenPR.webapp.model.vendorreg.CustomerFormHeader;
import com.ezc.aragenPR.webapp.sap.SapIntegrationMode;
import com.ezc.aragenPR.webapp.sap.SapIntegrationModeConfig;
import com.ezc.aragenPR.webapp.sap.SapODataClient;
import com.ezc.aragenPR.webapp.sap.SapOperationCode;
import com.ezc.aragenPR.webapp.service.shared.RFCReadSAPService;
import com.fasterxml.jackson.databind.JsonNode;
import com.sap.conn.jco.JCoDestination;
import com.sap.conn.jco.JCoFunction;
import com.sap.conn.jco.JCoParameterList;
import com.sap.conn.jco.JCoRepository;
import com.sap.conn.jco.JCoTable;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * The actual SAP I/O for vendor creation/validation - moved out of the business-flow service
 * (see {@code service.vendorreg.VendorSapPostingServiceImpl}, which now only does docId lookups,
 * workflow transitions and status updates and calls this class for the SAP part). Switchable per
 * {@code sap.mode.VENDOR_CREATE}/{@code VENDOR_VALIDATE} (see {@link SapIntegrationModeConfig}):
 * {@code validateVendor}/{@code createVendor} resolve the effective mode and dispatch to either
 * {@code fmXxx} (today's {@code Z_RFC_VENDOR_VALIDATE}/{@code Z_RFC_VENDOR_CREATE} JCo calls,
 * unchanged) or {@code odataXxx} (the configured OData service, via {@link SapODataClient}).
 *
 * {@code Z_RFC_VENDOR_CREATE}'s own shape (a flat {@code IT_FILE} table with type-flagged rows,
 * not structured parameters) is genuinely custom - unlike {@code ZBAPI_PR_CREATE} elsewhere in
 * this app, this is NOT a thin wrapper around a standard BAPI, so the OData path below is a real
 * field-by-field re-mapping onto the standard shape, not a name swap.
 */
@Slf4j
@Component
public class VendorSapGateway implements IVendorSapGateway {

    @Autowired
    private RFCReadSAPService rfcReadSAPService;

    @Autowired
    private SapIntegrationModeConfig sapIntegrationModeConfig;

    @Autowired
    private SapODataClient sapODataClient;

    @Override
    public SapValidationResult validateVendor(String docId, CustomerFormHeader header,
            VendorRegistrationDetails details, FinanceReviewFields finance) {
        SapIntegrationMode mode = sapIntegrationModeConfig.effectiveMode(SapOperationCode.VENDOR_VALIDATE);
        log.info("[SAP] VENDOR_VALIDATE for {} via {}", docId, mode);
        return switch (mode) {
            case FM -> fmVendorValidation(docId, header, details, finance);
            case ODATA -> odataVendorValidation(docId, header, details, finance);
        };
    }

    @Override
    public String createVendor(String docId, CustomerFormHeader header, VendorRegistrationDetails details,
            FinanceReviewFields finance) {
        SapIntegrationMode mode = sapIntegrationModeConfig.effectiveMode(SapOperationCode.VENDOR_CREATE);
        log.info("[SAP] VENDOR_CREATE for {} via {}", docId, mode);
        return switch (mode) {
            case FM -> fmVendorRegistration(docId, header, details, finance);
            case ODATA -> odataVendorRegistration(docId, header, details, finance);
        };
    }

    // ---- FM (JCo / Z-RFC) ---------------------------------------------------------------------

    private SapValidationResult fmVendorValidation(String docId, CustomerFormHeader header,
            VendorRegistrationDetails details, FinanceReviewFields finance) {
        try {
            JCoDestination destination = rfcReadSAPService.getDestination();
            JCoRepository repository = destination.getRepository();
            JCoFunction function = repository.getFunction("Z_RFC_VENDOR_VALIDATE");
            if (function == null) {
                throw new IllegalStateException("Z_RFC_VENDOR_VALIDATE not found in SAP repository");
            }

            JCoTable vendTable = function.getTableParameterList().getTable("IM_DATA");
            appendVendorHeaderRow(vendTable, header, details, finance, "H");
            appendVendorBankRow(vendTable, header, details, finance);

            function.execute(destination);

            JCoTable retOut = function.getTableParameterList().getTable("EX_RETURN");
            List<String> messages = new ArrayList<>();
            if (retOut.getNumRows() > 0) {
                do {
                    messages.add(String.valueOf(retOut.getValue(3)));
                } while (retOut.nextRow());
            }
            return new SapValidationResult(messages.isEmpty(), messages);
        } catch (Exception e) {
            log.error("SAP (FM) vendor validation failed for {}", docId, e);
            throw new RuntimeException("SAP vendor validation failed: " + e.getMessage(), e);
        }
    }

    private String fmVendorRegistration(String docId, CustomerFormHeader header,
            VendorRegistrationDetails details, FinanceReviewFields finance) {
        try {
            JCoDestination destination = rfcReadSAPService.getDestination();
            JCoRepository repository = destination.getRepository();
            JCoFunction function = repository.getFunction("Z_RFC_VENDOR_CREATE");
            if (function == null) {
                throw new IllegalStateException("Z_RFC_VENDOR_CREATE not found in SAP repository");
            }

            JCoTable vendTable = function.getTableParameterList().getTable("IT_FILE");
            appendVendorHeaderRow(vendTable, header, details, finance, "H");
            appendVendorBankRow(vendTable, header, details, finance);

            function.execute(destination);

            JCoParameterList expParam = function.getExportParameterList();
            return expParam.getValue("E_VENDOR") == null ? null : String.valueOf(expParam.getValue("E_VENDOR"));
        } catch (Exception e) {
            log.error("SAP (FM) vendor creation failed for {}", docId, e);
            throw new RuntimeException("SAP vendor creation failed: " + e.getMessage(), e);
        }
    }

    // ---- OData ---------------------------------------------------------------------------
    // Service/entity name comes from sap.odata.service.VENDOR_CREATE / VENDOR_VALIDATE (default
    // API_SUPPLIER - "Supplier - Create" / A_Supplier entity, S/4HANA - see sap.properties for
    // the override). Confirm the real field names against the live client's own $metadata before
    // relying on this in production: every field path in buildSupplierODataPayload() is a
    // documented assumption until verified against that client's actual service.

    private SapValidationResult odataVendorValidation(String docId, CustomerFormHeader header,
            VendorRegistrationDetails details, FinanceReviewFields finance) {
        try {
            String service = requireODataService(SapOperationCode.VENDOR_VALIDATE);
            Map<String, Object> body = buildSupplierODataPayload(header, details, finance);
            // Validate-only: most Gateway Supplier services don't expose a dedicated "check"
            // verb - the common pattern is a dry-run create against a sandbox/test system, or a
            // custom validation function import if the client's Gateway exposes one. Left as an
            // explicit call so it fails loudly (not silently) until that target is confirmed.
            JsonNode response = sapODataClient.post(sapODataClient.getBaseUrl(),
                    "/" + service, "/" + service + "/A_Supplier?sap-ds-test=true", body);
            return new SapValidationResult(true, List.of("OData validate response: " + response));
        } catch (Exception e) {
            log.error("SAP (OData) vendor validation failed for {}", docId, e);
            throw new RuntimeException("SAP OData vendor validation failed: " + e.getMessage(), e);
        }
    }

    private String odataVendorRegistration(String docId, CustomerFormHeader header,
            VendorRegistrationDetails details, FinanceReviewFields finance) {
        try {
            String service = requireODataService(SapOperationCode.VENDOR_CREATE);
            Map<String, Object> body = buildSupplierODataPayload(header, details, finance);
            JsonNode response = sapODataClient.post(sapODataClient.getBaseUrl(),
                    "/" + service, "/" + service + "/A_Supplier", body);
            JsonNode supplierNode = response == null ? null : response.path("d").path("Supplier");
            return (supplierNode == null || supplierNode.isMissingNode()) ? null : supplierNode.asText();
        } catch (Exception e) {
            log.error("SAP (OData) vendor creation failed for {}", docId, e);
            throw new RuntimeException("SAP OData vendor creation failed: " + e.getMessage(), e);
        }
    }

    /** Fails loudly (not a guessed default) if this operation's OData service isn't configured. */
    private String requireODataService(String operationCode) {
        String service = sapIntegrationModeConfig.odataServiceName(operationCode);
        if (service == null) {
            throw new IllegalStateException("sap.odata.service." + operationCode + " is not configured - "
                    + "set it once the real service name is confirmed (Business Accelerator Hub or the "
                    + "client's own Gateway catalog), or switch sap.mode." + operationCode + "=FM");
        }
        return service;
    }

    /**
     * Field-by-field re-mapping of the same data {@link #appendVendorHeaderRow}/
     * {@link #appendVendorBankRow} send via FM, onto the standard API_SUPPLIER entity's
     * commonly-documented field names. Confirm every key below against the target client's
     * actual $metadata before relying on it - SAP releases vary in exactly which fields a given
     * Supplier OData service exposes.
     */
    private Map<String, Object> buildSupplierODataPayload(CustomerFormHeader header,
            VendorRegistrationDetails details, FinanceReviewFields finance) {
        var contact = details.getContact();
        var constitution = details.getConstitution();
        var msme = details.getMsme();
        var bank = details.getBank();

        Map<String, Object> payload = new LinkedHashMap<>();
        payload.put("CompanyCode", nullToEmpty(header.getExt1()));
        payload.put("PurchasingOrganization", nullToEmpty(header.getSalesOrg()));
        payload.put("SupplierAccountGroup", nullToEmpty(header.getVenGrp()));
        payload.put("SupplierName", nullToEmpty(header.getCustName()));
        payload.put("Country", nullToEmpty(contact.getCountry()));
        payload.put("StreetName", nullToEmpty(contact.getAddrsLine1()));
        payload.put("CityName", nullToEmpty(contact.getDistrictName()));
        payload.put("Region", nullToEmpty(contact.getState()));
        payload.put("PhoneNumber1", nullToEmpty(contact.getMobNum()));
        payload.put("FaxNumber", nullToEmpty(contact.getFax()));
        payload.put("TaxNumber3", nullToEmpty(constitution.getGstNumber()));
        payload.put("PaymentTerms", nullToEmpty(msme.getPaymntTerms()));
        payload.put("Currency", nullToEmpty(constitution.getPurOrdCurr()));
        payload.put("IncotermsClassification", nullToEmpty(constitution.getIncoTerms()));
        payload.put("IncotermsLocation1", nullToEmpty(constitution.getIncoTerms2()));
        payload.put("to_SupplierBank", List.of(Map.of(
                "BankCountryKey", nullToEmpty(contact.getCountry()),
                "BankNumber", nullToEmpty(bank.getRtgsCode()),
                "BankAccount", nullToEmpty(bank.getAccntNumber()),
                "AccountHolderName", nullToEmpty(header.getCustName())
        )));
        if (finance != null && notBlank(finance.whTaxCode()) && notBlank(finance.whTaxType())) {
            payload.put("WithholdingTaxCode", finance.whTaxCode());
            payload.put("WithholdingTaxType", finance.whTaxType());
        }
        return payload;
    }

    /**
     * First row of the SAP vendor-master table parameter - general/address/tax data.
     * Field-for-field mapping ported from ezPrePostVendorToSAP.jsp/ezPostVendorToSAP.jsp -
     * do not "clean up" or reorder without re-checking against those files, several of
     * these (e.g. WITHT/WT_WITHCD) map to differently-named legacy variables than the SAP
     * field name would suggest.
     */
    private void appendVendorHeaderRow(JCoTable vendTable, CustomerFormHeader header, VendorRegistrationDetails details,
            FinanceReviewFields finance, String chck) {
        var contact = details.getContact();
        var constitution = details.getConstitution();
        var msme = details.getMsme();

        vendTable.appendRow();
        vendTable.setValue("CHCK", chck);
        vendTable.setValue("BUKRS", nullToEmpty(header.getExt1()));
        vendTable.setValue("EKORG", nullToEmpty(header.getSalesOrg()));
        vendTable.setValue("KTOKK", nullToEmpty(header.getVenGrp()));
        vendTable.setValue("NAME1", nullToEmpty(header.getCustName()));
        vendTable.setValue("LAND1", nullToEmpty(contact.getCountry()));
        vendTable.setValue("SORTL", nullToEmpty(header.getCustName()));
        vendTable.setValue("STRAS", "EN");
        vendTable.setValue("STREET2", nullToEmpty(contact.getAddrsLine1()));
        vendTable.setValue("STREET3", nullToEmpty(contact.getAddrsLine2()));
        vendTable.setValue("ORT01", nullToEmpty(contact.getDistrictName()));
        vendTable.setValue("PSTLZ", "");
        vendTable.setValue("REGIO", nullToEmpty(contact.getState()));
        vendTable.setValue("SPRAS", "");
        vendTable.setValue("TELF1", nullToEmpty(contact.getMobNum()));
        vendTable.setValue("TELFX", nullToEmpty(contact.getFax()));
        vendTable.setValue("LFURL", nullToEmpty(contact.getEmail1()));
        vendTable.setValue("J_1ICSTNO", "");
        vendTable.setValue("J_1ILSTNO", "");
        vendTable.setValue("J_1ISERN", nullToEmpty(msme.getMsmeUdyogAdhrNo()));
        vendTable.setValue("J_1IEXCD", "");
        vendTable.setValue("J_1IEXRN", "");
        vendTable.setValue("J_1IEXRG", "");
        vendTable.setValue("J_1IEXDI", "");
        vendTable.setValue("J_1IEXCO", "");
        vendTable.setValue("J_1IVTYP", "");
        vendTable.setValue("J_1IEXCIVE", "");
        vendTable.setValue("J_1ISSIST", nullToEmpty(msme.getMsmeType()));
        vendTable.setValue("J_1IPANNO", nullToEmpty(constitution.getPanNumber()));
        vendTable.setValue("J_1IPANREF", nullToEmpty(constitution.getPanNumber()));
        vendTable.setValue("J_1IPANVALDT", "");
        vendTable.setValue("STCD3", nullToEmpty(constitution.getGstNumber()));
        vendTable.setValue("VEN_CLASS", nullToEmpty(constitution.getGstVendorClas()));
        vendTable.setValue("AKONT", finance == null ? "" : nullToEmpty(finance.reconAccount()));
        vendTable.setValue("ZTERM_LFB1", nullToEmpty(msme.getPaymntTerms()));
        vendTable.setValue("REPRF", "X");
        vendTable.setValue("QLAND", "IN");
        vendTable.setValue("WAERS", nullToEmpty(constitution.getPurOrdCurr()));
        vendTable.setValue("ZTERM_LFM1", nullToEmpty(msme.getPaymntTerms()));
        vendTable.setValue("INCO1", nullToEmpty(constitution.getIncoTerms()));
        vendTable.setValue("INCO2", nullToEmpty(constitution.getIncoTerms2()));
        vendTable.setValue("KALSK", "IN");
        vendTable.setValue("WEBRE", "X");
        vendTable.setValue("KZAUT", "X");
    }

    /** Second row - bank account + withholding-tax data. */
    private void appendVendorBankRow(JCoTable vendTable, CustomerFormHeader header, VendorRegistrationDetails details, FinanceReviewFields finance) {
        var bank = details.getBank();
        vendTable.appendRow();
        vendTable.setValue("BANKS", nullToEmpty(details.getContact().getCountry()));
        vendTable.setValue("BANKL", nullToEmpty(bank.getRtgsCode()));
        vendTable.setValue("BANKN", nullToEmpty(bank.getAccntNumber()));
        vendTable.setValue("KOINH", nullToEmpty(header.getCustName()));

        if (finance != null && notBlank(finance.whTaxCode()) && notBlank(finance.whTaxType())) {
            // Field names intentionally cross-mapped exactly as in the legacy JSP: WITHT<-whTaxCode, WT_WITHCD<-whTaxType.
            vendTable.setValue("WITHT", finance.whTaxCode());
            vendTable.setValue("WT_WITHCD", finance.whTaxType());
            vendTable.setValue("WT_SUBJCT", "X");
            vendTable.setValue("QSREC", nullToEmpty(finance.recType()));
        }
    }

    private String nullToEmpty(String s) {
        return s == null ? "" : s;
    }

    private boolean notBlank(String s) {
        return s != null && !s.isBlank();
    }
}
