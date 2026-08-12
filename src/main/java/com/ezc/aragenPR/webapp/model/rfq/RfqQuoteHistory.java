package com.ezc.aragenPR.webapp.model.rfq;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.IdClass;
import jakarta.persistence.Table;

import lombok.Data;

/**
 * Mirrors the legacy Vendor Portal EZC_RFQ_QUOTE_HISTORY table (see db.sql) - an audit
 * snapshot of each condition written alongside EZC_RFQ_ITEM_CONDITIONS on quote submission
 * (see Vendor Portal/JSP/RFQ/ezQuotationSave.jsp). Note the table's real column prefix is
 * inconsistent in the legacy schema itself: most columns use ERQH_, but currency/exch
 * rate/cond vendor/ext4/ext5 use EQRH_ (kept as-is; do not "fix" the typo, this is the
 * real production column name).
 */
@Entity
@Table(name = "ezc_rfq_quote_history")
@IdClass(RfqQuoteHistoryId.class)
@Data
public class RfqQuoteHistory {

    @Id
    @Column(name = "ERQH_VENDOR", length = 15)
    private String vendor;

    @Id
    @Column(name = "ERQH_RFQ_NO", length = 20)
    private String rfqNo;

    @Id
    @Column(name = "ERQH_LINE_NO")
    private BigDecimal lineNo;

    /** Re-quote counter; always "1" for a first-time quote submission. */
    @Id
    @Column(name = "ERQH_COUNTER")
    private BigDecimal counter;

    /** Fixed condition code: DISC / PKFW / FRT / TAX (/ OTH for import). */
    @Id
    @Column(name = "ERQH_COND_CODE", length = 15)
    private String condCode;

    @Id
    @Column(name = "ERQH_SEQ_NO", length = 10)
    private String seqNo;

    @Column(name = "ERQH_COND_VALUE", length = 25)
    private String condValue;

    /** Value-type selector: P=percent, Q=per-qty, V=flat value. */
    @Column(name = "ERQH_COND_TYPE", length = 10)
    private String condType;

    /** Computed condition amount for this row. */
    @Column(name = "ERQH_COND_TOT_VALUE", length = 25)
    private String condTotValue;

    @Column(name = "ERQH_ENTERED_BY", length = 25)
    private String enteredBy;

    @Column(name = "ERQH_ENTERED_ON")
    private LocalDateTime enteredOn;

    @Column(name = "ERQH_CFORM", length = 5)
    private String cForm;

    @Column(name = "ERQH_QUOTE_FLAG", length = 10)
    private String quoteFlag;

    /** Qty at time of quoting. */
    @Column(name = "ERQH_EXT1", length = 20)
    private String ext1;

    /** Basic price at time of quoting. */
    @Column(name = "ERQH_EXT2", length = 20)
    private String ext2;

    @Column(name = "ERQH_EXT3", length = 20)
    private String ext3;

    @Column(name = "EQRH_CURRENCY", length = 5)
    private String currency;

    @Column(name = "EQRH_EXCH_RATE")
    private BigDecimal exchRate;

    @Column(name = "EQRH_COND_VEND", length = 15)
    private String condVendor;

    @Column(name = "EQRH_EXT4", length = 20)
    private String ext4;

    @Column(name = "EQRH_EXT5", length = 20)
    private String ext5;
}
