package com.ezc.aragenPR.webapp.dto.vendorreg;

import java.time.LocalDateTime;

/** One row from EZC_WF_AUDIT_TRAIL - see funAuditTrail / ezShowAuditTrail.jsp (Audit / Action / Date columns). */
public record AuditTrailEntry(String auditNo, String action, LocalDateTime date) {
}
