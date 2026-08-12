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
 * Mirrors the legacy Vendor Portal EZC_RFQ_PRS table (see db.sql) - links a Collective
 * RFQ / QCF to the original (un-clubbed) PR lines it was created from. Inserted once per
 * PR line (not once per vendor) - see ezCreateRFQ.jsp, which only writes these rows on
 * the first vendor iteration of its save loop.
 */
@Entity
@Table(name = "ezc_rfq_prs")
@IdClass(RfqPrId.class)
@Data
public class RfqPr {

    @Id
    @Column(name = "ERP_QCF_NO", length = 10)
    private String qcfNo;

    @Id
    @Column(name = "ERP_RFQ_LINE_NO", length = 5)
    private String rfqLineNo;

    @Id
    @Column(name = "ERP_PR_NO", length = 10)
    private String prNo;

    @Id
    @Column(name = "ERP_PR_ITEM", length = 5)
    private String prItem;

    @Column(name = "ERP_PR_QTY")
    private BigDecimal prQty;

    @Column(name = "ERP_PR_OPEN_QTY")
    private BigDecimal prOpenQty;

    @Column(name = "ERP_PR_DEL_DATE")
    private LocalDate prDelDate;

    @Column(name = "ERP_PR_TYPE", length = 4)
    private String prType;

    @Column(name = "ERP_PR_REL_DATE")
    private LocalDate prRelDate;
}
