package com.ezc.aragenPR.webapp.dto.rfq;

/** A buyer/approver's action on a QCF already in the approval workflow - see ezViewDOMQCF.jsp funSubmit(). */
public record QcfWorkflowActionRequest(String action, String comments) {

    public static final String FORWARD = "FORWARD";
    public static final String REJECT = "REJECT";
    /** Kicks the QCF back to the buyer for correction (e.g. wrong recommended quantities) - the
     * workflow routing is cleared entirely and the buyer re-submits via the normal Submit button. */
    public static final String SEND_BACK = "SEND_BACK";
}
