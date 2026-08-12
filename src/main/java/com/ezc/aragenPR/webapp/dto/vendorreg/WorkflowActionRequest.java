package com.ezc.aragenPR.webapp.dto.vendorreg;

/** A buyer's action on a vendor registration in the approval workflow - see ezSubmitVendRegOthMat.jsp actionSts. */
public record WorkflowActionRequest(String action, String comments, FinanceReviewFields finance) {

    public static final String FORWARD = "FORWARD";
    public static final String REJECT = "REJECT";
    public static final String SEND_BACK = "SEND_BACK";
}
