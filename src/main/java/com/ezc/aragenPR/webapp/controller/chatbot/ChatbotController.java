package com.ezc.aragenPR.webapp.controller.chatbot;

import com.ezc.aragenPR.webapp.model.chatbot.StaticFAQData;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.*;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import com.ezc.aragenPR.webapp.model.pr.EzPurchaseRequisitionHeader;
import com.ezc.aragenPR.webapp.repository.pr.EzcPRHeaderRepository;
import com.ezc.aragenPR.webapp.model.reservation.EzcReservationHeader;
import com.ezc.aragenPR.webapp.repository.reservation.EzcReservationHeaderRepo;
import com.ezc.aragenPR.webapp.model.ses.EzcSESHeader;
import com.ezc.aragenPR.webapp.repository.ses.SESRepo;
import com.ezc.aragenPR.webapp.model.user.Users;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@RestController
@RequestMapping("/api/chatbot")
public class ChatbotController {

    @Autowired
    private EzcPRHeaderRepository prHeaderRepo;

    @Autowired
    private SESRepo sesRepo;

    @Autowired
    private EzcReservationHeaderRepo reservationRepo;

    /**
     * Get initial menu options
     */
    @GetMapping("/menu")
    public ResponseEntity<?> getMenu() {
        Map<String, Object> menu = new LinkedHashMap<>();
        menu.put("title", "Welcome! How can I help you today?");

        List<Map<String, String>> options = new ArrayList<>();

        Map<String, String> prOption = new LinkedHashMap<>();
        prOption.put("id", "pr_faqs");
        prOption.put("label", "📋 FAQs on Purchase Requisition (PR)");
        prOption.put("action", "show_category");
        prOption.put("category", "PR");
        options.add(prOption);

        Map<String, String> sesOption = new LinkedHashMap<>();
        sesOption.put("id", "ses_faqs");
        sesOption.put("label", "📝 FAQs on Service Entry Sheet (SES)");
        sesOption.put("action", "show_category");
        sesOption.put("category", "SES");
        options.add(sesOption);

        Map<String, String> resOption = new LinkedHashMap<>();
        resOption.put("id", "reservation_faqs");
        resOption.put("label", "📦 FAQs on Reservation");
        resOption.put("action", "show_category");
        resOption.put("category", "RESERVATION");
        options.add(resOption);

        Map<String, String> statusOption = new LinkedHashMap<>();
        statusOption.put("id", "check_status");
        statusOption.put("label", "🔍 Check Status (PR/SES/Reservation)");
        statusOption.put("action", "check_status");
        options.add(statusOption);

        menu.put("options", options);
        return ResponseEntity.ok(menu);
    }

    /**
     * Get FAQs by category
     */
    @GetMapping("/faqs/{category}")
    public ResponseEntity<?> getFAQsByCategory(@PathVariable String category) {
        Map<String, Object> response = new LinkedHashMap<>();
        response.put("category", category);

        String title = "";
        switch (category.toUpperCase()) {
            case "PR":
                title = "📋 Purchase Requisition FAQs";
                break;
            case "SES":
                title = "📝 Service Entry Sheet FAQs";
                break;
            case "RESERVATION":
                title = "📦 Reservation FAQs";
                break;
        }
        response.put("title", title);

        List<StaticFAQData.FAQ> faqs = StaticFAQData.getFAQsByCategory(category);
        List<Map<String, String>> faqList = new ArrayList<>();

        for (StaticFAQData.FAQ faq : faqs) {
            Map<String, String> item = new LinkedHashMap<>();
            item.put("question", faq.question);
            item.put("answer", faq.answer);
            faqList.add(item);
        }

        response.put("faqs", faqList);
        return ResponseEntity.ok(response);
    }

