package com.ezc.aragenPR.webapp.dto.rfq;

/** One vendor's rate/total/recommended-qty cell within a shared line row on the Quotation Comparison Form. */
public record QcfVendorLineCell(String rfqNo, String rate, String totalAmount, String qtyRecommended, boolean alreadySubmitted) {
}
