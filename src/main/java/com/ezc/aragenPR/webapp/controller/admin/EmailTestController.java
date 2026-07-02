package com.ezc.aragenPR.webapp.controller.admin;

import com.ezc.aragenPR.webapp.service.shared.MailService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class EmailTestController {

    @Autowired
    private MailService mailService;

    @GetMapping("/test-mail")
    public String showTestMailPage() {
        return "testMail";
    }

    @PostMapping("/send-test-mail")
    public String sendTestMail(
            @RequestParam String to,
            @RequestParam String subject,
            @RequestParam String body,
            Model model) {

        try {
            mailService.sendTestMail(to, subject, body);
            model.addAttribute("msg", "✅ Mail sent successfully!");
        } catch (Exception e) {
            model.addAttribute("msg", "❌ Failed to send mail: " + e.getMessage());
        }

        return "testMail";
    }
}
