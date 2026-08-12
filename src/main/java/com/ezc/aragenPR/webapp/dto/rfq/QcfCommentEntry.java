package com.ezc.aragenPR.webapp.dto.rfq;

/** One row of the "Users / Date / Comments" audit trail at the bottom of the Quotation Comparison Form. */
public record QcfCommentEntry(String user, String date, String comments) {
}
