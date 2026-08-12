package com.ezc.aragenPR.webapp.service.rfq;

import com.ezc.aragenPR.webapp.dto.rfq.QcfCompareForm;
import com.ezc.aragenPR.webapp.dto.rfq.QcfListDataTablePage;
import com.ezc.aragenPR.webapp.dto.rfq.SubmitQcfRequest;
import com.ezc.aragenPR.webapp.model.user.Users;

/**
 * QCF ("Collective RFQ") flow - grouping vendor RFQs raised under one Purchase Requisition
 * batch. See Vendor Portal/JSP/RFQ (ezListQcfs / ezQCSList / ezQuotationComparisionForm /
 * ezSaveQuotationComparisionForm / ezSaveQCFWF).
 */
public interface IQcfService {

    /** "List of QCF(s)" grid - type is New (not yet submitted) or Sub (submitted into workflow) - see ezListQcfs.jsp. */
    QcfListDataTablePage getQcfList(Users buyer, String type, String rfqType, int draw, int start, int length);

    /** QCS list - QCFs already submitted into the approval workflow - see ezQCSList.jsp. */
    QcfListDataTablePage getQcsList(Users buyer, String wfStatus, int draw, int start, int length);

    /** The Quotation Comparison Form - all vendors' quotes side by side - see ezQuotationComparisionForm.jsp. */
    QcfCompareForm getCompareForm(String qcfNo, String type, Users buyer);

    /** Recommends quantities to selected vendor(s) and submits the QCF into the approval workflow. */
    void submitQcf(String qcfNo, SubmitQcfRequest request, Users buyer);
}
