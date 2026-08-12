package com.ezc.aragenPR.webapp.dto.rfq;

import java.util.List;

/**
 * One row of the Quotation Comparison Form's item table when multiple vendors are being compared -
 * SR No/Material/Description/Qty/Per/UOM/Budget Price/Last PO Price are shared across every vendor
 * (same underlying PR line), shown once; Rate/Total/Qty Recommended differ per vendor (vendorCells,
 * same order as QcfCompareForm.vendors()) - see ezQuotationComparisionForm.jsp.
 */
public record QcfCompareLineRow(
        String lineNo,
        String material,
        String materialDesc,
        String qty,
        String perQty,
        String uom,
        String budgetPrice,
        String lastPoPrice,
        List<QcfVendorLineCell> vendorCells) {
}
