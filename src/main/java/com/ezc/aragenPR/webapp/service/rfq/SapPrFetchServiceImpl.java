package com.ezc.aragenPR.webapp.service.rfq;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

import com.ezc.aragenPR.webapp.dto.rfq.PrLineItem;
import com.ezc.aragenPR.webapp.dto.rfq.PrSearchCriteria;
import com.ezc.aragenPR.webapp.service.shared.RFCReadSAPService;
import com.sap.conn.jco.JCoDestination;
import com.sap.conn.jco.JCoFunction;
import com.sap.conn.jco.JCoParameterList;
import com.sap.conn.jco.JCoRepository;
import com.sap.conn.jco.JCoTable;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Slf4j
@Service
public class SapPrFetchServiceImpl implements ISapPrFetchService {

    private static final DateTimeFormatter SAP_DATE = DateTimeFormatter.ofPattern("yyyyMMdd");

    @Autowired
    private RFCReadSAPService rfcReadSAPService;

    @Override
    public List<PrLineItem> fetchPurchaseRequisitions(PrSearchCriteria criteria, String buyerUserId) {
        try {
            return fetchFromSap(criteria);
        } catch (Throwable t) {
            // A missing sapjco3 native library (no live SAP connectivity in this environment -
            // see sap.properties) surfaces as ExceptionInInitializerError/UnsatisfiedLinkError,
            // which are Errors, not Exceptions - must be caught here too, or this fallback never runs.
            log.warn("[RFQ] SAP call to Z_EZ_GET_PRS failed (expected in an environment without a live SAP "
                    + "connection - see sap.properties) - returning example PRs (one per selected plant) so "
                    + "the RFQ flow can still be exercised end-to-end. Real error: {}", t.toString());
            return mockPrs(criteria, buyerUserId);
        }
    }

    /**
     * Real SAP call - see Vendor Portal/Includes/includes/iListPR.jsp for the legacy
     * equivalent. Mirrors the JCo calling convention already established in
     * PRController.editPR() (ZEZ_BAPI_PR_GETDETAIL): acquire the destination via
     * RFCReadSAPService, look up the function in the repository, populate SELECT-OPTIONS
     * range tables for each multi-select filter, execute, then parse REQUISITION_ITEMS.
     */
    private List<PrLineItem> fetchFromSap(PrSearchCriteria criteria) throws Exception {
        JCoDestination destination = rfcReadSAPService.getDestination();
        JCoRepository repository = destination.getRepository();
        JCoFunction function = repository.getFunction("Z_EZ_GET_PRS");
        if (function == null) {
            throw new RuntimeException("Z_EZ_GET_PRS not found in SAP repository");
        }

        JCoParameterList imports = function.getImportParameterList();
        imports.setValue("RELEASE_FLAG", "R".equals(criteria.getStatus()) ? "Y" : "N");
        imports.setValue("WITH_TEXTS", "X");
        imports.setValue("WITH_MAT_TEXT", "X");
        imports.setValue("WITH_PR_TEXT", "X");
        if (criteria.getDays() != null) {
            imports.setValue("FROM_DATE", LocalDate.now().minusDays(criteria.getDays()).format(SAP_DATE));
            imports.setValue("TO_DATE", LocalDate.now().format(SAP_DATE));
        }
        if ("Y".equals(criteria.getAmended())) {
            imports.setValue("CHANGED_FLAG", "X");
        }

        setRange(function, "R_PUR_GROUP", criteria.getPurGrp());
        setRange(function, "R_PLANT", criteria.getPlant());
        setRange(function, "R_DOC_TYPE", criteria.getDocType());
        setRange(function, "R_MAT_GRP", criteria.getMatGrp());
        setRange(function, "R_ACC_ASS_CAT", criteria.getAccCat());
        setRange(function, "R_ITEM_CATEGORY", criteria.getItemCat());
        if (criteria.getPrLow() != null && !criteria.getPrLow().isBlank()) {
            setRangeBetween(function, "R_PR_NO", criteria.getPrLow(), criteria.getPrHigh());
        }
        if (criteria.getMatLow() != null && !criteria.getMatLow().isBlank()) {
            setRangeBetween(function, "R_MATERIALS", criteria.getMatLow(), criteria.getMatHigh());
        }

        com.sap.conn.jco.JCoContext.begin(destination);
        function.execute(destination);
        com.sap.conn.jco.JCoContext.end(destination);

        JCoTable items = function.getTableParameterList().getTable("REQUISITION_ITEMS");
        List<PrLineItem> result = new ArrayList<>();
        for (int i = 0; i < items.getNumRows(); i++) {
            items.setRow(i);
            PrLineItem pr = new PrLineItem();
            pr.setReqNo(items.getString("PREQ_NO"));
            pr.setItem(items.getString("PREQ_ITEM"));
            pr.setMatGrp(items.getString("MAT_GRP"));
            pr.setCreatedDate(parseSapDate(items.getString("PREQ_DATE")));
            pr.setAccAssgnCat(items.getString("ACCTASSCAT"));
            pr.setItemCat(items.getString("ITEM_CAT"));
            pr.setMaterial(items.getString("MATERIAL"));
            pr.setDescription(items.getString("SHORT_TEXT"));
            pr.setQty(items.getBigDecimal("QUANTITY"));
            pr.setUom(items.getString("UNIT"));
            pr.setUnitPrice(items.getBigDecimal("C_AMT_BAPI"));
            pr.setCurrency(items.getString("CURRENCY"));
            pr.setDeliveryDate(parseSapDate(items.getString("DELIV_DATE")));
            pr.setPlant(items.getString("PLANT"));
            pr.setPurGrp(items.getString("PUR_GROUP"));
            pr.setRequestedBy(items.getString("PREQ_NAME"));
            pr.setCreatedBy(items.getString("CREATED_BY"));
            pr.setAmendedVersion(items.getString("BOMEXPL_NO"));
            pr.setDocType(items.getString("DOC_TYPE"));
            if (pr.getQty() != null && pr.getUnitPrice() != null) {
                pr.setTotalValue(pr.getQty().multiply(pr.getUnitPrice()));
            }
            result.add(pr);
        }
        return result;
    }

