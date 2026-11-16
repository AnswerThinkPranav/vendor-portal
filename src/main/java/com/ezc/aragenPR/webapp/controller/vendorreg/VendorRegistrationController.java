package com.ezc.aragenPR.webapp.controller.vendorreg;

import java.nio.file.AccessDeniedException;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

import com.ezc.aragenPR.webapp.dto.vendorreg.ApprovalHierarchyLevel;
import com.ezc.aragenPR.webapp.dto.vendorreg.AuditTrailEntry;
import com.ezc.aragenPR.webapp.dto.vendorreg.BankDetailsRequest;
import com.ezc.aragenPR.webapp.dto.vendorreg.ConstitutionDetailsRequest;
import com.ezc.aragenPR.webapp.dto.vendorreg.ContactDetailsRequest;
import com.ezc.aragenPR.webapp.dto.vendorreg.DocumentDetailsRequest;
import com.ezc.aragenPR.webapp.dto.vendorreg.InviteVendorRequest;
import com.ezc.aragenPR.webapp.dto.vendorreg.MsmeDetailsRequest;
import com.ezc.aragenPR.webapp.dto.vendorreg.VendorListDataTablePage;
import com.ezc.aragenPR.webapp.dto.vendorreg.VendorListRow;
import com.ezc.aragenPR.webapp.dto.vendorreg.VendorQueryEntry;
import com.ezc.aragenPR.webapp.dto.vendorreg.VendorRegLookups;
import com.ezc.aragenPR.webapp.dto.vendorreg.VendorRegistrationDetails;
import com.ezc.aragenPR.webapp.dto.vendorreg.VendorWorkflowStatus;
import com.ezc.aragenPR.webapp.dto.vendorreg.WorkflowActionRequest;
import com.ezc.aragenPR.webapp.model.user.Users;
import com.ezc.aragenPR.webapp.service.vendorreg.IVendorRegistrationService;
import com.ezc.aragenPR.webapp.service.vendorreg.IVendorSapPostingService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * Vendor Registration module - Invite Vendor (see ezTempUserCreation.jsp / ezAddTempUser.jsp),
 * New (see ezTempVendList.jsp), List (see ezVNRList.jsp), and the full multi-tab registration
 * form (see ezVendReg.jsp / ezSaveVendRegOthMat.jsp). RFQ/QCF land in a later step.
 */
@Slf4j
@Controller
public class VendorRegistrationController {

    @Autowired
    private IVendorRegistrationService vendorRegistrationService;

    @Autowired
    private IVendorSapPostingService vendorSapPostingService;

    @GetMapping("/vendorReg/invite")
    public String showInviteVendor(Model model) {
        Users buyer = currentUser();

        model.addAttribute("nextTempVendorId", vendorRegistrationService.peekNextTempVendorId());
        model.addAttribute("purOrgOptions", vendorRegistrationService.getPurOrgOptions());
        model.addAttribute("compCodeOptions", vendorRegistrationService.getCompCodeOptions());
        model.addAttribute("venGrpOptions", vendorRegistrationService.getVenGrpOptions());
        model.addAttribute("plantOptions", vendorRegistrationService.getAllowedPlants(buyer.getUserId()));
        model.addAttribute("categoryOptions", vendorRegistrationService.getAllowedCategories(buyer.getUserId()));

        return "vendorReg/invite";
    }

    @PostMapping("/vendorReg/invite")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> saveInviteVendor(@RequestBody InviteVendorRequest request) {
        String validationError = validate(request);
        if (validationError != null) {
            return ResponseEntity.badRequest().body(Map.of("status", "ERROR", "message", validationError));
        }

        String docId = vendorRegistrationService.inviteVendor(request, currentUser().getUserId());

        return ResponseEntity.ok(Map.of(
                "status", "OK",
                "docId", docId,
                "message", "Vendor invited successfully. Temp Vendor ID: " + docId
        ));
    }

    @GetMapping("/vendorReg/new")
    public String showMyInvites(Model model,
                                 @RequestParam(defaultValue = "ALL") String type,
                                 @RequestParam(defaultValue = "IN") String venType,
                                 @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fromDate,
                                 @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate toDate) {
        Users buyer = currentUser();
        List<VendorListRow> rows = vendorRegistrationService.getMyInvitedVendors(
                buyer.getUserId(), venType, type, fromDate, toDate);

        model.addAttribute("rows", rows);
        model.addAttribute("type", type);
        model.addAttribute("venType", venType);
        model.addAttribute("fromDate", fromDate);
        model.addAttribute("toDate", toDate);
        return "vendorReg/new";
    }

