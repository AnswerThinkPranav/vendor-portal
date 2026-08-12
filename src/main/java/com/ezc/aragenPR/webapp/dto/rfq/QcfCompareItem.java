package com.ezc.aragenPR.webapp.dto.rfq;

/** One line item row within a vendor's block on the Quotation Comparison Form - see ezQuotationComparisionForm.jsp. */
public record QcfCompareItem(
        String lineNo,
        String material,
        String materialDesc,
        String qty,
        String perQty,
        String uom,
        String budgetPrice,
        String lastPoPrice,
        String rate,
        String totalAmount,
        String qtyRecommended) {
}
