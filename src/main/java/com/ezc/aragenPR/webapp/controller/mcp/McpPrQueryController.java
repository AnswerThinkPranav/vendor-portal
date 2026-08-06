package com.ezc.aragenPR.webapp.controller.mcp;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.ezc.aragenPR.webapp.model.pr.EzPurchaseRequisitionHeader;
import com.ezc.aragenPR.webapp.service.pr.EzcPRHeaderService;

/**
 * JSON-only read endpoints for PR list/detail, additive alongside PRController's
 * existing prCreate/list, prCreate/list/filter, and prCreate/edit - those always
 * render the prCreation/prList Thymeleaf view and cannot serve a non-browser client.
 * This controller reuses the same EzcPRHeaderService queries and returns plain JSON,
 * with an explicit createdBy filter (rather than deriving it from the caller's
 * SecurityContext principal) so the MCP service account can list/inspect PRs created
 * by any user, not just itself.
 */
@RestController
public class McpPrQueryController {

    @Autowired
    private EzcPRHeaderService headerService;

    @GetMapping("/api/mcp/prs")
    public List<EzPurchaseRequisitionHeader> listPrs(
            @RequestParam(required = false) String status,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate fromDate,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate toDate,
            @RequestParam(required = false) String createdBy) {
        return headerService.getFilteredHeaders(startOfDay(fromDate), endOfDay(toDate), status, createdBy);
    }

    @GetMapping("/api/mcp/prs/by-doc-type")
    public List<EzPurchaseRequisitionHeader> listPrsByDocType(
            @RequestParam(required = false) String docType,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate fromDate,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate toDate,
            @RequestParam(required = false) String createdBy) {
        return headerService.getFilteredHeadersByDocType(startOfDay(fromDate), endOfDay(toDate), docType, createdBy);
    }

    @GetMapping("/api/mcp/prs/{reqNumber}")
    public ResponseEntity<EzPurchaseRequisitionHeader> getPr(@PathVariable String reqNumber) {
        List<EzPurchaseRequisitionHeader> matches = headerService.findByReqNumberWithItems(reqNumber);
        if (matches.isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(matches.get(0));
    }

    private static LocalDateTime startOfDay(LocalDate date) {
        return date == null ? null : date.atStartOfDay();
    }

    private static LocalDateTime endOfDay(LocalDate date) {
        return date == null ? null : date.atTime(23, 59, 59);
    }
}
