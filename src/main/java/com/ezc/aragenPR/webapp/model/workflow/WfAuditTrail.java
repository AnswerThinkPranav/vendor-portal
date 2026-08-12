package com.ezc.aragenPR.webapp.model.workflow;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import lombok.Data;

/**
 * Mirrors the legacy Vendor Portal EZC_WF_AUDIT_TRAIL table (see db.sql) - one row per
 * workflow transition (who acted, moving the doc from/to which participant). The legacy
 * table has no primary key at all; {@code id} is a new, purely additive surrogate key so
 * JPA has something to key rows on (same pattern as CustomerFormDetail/DocumentComment).
 */
@Entity
@Table(name = "ezc_wf_audit_trail")
@Data
public class WfAuditTrail {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "EWAT_AUDIT_NO", length = 10)
    private String auditNo;

    @Column(name = "EWAT_DOC_ID", length = 10)
    private String docId;

    @Column(name = "EWAT_TYPE", length = 15)
    private String docType;

    @Column(name = "EWAT_SOURCE_PARTICIPANT", length = 20)
    private String sourceParticipant;

    @Column(name = "EWAT_SOURCE_PARTICIPANT_TYPE", length = 1)
    private String sourceParticipantType;

    @Column(name = "EWAT_DEST_PARTICIPANT", length = 20)
    private String destParticipant;

    @Column(name = "EWAT_DEST_PARTICIPANT_TYPE", length = 1)
    private String destParticipantType;

    @Column(name = "EWAT_COMMENTS", length = 500)
    private String comments;

    @Column(name = "EWAT_DATE")
    private LocalDateTime date;
}
