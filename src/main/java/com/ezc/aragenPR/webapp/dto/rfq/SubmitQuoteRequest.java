package com.ezc.aragenPR.webapp.dto.rfq;

import java.util.List;

/** Submitted from the vendor quotation entry page - see ezQuotationSave.jsp. */
public record SubmitQuoteRequest(
        String paymentTerms,
        String incoTerms1,
        boolean ldApplicable,
        String ldClause,
        boolean pgApplicable,
        String pgClause,
        String comments,
        List<QuoteItemInput> items) {
}
