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
        List<QuoteLineItemView> items,
        /** True when the current user is the vendor this RFQ was sent to - only they may edit/submit. */
        boolean isOwner,
        /** ERH_STATUS - "N"=not yet quoted, "P"=quoted/to approve, "Y"=approved, "X"=rejected, "R"=requote. */
        String status,
        /** True when the current user is the buyer and this quote is awaiting their decision (status "P"). */
        boolean canAct) {
}
