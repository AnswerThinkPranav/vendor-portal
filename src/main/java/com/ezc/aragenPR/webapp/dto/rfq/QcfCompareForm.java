package com.ezc.aragenPR.webapp.dto.rfq;

import java.util.List;

/** The Quotation Comparison Form page - see ezQuotationComparisionForm.jsp. */
public record QcfCompareForm(
        String qcfNo,
        String qcfTitle,
        String rfqType,
        boolean showSubmit,
        List<QcfCompareVendor> vendors,
        List<QcfCompareLineRow> lineRows,
        List<QcfCommentEntry> commentHistory) {
}
