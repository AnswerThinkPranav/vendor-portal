package com.ezc.aragenPR.webapp.model.rfq;

import java.math.BigDecimal;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.IdClass;
import jakarta.persistence.Table;

import lombok.Data;

/**
 * Mirrors the legacy Vendor Portal EZC_RFQ_ITEM_CONDITIONS table (see db.sql) - one row per
 * pricing condition (DISC/PKFW/FRT/TAX) per RFQ line per vendor, written by the "Item
 * Conditions" popup on quote submission (see Vendor Portal/JSP/RFQ/ezQuotationSave.jsp).
 */
@Entity
@Table(name = "ezc_rfq_item_conditions")
@IdClass(RfqItemConditionId.class)
@Data
public class RfqItemCondition {

    @Id
    @Column(name = "ERIC_VENDOR", length = 15)
    private String vendor;

    @Id
    @Column(name = "ERIC_RFQ_NO", length = 20)
    private String rfqNo;

    @Id
    @Column(name = "ERIC_LINE_NO")
    private BigDecimal lineNo;

    /** Fixed condition code: DISC / PKFW / FRT / TAX (/ OTH for import). */
    @Id
    @Column(name = "ERIC_TAX_CODE", length = 15)
    private String taxCode;

    /** 1=DISC, 2=PKFW, 3=FRT, 4=TAX(or OTH) - matches ezQuotationSave.jsp's seq numbering. */
    @Id
    @Column(name = "ERIC_SEQ_NO", length = 10)
    private String seqNo;

    /** The raw entered value (discount %, pkg&fwd rate, freight rate, GST %). */
    @Column(name = "ERIC_TAX_VALUE", length = 25)
    private String taxValue;

    /** Value-type selector: P=percent, Q=per-qty, V=flat value. */
    @Column(name = "ERIC_TAX_TYPE", length = 10)
    private String taxType;

    @Column(name = "ERIC_CFORM", length = 5)
    private String cForm;

    /** Qty at time of quoting. */
    @Column(name = "ERIC_EXT1", length = 20)
    private String ext1;

    /** Basic price at time of quoting. */
    @Column(name = "ERIC_EXT2", length = 20)
    private String ext2;

    /** Computed condition amount for this row. */
    @Column(name = "ERIC_EXT3", length = 20)
    private String ext3;

    @Column(name = "ERIC_NEG_TAX_VALUE", length = 25)
    private String negTaxValue;

    @Column(name = "ERIC_CURRENCY", length = 5)
    private String currency;

    @Column(name = "ERIC_EXCH_RATE")
    private BigDecimal exchRate;

    @Column(name = "ERIC_COND_VEND", length = 15)
    private String condVendor;

    @Column(name = "ERIC_EXT4", length = 20)
    private String ext4;

    @Column(name = "ERIC_EXT5", length = 20)
    private String ext5;
}