    private void setRange(JCoFunction function, String tableName, List<String> values) {
        if (values == null || values.isEmpty()) {
            return;
        }
        JCoTable table = function.getTableParameterList().getTable(tableName);
        for (String value : values) {
            table.appendRow();
            table.setValue("SIGN", "I");
            table.setValue("OPTION", "EQ");
            table.setValue("LOW", value);
        }
    }

    private void setRangeBetween(JCoFunction function, String tableName, String low, String high) {
        JCoTable table = function.getTableParameterList().getTable(tableName);
        table.appendRow();
        table.setValue("SIGN", "I");
        if (high != null && !high.isBlank()) {
            table.setValue("OPTION", "BT");
            table.setValue("LOW", low);
            table.setValue("HIGH", high);
        } else {
            table.setValue("OPTION", "EQ");
            table.setValue("LOW", low);
        }
    }

    private LocalDate parseSapDate(String sapDate) {
        if (sapDate == null || sapDate.isBlank() || sapDate.startsWith("0000")) {
            return null;
        }
        try {
            return LocalDate.parse(sapDate.trim(), SAP_DATE);
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * Local dev/test PR lines for exercising the "from PRs" -> RFQ -> QCF flow without a live
     * SAP connection - real-looking data (14 lines across 6 PR numbers) supplied for testing,
     * filtered by whichever plant/purGrp/PR-number-range criteria the buyer actually searched
     * on, same as a real SAP search would narrow results. Falls back to one synthetic line if
     * every seeded row gets filtered out, so the flow is never a dead end.
     */
    private List<PrLineItem> mockPrs(PrSearchCriteria criteria, String buyerUserId) {
        List<PrLineItem> all = seedPrLines();
        List<PrLineItem> filtered = all.stream().filter(pr -> matchesCriteria(pr, criteria)).toList();
        if (!filtered.isEmpty()) {
            return filtered;
        }
        List<String> plants = (criteria.getPlant() != null && !criteria.getPlant().isEmpty())
                ? criteria.getPlant() : List.of("1002");
        List<PrLineItem> result = new ArrayList<>();
        int seq = 0;
        for (String plant : plants) {
            result.add(mockPr(criteria, buyerUserId, plant, seq++));
        }
        return result;
    }

    private boolean matchesCriteria(PrLineItem pr, PrSearchCriteria criteria) {
        if (criteria.getPlant() != null && !criteria.getPlant().isEmpty() && !criteria.getPlant().contains(pr.getPlant())) {
            return false;
        }
        if (criteria.getPurGrp() != null && !criteria.getPurGrp().isEmpty() && !criteria.getPurGrp().contains(pr.getPurGrp())) {
            return false;
        }
        if (criteria.getPrLow() != null && !criteria.getPrLow().isBlank()) {
            long low = Long.parseLong(criteria.getPrLow());
            long high = (criteria.getPrHigh() != null && !criteria.getPrHigh().isBlank())
                    ? Long.parseLong(criteria.getPrHigh()) : low;
            try {
                long reqNo = Long.parseLong(pr.getReqNo());
                if (reqNo < low || reqNo > high) {
                    return false;
                }
            } catch (NumberFormatException e) {
                return false;
            }
        }
        return true;
    }

    /** Real-looking test PR lines supplied for local RFQ/QCF end-to-end testing (all plant 2001). */
    private List<PrLineItem> seedPrLines() {
        List<PrLineItem> lines = new ArrayList<>();
        lines.add(seedLine("120155977", "10", "Engineering items", "76000032105", "TISSUE PAPER ROLL",
                "1500.000", "NOS", "30.37", "45555.00", "2001", "215", "14.10.2026", "RMANJU", "RMANJU"));
        lines.add(seedLine("120155949", "10", "Filter bags-Cen&VTD", "96000019287", "PP ANTISTATIC CLOTH CF-1009",
                "10.000", "NOS", "1929.04", "19290.40", "2001", "216", "24.10.2026", "DSAVIO", "DSAVIO"));
        lines.add(seedLine("120155948", "10", "WIRE MESH", "76000021136", "MESH VIBRO SIFTER SS316,16MESH",
                "1.000", "NOS", "3418.87", "3418.87", "2001", "216", "25.09.2026", "DSAVIO", "DSAVIO"));
        lines.add(seedLine("120155947", "10", "PRODUCTION CONSUMABE", "75000031949", "MESH VIBRO SIFTER SS316,18MESH",
                "1.000", "NOS", "2875.17", "2875.17", "2001", "216", "24.10.2026", "DSAVIO", "DSAVIO"));

        lines.add(seedLine("12407949", "10", "Solvents", "10000001926", "Methanol",
                "300000.000", "KG", "58.94", "17682000.00", "2001", "230", "24.09.2026", "PRABUK", "PRABUK"));
        lines.add(seedLine("12407949", "20", "Solvents", "10000001932", "Methylene Dichloride",
                "300000.000", "KG", "57.19", "17157000.00", "2001", "230", "24.09.2026", "PRABUK", "PRABUK"));
        lines.add(seedLine("12407949", "30", "Solvents", "10000001836", "Acetone",
                "36000.000", "KG", "134.19", "4830840.00", "2001", "230", "24.09.2026", "PRABUK", "PRABUK"));
        lines.add(seedLine("12407949", "40", "Solvents", "10000001905", "Isopropyl Alcohol",
                "30000.000", "KG", "138.92", "4167600.00", "2001", "230", "24.09.2026", "PRABUK", "PRABUK"));
        lines.add(seedLine("12407949", "50", "Solvents", "10000001857", "n-Butanol",
                "15000.000", "KG", "145.88", "2188200.00", "2001", "230", "24.10.2026", "PRABUK", "PRABUK"));

        lines.add(seedLine("150037387", "20", "CHEMICALS", "66000006558", "Compressor Gas R134A",
                "40.000", "KG", "1600.00", "64000.00", "2001", "217", "23.10.2026", "Santosh K", "MKKUMAR"));
        lines.add(seedLine("150037387", "30", "Mechanical/Utilities", "96000020986", "CHILLER COMPRESSOR (G 50 ASF-Z )",
                "1.000", "NOS", "764788.10", "764788.10", "2001", "217", "23.10.2026", "Santosh K", "MKKUMAR"));
        lines.add(seedLine("150037386", "10", "MATRL HANDLING SYSTM", "96000014571", "PALLET TROLLEY",
                "10.000", "NOS", "22000.00", "220000.00", "2001", "217", "23.10.2026", "Santosh K", "MKKUMAR"));

        lines.add(seedLine("140042184", "10", "bearings", "76000008835", "BALL BEARING 3305 ATN9,SKF",
                "8.000", "NOS", "4223.00", "33784.00", "2001", "214", "23.10.2026", "SALEEM", "SALEEMG"));
        lines.add(seedLine("140042184", "20", "Oil seals", "76000022809", "OIL SEAL 22 x 32 x 7",
                "15.000", "NOS", "120.00", "1800.00", "2001", "214", "23.10.2026", "SALEEM", "SALEEMG"));
        return lines;
    }

    private static final DateTimeFormatter SOURCE_DATE = DateTimeFormatter.ofPattern("dd.MM.yyyy");

    private PrLineItem seedLine(String reqNo, String item, String matGrp, String material, String description,
            String qty, String uom, String unitPrice, String totalValue, String plant, String purGrp,
            String deliveryDate, String requestedBy, String createdBy) {
        PrLineItem pr = new PrLineItem();
        pr.setReqNo(reqNo);
        pr.setItem(item);
        pr.setMatGrp(matGrp);
        pr.setCreatedDate(LocalDate.now().minusDays(1));
        pr.setChangedDate(LocalDate.now());
        pr.setAccAssgnCat("");
        pr.setItemCat("");
        pr.setMaterial(material);
        pr.setDescription(description);
        pr.setQty(new BigDecimal(qty));
        pr.setUom(uom);
        pr.setUnitPrice(new BigDecimal(unitPrice));
        pr.setTotalValue(new BigDecimal(totalValue));
        pr.setCurrency("INR");
        pr.setDeliveryDate(LocalDate.parse(deliveryDate, SOURCE_DATE));
        pr.setPlant(plant);
        pr.setPurGrp(purGrp);
        pr.setItemText("");
        pr.setPoText("");
        pr.setRequestedBy(requestedBy);
        pr.setCreatedBy(createdBy);
        pr.setAmendedVersion("0");
        pr.setDocType("NB");
        return pr;
    }

    private PrLineItem mockPr(PrSearchCriteria criteria, String buyerUserId, String plant, int seq) {
        PrLineItem pr = new PrLineItem();
        pr.setReqNo(String.valueOf(1000000123L + seq));
        pr.setItem("10");
        pr.setMatGrp(firstOrDefault(criteria.getMatGrp(), "RM01"));
        pr.setCreatedDate(LocalDate.now().minusDays(5));
        pr.setChangedDate(LocalDate.now().minusDays(2));
        pr.setAccAssgnCat(firstOrDefault(criteria.getAccCat(), ""));
        pr.setItemCat(firstOrDefault(criteria.getItemCat(), ""));
        pr.setMaterial("00000000010000012" + (3 + seq));
        pr.setDescription("Example Material - Steel Rod 10mm (SAP unavailable, sample data) - Plant " + plant);
        pr.setQty(new BigDecimal("100.000"));
        pr.setUom("EA");
        pr.setUnitPrice(new BigDecimal("250.00"));
        pr.setTotalValue(new BigDecimal("25000.00"));
        pr.setCurrency("INR");
        pr.setDeliveryDate(LocalDate.now().plusDays(30));
        pr.setPlant(plant);
        // Kept to 3 chars: ERH_COLLETIVE_RFQ_NO is varchar(10) and the legacy numbering
        // scheme is "purGrp + 7-digit sequence" - a real SAP purchase group is ~3 chars.
        pr.setPurGrp(firstOrDefault(criteria.getPurGrp(), "100"));
        pr.setItemText("Sample item text for demo purposes");
        pr.setPoText("Sample PO text for demo purposes");
        pr.setRequestedBy(buyerUserId);
        pr.setCreatedBy(buyerUserId);
        pr.setAmendedVersion("0");
        pr.setDocType(firstOrDefault(criteria.getDocType(), "NB"));
        return pr;
    }

    private String firstOrDefault(List<String> values, String fallback) {
        return (values != null && !values.isEmpty()) ? values.get(0) : fallback;
    }
}
