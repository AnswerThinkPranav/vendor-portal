package com.ezc.aragenPR.webapp.dto.rfq;

import java.math.BigDecimal;

public record QcfLineQtyInput(String lineNo, BigDecimal qtyRecommended) {
}
