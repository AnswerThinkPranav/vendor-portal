package com.ezc.aragenPR.webapp.service.vendorreg;

import java.time.LocalDate;
import java.util.List;

import com.ezc.aragenPR.webapp.dto.vendorreg.BankDetailsRequest;
import com.ezc.aragenPR.webapp.dto.vendorreg.ConstitutionDetailsRequest;
import com.ezc.aragenPR.webapp.dto.vendorreg.ContactDetailsRequest;
import com.ezc.aragenPR.webapp.dto.vendorreg.DocumentDetailsRequest;
import com.ezc.aragenPR.webapp.dto.vendorreg.InviteVendorRequest;
import com.ezc.aragenPR.webapp.dto.vendorreg.MsmeDetailsRequest;
import com.ezc.aragenPR.webapp.dto.vendorreg.ApprovalHierarchyLevel;
import com.ezc.aragenPR.webapp.dto.vendorreg.AuditTrailEntry;
import com.ezc.aragenPR.webapp.dto.vendorreg.OptionItem;
import com.ezc.aragenPR.webapp.dto.vendorreg.VendorListDataTablePage;
import com.ezc.aragenPR.webapp.dto.vendorreg.VendorListRow;
import com.ezc.aragenPR.webapp.dto.vendorreg.VendorQueryEntry;
import com.ezc.aragenPR.webapp.dto.vendorreg.VendorRegComment;
import com.ezc.aragenPR.webapp.dto.vendorreg.VendorRegistrationDetails;
import com.ezc.aragenPR.webapp.dto.vendorreg.VendorWorkflowStatus;
import com.ezc.aragenPR.webapp.dto.vendorreg.WorkflowActionRequest;

public interface IVendorRegistrationService {

    List<OptionItem> getPurOrgOptions();

    List<OptionItem> getCompCodeOptions();

    List<OptionItem> getVenGrpOptions();

    /** Plants the given buyer is authorized for (EZC_USER_DEF_KEY_VALUES key=PLANT). */
    List<OptionItem> getAllowedPlants(String buyerUserId);

    /** Categories the given buyer is authorized for (EZC_USER_DEF_KEY_VALUES key=CATEGORY). */
    List<OptionItem> getAllowedCategories(String buyerUserId);

    /**
     * Read-only preview of the id the next invite would get, for display only - does not
     * lock or advance the TEMP_USER_NR_RANGE counter (see generateNextTempVendorId inside
     * inviteVendor). The id actually assigned on save may differ if another invite is
     * submitted first.
     */
    String peekNextTempVendorId();

    /**
     * Saves the invite as an EZC_CUSTOMER_FORM_HEADER row (+ EZC_CUSTOMER_FORM_DETAILS
     * for fields with no dedicated header column) and returns the assigned temp vendor id.
     */
    String inviteVendor(InviteVendorRequest request, String createdByUserId);

    /**
     * "New" list - vendors this buyer has invited (see ezTempVendList.jsp).
     * statusFilter is one of ALL / Reg / Res.
     */
    List<VendorListRow> getMyInvitedVendors(String buyerUserId, String venType, String statusFilter,
                                             LocalDate fromDate, LocalDate toDate);

    /**
     * "List" (VNR) - vendor registrations within the buyer's authorized plant/category
     * scope (see ezVNRList.jsp). statusFilter is one of ALL / Act / Sub / Apr / Rej / Ven -
     * mapped onto ECFH_STATUS since the legacy workflow-status join isn't available yet
     * (see CustomerFormHeaderRepository.findForVnrList).
     */
    List<VendorListRow> getVendorRegistrationList(String buyerUserId, String venType, String statusFilter,
                                                   LocalDate fromDate, LocalDate toDate);

    /** Server-side paginated/searchable variant of {@link #getVendorRegistrationList} for the DataTables grid. */
    VendorListDataTablePage getVendorRegistrationListPage(String buyerUserId, String venType, String statusFilter,
                                                            LocalDate fromDate, LocalDate toDate, String searchTerm,
                                                            int draw, int start, int length);

    // --- Full registration form (ezVendReg.jsp) ---

    /** INCO_Terms dropdown - DB-driven, EZC_MASTER_KEY_VALUES / INCO_TERM (see iVendorDetails.jsp). */
    List<OptionItem> getIncoTermsOptions();

