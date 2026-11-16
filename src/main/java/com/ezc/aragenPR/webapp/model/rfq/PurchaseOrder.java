package com.ezc.aragenPR.webapp.model.rfq;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;

import lombok.Data;

/**
 * A locally-created Purchase Order, one per vendor recommended in an approved QCF - see
 * ezViewDOMQCF.jsp's Create PO button. No SAP posting (this app has no live SAP connection,
 * same simplification already used for vendor registration's SAP posting) - this is the
 * final, real record of "the QCF was approved and turned into an order."
 */
@Entity
@Table(name = "ezc_purchase_order")
@Data
public class PurchaseOrder {

    @Id
    @Column(name = "EPO_PO_NO", length = 15)
    private String poNo;

    @Column(name = "EPO_QCF_NO", length = 10)
    private String qcfNo;

    @Column(name = "EPO_RFQ_NO", length = 10)
    private String rfqNo;

    @Column(name = "EPO_VENDOR", length = 15)
    private String vendorId;

    @Column(name = "EPO_VENDOR_LABEL", length = 200)
    private String vendorLabel;

    @Column(name = "EPO_COMP_CODE", length = 4)
    private String compCode;

    @Column(name = "EPO_PLANT", length = 4)
    private String plant;

    @Column(name = "EPO_STATUS", length = 10)
    private String status;

    @Column(name = "EPO_TOTAL_VALUE", precision = 18, scale = 2)
    private BigDecimal totalValue;

    @Column(name = "EPO_CURRENCY", length = 5)
    private String currency;

    @Column(name = "EPO_CREATED_BY", length = 10)
    private String createdBy;

    @Column(name = "EPO_CREATED_ON")
    private LocalDateTime createdOn;

    @OneToMany(mappedBy = "purchaseOrder", cascade = CascadeType.ALL, orphanRemoval = true)
    private java.util.List<PurchaseOrderItem> items = new java.util.ArrayList<>();
}
