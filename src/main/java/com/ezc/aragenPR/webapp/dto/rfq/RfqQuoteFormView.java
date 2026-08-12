package com.ezc.aragenPR.webapp.dto.rfq;

import java.util.List;

import com.ezc.aragenPR.webapp.dto.vendorreg.OptionItem;

/** The vendor quotation entry page - see ezPostQuote.jsp. */
public record RfqQuoteFormView(
        String rfqNo,
        String rfqDate,
        String closingDate,
        String qtnDate,
        String rfqType,
        String paymentTerms,
        String incoTerms1,
        String ldStatus,
        String ldClause,
        String pgStatus,
        String pgClause,
        List<OptionItem> paymentTermsOptions,
        List<OptionItem> incoTermsOptions,
        List<QuoteLineItemView> items) {
}
