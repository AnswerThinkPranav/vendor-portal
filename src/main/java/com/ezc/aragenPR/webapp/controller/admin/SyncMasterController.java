
package com.ezc.aragenPR.webapp.controller.admin;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import com.ezc.aragenPR.webapp.model.master.EzcMasterData;
import com.ezc.aragenPR.webapp.repository.master.EzcMasterDataRepo;
import com.ezc.aragenPR.webapp.service.master.MasterDataService;
import com.sap.conn.jco.JCoDestination;
import com.sap.conn.jco.JCoException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.ezc.aragenPR.webapp.service.shared.RFCReadSAPService;

import lombok.extern.slf4j.Slf4j;


@Controller
@Slf4j
public class SyncMasterController {

	@Autowired
	RFCReadSAPService rfcReadSAPService;

    @Autowired
    private EzcMasterDataRepo masterRepo;

    @Autowired
    private MasterDataService masterServ;

    @GetMapping("/master/{action}/{key}")
    @ResponseBody
    public  List<EzcMasterData> getMasterData(@PathVariable("action") String action,@PathVariable("key") String key, Model model)
    {
        System.out.println("Starting syncMasterData for key: " + key+"action"+action);
        List<EzcMasterData> dataList = new ArrayList<>();
        if ("sync".equalsIgnoreCase(action)) {
            System.out.println("Starting sync from SAP for key: " + key);

            dataList = masterServ.syncFromSAP(key);
        }
        else if("show".equalsIgnoreCase(action)) {
            System.out.println("Starting sync from DB for key: " + key);
            dataList = masterRepo.findByEmdKey(key);
        }
        System.out.println("Fetched " + dataList.size() );

      //  model.addAttribute("matList", dataList); // pass to JSP if needed
     /*   String viewName = "master/";
        switch (key.toUpperCase()) {
            case "PURGRP":
                viewName += "PurGrpList";
                break;
            case "DIVISION":
                viewName += "divisionList";
                break;
            case "COSTCENTER":
                viewName += "costCenterList";
                break;
            case "PLANT":
                viewName += "plantList";
                break;
            case "COMPANY":
                viewName += "companyList";
                break;
            default:
                viewName += "divisionList";


        }*/
        return dataList;
    }
    @GetMapping(value = "/syncMaster")
    public String syncMaster (Model model)
    {
        return "master/divisionList";
    }




}




