package com.ezc.aragenPR.webapp.dto.rfq;

import java.util.List;

/** Submitted from the Quotation Comparison Form - see ezSaveQuotationComparisionForm.jsp / ezSaveQCFWF.jsp. */
public record SubmitQcfRequest(String comments, List<QcfVendorSelection> selections) {
}