    /**
     * Main chat endpoint
     */
    @PostMapping("/chat")
    public ResponseEntity<?> chat(@RequestBody Map<String, String> request) {
        try {
            String message = request.get("message");
            String action = request.get("action");
            String category = request.get("category");

            if (message == null || message.trim().isEmpty()) {
                return ResponseEntity.badRequest()
                        .body(createErrorResponse("Message cannot be empty"));
            }

            String messageLower = message.toLowerCase().trim();
            String context = request.getOrDefault("context", "");

            // Handle menu actions
            if ("show_category".equals(action) && category != null) {
                return getFAQsByCategory(category);
            }

            if ("check_status".equals(action)) {
                return ResponseEntity.ok(createContextResponse(
                        "What would you like to check?\n\n" +
                                "• Type 'PR' for Purchase Requisition status\n" +
                                "• Type 'SES' for Service Entry Sheet status\n" +
                                "• Type 'RESERVATION' for Reservation status",
                        "AWAITING_DOC_TYPE"
                ));
            }

            // Check if this is a status inquiry
            if (isStatusQuery(messageLower) || "AWAITING_DOC_TYPE".equals(context)) {
                return handleStatusQuery(message, messageLower, context);
            }

            // Check if this is a number-only response
            if (context.startsWith("AWAITING_") && isNumericInput(messageLower)) {
                return handleNumberInput(message, context);
            }

            // Default: Search in FAQ
            return searchStaticFAQ(message);

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(createErrorResponse("Unable to process your request. Please try again."));
        }
    }

    /**
     * Search static FAQ
     */
    private ResponseEntity<?> searchStaticFAQ(String message) {
        StaticFAQData.FAQ faq = StaticFAQData.findAnswer(message);

        if (faq != null) {
            Map<String, Object> response = new HashMap<>();
            response.put("response", faq.answer);
            response.put("question", faq.question);
            response.put("category", faq.category);
            response.put("found", true);
            return ResponseEntity.ok(response);
        } else {
            Map<String, Object> response = new HashMap<>();
            response.put("response", "I couldn't find an answer to that question. Please select from the menu options or try asking differently.");
            response.put("found", false);
            return ResponseEntity.ok(response);
        }
    }

    /**
     * Check if query is about status
     */
    private boolean isStatusQuery(String message) {
        String[] statusKeywords = {
                "status", "check status", "what is the status",
                "pr status", "ses status", "reservation status",
                "show status", "get status", "find status"
        };

        for (String keyword : statusKeywords) {
            if (message.contains(keyword)) {
                return true;
            }
        }
        return false;
    }

    /**
     * Check if input is numeric
     */
    private boolean isNumericInput(String message) {
        return message.replaceAll("[^0-9]", "").length() >= 6;
    }

    /**
     * Handle status queries
     */
    private ResponseEntity<?> handleStatusQuery(String message, String messageLower, String context) {
        String docType = null;
        String number = extractNumber(message);

        if (messageLower.contains("pr") || messageLower.contains("purchase") || messageLower.contains("requisition")) {
            docType = "PR";
        } else if (messageLower.contains("ses") || messageLower.contains("service entry")) {
            docType = "SES";
        } else if (messageLower.contains("reservation") || messageLower.contains("reserve")) {
            docType = "RESERVATION";
        }

        if (docType != null && number != null) {
            return getDocumentStatus(docType, number);
        }

        if (docType != null) {
            return ResponseEntity.ok(createContextResponse(
                    "Please provide the " + docType + " number you want to check.",
                    "AWAITING_" + docType + "_NUMBER"
            ));
        }

        return ResponseEntity.ok(createContextResponse(
                "What would you like to check?\n\n" +
                        "• Type 'PR' for Purchase Requisition status\n" +
                        "• Type 'SES' for Service Entry Sheet status\n" +
                        "• Type 'RESERVATION' for Reservation status",
                "AWAITING_DOC_TYPE"
        ));
    }

    /**
     * Handle numeric input
     */
    private ResponseEntity<?> handleNumberInput(String message, String context) {
        String number = extractNumber(message);

        if (number == null) {
            return ResponseEntity.ok(createContextResponse(
                    "I couldn't find a valid number. Please provide the document number (e.g., 4500012345)",
                    context
            ));
        }

        if (context.startsWith("AWAITING_PR_NUMBER")) {
            return getDocumentStatus("PR", number);
        } else if (context.startsWith("AWAITING_SES_NUMBER")) {
            return getDocumentStatus("SES", number);
        } else if (context.startsWith("AWAITING_RESERVATION_NUMBER")) {
            return getDocumentStatus("RESERVATION", number);
        }

        return searchStaticFAQ(message);
    }

    /**
     * Extract number from message
     */
    private String extractNumber(String message) {
        String digitsOnly = message.replaceAll("[^0-9]", "");
        if (digitsOnly.length() >= 6) {
            return digitsOnly;
        }
        return null;
    }

