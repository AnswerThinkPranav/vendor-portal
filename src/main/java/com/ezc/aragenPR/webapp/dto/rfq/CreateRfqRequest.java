package com.ezc.aragenPR.webapp.dto.rfq;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

import lombok.Data;

/** Final "Create RFQ" submission - see Vendor Portal/JSP/RFQ/ezEnterEndDate.jsp + ezCreateRFQ.jsp. */
@Data
public class CreateRfqRequest {

    /** DOM = Domestic, IMP = Import. */
    private String rfqType;
    private String purGrp;
    private String purOrg;
    private String compCode;
    private LocalDate qtnEndDate;
    private LocalTime qtnEndTime = LocalTime.of(23, 59);
    private String qcfTitle;
    private String comments;
    private String plant;
    private List<VendorOption> vendors;
    private List<Item> items;
    /** Set when re-adding vendors to an existing QCF - see qcfPrev in legacy. Null for a brand new QCF. */
    private String existingQcfNo;

    @Data
    public static class Item {
        private String prNo;
        private String prItem;
        private String material;
        private String materialDesc;
        private BigDecimal qty;
        private String uom;
        private String plant;
        private LocalDate deliveryDate;
        private String remarks;
        private String warranty;
        private String itemText;
        private String poText;
        private String currency;
        private String accCat;
        private String itemCat;
        private String docType;
        private String matGrp;
        private String createdBy;
    }
}
