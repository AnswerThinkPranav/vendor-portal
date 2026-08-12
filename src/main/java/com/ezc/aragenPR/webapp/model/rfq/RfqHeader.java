package com.ezc.aragenPR.webapp.model.rfq;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import lombok.Data;

/**
 * Mirrors the legacy Vendor Portal EZC_RFQ_HEADER table (see db.sql). One row per
 * vendor per RFQ - see Vendor Portal/JSP/RFQ/ezCreateRFQ.jsp, which creates one
 * EZC_RFQ_HEADER row for every vendor selected against a shared "Collective RFQ" /
 * QCF number (ERH_COLLETIVE_RFQ_NO).
 */
@Entity
@Table(name = "ezc_rfq_header")
@Data
public class RfqHeader {

    @Id
    @Column(name = "ERH_RFQ_NO", length = 10)
    private String rfqNo;

    @Column(name = "ERH_COLLETIVE_RFQ_NO", length = 10)
    private String collectiveRfqNo;

    @Column(name = "ERH_SYS_KEY", length = 18)
    private String sysKey;

    /** Vendor id this RFQ was created for. */
    @Column(name = "ERH_SOLD_TO", length = 15)
    private String soldTo;

    @Column(name = "ERH_STATUS", length = 1)
    private String status;

    @Column(name = "ERH_RFQ_DATE")
    private LocalDateTime rfqDate;

    @Column(name = "ERH_VALID_UPTO")
    private LocalDateTime validUpto;

    @Column(name = "ERH_CREATED_BY", length = 10)
    private String createdBy;

    @Column(name = "ERH_CREATED_ON")
    private LocalDateTime createdOn;

    @Column(name = "ERH_MODIFIED_BY", length = 10)
    private String modifiedBy;

    @Column(name = "ERH_MODIFIED_ON")
    private LocalDateTime modifiedOn;

    @Column(name = "ERH_PUR_ORG", length = 20)
    private String purOrg;

    @Column(name = "ERH_PUR_GRP", length = 20)
    private String purGrp;

    /** S = SAP vendor, N = non-SAP vendor - see ezVendorViewList.jsp checkbox type flag. */
    @Column(name = "ERH_VENDOR_TYPE", length = 10)
    private String vendorType;

    @Column(name = "ERH_AGENT_CODE", length = 10)
    private String agentCode;

    @Column(name = "ERH_RELEASE_INDICATOR", length = 1)
    private String releaseIndicator;

    @Column(name = "ERH_RANK_STATUS", length = 3)
    private String rankStatus;

    /** Delimited PR#-Item#-Mat#-Plant#-Qty string across all selected PRs (see setPRDetails in ezCreateRFQ.jsp). */
    @Column(name = "ERH_PR_NO", length = 3000)
    private String prNo;

    @Column(name = "ERH_PLANT", length = 4)
    private String plant;

    @Column(name = "ERH_COMP_CODE", length = 4)
    private String compCode;

    /** Workflow category classification (see getWFCategory in legacy). */
    @Column(name = "ERH_CATEGORY", length = 10)
    private String category;

    /** SAP material type (looked up via MARA), matches setValType in ezCreateRFQ.jsp. */
    @Column(name = "ERH_VAL_TYPE", length = 10)
    private String valType;

    @Column(name = "ERH_PAYMENT_TERMS", length = 10)
    private String paymentTerms;

    @Column(name = "ERH_INCO_TERMS1", length = 10)
    private String incoTerms1;

    @Column(name = "ERH_INCO_TERMS2", length = 50)
    private String incoTerms2;

    /** RFQ Type (Domestic/Import) - reuses EXT2 exactly like the legacy save handler. */
    @Column(name = "ERH_EXT2", length = 250)
    private String rfqType;

    /** QCF Title - reuses EXT3 exactly like the legacy save handler. */
    @Column(name = "ERH_EXT3")
    private String qcfTitle;

    @Column(name = "ERH_WF_STATUS", length = 10)
    private String wfStatus;

    @Column(name = "ERH_FINAL_VALUE")
    private BigDecimal finalValue;

    @Column(name = "ERH_REC_VALUE")
    private BigDecimal recValue;

    @Column(name = "ERH_PO_FLAG", length = 1)
    private String poFlag;

    @Column(name = "ERH_PR_ITEM_NO", length = 5)
    private String prItemNo;

    @Column(name = "ERH_PR_TEXT", length = 5000)
    private String prText;

    /** Who last saved a quote against this RFQ - EU_TYPE of the saver (2=buyer/offline, 3/4=vendor/online). */
    @Column(name = "ERH_SAVE_FLG", length = 1)
    private String saveFlag;

    @Column(name = "ERH_LD_STATUS", length = 1)
    private String ldStatus;

    @Column(name = "ERH_LD_CLAUSE", length = 500)
    private String ldClause;

    @Column(name = "ERH_PG_STATUS", length = 1)
    private String pgStatus;

    @Column(name = "ERH_PG_CLAUSE", length = 500)
    private String pgClause;
}
