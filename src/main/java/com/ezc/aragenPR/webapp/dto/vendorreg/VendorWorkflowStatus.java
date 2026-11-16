package com.ezc.aragenPR.webapp.dto.vendorreg;

/** Current approval-workflow state for a vendor registration, as seen by the currently logged-in buyer. */
public record VendorWorkflowStatus(
        String wfStatus,
        Integer currentLevel,
        String currentGroup,
        boolean isFinalLevel,
        boolean canAct,
        /** Reject is hidden from the PP (Purchase Person / level-1 buyer) role, matching ezVendReg.jsp's {@code showReject && !"PP".equals(userRole)} - a subset of canAct. */
        boolean canReject,
        /** Only the PP role can send a doc back to the vendor - not turn-restricted like canAct, matching ezVendReg.jsp's {@code "PP".equals(userRole) && !"APPROVED".equals(wfStatus)}. */
        boolean canSendBack,
        /** Only non-PP, non-VIW roles (level 2+ approvers) can raise a query - matching ezVendReg.jsp's {@code !"PP".equals(userRole) && !"VIW".equals(userRole) && !"APPROVED".equals(wfStatus)}. The query now targets the PP role, not the vendor. */
        boolean canQuery,
        /** True when the current user holds the PP role - they're the one who answers a query raised by a higher-level approver (see canQuery). */
        boolean canReplyToQuery,
        /** True once the vendor has submitted but before any buyer has pushed it into the approval workflow (see IVendorRegistrationService.submitToWorkflow). */
        boolean canSubmitToWorkflow,
        /** True once the workflow has reached (or passed) the template's finance level - hidden entirely at earlier levels and before routing. */
        boolean financeFieldsVisible,
        boolean financeFieldsEditable,
        FinanceReviewFields finance) {
}
