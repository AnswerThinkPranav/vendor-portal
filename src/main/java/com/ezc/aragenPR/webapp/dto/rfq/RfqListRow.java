package com.ezc.aragenPR.webapp.dto.rfq;

/** One row of the "List of RFQs" grid - see Vendor Portal/JSP/RFQ/ezListRFQs.jsp. */
public record RfqListRow(
        String rfqNo,
        String collectiveRfqNo,
        String qcfTitle,
        String prNo,
        String rfqDate,
        String vendorLabel,
        String purGrpLabel,
        String buyer,
        String closingDate,
        String status,
        String statusColor,
        String quoteIndColor,
        String listType,
        String rfqType,
        boolean expired) {
}
