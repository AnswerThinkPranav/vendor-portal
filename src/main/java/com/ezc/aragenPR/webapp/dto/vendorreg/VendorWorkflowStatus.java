package com.ezc.aragenPR.webapp.dto.vendorreg;

/** Current approval-workflow state for a vendor registration, as seen by the currently logged-in buyer. */
public record VendorWorkflowStatus(
        String wfStatus,
        Integer currentLevel,
        String currentGroup,
        boolean isFinalLevel,
        boolean canAct,
        /** Any buyer can send a submitted registration back to the vendor while it's active in the workflow - not limited to the exact current-level actor like canAct. */
        boolean canSendBack,
        /** True once the vendor has submitted but before any buyer has pushed it into the approval workflow (see IVendorRegistrationService.submitToWorkflow). */
        boolean canSubmitToWorkflow,
        /** True once the workflow has reached (or passed) the template's finance level - hidden entirely at earlier levels and before routing. */
        boolean financeFieldsVisible,
        boolean financeFieldsEditable,
        FinanceReviewFields finance) {
}
