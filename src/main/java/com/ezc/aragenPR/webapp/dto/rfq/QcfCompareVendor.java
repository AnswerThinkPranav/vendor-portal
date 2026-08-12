package com.ezc.aragenPR.webapp.dto.rfq;

import java.util.List;

/** One vendor's block ("Name of the Party") on the Quotation Comparison Form - see ezQuotationComparisionForm.jsp. */
public record QcfCompareVendor(
        String rfqNo,
        String vendorId,
        String vendorLabel,
        String paymentTerms,
        String incoTerms1,
        boolean alreadySubmitted,
        List<QcfCompareItem> items,
        String totalAmount) {
}
