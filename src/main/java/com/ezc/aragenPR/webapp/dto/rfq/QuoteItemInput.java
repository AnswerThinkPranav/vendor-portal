package com.ezc.aragenPR.webapp.dto.rfq;

import java.math.BigDecimal;

/** One RFQ line's quote entry, submitted from ezPostQuote-equivalent page + its Item Conditions popup. */
public record QuoteItemInput(
        String lineNo,
        BigDecimal qty,
        BigDecimal perQty,
        BigDecimal price,
        BigDecimal mrpPrice,
        String currency,
        String hsnCode,
        String warranty,
        QuoteConditionInput discount,
        QuoteConditionInput pkgFwd,
        QuoteConditionInput freight,
        BigDecimal gstPercent) {
}
