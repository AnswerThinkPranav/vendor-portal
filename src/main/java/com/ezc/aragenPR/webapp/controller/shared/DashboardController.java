package com.ezc.aragenPR.webapp.controller.shared;

import com.ezc.aragenPR.webapp.dto.master.ListSelector;
import com.ezc.aragenPR.webapp.model.pr.EzPurchaseRequisitionHeader;
import com.ezc.aragenPR.webapp.model.user.Roles;
import com.ezc.aragenPR.webapp.model.user.UserDefaults;
import com.ezc.aragenPR.webapp.model.user.Users;
import com.ezc.aragenPR.webapp.repository.pr.EzcPRHeaderRepository;
import com.ezc.aragenPR.webapp.repository.reservation.EzcReservationHeaderRepo;
import com.ezc.aragenPR.webapp.repository.ses.SESRepo;
import com.ezc.aragenPR.webapp.security.PostLoginSessionSetupService;
import com.ezc.aragenPR.webapp.security.UserSessionContext;
import com.ezc.aragenPR.webapp.service.pr.EzcPRHeaderService;
import com.ezc.aragenPR.webapp.service.shared.IVendorPortalDashboardService;
import jakarta.servlet.http.HttpSession;
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
import java.util.stream.Collectors;

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

    @Autowired
    private IVendorPortalDashboardService vendorPortalDashboardService;

    @GetMapping("/dashboard/*")
    public String showView(Principal principal, Authentication auth, Model model,
                           SecurityContextHolderAwareRequestWrapper requestWrapper, HttpSession session) {

        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        Users userObj = (Users) authentication.getPrincipal();

        model.addAttribute("userId", userObj.getUserId());

        if (authentication != null && authentication.isAuthenticated()) {
            for (GrantedAuthority authority : authentication.getAuthorities()) {
                log.debug("Role: " + authority.getAuthority());
            }
        }

        Set<String> authorities = authentication.getAuthorities().stream()
                .map(GrantedAuthority::getAuthority)
                .collect(Collectors.toSet());

        // EU_TYPE-derived role (see CustomUserServiceImpl.getAuthorities) picks the dashboard
        // variant, mirroring the legacy ezBuyerWelcome.jsp / ezWelcome_New.jsp / ezWelcomeTempUser.jsp split.
        if (authorities.contains("ROLE_VEND_SAP")) {
            return showVendorDashboard(userObj, model);
        }
        if (authorities.contains("ROLE_VEND_TEMP")) {
            return showTempVendorDashboard(userObj, model, session);
        }
        return showBuyerDashboard(userObj, model);
    }

    private String showBuyerDashboard(Users userObj, Model model) {
        String plantCode = "";
        Set<UserDefaults> defaults = userObj.getUserDefaults();
        List<String> userRoles = userObj.getRoles().stream()
                .map(Roles::getName)
                .toList();

        String loggedUser = userObj.getUserId();

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

        // Vendor Portal merge - QCF / RFQ / Vendor Registration tiles. See ezBuyerWelcome.jsp;
        // counts are placeholders from IVendorPortalDashboardService until wired up piece by piece.
        model.addAttribute("domesticRfqToAct", vendorPortalDashboardService.getDomesticRfqToActCount(loggedUser));
        model.addAttribute("importRfqToAct", vendorPortalDashboardService.getImportRfqToActCount(loggedUser));
        model.addAttribute("qcfPendingApproval", vendorPortalDashboardService.getQcfPendingApprovalCount(loggedUser));
        model.addAttribute("qcfPendingPoCreation", vendorPortalDashboardService.getQcfPendingPoCreationCount(loggedUser));
        model.addAttribute("domesticVendorPendingApproval", vendorPortalDashboardService.getDomesticVendorPendingApprovalCount(loggedUser));
        model.addAttribute("importVendorPendingApproval", vendorPortalDashboardService.getImportVendorPendingApprovalCount(loggedUser));

        return "dashboard/index";
    }

    private String showVendorDashboard(Users userObj, Model model) {
        // See ezWelcome_New.jsp (SAP vendor dashboard, EU_TYPE=3). UI only for now - counts
        // are placeholders from IVendorPortalDashboardService until wired up piece by piece.
        String vendorCode = userObj.getVendorCode();
        model.addAttribute("rfqToQuote", vendorPortalDashboardService.getRfqToQuoteCount(vendorCode));
        model.addAttribute("rfqToRequote", vendorPortalDashboardService.getRfqToRequoteCount(vendorCode));
        return "dashboard/vendorDashboard";
    }

    private String showTempVendorDashboard(Users userObj, Model model, HttpSession session) {
        // See ezWelcomeTempUser.jsp (temp vendor dashboard, EU_TYPE=4). Tiles are gated by
        // ALLOW_RFQ/ALLOW_REG exactly like the legacy page, now sourced from the
        // UserSessionContext that PostLoginSessionSetupService populates at login.
        UserSessionContext ctx = (UserSessionContext) session.getAttribute(PostLoginSessionSetupService.SESSION_ATTRIBUTE);
        boolean allowRfq = ctx != null && "Y".equals(ctx.getAllowRfq());
        boolean allowReg = ctx != null && "Y".equals(ctx.getAllowReg());
        model.addAttribute("allowRfq", allowRfq);
        model.addAttribute("allowReg", allowReg);

        if (allowRfq) {
            String vendorCode = userObj.getVendorCode();
            model.addAttribute("rfqToQuote", vendorPortalDashboardService.getRfqToQuoteCount(vendorCode));
            model.addAttribute("rfqToRequote", vendorPortalDashboardService.getRfqToRequoteCount(vendorCode));
        }

        return "dashboard/tempVendorDashboard";
    }

    @GetMapping("/user-manuals")
    public String getUserManuals(Model model) {
        return "documents";
    }
}
