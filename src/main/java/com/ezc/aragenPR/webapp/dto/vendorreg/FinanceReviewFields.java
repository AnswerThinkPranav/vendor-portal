package com.ezc.aragenPR.webapp.dto.vendorreg;

/**
 * The buyer-entered (not vendor-entered) finance fields used for SAP vendor-master posting -
 * only editable by users with USERROLE VAR/LB/SCA, see ezSubmitVendRegOthMat.jsp and
 * ezPrePostVendorToSAP.jsp/ezPostVendorToSAP.jsp (WITHT/WT_WITHCD/QSREC/AKONT).
 */
public record FinanceReviewFields(String whTaxType, String whTaxCode, String recType, String reconAccount, String docAck) {
}
