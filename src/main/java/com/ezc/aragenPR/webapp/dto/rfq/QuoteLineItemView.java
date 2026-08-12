package com.ezc.aragenPR.webapp.dto.rfq;

/** One line item row on the vendor quotation entry page - see ezPostQuote.jsp. */
public record QuoteLineItemView(
        String lineNo,
        String material,
        String materialDesc,
        String matGroup,
        String hsnCode,
        String qty,
        String perQty,
        String uom,
        String mrpPrice,
        String price,
        String currency,
        String remarks,
        String deliveryDate,
        String warranty) {
}
