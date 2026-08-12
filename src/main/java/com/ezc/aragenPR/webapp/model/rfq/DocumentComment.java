package com.ezc.aragenPR.webapp.model.rfq;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import lombok.Data;

/** Mirrors the legacy Vendor Portal EZC_DOCUMENT_COMMENTS table - one row per free-text comment on a document (RFQ, PR, etc). */
@Entity
@Table(name = "ezc_document_comments")
@Data
public class DocumentComment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "EDC_DOC_ID", length = 20, nullable = false)
    private String docId;

    @Column(name = "edc_doc_type", length = 20, nullable = false)
    private String docType;

    @Column(name = "EDC_COMMENTS", length = 5000)
    private String comments;

    @Column(name = "EDC_USER_ID", length = 60, nullable = false)
    private String userId;

    @Column(name = "EDC_DATE", nullable = false)
    private LocalDateTime date;
}
