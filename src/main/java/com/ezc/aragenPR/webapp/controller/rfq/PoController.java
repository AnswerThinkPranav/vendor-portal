package com.ezc.aragenPR.webapp.controller.rfq;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ezc.aragenPR.webapp.dto.rfq.PoSummary;
import com.ezc.aragenPR.webapp.model.user.Users;
import com.ezc.aragenPR.webapp.service.rfq.IPoService;

/** Local-only Purchase Order creation from an approved QCF - see ezViewDOMQCF.jsp's Create PO button. */
@Controller
@RequestMapping("/po")
public class PoController {

    @Autowired
    private IPoService poService;

    @PostMapping("/api/{qcfNo}/create")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> createPo(@PathVariable String qcfNo) {
        try {
            List<PoSummary> pos = poService.createPurchaseOrders(qcfNo, currentUser());
            return ResponseEntity.ok(Map.of("status", "OK", "message", "Purchase Order(s) created.", "pos", pos));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("status", "ERROR", "message", e.getMessage()));
        }
    }

    @GetMapping("/api/{qcfNo}")
    @ResponseBody
    public ResponseEntity<List<PoSummary>> getPos(@PathVariable String qcfNo) {
        return ResponseEntity.ok(poService.getPurchaseOrders(qcfNo));
    }

    private Users currentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        return (Users) authentication.getPrincipal();
    }
}