    @GetMapping("/vendorReg/list")
    public String showVendorRegistrationList(Model model,
                                              @RequestParam(defaultValue = "ALL") String type,
                                              @RequestParam(defaultValue = "IN") String venType,
                                              @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fromDate,
                                              @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate toDate) {
        // Rows are loaded client-side via the paginated/searchable DataTables endpoint below.
        model.addAttribute("type", type);
        model.addAttribute("venType", venType);
        model.addAttribute("fromDate", fromDate);
        model.addAttribute("toDate", toDate);
        return "vendorReg/list";
    }

    /** jQuery DataTables server-side processing endpoint backing the "List" grid. */
    @GetMapping("/vendorReg/list/datatable")
    @ResponseBody
    public ResponseEntity<VendorListDataTablePage> vendorRegistrationListDataTable(
            @RequestParam(defaultValue = "ALL") String type,
            @RequestParam(defaultValue = "IN") String venType,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fromDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate toDate,
            @RequestParam(defaultValue = "0") int draw,
            @RequestParam(defaultValue = "0") int start,
            @RequestParam(defaultValue = "10") int length,
            @RequestParam(name = "search[value]", required = false) String searchValue) {
        Users buyer = currentUser();
        return ResponseEntity.ok(vendorRegistrationService.getVendorRegistrationListPage(
                buyer.getUserId(), venType, type, fromDate, toDate, searchValue, draw, start, length));
    }

    /**
     * Single page for both the vendor's fill-in flow and the buyer's review/approval flow - same
     * tab-wise details throughout, gated by ownership: the vendor (docId == their own login id,
     * see IVendorRegistrationService.inviteVendor) can edit and submit; anyone else (a buyer) sees
     * the same tabs read-only plus the workflow status banner and action buttons (Send Back,
     * Reject, Forward, Query, Approval Hierarchy, Audit Trail, Submit to Workflow, SAP posting).
     */
    @GetMapping("/vendorReg/register/{docId}")
    public String showRegistrationForm(@PathVariable String docId, Model model) throws AccessDeniedException {
        boolean isOwner = docId.equals(currentUser().getUserId());

        VendorRegistrationDetails details = vendorRegistrationService.getVendorRegistrationDetails(docId);
        // INITIATED means the vendor hasn't submitted yet (or it was just Sent Back to them, which
        // resets it to this same state - see actOnVendorRegistration's SEND_BACK case) - a buyer has
        // nothing to review yet, so it's not even visible to open, only the owning vendor can.
        if (!isOwner && "INITIATED".equals(details.getStatus())) {
            throw new AccessDeniedException("This vendor registration has not been submitted yet.");
        }
        model.addAttribute("isOwner", isOwner);
        model.addAttribute("hasUnansweredQuery", vendorRegistrationService.hasUnansweredQuery(docId));
        model.addAttribute("queries", vendorRegistrationService.getQueries(docId));
        model.addAttribute("comments", vendorRegistrationService.getComments(docId));
        model.addAttribute("headerAttachments", vendorRegistrationService.getHeaderAttachments(docId));
        model.addAttribute("workflow", vendorRegistrationService.getVendorWorkflowStatus(docId, currentUser().getUserId()));

        model.addAttribute("details", details);
        model.addAttribute("countryOptions", VendorRegLookups.countries());
        model.addAttribute("stateOptions", VendorRegLookups.states());
        model.addAttribute("currencyOptions", VendorRegLookups.currencies());
        model.addAttribute("conMethodOptions", VendorRegLookups.preferredContactMethods());
        model.addAttribute("orgTypeOptions", VendorRegLookups.organizationTypes());
        model.addAttribute("supTypeOptions", VendorRegLookups.supplierTypes());
        model.addAttribute("vendorTypeOptions", VendorRegLookups.vendorTypes());
        model.addAttribute("gstVendorClasOptions", VendorRegLookups.gstVendorClassifications());
        model.addAttribute("gstTypeOptions", VendorRegLookups.gstRegistrationTypes());
        model.addAttribute("msmeTypeOptions", VendorRegLookups.msmeStatusTypes());
        model.addAttribute("busStatusOptions", VendorRegLookups.businessStatusTypes());
        model.addAttribute("incoTermsOptions", vendorRegistrationService.getIncoTermsOptions());
        model.addAttribute("paymentTermsOptions", vendorRegistrationService.getPaymentTermsOptions());

        return "vendorReg/register";
    }

