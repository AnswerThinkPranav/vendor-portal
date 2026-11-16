package com.ezc.aragenPR.webapp.dto.rfq;

/** Current approval-workflow state for a QCF - see ezViewDOMQCF.jsp's showSubmit/showApprove/showReject. */
public record QcfWorkflowStatus(
        String wfStatus,
        Integer currentLevel,
        String currentGroup,
        boolean isFinalLevel,
        /** True when the current user is the actual current-level approver - drives Forward/Reject. */
        boolean canAct,
        /** True once every vendor has quoted (no vendor still "N"/"R") and this QCF hasn't been routed yet. */
        boolean canSubmitToWorkflow,
        /** True once the workflow has reached final approval - drives the "Create PO" button. */
        boolean approved) {
}
