package com.ezc.aragenPR.webapp.dto.rfq;

import java.util.List;

/** One created Purchase Order, for display after Create PO - see ezViewDOMQCF.jsp. */
public record PoSummary(String poNo, String vendorLabel, String plant, String totalValue, String currency,
        List<PoItemSummary> items) {

    public record PoItemSummary(String lineNo, String material, String materialDesc, String qty, String uom,
            String rate, String lineValue) {
    }
}