    /**
     * Get document status from database
     */
    private ResponseEntity<?> getDocumentStatus(String docType, String number) {
        try {
            String loggedUser = getLoggedInUser();

            if ("PR".equals(docType)) {
                return getPRStatus(number, loggedUser);
            } else if ("SES".equals(docType)) {
                return getSESStatus(number, loggedUser);
            } else if ("RESERVATION".equals(docType)) {
                return getReservationStatus(number, loggedUser);
            }

            return ResponseEntity.ok(createResponse(
                    "I couldn't determine the document type. Please specify PR, SES, or Reservation."
            ));

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.ok(createResponse(
                    "I encountered an error while checking the status. Please verify the number and try again."
            ));
        }
    }

    /**
     * Get PR Status
     */
    private ResponseEntity<?> getPRStatus(String prNumber, String loggedUser) {
        List<EzPurchaseRequisitionHeader> prList = prHeaderRepo.findByReqNumber(prNumber);

        if (prList == null || prList.isEmpty()) {
            return ResponseEntity.ok(createResponse(
                    "❌ PR Number " + prNumber + " not found in the system.\n\n" +
                            "Please verify the PR number and try again."
            ));
        }

        EzPurchaseRequisitionHeader pr = prList.get(0);

        if (pr.getCreatedBy() == null || !pr.getCreatedBy().equalsIgnoreCase(loggedUser)) {
            return ResponseEntity.ok(createResponse(
                    "🔒 **Access Denied**\n\nYou can only view PRs that you have created."
            ));
        }

        StringBuilder response = new StringBuilder();
        response.append("📋 **Purchase Requisition Details**\n\n");
        response.append("**PR Number:** ").append(pr.getReqNumber()).append("\n");
        response.append("**Status:** ").append(formatStatus(pr.getStatus())).append("\n");
        response.append("**Document Type:** ").append(pr.getDocType()).append("\n");
        response.append("**Plant:** ").append(pr.getPlant()).append("\n");
        response.append("**Division:** ").append(pr.getDivision()).append("\n");
        response.append("**Created By:** ").append(pr.getCreatedBy()).append("\n");

        if (pr.getCreatedOn() != null) {
            response.append("**Created On:** ").append(pr.getCreatedOn().toString()).append("\n");
        }

        if (pr.getItems() != null && !pr.getItems().isEmpty()) {
            response.append("**Total Items:** ").append(pr.getItems().size()).append("\n");
        }

        response.append("\n").append(getStatusExplanation(pr.getStatus()));

        return ResponseEntity.ok(createResponse(response.toString()));
    }

    /**
     * Get SES Status
     */
    private ResponseEntity<?> getSESStatus(String sesNumber, String loggedUser) {
        EzcSESHeader ses = sesRepo.findBySesNumber(sesNumber);

        if (ses == null) {
            return ResponseEntity.ok(createResponse(
                    "❌ SES Number " + sesNumber + " not found in the system."
            ));
        }

        if (ses.getCreatedBy() == null || !ses.getCreatedBy().equalsIgnoreCase(loggedUser)) {
            return ResponseEntity.ok(createResponse(
                    "🔒 **Access Denied**\n\nYou can only view SES entries that you have created."
            ));
        }

        StringBuilder response = new StringBuilder();
        response.append("📝 **Service Entry Sheet Details**\n\n");
        response.append("**SES Number:** ").append(ses.getSesNumber()).append("\n");
        response.append("**Status:** ").append(formatStatus(ses.getStatus())).append("\n");

        if (ses.getEntryDate() != null) {
            response.append("**Entry Date:** ").append(ses.getEntryDate().toString()).append("\n");
        }

        if (ses.getLineItems() != null) {
            response.append("**Total Service Lines:** ").append(ses.getLineItems().size()).append("\n");
        }

        response.append("\n").append(getSESStatusExplanation(ses.getStatus()));

        return ResponseEntity.ok(createResponse(response.toString()));
    }