    @PostMapping("/vendorReg/register/{docId}/contact")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> saveContact(@PathVariable String docId, @RequestBody ContactDetailsRequest request) {
        vendorRegistrationService.saveContactDetails(docId, request);
        return ResponseEntity.ok(Map.of("status", "OK", "message", "Vendor information saved"));
    }

    @PostMapping("/vendorReg/register/{docId}/constitution")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> saveConstitution(@PathVariable String docId, @RequestBody ConstitutionDetailsRequest request) {
        vendorRegistrationService.saveConstitutionDetails(docId, request);
        return ResponseEntity.ok(Map.of("status", "OK", "message", "Commercial information saved"));
    }

    @PostMapping("/vendorReg/register/{docId}/msme")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> saveMsme(@PathVariable String docId, @RequestBody MsmeDetailsRequest request) {
        vendorRegistrationService.saveMsmeDetails(docId, request);
        return ResponseEntity.ok(Map.of("status", "OK", "message", "Financial information saved"));
    }

    @PostMapping("/vendorReg/register/{docId}/documents")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> saveDocuments(@PathVariable String docId, @RequestBody DocumentDetailsRequest request) {
        vendorRegistrationService.saveDocumentDetails(docId, request);
        return ResponseEntity.ok(Map.of("status", "OK", "message", "Attachments saved"));
    }

    @PostMapping("/vendorReg/register/{docId}/bank")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> saveBank(@PathVariable String docId, @RequestBody BankDetailsRequest request) {
        vendorRegistrationService.saveBankDetails(docId, request);
        return ResponseEntity.ok(Map.of("status", "OK", "message", "Bank details saved"));
    }

    @PostMapping("/vendorReg/register/{docId}/submit")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> submit(@PathVariable String docId) {
        try {
            String message = vendorRegistrationService.submitVendorRegistration(docId, currentUser().getUserId());
            return ResponseEntity.ok(Map.of("status", "OK", "message", message));
        } catch (Exception e) {
            log.warn("submitVendorRegistration failed for {}: {}", docId, e.getMessage());
            return ResponseEntity.badRequest().body(Map.of("status", "ERROR", "message", e.getMessage()));
        }
    }