    /** Payment Terms dropdown - DB-driven, EZC_MASTER_KEY_VALUES / PMNT_TERM. */
    List<OptionItem> getPaymentTermsOptions();

    /** Loads the header + every tab's saved EZC_CUSTOMER_FORM_DETAILS rows for pre-fill. */
    VendorRegistrationDetails getVendorRegistrationDetails(String docId);

    void saveContactDetails(String docId, ContactDetailsRequest request);

    void saveConstitutionDetails(String docId, ConstitutionDetailsRequest request);

    void saveMsmeDetails(String docId, MsmeDetailsRequest request);

    void saveDocumentDetails(String docId, DocumentDetailsRequest request);

    void saveBankDetails(String docId, BankDetailsRequest request);

    /**
     * Vendor's own submit (ezSubmitVendRegOthMat.jsp, userType=4/actionSts=V or U path) - marks
     * the registration SUBMITTED and routes it straight into the approval workflow at level 1
     * (see {@link com.ezc.aragenPR.webapp.service.workflow.IWorkflowEngineService#startWorkflow}).
     * Returns a display message naming the level-1 role the registration was submitted to (e.g.
     * "Details have been submitted to PP").
     */
    String submitVendorRegistration(String docId, String submittedByUserId);

    /**
     * Buyer pushes an already-submitted registration into the approval workflow (see
     * ezSubmitVendRegOthMat.jsp actionSts='S', legacy's showSubmit): resolves the
     * EZC_WF_KEY_MAP template for (VNR, compCode, plant, category) and starts routing at level
     * 1. Throws if the registration isn't in SUBMITTED status, or if no workflow template is
     * configured for its company code/plant/category. Returns a display message naming the
     * level-1 role (e.g. "Approval sent to next level : PP").
     */
    String submitToWorkflow(String docId, String buyerUserId);

    /** The current approval-workflow state for this registration, as seen by the given user (level, group, whether they can act, finance-field editability). */
    VendorWorkflowStatus getVendorWorkflowStatus(String docId, String currentUserId);

    /**
     * A buyer's action on a registration already in the approval workflow - forward to the
     * next level, reject, or send back to the vendor for correction (see
     * ezSubmitVendRegOthMat.jsp actionSts S/R/B). Finance fields are only persisted if the
     * actor's USERROLE is VAR/LB/SCA (see ezPrePostVendorToSAP.jsp). Returns a display message -
     * for FORWARD, names the next level's role (e.g. "Approval sent to next level : LEADBUYER").
     */
    String actOnVendorRegistration(String docId, String actorUserId, WorkflowActionRequest request);

    /** The buyer-entered finance fields currently saved for this registration (see FinanceReviewFields) - used by the SAP posting service. */
    com.ezc.aragenPR.webapp.dto.vendorreg.FinanceReviewFields getFinanceFields(String docId);

    // --- Query / Approval Hierarchy / Audit Trail (see ezVendReg.jsp Query/funShowApprovalHirearchy/funAuditTrail) ---

    /** Buyer raises a query on the registration - blocks Forward/Reject/SendBack/SAP-post until the vendor replies. */
    void raiseQuery(String docId, String raisedByUserId, String queryText);

    /** Vendor replies to the currently open query (if any) on their own registration. */
    void replyToQuery(String docId, String repliedByUserId, String replyText);

    /** Whether this registration has a query awaiting a vendor reply. */
    boolean hasUnansweredQuery(String docId);

    /** Full query/reply history, most recent first - see ezShowQuery2.jsp. */
    List<VendorQueryEntry> getQueries(String docId);

    /** The resolved workflow template's levels/roles/groups/users for this registration's (compCode, plant, category). */
    List<ApprovalHierarchyLevel> getApprovalHierarchy(String docId);

    /** Workflow transition history for this registration - see funAuditTrail. */
    List<AuditTrailEntry> getAuditTrail(String docId);

    /** Past comments logged against this registration (submit/forward/reject/etc.), oldest first - see getJGLDocComments. */
    List<VendorRegComment> getComments(String docId);

    /** File names uploaded as general attachments (not tied to a specific field) - see iGetUploadList.jsp / EUD_DOC_TYPE='VNRH'. */
    List<String> getHeaderAttachments(String docId);
}
