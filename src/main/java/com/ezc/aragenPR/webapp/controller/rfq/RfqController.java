package com.ezc.aragenPR.webapp.controller.rfq;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

import com.ezc.aragenPR.webapp.dto.rfq.CreateRfqRequest;
import com.ezc.aragenPR.webapp.dto.rfq.PrLineItem;
import com.ezc.aragenPR.webapp.dto.rfq.PrSearchCriteria;
import com.ezc.aragenPR.webapp.dto.rfq.RfqListDataTablePage;
import com.ezc.aragenPR.webapp.dto.rfq.RfqQuoteFormView;
import com.ezc.aragenPR.webapp.dto.rfq.RfqViewDetails;
import com.ezc.aragenPR.webapp.dto.rfq.SubmitQuoteRequest;
import com.ezc.aragenPR.webapp.dto.rfq.VendorDataTablePage;
import com.ezc.aragenPR.webapp.dto.rfq.VendorOption;
import com.ezc.aragenPR.webapp.model.user.Users;
import com.ezc.aragenPR.webapp.service.rfq.IRfqService;
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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * RFQ-from-PRs flow - see Vendor Portal/JSP/RFQ (ezPrePRList -> ezListPR -> ezVendorViewList
 * -> ezEnterEndDate -> ezCreateRFQ). SAP is called live via {@link IRfqService#searchPurchaseRequisitions}
 * (backed by ISapPrFetchService); when SAP is unreachable (e.g. this local dev environment - see
 * sap.properties) that service transparently falls back to one example PR so this whole flow can
 * still be exercised end-to-end. Vendors are read live from the local DB (EZC_USERS).
 */
@Controller
@RequestMapping("/rfq")
public class RfqController {

    @Autowired
    private IRfqService rfqService;

    @GetMapping("/createFromPr")
    public String showCreateFromPr(Model model) {
        model.addAttribute("purGrpOptions", rfqService.getPurGrpOptions());
        model.addAttribute("plantOptions", rfqService.getPlantOptions());
        model.addAttribute("docTypeOptions", rfqService.getDocTypeOptions());
        model.addAttribute("matGrpOptions", rfqService.getMatGrpOptions());
        model.addAttribute("accCatOptions", rfqService.getAccCatOptions());
        model.addAttribute("itemCatOptions", rfqService.getItemCatOptions());
        return "rfq/createFromPr";
    }

    @PostMapping("/api/search")
    @ResponseBody
    public ResponseEntity<List<PrLineItem>> searchPrs(@RequestBody PrSearchCriteria criteria) {
        return ResponseEntity.ok(rfqService.searchPurchaseRequisitions(criteria, currentUser().getUserId()));
    }

    @GetMapping("/api/vendors")
    @ResponseBody
    public ResponseEntity<Map<String, List<VendorOption>>> vendors(
            @RequestParam(defaultValue = "S") String type,
            @RequestParam(required = false) String q) {
        List<VendorOption> vendors = "N".equalsIgnoreCase(type)
                ? rfqService.getNonSapVendors(q)
                : rfqService.getSapVendors(q);
        return ResponseEntity.ok(Map.of("vendors", vendors));
    }

    /** jQuery DataTables server-side processing endpoint backing the "Select Vendor" grid. */
    @GetMapping("/api/vendors/datatable")
    @ResponseBody
    public ResponseEntity<VendorDataTablePage> vendorsDataTable(
            @RequestParam(defaultValue = "S") String type,
            @RequestParam(defaultValue = "0") int draw,
            @RequestParam(defaultValue = "0") int start,
            @RequestParam(defaultValue = "10") int length,
            @RequestParam(name = "search[value]", required = false) String searchValue) {
        return ResponseEntity.ok(rfqService.getVendorsPage(type, searchValue, draw, start, length));
    }

    // --- List of RFQs (ezListRFQs.jsp) ---

    @GetMapping("/list")
    public String showRfqList(Model model,
                               @RequestParam(defaultValue = "ALL") String type,
                               @RequestParam(defaultValue = "DOM") String rfqType,
                               @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fromDate,
                               @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate toDate) {
        model.addAttribute("type", type);
        model.addAttribute("rfqType", rfqType);
        model.addAttribute("fromDate", fromDate);
        model.addAttribute("toDate", toDate);
        model.addAttribute("isVendor", isVendorUser(currentUser()));
        return "rfq/list";
    }

    /** jQuery DataTables server-side processing endpoint backing the "List of RFQs" grid. */
    @GetMapping("/list/datatable")
    @ResponseBody
    public ResponseEntity<RfqListDataTablePage> rfqListDataTable(
            @RequestParam(defaultValue = "ALL") String type,
            @RequestParam(defaultValue = "DOM") String rfqType,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fromDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate toDate,
            @RequestParam(required = false) String selVendorCode,
            @RequestParam(defaultValue = "0") int draw,
            @RequestParam(defaultValue = "0") int start,
            @RequestParam(defaultValue = "10") int length) {
        return ResponseEntity.ok(rfqService.getRfqListPage(
                currentUser(), type, rfqType, fromDate, toDate, selVendorCode, draw, start, length));
    }

    // --- RFQ view-details page (ezViewRFQDetails.jsp) ---

    @GetMapping("/view/{rfqNo}")
    public String viewRfqDetails(@PathVariable String rfqNo, Model model,
                                  @RequestParam(defaultValue = "ALL") String type,
                                  @RequestParam(defaultValue = "DOM") String rfqType) {
        model.addAttribute("details", rfqService.getRfqViewDetails(rfqNo, currentUser()));
        model.addAttribute("type", type);
        model.addAttribute("rfqType", rfqType);
        return "rfq/view";
    }

    // --- Vendor quotation entry page (ezPostQuote.jsp) ---

    @GetMapping("/quote/{rfqNo}")
    public String showQuoteForm(@PathVariable String rfqNo, Model model) {
        model.addAttribute("form", rfqService.getQuoteForm(rfqNo, currentUser()));
        return "rfq/quote";
    }

    @PostMapping("/api/quote/{rfqNo}/submit")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> submitQuote(@PathVariable String rfqNo, @RequestBody SubmitQuoteRequest request) {
        String validationError = validateQuote(request);
        if (validationError != null) {
            return ResponseEntity.badRequest().body(Map.of("status", "ERROR", "message", validationError));
        }
        rfqService.submitQuote(rfqNo, request, currentUser());
        return ResponseEntity.ok(Map.of("status", "OK", "message", "Quotation submitted successfully."));
    }

    private String validateQuote(SubmitQuoteRequest r) {
        if (r.paymentTerms() == null || r.paymentTerms().isBlank()) return "Please select Payment Terms";
        if (r.incoTerms1() == null || r.incoTerms1().isBlank()) return "Please select Inco Terms";
        if (r.items() == null || r.items().isEmpty()) return "No line items to quote";
        boolean anyPriced = r.items().stream().anyMatch(i -> i.price() != null && i.price().compareTo(java.math.BigDecimal.ZERO) > 0);
        if (!anyPriced) return "Please enter the price for at least one material";
        return null;
    }

    private boolean isVendorUser(Users u) {
        return u.getUserType() != null && (u.getUserType() == 3 || u.getUserType() == 4);
    }

    // --- Buyer decision on a vendor's quote (ezViewQuoteDetails.jsp) ---

    @PostMapping("/api/{rfqNo}/approve")
    @ResponseBody
    public ResponseEntity<Map<String, String>> approveQuote(@PathVariable String rfqNo, @RequestBody Map<String, String> body) {
        try {
            rfqService.approveQuote(rfqNo, currentUser(), body.get("comments"));
            return ResponseEntity.ok(Map.of("status", "OK", "message", "Quotation approved."));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("status", "ERROR", "message", e.getMessage()));
        }
    }

    @PostMapping("/api/{rfqNo}/reject")
    @ResponseBody
    public ResponseEntity<Map<String, String>> rejectQuote(@PathVariable String rfqNo, @RequestBody Map<String, String> body) {
        try {
            rfqService.rejectQuote(rfqNo, currentUser(), body.get("comments"));
            return ResponseEntity.ok(Map.of("status", "OK", "message", "Quotation rejected."));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("status", "ERROR", "message", e.getMessage()));
        }
    }

    @PostMapping("/api/{rfqNo}/requote")
    @ResponseBody
    public ResponseEntity<Map<String, String>> requoteQuote(@PathVariable String rfqNo, @RequestBody Map<String, String> body) {
        try {
            rfqService.requoteQuote(rfqNo, currentUser(), body.get("comments"));
            return ResponseEntity.ok(Map.of("status", "OK", "message", "Sent back to vendor for requote."));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("status", "ERROR", "message", e.getMessage()));
        }
    }

    @PostMapping("/api/create")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> createRfq(@RequestBody CreateRfqRequest request) {
        String validationError = validate(request);
        if (validationError != null) {
            return ResponseEntity.badRequest().body(Map.of("status", "ERROR", "message", validationError));
        }

        String qcfNo = rfqService.createRfq(request, currentUser().getUserId());
        return ResponseEntity.ok(Map.of(
                "status", "OK",
                "qcfNo", qcfNo,
                "message", "RFQ created successfully. QCF No: " + qcfNo
        ));
    }

    private String validate(CreateRfqRequest r) {
        if (r.getPurGrp() == null || r.getPurGrp().isBlank()) return "Please select a Purchase Group";
        if (r.getItems() == null || r.getItems().isEmpty()) return "Please select at least one PR line";
        if (r.getVendors() == null || r.getVendors().isEmpty()) return "Please select at least one vendor";
        if (r.getQtnEndDate() == null) return "Please enter the Quotation End Date";
        return null;
    }

    private Users currentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        return (Users) authentication.getPrincipal();
    }
}
