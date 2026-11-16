package com.ezc.aragenPR.webapp.model.rfq;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import lombok.Data;

/**
 * An approver-raised query on a QCF that blocks further workflow action (Forward/Reject/Send
 * Back) until the buyer replies - mirrors {@code com.ezc.aragenPR.webapp.model.vendorreg.
 * VendorQuery}, same simplified one-row-per-query-with-nullable-reply model, but for the QCF
 * approval chain where it's an approver questioning the buyer's recommendation rather than a
 * buyer questioning a vendor.
 */
@Entity
@Table(name = "ezc_qcf_query")
@Data
public class QcfQuery {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "EQQ_QCF_NO", length = 10, nullable = false)
    private String qcfNo;

    @Column(name = "EQQ_RAISED_BY", length = 10, nullable = false)
    private String raisedBy;

    @Column(name = "EQQ_RAISED_ON", nullable = false)
    private LocalDateTime raisedOn;

    @Column(name = "EQQ_QUERY_TEXT", length = 1000, nullable = false)
    private String queryText;

    @Column(name = "EQQ_REPLIED_BY", length = 10)
    private String repliedBy;

    @Column(name = "EQQ_REPLIED_ON")
    private LocalDateTime repliedOn;

    @Column(name = "EQQ_REPLY_TEXT", length = 1000)
    private String replyText;
}
