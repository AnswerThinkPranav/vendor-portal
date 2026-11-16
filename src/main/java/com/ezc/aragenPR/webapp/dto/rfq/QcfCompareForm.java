package com.ezc.aragenPR.webapp.dto.rfq;

import java.util.List;

/** The Quotation Comparison Form page - see ezQuotationComparisionForm.jsp. */
public record QcfCompareForm(
        String qcfNo,
        String qcfTitle,
        String rfqType,
        List<QcfCompareVendor> vendors,
        List<QcfCompareLineRow> lineRows,
        List<QcfCommentEntry> commentHistory,
        QcfWorkflowStatus workflow,
        List<QcfQueryEntry> queries,
        boolean hasUnansweredQuery,
        /** True when the current viewer is the buyer who created this QCF - drives who sees the reply box vs. the raise box. */
        boolean isBuyer) {
}
