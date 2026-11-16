package com.ezc.aragenPR.webapp.service.rfq;

import java.util.List;

import org.apache.poi.ss.usermodel.Workbook;

import com.ezc.aragenPR.webapp.dto.rfq.QcfCompareForm;
import com.ezc.aragenPR.webapp.dto.rfq.QcfListDataTablePage;
import com.ezc.aragenPR.webapp.dto.rfq.QcfQueryEntry;
import com.ezc.aragenPR.webapp.dto.rfq.QcfWorkflowActionRequest;
import com.ezc.aragenPR.webapp.dto.rfq.QcfWorkflowStatus;
import com.ezc.aragenPR.webapp.dto.rfq.SubmitQcfRequest;
import com.ezc.aragenPR.webapp.dto.vendorreg.ApprovalHierarchyLevel;
import com.ezc.aragenPR.webapp.dto.vendorreg.AuditTrailEntry;
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

    // --- Approval workflow (see ezViewDOMQCF.jsp) - reuses IWorkflowEngineService, same as Vendor Registration ---

    /** The current approval-workflow state for this QCF, as seen by the given user. */
    QcfWorkflowStatus getWorkflowStatus(String qcfNo, String currentUserId);

    /** A buyer/approver's Forward or Reject action on a QCF already in the workflow. */
    void actOnQcf(String qcfNo, String actorUserId, QcfWorkflowActionRequest request);

    /** The resolved workflow template's levels/roles/users for this QCF's (compCode, plant, category). */
    List<ApprovalHierarchyLevel> getApprovalHierarchy(String qcfNo);

    /** Workflow transition history for this QCF. */
    List<AuditTrailEntry> getAuditTrail(String qcfNo);

    // --- Query mechanism (an approver questioning the buyer's recommendation) ---

    /** The current-level approver raises a query - blocks Forward/Reject/Send Back until the buyer replies. */
    void raiseQuery(String qcfNo, String raisedByUserId, String queryText);

    /** The buyer (this QCF's creator) replies to the currently open query, if any. */
    void replyToQuery(String qcfNo, String repliedByUserId, String replyText);

    /** Whether this QCF has a query awaiting the buyer's reply. */
    boolean hasUnansweredQuery(String qcfNo);

    /** Full query/reply history, most recent first. */
    List<QcfQueryEntry> getQueries(String qcfNo);

    /** Builds an .xlsx workbook mirroring the on-screen comparison grid - see ezQuotationComparisionForm.jsp's Excel export. */
    Workbook exportCompareForm(String qcfNo, Users buyer);
}