    /** Vendor's reply to the currently open query on their own registration (see ezShowQuery2.jsp submitQuery). */
    @PostMapping("/vendorReg/register/{docId}/query-reply")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> replyToQuery(@PathVariable String docId, @RequestBody Map<String, String> body) {
        try {
            vendorRegistrationService.replyToQuery(docId, currentUser().getUserId(), body.get("replyText"));
            return ResponseEntity.ok(Map.of("status", "OK", "message", "Reply sent"));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("status", "ERROR", "message", e.getMessage()));
        }
    }

    /** Old buyer review/approval screen - now merged into showRegistrationForm (same tab-wise page for both vendor and buyer). */
    @GetMapping("/vendorReg/approve/{docId}")
    public String showApprovalScreen(@PathVariable String docId) {
        return "redirect:/vendorReg/register/" + docId;
    }

    @PostMapping("/vendorReg/approve/{docId}/action")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> actOnRegistration(@PathVariable String docId, @RequestBody WorkflowActionRequest request) {
        try {
            String message = vendorRegistrationService.actOnVendorRegistration(docId, currentUser().getUserId(), request);
            return ResponseEntity.ok(Map.of("status", "OK", "message", message));
        } catch (Exception e) {
            log.warn("actOnVendorRegistration failed for {}: {}", docId, e.getMessage());
            return ResponseEntity.badRequest().body(Map.of("status", "ERROR", "message", e.getMessage()));
        }
    }

    /** Buyer pushes a submitted registration into the approval workflow (see legacy showSubmit / actionSts='S'). */
    @PostMapping("/vendorReg/approve/{docId}/submit-to-workflow")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> submitToWorkflow(@PathVariable String docId) {
        try {
            String message = vendorRegistrationService.submitToWorkflow(docId, currentUser().getUserId());
            return ResponseEntity.ok(Map.of("status", "OK", "message", message));
        } catch (Exception e) {
            log.warn("submitToWorkflow failed for {}: {}", docId, e.getMessage());
            return ResponseEntity.badRequest().body(Map.of("status", "ERROR", "message", e.getMessage()));
        }
    }

    /** Buyer raises a query on the registration - blocks Forward/Reject/SendBack/SAP-post until the vendor replies (see funQuery). */
    @PostMapping("/vendorReg/approve/{docId}/query")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> raiseQuery(@PathVariable String docId, @RequestBody Map<String, String> body) {
        String queryText = body.get("queryText");
        if (queryText == null || queryText.isBlank()) {
            return ResponseEntity.badRequest().body(Map.of("status", "ERROR", "message", "Please enter the query"));
        }
        vendorRegistrationService.raiseQuery(docId, currentUser().getUserId(), queryText);
        return ResponseEntity.ok(Map.of("status", "OK", "message", "Query sent to the vendor"));
    }

    /** Resolved workflow template levels/roles/users for this registration (see funShowApprovalHirearchy / ezWFUsers.jsp). */
    @GetMapping("/vendorReg/{docId}/hierarchy")
    @ResponseBody
    public ResponseEntity<List<ApprovalHierarchyLevel>> approvalHierarchy(@PathVariable String docId) {
        return ResponseEntity.ok(vendorRegistrationService.getApprovalHierarchy(docId));
    }

    /** Workflow transition history for this registration (see funAuditTrail). */
    @GetMapping("/vendorReg/{docId}/audit-trail")
    @ResponseBody
    public ResponseEntity<List<AuditTrailEntry>> auditTrail(@PathVariable String docId) {
        return ResponseEntity.ok(vendorRegistrationService.getAuditTrail(docId));
    }

    /** Query/reply history for this registration (see ezShowQuery2.jsp). */
    @GetMapping("/vendorReg/{docId}/queries")
    @ResponseBody
    public ResponseEntity<List<VendorQueryEntry>> queries(@PathVariable String docId) {
        return ResponseEntity.ok(vendorRegistrationService.getQueries(docId));
    }

    @PostMapping("/vendorReg/approve/{docId}/sap-validate")
    @ResponseBody
    public ResponseEntity<?> validateSap(@PathVariable String docId) {
        try {
            return ResponseEntity.ok(vendorSapPostingService.validateVendor(docId));
        } catch (Exception e) {
            log.warn("SAP validate failed for {}: {}", docId, e.getMessage());
            return ResponseEntity.badRequest().body(Map.of("status", "ERROR", "message", e.getMessage()));
        }
    }

    @PostMapping("/vendorReg/approve/{docId}/sap-post")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> postToSap(@PathVariable String docId, @RequestBody Map<String, String> body) {
        try {
            String vendorCode = vendorSapPostingService.postVendor(docId, currentUser().getUserId(), body.get("comments"));
            return ResponseEntity.ok(Map.of("status", "OK", "vendorCode", vendorCode,
                    "message", "Vendor posted to SAP. Vendor Code: " + vendorCode));
        } catch (Exception e) {
            log.warn("SAP post failed for {}: {}", docId, e.getMessage());
            return ResponseEntity.badRequest().body(Map.of("status", "ERROR", "message", e.getMessage()));
        }
    }

    private String validate(InviteVendorRequest r) {
        if (isBlank(r.getUserName())) return "Please enter the Vendor Name";
        if (isBlank(r.getEmail())) return "Please enter the Vendor Email";
        if (isBlank(r.getCompCode())) return "Please select a Company Code";
        if (isBlank(r.getPurOrg())) return "Please select a Purchase Org";
        if (isBlank(r.getVenGrp())) return "Please select an Account Group";
        if (isBlank(r.getVenType())) return "Please select a Vendor Type";
        if (isBlank(r.getSelPlant())) return "Please select a Plant";
        if (isBlank(r.getSelCategory())) return "Please select a Category";
        if (!r.isRfqAuth() && !r.isVendRegAuth()) return "Please select at least one authorization (RFQ or Vendor Registration Form)";
        return null;
    }

    private boolean isBlank(String s) {
        return s == null || s.isBlank();
    }

    private Users currentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        return (Users) authentication.getPrincipal();
    }
}
