package com.ezc.aragenPR.webapp.controller.pr;

import com.ezc.aragenPR.webapp.model.pr.EzPurchaseRequisitionHeader;
import com.ezc.aragenPR.webapp.model.user.Users;
import com.ezc.aragenPR.webapp.service.pr.EzcPRHeaderService;
import com.ezc.aragenPR.webapp.service.pr.PRReleaseInfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

@Controller
public class PRStatusSyncController {


    @Autowired
    PRReleaseInfoService prReleaseInfoService;
    @Autowired
    private EzcPRHeaderService headerService;

    @GetMapping("/pending/last15days")
    public String getPendingPRs(Model model) {
        Date fromDate=new Date();
        Date toDate=new Date();
        LocalDateTime from = null;
        LocalDateTime to = null;


        System.out.println("pending/last15days");
        try {
            prReleaseInfoService.getPendingPRsFromDBAndSAP();
            if (fromDate == null || toDate == null) {
                Calendar cal = Calendar.getInstance();
                int year = cal.get(Calendar.YEAR);
                // Example: FY Apr 1 to Mar 31
                cal.set(year, Calendar.APRIL, 1, 0, 0, 0);
                fromDate = cal.getTime();
                cal.set(year + 1, Calendar.MARCH, 31, 23, 59, 59);
                toDate = cal.getTime();
            }
            if (fromDate != null) {
                from = fromDate.toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime();
            }
            if (toDate != null) {
                to = toDate.toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime();
            }

        } catch (Exception e) {
            e.printStackTrace();

        }
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        Users userObj = (Users)authentication.getPrincipal();
        String loggedUser=(String)userObj.getUserId();
        List<EzPurchaseRequisitionHeader> headers = headerService.getCreatedByList(from, to,  loggedUser);
        System.out.print("headers in filterPRItems"+headers.size());
        model.addAttribute("headers", headers);
        model.addAttribute("fromDate", fromDate);
        model.addAttribute("toDate", toDate);
        return "prCreation/prList";
    }
}
