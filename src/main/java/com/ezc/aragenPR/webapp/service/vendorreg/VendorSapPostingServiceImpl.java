package com.ezc.aragenPR.webapp.service.vendorreg;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import com.ezc.aragenPR.webapp.dto.vendorreg.FinanceReviewFields;
import com.ezc.aragenPR.webapp.dto.vendorreg.SapValidationResult;
import com.ezc.aragenPR.webapp.dto.vendorreg.VendorRegistrationDetails;
import com.ezc.aragenPR.webapp.model.vendorreg.CustomerFormHeader;
import com.ezc.aragenPR.webapp.repository.vendorreg.CustomerFormHeaderRepository;
import com.ezc.aragenPR.webapp.service.shared.RFCReadSAPService;
import com.ezc.aragenPR.webapp.service.workflow.IWorkflowEngineService;
import com.sap.conn.jco.JCoDestination;
import com.sap.conn.jco.JCoFunction;
import com.sap.conn.jco.JCoParameterList;
import com.sap.conn.jco.JCoRepository;
import com.sap.conn.jco.JCoTable;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Service
public class VendorSapPostingServiceImpl implements IVendorSapPostingService {

    private static final String WF_DOC_TYPE = "VNR";

    @Autowired
    private RFCReadSAPService rfcReadSAPService;

    @Autowired
    private IVendorRegistrationService vendorRegistrationService;

    @Autowired
    private CustomerFormHeaderRepository customerFormHeaderRepository;

    @Autowired
    private IWorkflowEngineService workflowEngineService;

    @Override
    public SapValidationResult validateVendor(String docId) {
        CustomerFormHeader header = requireHeader(docId);
        VendorRegistrationDetails details = vendorRegistrationService.getVendorRegistrationDetails(docId);
        FinanceReviewFields finance = vendorRegistrationService.getFinanceFields(docId);

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
            log.error("SAP vendor validation failed for {}", docId, e);
            throw new RuntimeException("SAP vendor validation failed: " + e.getMessage(), e);
        }
    }

    @Override
    @Transactional
    public String postVendor(String docId, String actorUserId, String comments) {
        if (vendorRegistrationService.hasUnansweredQuery(docId)) {
            throw new IllegalStateException("Query has not been replied to this Vendor Registration. You cannot submit/approve Vendor Registration now.");
        }

        CustomerFormHeader header = requireHeader(docId);
        VendorRegistrationDetails details = vendorRegistrationService.getVendorRegistrationDetails(docId);
        FinanceReviewFields finance = vendorRegistrationService.getFinanceFields(docId);

        String vendorCode;
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
            vendorCode = expParam.getValue("E_VENDOR") == null ? null : String.valueOf(expParam.getValue("E_VENDOR"));
        } catch (Exception e) {
            log.error("SAP vendor creation failed for {}", docId, e);
            throw new RuntimeException("SAP vendor creation failed: " + e.getMessage(), e);
        }

        if (vendorCode == null || vendorCode.isBlank()) {
            throw new IllegalStateException("SAP did not return a vendor code for " + docId);
        }

        header.setSapCode(vendorCode);
        header.setStatus("POSTED");
        header.setModifiedBy(actorUserId);
        header.setModifiedOn(LocalDate.now());
        header.setNextParticipant("");
        customerFormHeaderRepository.save(header);

        workflowEngineService.markApproved(WF_DOC_TYPE, docId, actorUserId, comments);

        return vendorCode;
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

    private CustomerFormHeader requireHeader(String docId) {
        return customerFormHeaderRepository.findById(docId)
                .orElseThrow(() -> new IllegalArgumentException("Vendor registration not found: " + docId));
    }

    private String nullToEmpty(String s) {
        return s == null ? "" : s;
    }

    private boolean notBlank(String s) {
        return s != null && !s.isBlank();
    }
}
