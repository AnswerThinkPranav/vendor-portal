package com.ezc.aragenPR.webapp.controller.shared;

import com.ezc.aragenPR.webapp.dto.master.ListSelector;
import com.ezc.aragenPR.webapp.model.pr.EzPurchaseRequisitionHeader;
import com.ezc.aragenPR.webapp.model.user.Roles;
import com.ezc.aragenPR.webapp.model.user.UserDefaults;
import com.ezc.aragenPR.webapp.model.user.Users;
import com.ezc.aragenPR.webapp.repository.pr.EzcPRHeaderRepository;
import com.ezc.aragenPR.webapp.repository.reservation.EzcReservationHeaderRepo;
import com.ezc.aragenPR.webapp.repository.ses.SESRepo;
import com.ezc.aragenPR.webapp.service.pr.EzcPRHeaderService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.servletapi.SecurityContextHolderAwareRequestWrapper;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.security.Principal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.*;

@Slf4j
@Controller
public class DashboardController {

    @Autowired
    private EzcPRHeaderService headerService;

    @Autowired
    private EzcPRHeaderRepository headerRepo;

    @Autowired
    private SESRepo sesRepo;

    @Autowired
    private EzcReservationHeaderRepo resRepo;

    @GetMapping("/dashboard/*")
    public String showView(Principal principal, Authentication auth, Model model,
                           SecurityContextHolderAwareRequestWrapper requestWrapper) {

        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String plantCode = "";
        Users userObj = (Users) authentication.getPrincipal();
        Set<UserDefaults> defaults = userObj.getUserDefaults();
        List<String> userRoles = userObj.getRoles().stream()
                .map(Roles::getName)
                .toList();

        ArrayList<String> userList = new ArrayList<>();
        String loggedUser = userObj.getUserId();
        userList.add(userObj.getUserId());

        model.addAttribute("userId", userObj.getUserId());

        if (authentication != null && authentication.isAuthenticated()) {
            for (GrantedAuthority authority : authentication.getAuthorities()) {
                log.debug("Role: " + authority.getAuthority());
            }
        }

        List<String> plantList = new ArrayList<>();
        if (defaults != null) {
            for (UserDefaults def : defaults) {
                if ("LOCATION".equalsIgnoreCase(def.getKey())) {
                    plantCode = def.getValue();
                    break;
                }
            }
            if (plantCode.contains("##")) {
                String[] plantListArr = plantCode.split("##");
                for (String plant : plantListArr) {
                    plantList.add(plant);
                }
            } else {
                plantList.add(plantCode);
            }
        }

        Date todayDate = new Date();
        Calendar c = Calendar.getInstance();
        c.setTime(todayDate);
        c.add(Calendar.MONTH, -6);
        Date fromDate = c.getTime();
        Date toDate = todayDate;

        LocalDateTime from = fromDate.toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime();
        LocalDateTime to = toDate.toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime();

        List<EzPurchaseRequisitionHeader> headers = headerService.getFilteredHeaders(from, to, "UNRELEASED", loggedUser);
        List<EzPurchaseRequisitionHeader> headersRel = headerService.getFilteredHeaders(from, to, "RELEASED", loggedUser);
        List<EzPurchaseRequisitionHeader> headersPend = headerService.getFilteredHeaders(from, to, "PENDING", loggedUser);

        model.addAttribute("unreleasedPR", headers.size());
        model.addAttribute("releasedPR", headersRel.size());
        model.addAttribute("pendingPR", headersPend.size());

        LocalDate sesFromDate = from.toLocalDate();
        long unReleasedSESCnt = sesRepo.countByEntryDateAfterAndStatusAndCreatedBy(sesFromDate, "UNRELEASED", loggedUser);
        long releasedSESCnt = sesRepo.countByEntryDateAfterAndStatusAndCreatedBy(sesFromDate, "RELEASED", loggedUser);
        long pendingSESCnt = sesRepo.countByEntryDateAfterAndStatusAndCreatedBy(sesFromDate, "PENDING", loggedUser);

        model.addAttribute("unreleasedSES", unReleasedSESCnt);
        model.addAttribute("releasedSES", releasedSESCnt);
        model.addAttribute("pendingSES", pendingSESCnt);

        return "dashboard/index";
    }

    @GetMapping("/user-manuals")
    public String getUserManuals(Model model) {
        return "documents";
    }
}