    /**
     * Get Reservation Status
     */
    private ResponseEntity<?> getReservationStatus(String reservationNumber, String loggedUser) {
        Optional<EzcReservationHeader> reservationOpt = reservationRepo.findByReservationNo(reservationNumber);

        if (!reservationOpt.isPresent()) {
            return ResponseEntity.ok(createResponse(
                    "❌ Reservation Number " + reservationNumber + " not found in the system."
            ));
        }

        EzcReservationHeader reservation = reservationOpt.get();

        if (reservation.getCreatedBy() == null || !reservation.getCreatedBy().equalsIgnoreCase(loggedUser)) {
            return ResponseEntity.ok(createResponse(
                    "🔒 **Access Denied**\n\nYou can only view reservations that you have created."
            ));
        }

        StringBuilder response = new StringBuilder();
        response.append("📦 **Reservation Details**\n\n");
        response.append("**Reservation Number:** ").append(reservation.getReservationNo()).append("\n");
        response.append("**Status:** ").append(formatStatus(reservation.getStatus())).append("\n");

        if (reservation.getMovementType() != null) {
            response.append("**Movement Type:** ").append(reservation.getMovementType()).append("\n");
        }

        if (reservation.getCreatedOn() != null) {
            response.append("**Created On:** ").append(reservation.getCreatedOn().toString()).append("\n");
        }

        response.append("\n").append(getReservationStatusExplanation(reservation.getStatus()));

        return ResponseEntity.ok(createResponse(response.toString()));
    }

    private String formatStatus(String status) {
        if (status == null) return "UNKNOWN";
        switch (status.toUpperCase()) {
            case "UNRELEASED": return "🟡 UNRELEASED";
            case "PENDING": return "🟠 PENDING";
            case "RELEASED":
            case "APPROVED": return "✅ RELEASED";
            case "REJECTED": return "❌ REJECTED";
            default: return status;
        }
    }

    private String getStatusExplanation(String status) {
        if (status == null) return "";
        switch (status.toUpperCase()) {
            case "UNRELEASED":
                return "ℹ️ Your PR is created but not submitted. You can still edit it.";
            case "PENDING":
                return "ℹ️ Your PR is in approval workflow. Waiting for approver(s).";
            case "RELEASED":
                return "ℹ️ Your PR is fully approved and ready for PO creation!";
            case "REJECTED":
                return "ℹ️ Your PR was rejected. Please check comments and create new PR.";
            default:
                return "";
        }
    }

    private String getSESStatusExplanation(String status) {
        if (status == null) return "";
        switch (status.toUpperCase()) {
            case "CREATED": return "ℹ️ SES created but not yet approved.";
            case "APPROVED": return "ℹ️ SES approved and ready for payment.";
            case "REJECTED": return "ℹ️ SES was rejected. Please correct and resubmit.";
            default: return "";
        }
    }

    private String getReservationStatusExplanation(String status) {
        if (status == null) return "";
        switch (status.toUpperCase()) {
            case "UNRELEASED": return "ℹ️ Reservation created but not finalized.";
            case "RELEASED": return "ℹ️ Reservation approved. Materials are reserved for you.";
            case "CLOSED": return "ℹ️ Reservation is closed.";
            default: return "";
        }
    }

    private String getLoggedInUser() {
        try {
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            if (authentication != null && authentication.getPrincipal() instanceof Users) {
                return ((Users) authentication.getPrincipal()).getUserId();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "SYSTEM";
    }

    private Map<String, Object> createContextResponse(String message, String context) {
        Map<String, Object> response = new HashMap<>();
        response.put("response", message);
        response.put("context", context);
        response.put("timestamp", System.currentTimeMillis());
        return response;
    }

    private Map<String, Object> createResponse(String message) {
        Map<String, Object> response = new HashMap<>();
        response.put("response", message);
        response.put("timestamp", System.currentTimeMillis());
        return response;
    }

    private Map<String, Object> createErrorResponse(String message) {
        Map<String, Object> error = new HashMap<>();
        error.put("error", message);
        error.put("timestamp", System.currentTimeMillis());
        return error;
    }

    @GetMapping("/health")
    public ResponseEntity<?> healthCheck() {
        Map<String, Object> health = new HashMap<>();
        health.put("status", "healthy");
        health.put("service", "Static Chatbot Service");
        health.put("mode", "100% Static (No Dependencies)");
        health.put("total_faqs", StaticFAQData.getAllFAQs().size());
        health.put("timestamp", System.currentTimeMillis());
        return ResponseEntity.ok(health);
    }
}