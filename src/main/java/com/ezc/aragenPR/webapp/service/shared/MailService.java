package com.ezc.aragenPR.webapp.service.shared;
import com.ezc.aragenPR.webapp.model.pr.EzPurchaseRequisitionHeader;
import com.ezc.aragenPR.webapp.model.pr.EzPurchaseRequisitionItems;
import com.ezc.aragenPR.webapp.model.ses.EzcSESHeader;
import com.ezc.aragenPR.webapp.model.ses.EzcSESItems;
import com.ezc.aragenPR.webapp.model.reservation.EzcReservationHeader;
import com.ezc.aragenPR.webapp.model.reservation.EzcReservationItems;
import com.ezc.aragenPR.webapp.model.user.Users;
import com.ezc.aragenPR.webapp.repository.user.UserRepository;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

@Slf4j
@Service
public class MailService {

    @Autowired
    private JavaMailSender mailSender;

    @Autowired
    private UserRepository userRepository;

    @org.springframework.beans.factory.annotation.Value("${spring.mail.username}")
    private String fromAddress;

    public void sendTestMail(String to, String subject, String body) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setFrom("sap.helpdesk@aragen.com");
        message.setTo(to);
        message.setSubject(subject);
        message.setText(body);

        mailSender.send(message);
    }
    public void sendPRStatusMail(EzPurchaseRequisitionHeader header, String status)
    {
        String userEmail = null;
        String userName = "";
        if (header.getCreatedBy() != null && !header.getCreatedBy().isEmpty()) {
            Users user = userRepository.findByUserId(header.getCreatedBy());
            if (user != null && user.getEmail() != null) {
                userEmail = user.getEmail();
                userName = user.getFirstName() != null ? user.getFirstName() : header.getCreatedBy();
            }
        }

        if (userEmail == null || userEmail.isEmpty()) {
            log.warn("No email found for PR creator: " + header.getCreatedBy());
            return;
        }

        SimpleMailMessage message = new SimpleMailMessage();
        message.setFrom("sap.helpdesk@aragen.com");
        message.setTo(userEmail);

        if ("RELEASED".equalsIgnoreCase(status)) {
            message.setSubject("PR Released - " + header.getReqNumber());
            message.setText(
                    "Dear " + userName + ",\n\n" +
                            "PR " + header.getReqNumber() +
                            " has been released successfully.\n\n" +
                            "Regards,\nSAP Helpdesk");
        } else if ("PENDING".equalsIgnoreCase(status)) {
            message.setSubject("PR Pending for Approval - " + header.getReqNumber());
            message.setText(
                    "Dear " + userName + ",\n\n" +
                            "PR " + header.getReqNumber() +
                            " is pending for approval at your level.\n\n" +
                            "Regards,\nSAP Helpdesk");
        }

        mailSender.send(message);
    }
    public void sendPRCreationMail(EzPurchaseRequisitionHeader header)
            throws MessagingException
    {
        log.debug("IN sendPRCreationMail");
        MimeMessage message = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
        String loggedUser="",loggedUserMail="";
        try {
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            if (authentication != null && authentication.getPrincipal() instanceof Users) {
                loggedUser=((Users) authentication.getPrincipal()).getUserId();
                loggedUserMail=((Users) authentication.getPrincipal()).getEmail();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        helper.setFrom("sap.helpdesk@aragen.com");
        helper.setTo(loggedUserMail);
        helper.setCc(new String[] { "kkakarlapudi@answerthink.com", "nagasaipranav.varanasi@answerthink.com" });

        helper.setSubject("PR has been created - "+header.getReqNumber());
        StringBuilder html = new StringBuilder();

        html.append("<!DOCTYPE html>");
        html.append("<html><head><style>");
        html.append("body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; background-color: #f4f4f4; margin: 0; padding: 0; }");
        html.append(".container { max-width: 800px; margin: 20px auto; padding: 0; background-color: #ffffff; }");
        html.append(".header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px 20px; text-align: center; }");
        html.append(".header h2 { margin: 0; font-size: 24px; font-weight: 600; }");
        html.append(".content { padding: 30px; }");
        html.append(".greeting { font-size: 16px; color: #333; margin-bottom: 10px; }");
        html.append(".intro { font-size: 14px; color: #666; margin-bottom: 25px; }");
        html.append(".section-title { color: #667eea; font-size: 18px; font-weight: 600; margin: 25px 0 15px 0; padding-bottom: 8px; border-bottom: 3px solid #667eea; }");
        html.append("table { width: 100%; border-collapse: collapse; margin: 15px 0 25px 0; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }");
        html.append("th { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 14px 12px; text-align: left; font-weight: 600; font-size: 13px; text-transform: uppercase; letter-spacing: 0.5px; }");
        html.append("td { padding: 12px; border-bottom: 1px solid #e0e0e0; font-size: 14px; }");
        html.append("tr:last-child td { border-bottom: none; }");
        html.append("tr:hover { background-color: #f8f9fa; }");
        html.append(".label { font-weight: 600; background-color: #f8f9fa; width: 35%; color: #555; }");
        html.append(".value { color: #333; }");
        html.append(".item-table th { text-align: center; }");
        html.append(".item-table td { text-align: left; }");
        html.append(".item-table td:first-child { text-align: center; font-weight: 600; }");
        html.append(".item-table td:nth-child(4), .item-table td:nth-child(5) { text-align: right; }");
        html.append(".footer { margin-top: 30px; padding: 25px 30px; background-color: #f8f9fa; border-top: 3px solid #667eea; }");
        html.append(".footer-text { color: #666; font-size: 14px; line-height: 1.8; margin: 0; }");
        html.append(".footer-name { color: #667eea; font-weight: 600; font-size: 15px; }");
        html.append("</style></head><body>");

        html.append("<div class='container'>");
        html.append("<div class='header'><h2>✓ Purchase Requisition Created Successfully</h2></div>");
        html.append("<div class='content'>");
        html.append("<p class='greeting'>Dear User,</p>");
        html.append("<p class='intro'>Your Purchase Requisition has been created successfully. Please find the details below:</p>");

        // Header Table
        html.append("<h3 class='section-title'>PR Details</h3>");
        html.append("<table>");
        html.append("<tr><td class='label'>Document Type</td><td class='value'>")
                .append(header.getDocType() != null ? header.getDocType() : "N/A").append("</td></tr>");
        html.append("<tr><td class='label'>Account Assignment</td><td class='value'>")
                .append(header.getAccAsmt() != null ? header.getAccAsmt() : "N/A").append("</td></tr>");
        html.append("<tr><td class='label'>Division</td><td class='value'>")
                .append(header.getDivision() != null ? header.getDivision() : "N/A").append("</td></tr>");
        html.append("<tr><td class='label'>Item Category</td><td class='value'>")
                .append(header.getItemCat() != null ? header.getItemCat() : "N/A").append("</td></tr>");
        html.append("<tr><td class='label'>Plant</td><td class='value'>")
                .append(header.getPlant() != null ? header.getPlant() : "N/A").append("</td></tr>");
        html.append("<tr><td class='label'>Purchasing Group</td><td class='value'>")
                .append(header.getPurGrp() != null ? header.getPurGrp() : "N/A").append("</td></tr>");
        html.append("<tr><td class='label'>Department</td><td class='value'>")
                .append(header.getDept() != null ? header.getDept() : "N/A").append("</td></tr>");
        html.append("</table>");

        // Item Table
        html.append("<h3 class='section-title'>Material Details</h3>");
        html.append("<table class='item-table'>");
        html.append("<tr>");
        html.append("<th>S.No</th>");
        html.append("<th>Material</th>");
        html.append("<th>Description</th>");
        html.append("<th>Quantity</th>");
        html.append("<th>Price</th>");
        html.append("</tr>");

        int i = 1;
        for (EzPurchaseRequisitionItems item : header.getItems()) {
            html.append("<tr>");
            html.append("<td>").append(i++).append("</td>");
            html.append("<td>").append(item.getMatNumber() != null ? item.getMatNumber() : "").append("</td>");
            html.append("<td>").append(item.getShortText() != null ? item.getShortText() : "").append("</td>");
            html.append("<td>").append(item.getQuantity() != null ? item.getQuantity() : "").append("</td>");
            html.append("<td>").append(item.getValPrice() != null ? item.getValPrice() : "").append("</td>");
            html.append("</tr>");
        }

        html.append("</table>");
        html.append("</div>");
        html.append("<div class='footer'>");
        html.append("<p class='footer-text'>Best Regards,<br><span class='footer-name'>").append(loggedUser).append("</span><br>SAP Helpdesk Team</p>");
        html.append("</div>");
        html.append("</div>");
        html.append("</body></html>");

        helper.setText(html.toString(), true);
       mailSender.send(message);
    }

    public void sendSESCreationMail(EzcSESHeader header)
            throws MessagingException
    {
        log.debug("IN sendSESCreationMail for SES: " + header.getSesNumber());

        // Get user email from createdBy field
        String userEmail = null;
        String userName = "";
        if (header.getCreatedBy() != null && !header.getCreatedBy().isEmpty()) {
            Users user = userRepository.findByUserId(header.getCreatedBy());
            if (user != null && user.getEmail() != null) {
                userEmail = user.getEmail();
                userName = user.getFirstName() != null ? user.getFirstName() : header.getCreatedBy();
            }
        }

        // Skip if no email found
        if (userEmail == null || userEmail.isEmpty()) {
            log.warn("No email found for user: " + header.getCreatedBy());
            return;
        }

        MimeMessage message = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

        helper.setFrom("sap.helpdesk@aragen.com");
        helper.setTo(userEmail);
        helper.setCc("kkakarlapudi@answerthink.com");

        helper.setSubject("Service Entry Sheet Available - " + header.getSesNumber());
        StringBuilder html = new StringBuilder();

        html.append("<!DOCTYPE html>");
        html.append("<html><head><style>");
        html.append("body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; background-color: #f4f4f4; margin: 0; padding: 0; }");
        html.append(".container { max-width: 800px; margin: 20px auto; padding: 0; background-color: #ffffff; }");
        html.append(".header { background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%); color: white; padding: 30px 20px; text-align: center; }");
        html.append(".header h2 { margin: 0; font-size: 24px; font-weight: 600; }");
        html.append(".content { padding: 30px; }");
        html.append(".greeting { font-size: 16px; color: #333; margin-bottom: 10px; }");
        html.append(".intro { font-size: 14px; color: #666; margin-bottom: 25px; }");
        html.append(".section-title { color: #11998e; font-size: 18px; font-weight: 600; margin: 25px 0 15px 0; padding-bottom: 8px; border-bottom: 3px solid #11998e; }");
        html.append("table { width: 100%; border-collapse: collapse; margin: 15px 0 25px 0; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }");
        html.append("th { background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%); color: white; padding: 14px 12px; text-align: left; font-weight: 600; font-size: 13px; text-transform: uppercase; letter-spacing: 0.5px; }");
        html.append("td { padding: 12px; border-bottom: 1px solid #e0e0e0; font-size: 14px; }");
        html.append("tr:last-child td { border-bottom: none; }");
        html.append("tr:hover { background-color: #f8f9fa; }");
        html.append(".label { font-weight: 600; background-color: #f8f9fa; width: 35%; color: #555; }");
        html.append(".value { color: #333; }");
        html.append(".status-badge { display: inline-block; padding: 5px 12px; border-radius: 15px; font-size: 12px; font-weight: 600; }");
        html.append(".status-unreleased { background-color: #fff3cd; color: #856404; }");
        html.append(".status-pending { background-color: #d1ecf1; color: #0c5460; }");
        html.append(".status-released { background-color: #d4edda; color: #155724; }");
        html.append(".status-deleted { background-color: #f8d7da; color: #721c24; }");
        html.append(".item-table th { text-align: center; }");
        html.append(".item-table td { text-align: left; }");
        html.append(".item-table td:first-child { text-align: center; font-weight: 600; }");
        html.append(".item-table td:nth-child(4), .item-table td:nth-child(5) { text-align: right; }");
        html.append(".footer { margin-top: 30px; padding: 25px 30px; background-color: #f8f9fa; border-top: 3px solid #11998e; }");
        html.append(".footer-text { color: #666; font-size: 14px; line-height: 1.8; margin: 0; }");
        html.append(".footer-name { color: #11998e; font-weight: 600; font-size: 15px; }");
        html.append(".highlight { background-color: #fffacd; padding: 15px; border-left: 4px solid #11998e; margin: 20px 0; }");
        html.append("</style></head><body>");

        html.append("<div class='container'>");
        html.append("<div class='header'><h2>📋 Service Entry Sheet Available</h2></div>");
        html.append("<div class='content'>");
        html.append("<p class='greeting'>Dear ").append(userName).append(",</p>");
        html.append("<p class='intro'>A Service Entry Sheet has been synced from SAP and is now available in the portal for your action. Please find the details below:</p>");

        // Status badge
        String statusClass = "status-unreleased";
        String status = header.getStatus() != null ? header.getStatus() : "UNRELEASED";
        if ("RELEASED".equalsIgnoreCase(status)) {
            statusClass = "status-released";
        } else if ("PENDING".equalsIgnoreCase(status)) {
            statusClass = "status-pending";
        } else if ("DELETED".equalsIgnoreCase(status)) {
            statusClass = "status-deleted";
        }

        // SES Header Details
        html.append("<h3 class='section-title'>SES Details</h3>");
        html.append("<table>");
        html.append("<tr><td class='label'>SES Number</td><td class='value'>")
                .append(header.getSesNumber() != null ? header.getSesNumber() : "N/A").append("</td></tr>");
        html.append("<tr><td class='label'>Status</td><td class='value'><span class='status-badge ").append(statusClass).append("'>")
                .append(status).append("</span></td></tr>");
        html.append("<tr><td class='label'>PO Number</td><td class='value'>")
                .append(header.getPoNumber() != null ? header.getPoNumber() : "N/A").append("</td></tr>");
        html.append("<tr><td class='label'>Vendor Name</td><td class='value'>")
                .append(header.getVendorName() != null ? header.getVendorName() : "N/A").append("</td></tr>");
        html.append("<tr><td class='label'>Short Text</td><td class='value'>")
                .append(header.getShortText() != null ? header.getShortText() : "N/A").append("</td></tr>");
        html.append("<tr><td class='label'>Service Location</td><td class='value'>")
                .append(header.getServiceLocation() != null ? header.getServiceLocation() : "N/A").append("</td></tr>");
        html.append("<tr><td class='label'>Total Amount</td><td class='value'>")
                .append(header.getTotalAmount() != null ? String.format("%.2f", header.getTotalAmount()) : "0.00")
                .append(" ").append(header.getCurrency() != null ? header.getCurrency() : "").append("</td></tr>");
        html.append("<tr><td class='label'>Entry Date</td><td class='value'>")
                .append(header.getEntryDate() != null ? header.getEntryDate().toString() : "N/A").append("</td></tr>");
        html.append("<tr><td class='label'>Posting Date</td><td class='value'>")
                .append(header.getPostingDate() != null ? header.getPostingDate().toString() : "N/A").append("</td></tr>");
        html.append("</table>");

        // Action Required Message
        if ("UNRELEASED".equalsIgnoreCase(status) || "PENDING".equalsIgnoreCase(status)) {
            html.append("<div class='highlight'>");
            html.append("<strong>⚠️ Action Required:</strong> This SES is currently <strong>").append(status).append("</strong>. ");
            html.append("Please log in to the portal to review and take necessary action.");
            html.append("</div>");
        }

        // Item Details (if available)
        if (header.getLineItems() != null && !header.getLineItems().isEmpty()) {
            html.append("<h3 class='section-title'>Service Line Items</h3>");
            html.append("<table class='item-table'>");
            html.append("<tr>");
            html.append("<th>Line No</th>");
            html.append("<th>Service Number</th>");
            html.append("<th>Description</th>");
            html.append("<th>Quantity</th>");
            html.append("<th>Unit</th>");
            html.append("</tr>");

            for (EzcSESItems item : header.getLineItems()) {
                html.append("<tr>");
                html.append("<td>").append(item.getLineNumber() != null ? item.getLineNumber() : "").append("</td>");
                html.append("<td>").append(item.getServiceNumber() != null ? item.getServiceNumber() : "").append("</td>");
                html.append("<td>").append(item.getShortText() != null ? item.getShortText() : "").append("</td>");
                html.append("<td>").append(item.getQuantity() != null ? String.format("%.2f", item.getQuantity()) : "").append("</td>");
                html.append("<td>").append(item.getUnit() != null ? item.getUnit() : "").append("</td>");
                html.append("</tr>");
            }

            html.append("</table>");
        }

        html.append("</div>");
        html.append("<div class='footer'>");
        html.append("<p class='footer-text'>Best Regards,<br><span class='footer-name'>SAP Helpdesk Team</span><br>Aragen Life Sciences</p>");
        html.append("</div>");
        html.append("</div>");
        html.append("</body></html>");

        helper.setText(html.toString(), true);
        mailSender.send(message);
        log.info("SES creation email sent successfully to: " + userEmail);
    }

    public void sendReservationCreationMail(EzcReservationHeader header)
            throws MessagingException
    {
        log.debug("IN sendReservationCreationMail for Reservation: " + header.getReservationNo());

        MimeMessage message = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
        String loggedUser = "";
        String loggedUserMail = "";

        try {
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            if (authentication != null && authentication.getPrincipal() instanceof Users) {
                loggedUser = ((Users) authentication.getPrincipal()).getUserId();
                loggedUserMail = ((Users) authentication.getPrincipal()).getEmail();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Skip if no email found
        if (loggedUserMail == null || loggedUserMail.isEmpty()) {
            log.warn("No email found for logged user: " + loggedUser);
            return;
        }

        helper.setFrom("sap.helpdesk@aragen.com");
        helper.setTo(loggedUserMail);
        helper.setCc(new String[] { "kkakarlapudi@answerthink.com", "nagasaipranav.varanasi@answerthink.com" });

        helper.setSubject("Reservation Created Successfully - " + header.getReservationNo());
        StringBuilder html = new StringBuilder();

        html.append("<!DOCTYPE html>");
        html.append("<html><head><style>");
        html.append("body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; background-color: #f4f4f4; margin: 0; padding: 0; }");
        html.append(".container { max-width: 800px; margin: 20px auto; padding: 0; background-color: #ffffff; }");
        html.append(".header { background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); color: white; padding: 30px 20px; text-align: center; }");
        html.append(".header h2 { margin: 0; font-size: 24px; font-weight: 600; }");
        html.append(".content { padding: 30px; }");
        html.append(".greeting { font-size: 16px; color: #333; margin-bottom: 10px; }");
        html.append(".intro { font-size: 14px; color: #666; margin-bottom: 25px; }");
        html.append(".section-title { color: #f5576c; font-size: 18px; font-weight: 600; margin: 25px 0 15px 0; padding-bottom: 8px; border-bottom: 3px solid #f5576c; }");
        html.append("table { width: 100%; border-collapse: collapse; margin: 15px 0 25px 0; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }");
        html.append("th { background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); color: white; padding: 14px 12px; text-align: left; font-weight: 600; font-size: 13px; text-transform: uppercase; letter-spacing: 0.5px; }");
        html.append("td { padding: 12px; border-bottom: 1px solid #e0e0e0; font-size: 14px; }");
        html.append("tr:last-child td { border-bottom: none; }");
        html.append("tr:hover { background-color: #f8f9fa; }");
        html.append(".label { font-weight: 600; background-color: #f8f9fa; width: 35%; color: #555; }");
        html.append(".value { color: #333; }");
        html.append(".item-table th { text-align: center; }");
        html.append(".item-table td { text-align: left; }");
        html.append(".item-table td:first-child { text-align: center; font-weight: 600; }");
        html.append(".item-table td:nth-child(4), .item-table td:nth-child(5) { text-align: right; }");
        html.append(".footer { margin-top: 30px; padding: 25px 30px; background-color: #f8f9fa; border-top: 3px solid #f5576c; }");
        html.append(".footer-text { color: #666; font-size: 14px; line-height: 1.8; margin: 0; }");
        html.append(".footer-name { color: #f5576c; font-weight: 600; font-size: 15px; }");
        html.append("</style></head><body>");

        html.append("<div class='container'>");
        html.append("<div class='header'><h2>✓ Reservation Created Successfully</h2></div>");
        html.append("<div class='content'>");
        html.append("<p class='greeting'>Dear User,</p>");
        html.append("<p class='intro'>Your Material Reservation has been created successfully in SAP. Please find the details below:</p>");

        // Reservation Header Details
        html.append("<h3 class='section-title'>Reservation Details</h3>");
        html.append("<table>");
        html.append("<tr><td class='label'>Reservation Number</td><td class='value'>")
                .append(header.getReservationNo() != null ? header.getReservationNo() : "N/A").append("</td></tr>");
        html.append("<tr><td class='label'>Movement Type</td><td class='value'>")
                .append(header.getMovementType() != null ? header.getMovementType() : "N/A").append("</td></tr>");

        if (header.getWbs() != null && !header.getWbs().isEmpty()) {
            html.append("<tr><td class='label'>WBS Element</td><td class='value'>")
                    .append(header.getWbs()).append("</td></tr>");
            if (header.getWbsDesc() != null && !header.getWbsDesc().isEmpty()) {
                html.append("<tr><td class='label'>WBS Description</td><td class='value'>")
                        .append(header.getWbsDesc()).append("</td></tr>");
            }
        }

        if (header.getCostCenter() != null && !header.getCostCenter().isEmpty()) {
            html.append("<tr><td class='label'>Cost Center</td><td class='value'>")
                    .append(header.getCostCenter()).append("</td></tr>");
        }

        if (header.getInternalOrder() != null && !header.getInternalOrder().isEmpty()) {
            html.append("<tr><td class='label'>Internal Order</td><td class='value'>")
                    .append(header.getInternalOrder()).append("</td></tr>");
        }

        if (header.getNetwork() != null && !header.getNetwork().isEmpty()) {
            html.append("<tr><td class='label'>Network</td><td class='value'>")
                    .append(header.getNetwork()).append("</td></tr>");
        }

        if (header.getActivity() != null && !header.getActivity().isEmpty()) {
            html.append("<tr><td class='label'>Activity</td><td class='value'>")
                    .append(header.getActivity()).append("</td></tr>");
        }

        if (header.getGlAccount() != null && !header.getGlAccount().isEmpty()) {
            html.append("<tr><td class='label'>G/L Account</td><td class='value'>")
                    .append(header.getGlAccount()).append("</td></tr>");
        }

        if (header.getGoodsReceipt() != null && !header.getGoodsReceipt().isEmpty()) {
            html.append("<tr><td class='label'>Goods Receipt</td><td class='value'>")
                    .append(header.getGoodsReceipt()).append("</td></tr>");
        }

        html.append("<tr><td class='label'>Requirement Date</td><td class='value'>")
                .append(header.getReqDate() != null ? header.getReqDate().toString() : "N/A").append("</td></tr>");
        html.append("<tr><td class='label'>Status</td><td class='value'>")
                .append(header.getStatus() != null ? header.getStatus() : "N/A").append("</td></tr>");
        html.append("<tr><td class='label'>Created By</td><td class='value'>")
                .append(header.getCreatedBy() != null ? header.getCreatedBy() : "N/A").append("</td></tr>");
        html.append("<tr><td class='label'>Created On</td><td class='value'>")
                .append(header.getCreatedOn() != null ? header.getCreatedOn().toString() : "N/A").append("</td></tr>");
        html.append("</table>");

        // Item Details
        if (header.getLineItems() != null && !header.getLineItems().isEmpty()) {
            html.append("<h3 class='section-title'>Material Line Items</h3>");
            html.append("<table class='item-table'>");
            html.append("<tr>");
            html.append("<th>Item No</th>");
            html.append("<th>Material</th>");
            html.append("<th>Description</th>");
            html.append("<th>Quantity</th>");
            html.append("<th>UOM</th>");
            html.append("<th>Plant</th>");
            html.append("<th>Storage Loc</th>");
            html.append("</tr>");

            for (EzcReservationItems item : header.getLineItems()) {
                html.append("<tr>");
                html.append("<td>").append(item.getItemNo() != null ? item.getItemNo() : "").append("</td>");
                html.append("<td>").append(item.getMaterial() != null ? item.getMaterial() : "").append("</td>");
                html.append("<td>").append(item.getShortText() != null ? item.getShortText() : "").append("</td>");
                html.append("<td>").append(item.getQty() != null ? String.format("%.2f", item.getQty()) : "").append("</td>");
                html.append("<td>").append(item.getUom() != null ? item.getUom() : "").append("</td>");
                html.append("<td>").append(item.getPlant() != null ? item.getPlant() : "").append("</td>");
                html.append("<td>").append(item.getStorageLoc() != null ? item.getStorageLoc() : "").append("</td>");
                html.append("</tr>");
            }

            html.append("</table>");
        }

        html.append("</div>");
        html.append("<div class='footer'>");
        html.append("<p class='footer-text'>Best Regards,<br><span class='footer-name'>").append(loggedUser).append("</span><br>SAP Helpdesk Team</p>");
        html.append("</div>");
        html.append("</div>");
        html.append("</body></html>");

        helper.setText(html.toString(), true);
        mailSender.send(message);
        log.info("Reservation creation email sent successfully to: " + loggedUserMail);
    }

    public void sendOtpMail(Users user, String otp) throws MessagingException {
        MimeMessage message = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

        helper.setFrom(fromAddress);
        helper.setTo(user.getEmail());
        helper.setSubject("Aragen - Your Password Reset OTP");

        StringBuilder html = new StringBuilder();
        html.append("<!DOCTYPE html><html><body style='font-family:Arial,sans-serif;background:#f4f4f4;margin:0;padding:20px;'>");
        html.append("<div style='max-width:480px;margin:auto;background:#fff;border-radius:8px;padding:32px;box-shadow:0 2px 8px rgba(0,0,0,0.1);'>");
        html.append("<h2 style='color:#003366;margin-top:0;'>Password Reset OTP</h2>");
        html.append("<p style='color:#333;'>Dear <strong>").append(user.getUserId()).append("</strong>,</p>");
        html.append("<p style='color:#333;'>Use the OTP below to reset your Aragen password. It is valid for <strong>5 minutes</strong>.</p>");
        html.append("<div style='text-align:center;margin:24px 0;'>");
        html.append("<span style='display:inline-block;font-size:36px;font-weight:bold;letter-spacing:10px;color:#003366;background:#f0f4ff;padding:16px 32px;border-radius:8px;'>")
            .append(otp).append("</span>");
        html.append("</div>");
        html.append("<p style='color:#666;font-size:13px;'>If you did not request this, please ignore this email.</p>");
        html.append("<hr style='border:none;border-top:1px solid #eee;margin:24px 0;'>");
        html.append("<p style='color:#999;font-size:12px;margin:0;'>Aragen Life Sciences &mdash; SAP Portal</p>");
        html.append("</div></body></html>");

        helper.setText(html.toString(), true);
        mailSender.send(message);
        log.info("OTP mail sent to: " + user.getEmail());
    }

}
