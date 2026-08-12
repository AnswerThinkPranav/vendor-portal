package com.ezc.aragenPR.webapp.dto.rfq;

import java.math.BigDecimal;

/** One condition entry (Discount / Pkg&Fwd / Freight) from the Item Conditions popup. type is P (percent), Q (per-qty) or V (flat value). */
public record QuoteConditionInput(String type, BigDecimal value) {
}
