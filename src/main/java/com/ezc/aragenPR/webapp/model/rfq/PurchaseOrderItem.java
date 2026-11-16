package com.ezc.aragenPR.webapp.model.rfq;

import java.math.BigDecimal;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

import com.fasterxml.jackson.annotation.JsonBackReference;
import lombok.Data;

/** One material line on a locally-created Purchase Order - see PurchaseOrder. */
@Entity
@Table(name = "ezc_purchase_order_items")
@Data
public class PurchaseOrderItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @JsonBackReference
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "EPOI_PO_NO")
    private PurchaseOrder purchaseOrder;

    @Column(name = "EPOI_LINE_NO", length = 5)
    private String lineNo;

    @Column(name = "EPOI_MATERIAL", length = 20)
    private String material;

    @Column(name = "EPOI_MATERIAL_DESC", length = 200)
    private String materialDesc;

    @Column(name = "EPOI_QTY", precision = 15, scale = 3)
    private BigDecimal qty;

    @Column(name = "EPOI_UOM", length = 10)
    private String uom;

    @Column(name = "EPOI_RATE", precision = 15, scale = 3)
    private BigDecimal rate;

    @Column(name = "EPOI_LINE_VALUE", precision = 18, scale = 2)
    private BigDecimal lineValue;
}
