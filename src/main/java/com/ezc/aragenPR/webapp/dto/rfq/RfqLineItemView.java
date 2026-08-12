package com.ezc.aragenPR.webapp.dto.rfq;

/** One line item row on the RFQ view-details page - see ezViewRFQDetails.jsp. */
public record RfqLineItemView(
        String lineNo,
        String prNo,
        String material,
        String materialDesc,
        String uom,
        String qty,
        String plant,
        String remarks) {
}
