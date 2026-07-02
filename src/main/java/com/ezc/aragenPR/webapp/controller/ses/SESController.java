package com.ezc.aragenPR.webapp.controller.ses;
import com.ezc.aragenPR.webapp.model.ses.EzcSESHeader;
import com.ezc.aragenPR.webapp.model.ses.EzcSESItems;
import com.ezc.aragenPR.webapp.model.user.Users;
import com.ezc.aragenPR.webapp.repository.ses.SESRepo;
import com.ezc.aragenPR.webapp.service.ses.SESService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Controller
@RequestMapping("/ses")
public class SESController {



    @Autowired
    private SESService sesService;
    @Autowired
    private SESRepo sesRepo;

    public SESController(SESService sesService) {
        this.sesService = sesService;
    }


    //@ResponseBody
    @GetMapping("/sync")
    public String syncAndShowSES(Model model)
    {
        String loggedUser = "";

        try {
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            Users userObj = (Users) authentication.getPrincipal();
            loggedUser = (String) userObj.getUserId();
            System.out.print("loggedUser"+loggedUser);
        }catch(Exception e){}
            try {
            // Step 1️⃣: Sync SES from SAP (fetch + insert new)
            List<EzcSESHeader> syncedList = sesService.syncFromSAP();
            LocalDate threeMonthsAgo = LocalDate.now().minusMonths(3);

            List<EzcSESHeader> sesList = sesRepo.findByEntryDateAfterAndCreatedByOrderByEntryDateDesc(threeMonthsAgo,loggedUser);

            // Step 3️⃣: Add to model
            model.addAttribute("sesList", sesList);
            model.addAttribute("status", "success");
            model.addAttribute("message", "SES data synchronized successfully from SAP!");
            model.addAttribute("count", sesList.size());

            return "serviceEntry/sesList";
        } catch (Exception e) {
            e.printStackTrace();
            LocalDate threeMonthsAgo = LocalDate.now().minusMonths(3);
            List<EzcSESHeader> sesList = sesRepo.findByEntryDateAfterAndCreatedByOrderByEntryDateDesc(threeMonthsAgo,loggedUser);

            model.addAttribute("sesList", sesList);
            model.addAttribute("status", "error");
            model.addAttribute("message", "Error syncing from SAP: " + e.getMessage());

            return "serviceEntry/sesList";
        }
    }
    @GetMapping("/view/test")
    public String testSes(Model model) {
        // Create dummy SES data
        com.ezc.aragenPR.webapp.model.ses.EzcSESHeader ses = new com.ezc.aragenPR.webapp.model.ses.EzcSESHeader();
        ses.setSesNumber("SES500001");
        ses.setPoNumber("PO100234");
        ses.setVendorName("Vendor A");
        ses.setStatus("Accepted");
        ses.setShortText("Calibration and Preventive Maintenance Services");
        ses.setServiceLocation("Plant 1 - Lab Equipment");
        ses.setTotalAmount(14500.75);
        ses.setEntryDate(java.time.LocalDate.now().minusDays(3));
        ses.setPostingDate(java.time.LocalDate.now());

        // Create dummy line items
        com.ezc.aragenPR.webapp.model.ses.EzcSESItems i1 = new com.ezc.aragenPR.webapp.model.ses.EzcSESItems();
        i1.setLineNumber(10);
        i1.setServiceNumber("SVC1001");
        i1.setShortText("Equipment Calibration - Lab A");
        i1.setQuantity(2.0);
        i1.setUnit("AU");
        i1.setGrossPrice(5000.0);
        i1.setPeriodFrom(java.time.LocalDate.now().minusDays(10));
        i1.setPeriodTo(java.time.LocalDate.now().minusDays(5));

        com.ezc.aragenPR.webapp.model.ses.EzcSESItems i2 = new com.ezc.aragenPR.webapp.model.ses.EzcSESItems();
        i2.setLineNumber(20);
        i2.setServiceNumber("SVC1002");
        i2.setShortText("Preventive Maintenance - Lab B");
        i2.setQuantity(1.0);
        i2.setUnit("AU");
        i2.setGrossPrice(4500.75);
        i2.setPeriodFrom(java.time.LocalDate.now().minusDays(8));
        i2.setPeriodTo(java.time.LocalDate.now().minusDays(3));

        ses.setLineItems(java.util.List.of(i1, i2));
        i1.setHeader(ses);
        i2.setHeader(ses);

        model.addAttribute("ses", ses);
        return "serviceEntry/viewSES";
    }
    @GetMapping("/list")
    public String showSESList(Model model) {
        String loggedUser = "";

        try {
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            Users userObj = (Users) authentication.getPrincipal();
            loggedUser = (String) userObj.getUserId();
            System.out.print("loggedUser"+loggedUser);
        }catch(Exception e){}
        LocalDate threeMonthsAgo = LocalDate.now().minusMonths(3);
        List<EzcSESHeader> sesList = sesRepo.findByEntryDateAfterAndCreatedByOrderByEntryDateDesc(threeMonthsAgo,loggedUser);

        model.addAttribute("sesList", sesList);
        model.addAttribute("status", "info");
        model.addAttribute("message", "Showing SES for the last 3 months.");
        model.addAttribute("count", sesList.size());

        return "serviceEntry/sesList";
    }
    @GetMapping("/read/{sesNumber}")
    public String readSESFromSAP(@PathVariable String sesNumber, Model model) {
        System.out.print("readSESFromSAP"+sesNumber);

        log.debug("sesNumber"+sesNumber);
        try {

            EzcSESHeader header = sesService.fetchSESFromSAP(sesNumber);
            if (header == null) {
                model.addAttribute("error", "No SES data found for " + sesNumber);
                return "serviceEntry/sesList";
            }
            System.out.print("FROM SERVICE"+header);
            model.addAttribute("ses", header);
            model.addAttribute("items", header.getLineItems());
        } catch (Exception e) {
            model.addAttribute("error", "Error fetching SES: " + e.getMessage());
        }

       // EzcSESHeader ses = sesRepo.findBySesNumber(sesNumber);
       // System.out.print("ses"+ses);
        /*if (ses == null) {
            // Return error page or redirect if SES not found
            model.addAttribute("error", "SES Number " + sesNumber + " not found");
            return "error/404";
        }*/



        return "serviceEntry/viewSES";

    }
    @PostMapping("/releaseEntrySheet")
    @ResponseBody
    public Map<String, Object> releaseEntrySheet(@RequestBody Map<String, String> payload) {
        String sesNumber = payload.get("sesNumber");
        String releaseCode = payload.get("releaseCode");
        Map<String, Object> response = new HashMap<>();

        try {
            Map<String, Object> result = sesService.releaseSES(sesNumber, releaseCode);
System.out.print("result"+result);
            if ("SUCCESS".equals(result.get("status"))) {

                System.out.print("sesNumber"+sesNumber);
                sesRepo.updateStatusToApproved( sesNumber);
                response.put("status", "success");
                response.put("message", "SES " + sesNumber + " released successfully");


            } else {
                response.put("status", "error");
                response.put("message", result.get("message"));
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.put("status", "error");
            response.put("message", "Internal server error");
        }

        return response;

    }



}
