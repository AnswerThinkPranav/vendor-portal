package com.ezc.aragenPR.webapp.dto.rfq;

import java.util.List;

/** RFQ view-details page - see ezViewRFQDetails.jsp. */
public record RfqViewDetails(
        String rfqNo,
        String collectiveRfqNo,
        String rfqDate,
        String closingDate,
        String rfqType,
        String vendorId,
        String vendorLabel,
        String buyerId,
        String status,
        boolean alreadyQuoted,
        boolean expired,
        List<RfqLineItemView> lineItems) {
}
