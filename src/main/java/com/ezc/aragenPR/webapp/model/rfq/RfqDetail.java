package com.ezc.aragenPR.webapp.model.rfq;

import java.math.BigDecimal;
import java.time.LocalDate;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.IdClass;
import jakarta.persistence.Table;

import lombok.Data;

/**
 * Mirrors the legacy Vendor Portal EZC_RFQ_DETAILS table (see db.sql) - one row per
 * (vendor's RFQ x PR line), see ezCreateRFQ.jsp's EziRFQDetailsTableRow mapping.
 */
@Entity
@Table(name = "ezc_rfq_details")
@IdClass(RfqDetailId.class)
@Data
public class RfqDetail {

    @Id
    @Column(name = "ERD_RFQ_NO", length = 10)
    private String rfqNo;

    @Id
    @Column(name = "ERD_LINE_NO")
    private BigDecimal lineNo;

    @Id
    @Column(name = "ERD_COUNTER")
    private BigDecimal counter;

    @Column(name = "ERD_MATERIAL", length = 18)
    private String material;

    @Column(name = "ERD_MATERIAL_DESC", length = 50)
    private String materialDesc;

    @Column(name = "ERD_UOM", length = 10)
    private String uom;

    @Column(name = "ERD_DELIVERY_DATE")
    private LocalDate deliveryDate;

    @Column(name = "ERD_QUANTITY")
    private BigDecimal quantity;

    @Column(name = "ERD_ORDER_UNIT", length = 10)
    private String orderUnit;

    @Column(name = "ERD_PR_CREATED_BY", length = 15)
    private String prCreatedBy;

    @Column(name = "ERD_PRICE")
    private BigDecimal price;

    @Column(name = "ERD_REMARKS", length = 4000)
    private String remarks;

    @Column(name = "ERD_PLANT", length = 4)
    private String plant;

    @Column(name = "ERD_ACC_CAT", length = 10)
    private String accCategory;

    @Column(name = "ERD_ITEM_CAT", length = 10)
    private String itemCategory;

    /** PR number this line came from - reuses EXT1 exactly like the legacy save handler. */
    @Column(name = "ERD_EXT1", length = 2000)
    private String prNo;

    /** Item Text - reuses EXT2 exactly like the legacy save handler. */
    @Column(name = "ERD_EXT2", length = 2000)
    private String itemText;

    /** PO Text - reuses EXT3 exactly like the legacy save handler. */
    @Column(name = "ERD_EXT3", length = 4000)
    private String poText;

    @Column(name = "ERD_CURRENCY", length = 5)
    private String currency;

    @Column(name = "ERD_WARRANTY", length = 500)
    private String warranty;

    @Column(name = "ERD_DOC_TYPE", length = 10)
    private String docType;

    @Column(name = "ERD_MAT_GRP", length = 50)
    private String matGroup;

    @Column(name = "ERD_STATUS", length = 1)
    private String status;

    @Column(name = "ERD_MRP_PRICE")
    private BigDecimal mrpPrice;

    @Column(name = "ERD_EXCH_RATE")
    private BigDecimal exchRate;

    @Column(name = "ERD_LEAD_DAYS", length = 3)
    private String leadDays;

    @Column(name = "ERD_VEND_GST", length = 20)
    private String vendGst;

    @Column(name = "ERD_SAP_GST", length = 20)
    private String sapGst;

    @Column(name = "ERD_VEND_HSN_CODE", length = 20)
    private String vendHsnCode;

    @Column(name = "ERD_SAP_HSN_CODE", length = 20)
    private String sapHsnCode;

    /** Buyer-recommended quantity awarded to this vendor for this line - set by the Quotation Comparison Form on QCF submit. */
    @Column(name = "ERD_PO_QTY")
    private BigDecimal poQty;
}
