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
        String warranty,
        /** Previously saved condition values (RfqItemCondition), so re-opening the quote form -
         * whether the vendor editing again or a buyer reviewing - shows what was actually quoted
         * instead of resetting to blank. Type is P/Q/V (percent/per-qty/value), or "" if unset. */
        String discType, String discValue,
        String pkfwType, String pkfwValue,
        String frtType, String frtValue,
        String gstPercent) {
}
