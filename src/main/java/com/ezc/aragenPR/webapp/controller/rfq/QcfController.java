package com.ezc.aragenPR.webapp.controller.rfq;

import java.io.IOException;
import java.util.Map;

import java.util.List;

import jakarta.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Workbook;

import com.ezc.aragenPR.webapp.dto.rfq.QcfCompareForm;
import com.ezc.aragenPR.webapp.dto.rfq.QcfListDataTablePage;
import com.ezc.aragenPR.webapp.dto.rfq.QcfWorkflowActionRequest;
import com.ezc.aragenPR.webapp.dto.rfq.QcfWorkflowStatus;
import com.ezc.aragenPR.webapp.dto.rfq.SubmitQcfRequest;
import com.ezc.aragenPR.webapp.dto.vendorreg.ApprovalHierarchyLevel;
import com.ezc.aragenPR.webapp.dto.vendorreg.AuditTrailEntry;
import com.ezc.aragenPR.webapp.model.user.Users;
import com.ezc.aragenPR.webapp.service.rfq.IQcfService;
import org.springframework.beans.factory.annotation.Autowired;
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
 * QCF ("Collective RFQ") flow - see Vendor Portal/JSP/RFQ (ezListQcfs / ezQCSList /
 * ezQuotationComparisionForm / ezViewDOMQCF). Create PO lives in {@link PoController}.
 */
@Controller
@RequestMapping("/qcf")
public class QcfController {

    @Autowired
    private IQcfService qcfService;

    @GetMapping("/list")
    public String showQcfList(Model model,
                               @RequestParam(defaultValue = "New") String type,
                               @RequestParam(defaultValue = "DOM") String rfqType) {
        model.addAttribute("type", type);
        model.addAttribute("rfqType", rfqType);
        return "qcf/list";
    }

    @GetMapping("/list/datatable")
    @ResponseBody
    public ResponseEntity<QcfListDataTablePage> qcfListDataTable(
            @RequestParam(defaultValue = "New") String type,
            @RequestParam(defaultValue = "DOM") String rfqType,
            @RequestParam(defaultValue = "0") int draw,
            @RequestParam(defaultValue = "0") int start,
            @RequestParam(defaultValue = "10") int length) {
        return ResponseEntity.ok(qcfService.getQcfList(currentUser(), type, rfqType, draw, start, length));
    }

    @GetMapping("/qcsList")
    public String showQcsList(Model model, @RequestParam(defaultValue = "ALL") String wfStatus) {
        model.addAttribute("wfStatus", wfStatus);
        return "qcf/qcsList";
    }

    @GetMapping("/qcsList/datatable")
    @ResponseBody
    public ResponseEntity<QcfListDataTablePage> qcsListDataTable(
            @RequestParam(defaultValue = "ALL") String wfStatus,
            @RequestParam(defaultValue = "0") int draw,
            @RequestParam(defaultValue = "0") int start,
            @RequestParam(defaultValue = "10") int length) {
        return ResponseEntity.ok(qcfService.getQcsList(currentUser(), wfStatus, draw, start, length));
    }

    @GetMapping("/compare/{qcfNo}")
    public String showCompareForm(@PathVariable String qcfNo, Model model,
                                   @RequestParam(defaultValue = "New") String type) {
        QcfCompareForm form = qcfService.getCompareForm(qcfNo, type, currentUser());
        model.addAttribute("form", form);
        model.addAttribute("type", type);
        return "qcf/compare";
    }

    @PostMapping("/api/{qcfNo}/submit")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> submitQcf(@PathVariable String qcfNo, @RequestBody SubmitQcfRequest request) {
        try {
            qcfService.submitQcf(qcfNo, request, currentUser());
            return ResponseEntity.ok(Map.of("status", "OK", "message", "QCF " + qcfNo + " submitted for approval."));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("status", "ERROR", "message", e.getMessage()));
        }
    }

    // --- Approval workflow (ezViewDOMQCF.jsp) ---

    @PostMapping("/api/{qcfNo}/action")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> actOnQcf(@PathVariable String qcfNo, @RequestBody QcfWorkflowActionRequest request) {
        try {
            qcfService.actOnQcf(qcfNo, currentUser().getUserId(), request);
            return ResponseEntity.ok(Map.of("status", "OK", "message", "Action completed."));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("status", "ERROR", "message", e.getMessage()));
        }
    }

    @GetMapping("/{qcfNo}/hierarchy")
    @ResponseBody
    public ResponseEntity<List<ApprovalHierarchyLevel>> hierarchy(@PathVariable String qcfNo) {
        return ResponseEntity.ok(qcfService.getApprovalHierarchy(qcfNo));
    }

    @GetMapping("/{qcfNo}/audit-trail")
    @ResponseBody
    public ResponseEntity<List<AuditTrailEntry>> auditTrail(@PathVariable String qcfNo) {
        return ResponseEntity.ok(qcfService.getAuditTrail(qcfNo));
    }

    @GetMapping("/{qcfNo}/export")
    public void exportCompareForm(@PathVariable String qcfNo, HttpServletResponse response) throws IOException {
        Workbook wb = qcfService.exportCompareForm(qcfNo, currentUser());
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=QCF_" + qcfNo + ".xlsx");
        wb.write(response.getOutputStream());
        wb.close();
    }

    // --- Query mechanism (an approver questioning the buyer's recommendation) ---

    @PostMapping("/api/{qcfNo}/query")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> raiseQuery(@PathVariable String qcfNo, @RequestBody Map<String, String> body) {
        try {
            qcfService.raiseQuery(qcfNo, currentUser().getUserId(), body.get("queryText"));
            return ResponseEntity.ok(Map.of("status", "OK", "message", "Query raised."));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("status", "ERROR", "message", e.getMessage()));
        }
    }

    @PostMapping("/api/{qcfNo}/query-reply")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> replyToQuery(@PathVariable String qcfNo, @RequestBody Map<String, String> body) {
        try {
            qcfService.replyToQuery(qcfNo, currentUser().getUserId(), body.get("replyText"));
            return ResponseEntity.ok(Map.of("status", "OK", "message", "Reply sent."));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("status", "ERROR", "message", e.getMessage()));
        }
    }

    private Users currentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        return (Users) authentication.getPrincipal();
    }
}
