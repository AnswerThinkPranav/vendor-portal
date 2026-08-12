package com.ezc.aragenPR.webapp.dto.rfq;

import java.math.BigDecimal;
import java.time.LocalDate;

import lombok.Data;

/** One PR line result row - see Vendor Portal/JSP/RFQ/ezListPR.jsp (fetched live from SAP, Z_EZ_GET_PRS). */
@Data
public class PrLineItem {

    private String reqNo;
    private String item;
    private String matGrp;
    private LocalDate createdDate;
    private LocalDate changedDate;
    private String accAssgnCat;
    private String itemCat;
    private String material;
    private String description;
    private BigDecimal qty;
    private String uom;
    private BigDecimal unitPrice;
    private BigDecimal totalValue;
    private String currency;
    private LocalDate deliveryDate;
    private String plant;
    private String purGrp;
    private String itemText;
    private String poText;
    private String requestedBy;
    private String createdBy;
    private String amendedVersion;
    private String docType;
    /** True if EZC_RFQ_PRS already has a row for this PR#/item - see ezListPR.jsp's prTreeSet check. */
    private boolean rfqAlreadyCreated;
}
