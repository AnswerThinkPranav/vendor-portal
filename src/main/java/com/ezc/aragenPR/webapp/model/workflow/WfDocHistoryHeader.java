package com.ezc.aragenPR.webapp.model.workflow;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.IdClass;
import jakarta.persistence.Table;

import lombok.Data;

/**
 * Mirrors the legacy Vendor Portal EZC_WF_DOC_HISTORY_HEADER table (see db.sql) - one row
 * per document submitted into the multi-level approval workflow (see
 * Vendor Portal/JSP/RFQ/ezSaveQCFWF.jsp). The full workflow engine (template/step/participant
 * routing tables - EZC_WF_TEMPLATE_CODE, EZC_WF_TEMPLATE_STEPS, EZC_WF_WORKGROUPS, etc.) has
 * no configured data in the current DB replica, so this app only writes a single-step
 * "SUBMITTED" row today (EWDHH_CURRENT_STEP=1, no participant routing) - the real multi-level
 * approval routing is a later phase once that config is available.
 */
@Entity
@Table(name = "ezc_wf_doc_history_header")
@IdClass(WfDocHistoryHeaderId.class)
@Data
public class WfDocHistoryHeader {

    @Id
    @Column(name = "EWDHH_AUTH_KEY", length = 16)
    private String authKey;

    @Id
    @Column(name = "EWDHH_DOC_ID", length = 20)
    private String docId;

    @Column(name = "EWDHH_SYSKEY", length = 6)
    private String sysKey;

    @Column(name = "EWDHH_SOLD_TO", length = 20)
    private String soldTo;

    @Column(name = "EWDHH_TEMPLATE_CODE")
    private BigDecimal templateCode;

    @Column(name = "EWDHH_KEY")
    private BigDecimal key;

    @Column(name = "EWDHH_DOC_DATE")
    private LocalDateTime docDate;

    @Column(name = "EWDHH_WF_STATUS", length = 20)
    private String wfStatus;

    @Column(name = "EWDHH_CREATED_ON")
    private LocalDateTime createdOn;

    @Column(name = "EWDHH_MODIFIED_ON")
    private LocalDateTime modifiedOn;

    @Column(name = "EWDHH_CREATED_BY", length = 10)
    private String createdBy;

    @Column(name = "EWDHH_MODIFIED_BY", length = 10)
    private String modifiedBy;

    @Column(name = "EWDHH_CURRENT_STEP")
    private BigDecimal currentStep;

    @Column(name = "EWDHH_NEXT_PARTICIPANT", length = 20)
    private String nextParticipant;

    @Column(name = "EWDHH_PARTICIPANT_TYPE", length = 1)
    private String participantType;

    @Column(name = "EWDHH_REF1", length = 100)
    private String ref1;

    @Column(name = "EWDHH_REF2", length = 250)
    private String ref2;
}
