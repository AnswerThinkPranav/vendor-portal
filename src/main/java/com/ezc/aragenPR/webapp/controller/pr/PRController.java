package com.ezc.aragenPR.webapp.controller.pr;
import com.ezc.aragenPR.webapp.dto.pr.PRRequest;
import com.ezc.aragenPR.webapp.dto.pr.PRItem;
import com.ezc.aragenPR.webapp.dto.pr.PRService;
import com.ezc.aragenPR.webapp.repository.master.EzcMasterDataRepo;
import com.ezc.aragenPR.webapp.repository.pr.EzcPRHeaderRepository;
import com.ezc.aragenPR.webapp.security.LoggedUser;
import com.ezc.aragenPR.webapp.service.pr.EzcPRHeaderService;
import com.ezc.aragenPR.webapp.service.shared.MailService;
import com.ezc.aragenPR.webapp.service.shared.RFCReadSAPService;
import com.sap.conn.jco.*;
import lombok.extern.slf4j.Slf4j;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.security.Principal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.*;
import java.util.stream.Collectors;

import com.ezc.aragenPR.webapp.service.shared.RFCReadSAPService;

import com.ibm.icu.impl.ICULocaleService;
import lombok.extern.slf4j.XSlf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.servletapi.SecurityContextHolderAwareRequestWrapper;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.SpringServletContainerInitializer;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import com.ezc.aragenPR.webapp.dto.pr.MaterialDto;
import com.ezc.aragenPR.webapp.model.master.EzcMasterData;
import com.ezc.aragenPR.webapp.model.pr.EzPurchaseRequisitionHeader;
import com.ezc.aragenPR.webapp.model.pr.EzPurchaseRequisitionItems;
import com.ezc.aragenPR.webapp.model.pr.EzPurchaseRequisitionServices;
import com.ezc.aragenPR.webapp.model.user.UserDefaults;
import com.ezc.aragenPR.webapp.model.user.Users;
   



@Slf4j
@Controller
public class PRController {

    @Autowired
    RFCReadSAPService rfcReadSAPService;

    @Autowired
    private EzcPRHeaderRepository headerRepo;


    @Autowired
    private EzcMasterDataRepo masterRepo;

    @Autowired
    private EzcPRHeaderService headerService;

    @Autowired
    private MailService mailService;

    private String checkNull(Object value) {
        return (value == null) ? "" : value.toString().trim();
    }
    private String removeLeadingZeros(String value) {
        if (value == null) return "";
        return value.replaceFirst("^0+(?!$)", ""); // removes only leading zeros
    }
    private BigDecimal safeBigDecimal(String value) {
        try {
            return (value != null && !value.trim().isEmpty())
                    ? new BigDecimal(value.trim())
                    : BigDecimal.ZERO;
        } catch (NumberFormatException e) {
            return BigDecimal.ZERO;
        }
    }
    private BigDecimal safeDecimal(BigDecimal value) {
        return value != null ? value.setScale(2, RoundingMode.HALF_UP) : BigDecimal.ZERO;
    }

    @GetMapping("prCreate/add")
    public String showCreatePage(Model model)
    {
        String loggedUser = "";
        String documentType="";
        List<String> docTypesList=new ArrayList<String>();
        try {
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            Users userObj = (Users)authentication.getPrincipal();
            loggedUser=(String)userObj.getUserId();
            Set<UserDefaults> defaults = userObj.getUserDefaults();
            if (defaults != null) {
                for (UserDefaults def : defaults)
                {
                    if ("DOCTYPE".equalsIgnoreCase(def.getKey())) {
                        documentType = def.getValue();
                        log.debug("User documentType: " + documentType);
                        break; // if only one documentType per user
                    }
                }
                if (documentType.contains("##"))
                {
                    String[] docTypeArr = documentType.split("##");

                    for (int i = 0; i < docTypeArr.length; i++) {
                        String currDocType = docTypeArr[i];
                        log.debug("docType:" + (i + 1) + ":" + currDocType);
                        docTypesList.add(currDocType);
                        // Add additional logic here if you want to handle more than 2 plants
                    }
                }
                else {
                    docTypesList.add(documentType);
                }
            }

        } catch (Exception e) {

        }
        List<EzcMasterData> accAssgList = masterRepo.findByEmdKey("ACCASSG");
        List<EzcMasterData> plantList = masterRepo.findByEmdKey("PLANT");
        List<EzcMasterData> itemCategList = masterRepo.findByEmdKey("ITEMCATEG");
        List<EzcMasterData> docTypeList = masterRepo.findByEmdKey("DOCTYPE");
        List<EzcMasterData> divisionList = masterRepo.findByEmdKey("DIVISION");
        List<EzcMasterData> purchaseGroupList = masterRepo.findByEmdKey("PURGRP");
        List<EzcMasterData> storLocList = masterRepo.findByEmdKey("STRGLOC");
        divisionList = divisionList != null ? divisionList : new ArrayList<>();
        purchaseGroupList = purchaseGroupList != null ? purchaseGroupList : new ArrayList<>();
        model.addAttribute("divisions", divisionList);
        model.addAttribute("purchaseGroups", purchaseGroupList);
        model.addAttribute("docTypes",docTypeList);
        model.addAttribute("plants",plantList);
        model.addAttribute("accAssgs",accAssgList);
        model.addAttribute("itemCategs",itemCategList);
        model.addAttribute("storgLocs",storLocList);
        model.addAttribute("prForm", new EzPurchaseRequisitionHeader());
        return "prCreation/createPR";
    }

    @GetMapping(value="/getDepartments")
    @ResponseBody
    public List<EzcMasterData> getDepartments(@RequestParam("division") String division,@RequestParam("plant") String plant)
    {
        String compositeKey = division + "#" + plant;
        log.debug("compositeKey"+compositeKey);
        //System.out.println("returnJson"+masterRepo.findByEmdKeyAndEmdValue3("DEPART", compositeKey));
        return masterRepo.findByEmdKeyAndEmdValue3("DEPART", compositeKey);

    }
    @GetMapping(value="/getStorageLocations")
    @ResponseBody
    public List<EzcMasterData> getStorageLocations(@RequestParam("plant") String plant)
    {
        String compositeKey =  plant;
        log.debug("compositeKey getStorageLocations"+compositeKey);
        //System.out.println("returnJson"+masterRepo.findByEmdKeyAndEmdValue3("STRGLOC", compositeKey));
        return masterRepo.findByEmdKeyAndEmdValue3("STRGLOC", compositeKey);

    }
    @GetMapping(value="/getMaterialGroup")
    @ResponseBody
    public List<EzcMasterData> getMaterialGroup(@RequestParam("plant") String plant)
    {
        String compositeKey =  plant;
        log.debug("compositeKey getMaterialGroup"+compositeKey);
        //System.out.println("returnJson"+masterRepo.findByEmdKey("MATGRP"));
        return masterRepo.findByEmdKey("MATGRP");

    }

    @GetMapping(value="/getMaterials")
    @ResponseBody
    public List<MaterialDto>getMaterials(@RequestParam("plant") String plant,@RequestParam("query") String query,@RequestParam("searchType") String searchType)
    {
        List<MaterialDto> materials = new ArrayList<>();
        log.debug("IN getMaterials"+plant+"query"+query+"searchType"+searchType);
        try {

            JCoDestination destination = rfcReadSAPService.getDestination();
            JCoRepository repository = destination.getRepository();
            JCoFunction poFunction = repository.getFunction("BAPI_MATERIAL_GETLIST");
            //JCoFunction commitFunction = repository.getFunction("BAPI_TRANSACTION_COMMIT");

            log.debug("SAP Connection established successfully!");
            // System.out.println("Connected User: " + destination.getUser());

            try
            {

                if("shortText".equals(searchType))
                {

                    JCoTable matShortDescSel = poFunction.getTableParameterList().getTable("MATERIALSHORTDESCSEL");

                    matShortDescSel.appendRow();

                    matShortDescSel.setValue("SIGN","I");

                    matShortDescSel.setValue("OPTION","CP");

                    matShortDescSel.setValue("DESCR_LOW",query + "*");

                }

                if("matNumber".equals(searchType))
                {

                    JCoTable matnrSel = poFunction.getTableParameterList().getTable("MATNRSELECTION");

                    matnrSel.appendRow();

                    matnrSel.setValue("SIGN","I");

                    matnrSel.setValue("OPTION","CP");

                    matnrSel.setValue("MATNR_LOW","*" + query);

                }

            }

            catch (Exception execEx)
            {

                log.debug("start 123: " + execEx.getMessage());

            }

            JCoTable plantSel = poFunction.getTableParameterList().getTable("PLANTSELECTION");

            plantSel.appendRow();

            plantSel.setValue("SIGN","I");

            plantSel.setValue("OPTION","EQ");

            plantSel.setValue("PLANT_LOW",plant);


            log.debug("Executing BAPI_MATERIAL_GETLIST");
            try {
                JCoContext.begin(destination);
                poFunction.execute(destination);
                //commitFunction.execute(destination);
                JCoContext.end(destination);
            }catch(Exception e){}

            JCoTable matListTable = poFunction.getTableParameterList().getTable("MATNRLIST");

            try
            {
                if(matListTable != null && matListTable.getNumRows() > 0)
                {
                    log.debug("Material num of Rows"+matListTable.getNumRows());
                    do
                    {
                        MaterialDto m1=new MaterialDto();
                        String rawCode = (String) matListTable.getValue("MATERIAL");

                        String trimmedCode = rawCode != null ? rawCode.replaceFirst("^0+(?!$)", "") : "";

                        m1.setMaterialCode(trimmedCode);
                        m1.setDescription((String)matListTable.getValue("MATL_DESC"));
                        materials.add(m1);

                    }
                    while(matListTable.nextRow());
                }
            }catch(Exception e){log.debug("Exception in output " +e);}


        } catch (JCoException e) {
            log.debug("Error connecting to SAP: " + e.getMessage());
            e.printStackTrace();
        }
        //System.out.println("materials"+materials);
        return materials;
    }
    @GetMapping(value="/getWBSElements")
    @ResponseBody
    public List<MaterialDto>getWBSElements(@RequestParam("plant") String plant,@RequestParam(required = false) String query)
    {
        List<MaterialDto> wbsElements = new ArrayList<>();
        log.debug("IN getWBSElements"+plant+"query"+query);
        try {

            JCoDestination destination = rfcReadSAPService.getDestination();
            JCoRepository repository = destination.getRepository();
            JCoFunction poFunction = repository.getFunction("ZEZ_ACTIVE_WBS");


            log.debug("SAP Connection established successfully!");
            log.debug("Connected User: " + destination.getUser());

            try
            {


                JCoTable matShortDescSel = poFunction.getTableParameterList().getTable("I_WBS");

                matShortDescSel.appendRow();

                matShortDescSel.setValue("SIGN","I");

                matShortDescSel.setValue("OPTION","CP");

                matShortDescSel.setValue("LOW",query + "*");

            }

            catch (Exception execEx)
            {

                log.debug("start 123: " + execEx.getMessage());

            }

            log.debug("Executing ZEZ_ACTIVE_WBS");
            try {
                JCoContext.begin(destination);
                poFunction.execute(destination);
                //commitFunction.execute(destination);
                JCoContext.end(destination);
            }catch(Exception e){}

            JCoTable wbsTable = poFunction.getTableParameterList().getTable("E_WBS");

            try
            {
                if(wbsTable != null && wbsTable.getNumRows() > 0)
                {
                    log.debug("Material num of Rows"+wbsTable.getNumRows());
                    do
                    {
                        MaterialDto m1=new MaterialDto();
                        String rawCode = (String) wbsTable.getValue("PSPNR");
                        String wbsCode = (String) wbsTable.getValue("POSID");
                        String plantFromSAP = (String) wbsTable.getValue("WERKS");
                        //System.out.println("rawCode"+rawCode +"wbsCode"+wbsCode);
                        // if(plant.equals(plantFromSAP))
                        //  {
                        m1.setWbsCode(wbsCode);
                        m1.setWbsCodeDesc(wbsCode);
                        wbsElements.add(m1);
                        //}
                    }
                    while(wbsTable.nextRow());
                }
            }catch(Exception e){log.debug("Exception in output " +e);}


        } catch (JCoException e) {
            log.debug("Error connecting to SAP: " + e.getMessage());
            e.printStackTrace();
        }
        log.debug("WBSmaterials size"+wbsElements.size());
        return wbsElements;
    }

    @GetMapping(value="/getGLAcct")
    @ResponseBody
    public List<MaterialDto>getGLAccount(@RequestParam("plant") String plant)
    {
        List<MaterialDto> materials = new ArrayList<>();
        log.debug("IN getGLAccount"+plant);
        try {

            JCoDestination destination = rfcReadSAPService.getDestination();
            JCoRepository repository = destination.getRepository();
            JCoFunction poFunction = repository.getFunction("Z_EZ_GET_GL_ACCOUNT");



            log.debug("SAP Connection established successfully!");
            log.debug("Connected User: " + destination.getUser());

            JCoTable plantSel = poFunction.getImportParameterList().getTable("GLACCOUNT");

            plantSel.appendRow();

            plantSel.setValue("SIGN","I");

            plantSel.setValue("OPTION","CP");

            plantSel.setValue("LOW","004*");


            log.debug("Executing Z_EZ_GET_GL_ACCOUNT");
            try {
                JCoContext.begin(destination);
                poFunction.execute(destination);

                JCoContext.end(destination);
            }catch(Exception e){}

            JCoTable matListTable = poFunction.getTableParameterList().getTable("ET_SKA1");
            try
            {
                if(matListTable != null && matListTable.getNumRows() > 0)
                {
                    log.debug("Material num of Rows"+matListTable.getNumRows());
                    do
                    {
                        MaterialDto m1=new MaterialDto();
                        String rawCode = (String) matListTable.getValue("SAKAN");

                        m1.setGlAcc(rawCode);
                        m1.setGlAccDesc((String)matListTable.getValue("TXT50"));
                        materials.add(m1);

                    }
                    while(matListTable.nextRow());
                }
            }catch(Exception e){log.debug("Exception in output " +e);}


        } catch (JCoException e) {
            log.debug("Error connecting to SAP: " + e.getMessage());
            e.printStackTrace();
        }
        //System.out.println("materials"+materials);
        return materials;
    }
    @GetMapping(value="/getProjCode")
    @ResponseBody
    public List<MaterialDto>getProjCode(@RequestParam("plant") String plant)
    {
        List<MaterialDto> materials = new ArrayList<>();
        System.out.println("IN getProjCode"+plant);
        try {

            JCoDestination destination = rfcReadSAPService.getDestination();
            JCoRepository repository = destination.getRepository();
            JCoFunction poFunction = repository.getFunction("Z_EZ_GET_PROJ_WBS");


            System.out.println("SAP Connection established successfully!");
            System.out.println("Connected User: " + destination.getUser());


            JCoParameterList importParams = poFunction.getImportParameterList();
            importParams.setValue("PSPID", "*");
            importParams.setValue("PBUKR", "1000");


            System.out.println("Executing Z_EZ_GET_PROJ_WBS");
            try {
                JCoContext.begin(destination);
                poFunction.execute(destination);

                JCoContext.end(destination);
            }catch(Exception e){}


            JCoStructure projStruct = poFunction.getExportParameterList().getStructure("RETURN");
            if (projStruct != null && !"".equals(projStruct.getString("MESSAGE")))
            {
                String returnType = projStruct.getString("TYPE");
                String returnMsg = projStruct.getString("MESSAGE");
                System.out.print("Z_EZ_GET_PROJ_WBS SAP RETURN Message [" + returnType + "]: " + returnMsg);

                if ("E".equals(returnType) || "A".equals(returnType)) {
                    System.out.print("Error returned by Z_EZ_GET_PROJ_WBS: " + returnMsg);

                }
            }
            try {
                JCoTable returnTable = poFunction.getTableParameterList().getTable("PROJ_TAB");

                if (returnTable != null && returnTable.getNumRows() > 0) {
                    boolean matchedPlantFound = false;

                    returnTable.firstRow();
                    do {
                        String projPlant = (returnTable.getValue("WERKS").toString());
                        MaterialDto m1 = new MaterialDto();
                        if (projPlant.equals(plant)) {
                            m1.setProjCode((String) returnTable.getValue("PSPID"));
                            m1.setProjCodeDesc((String) returnTable.getValue("POST1"));
                            materials.add(m1);

                        }

                    } while (returnTable.nextRow());

                }
            }catch(Exception e){}


        } catch (JCoException e) {
            System.out.println("Error connecting to SAP: " + e.getMessage());
            e.printStackTrace();
        }
        //System.out.println("materials"+materials);
        return materials;
    }

    @GetMapping(value="/getCostCenter")
    @ResponseBody
    public List<EzcMasterData> getCostCenter()
    {

        log.debug("getCostCenter");

        return masterRepo.findByEmdKey("COSTCENTER");

    }
    @GetMapping(value="/getReason")
    @ResponseBody
    public List<EzcMasterData> getReason()
    {

        log.debug("getReason");

        return masterRepo.findByEmdKey("REASON");

    }
    @GetMapping(value="/getInternalOrders")
    @ResponseBody
    public List<EzcMasterData> getInternalOrders()
    {

        log.debug("getInternalOrders");

        return masterRepo.findByEmdKey("IO");

    }
    @GetMapping(value="/getNetwork")
    @ResponseBody
    public List<EzcMasterData>getNetwork(@RequestParam("plant") String plant)
    {
        List<MaterialDto> materials = new ArrayList<>();
        log.debug("IN getNetwork"+plant);
        String compositeKey =  plant;
        log.debug("compositeKey getNetwork"+compositeKey);
        //  System.out.println("returnJson"+masterRepo.findByEmdKeyAndEmdValue3("SERVICECD", compositeKey));

        return masterRepo.findByEmdKeyAndEmdValue3("NETWORK", compositeKey);
        //System.out.println("materials"+materials);

    }

    /*  @GetMapping(value="/getWBSElements")
      @ResponseBody
      public List<MaterialDto>getWBSElements(@RequestParam("plant") String plant)
      {
          List<MaterialDto> materials = new ArrayList<>();
          System.out.println("IN getWBSElements"+plant);
          String[] outputFields =null;
          String[] queryValues=null;
          String tabName="";
          try {
              outputFields = new String[]{"POSID","POST1"};
              queryValues = new String[]{"WERKS EQ '"+plant+"'"};
              tabName="PRPS";
              List<String[]> dataList = rfcReadSAPService.readRFCTable(tabName, outputFields, queryValues);
              if(dataList!=null)
              {
                  for(String row[]:dataList)
                  {
                          MaterialDto m1 = new MaterialDto();

                              m1.setWbsCode(row[0]);
                              m1.setWbsCodeDesc(row[1]);
                              materials.add(m1);

                  }

              }
              }catch(Exception e){}
          System.out.println("materials"+materials);
          return materials;
      }
    */
    @GetMapping(value="/getServiceCode")
    @ResponseBody
    public List<EzcMasterData>getServiceCode(@RequestParam("plant")  String plant,@RequestParam("matGroup")  String matGroup)
    {

        String compositeKey =  matGroup;
        log.debug("compositeKey getServiceCode"+compositeKey);
        //  System.out.println("returnJson"+masterRepo.findByEmdKeyAndEmdValue3("SERVICECD", compositeKey));

        return masterRepo.findByEmdKeyAndEmdValue3("SERVICECD", compositeKey);

      /*String[] outputFields =null;
      String[] queryValues=null;
      String tabName="";
      try {
          outputFields = new String[]{"ASNUM","ASKTX","BKLAS"};
          queryValues = new String[]{"ASNUM LIKE '0000000003%'"};
          tabName="VASMD";
          List<String[]> dataList = rfcReadSAPService.readRFCTable(tabName, outputFields, queryValues);
          if(dataList!=null)
          {
              for(String row[]:dataList)
              {
                  MaterialDto m1 = new MaterialDto();

                  m1.setServCode(row[0]);
                  m1.setServCodeDesc(row[1]);
                  materials.add(m1);

              }

          }
      }catch(Exception e){}*/



    }
    @GetMapping(value="/getAggrements")
    @ResponseBody
    public List<MaterialDto>getAggrements(@RequestParam("plant")  String plant,@RequestParam("materialCode")  String materialCode)
    {

        List<MaterialDto> materials = new ArrayList<>();
        log.debug("getAggrements getAggrements"+materialCode);
        try {

            JCoDestination destination = rfcReadSAPService.getDestination();
            JCoRepository repository = destination.getRepository();
            JCoFunction poFunction = repository.getFunction("ZEZ_AGREEMENT_LIST");


            System.out.println("SAP Connection established successfully! ZEZ_AGREEMENT_LIST");
            System.out.println("Connected User: " + destination.getUser());
            JCoParameterList importParams = poFunction.getImportParameterList();
            importParams.setValue("MATERIAL", String.format("%018d", Long.parseLong(materialCode)));
            importParams.setValue("PLANT", plant);
            importParams.setValue("DOC_CATEGORY", "K");




            System.out.println("Executing BAPI_MATERIAL_GET_DETAIL"+importParams.getString("MATERIAL"));
            try {
                JCoContext.begin(destination);
                poFunction.execute(destination);

                JCoContext.end(destination);
            }catch(Exception e){}

            JCoParameterList tableParams = poFunction.getTableParameterList();
            JCoParameterList exportParams = poFunction.getExportParameterList();
            JCoTable headerRet = tableParams.getTable("PO_HEADERS");
            JCoTable itemRet = tableParams.getTable("PO_ITEMS");

            Map<String, String> agreementVendorMap = new HashMap<>();
            System.out.println("PO_HEADERS"+headerRet.getNumRows());
            for (int i = 0; i < headerRet.getNumRows(); i++) {
                headerRet.setRow(i);

                String agreement = headerRet.getString("EBELN");
                String vendor = headerRet.getString("LIFNR");
                System.out.println("Executing BAPI_MATERIAL_GET_DETAIL"+agreement);
                agreementVendorMap.put(agreement, vendor);
            }
            for (int i = 0; i < itemRet.getNumRows(); i++) {

                itemRet.setRow(i);

                String agreement = itemRet.getString("EBELN");
                String itemNo = itemRet.getString("EBELP");
                String shortText = itemRet.getString("TXZ01");

                // Fetch vendor from header map
                String vendor = agreementVendorMap.get(agreement);
                MaterialDto m1 = new MaterialDto();
                m1.setAggKey(agreement + "#" + vendor + "#" + itemNo);
                m1.setAggValue(agreement + " - " + itemNo + " - " + vendor + " - " + shortText);

                materials.add(m1);
            }
        } catch (Exception e1) {
            System.out.println("Exception while preparing or executing BAPI_MATERIAL_GET_DETAIL: " + e1.getMessage());
        }

        //System.out.println("materials"+materials);
        return materials;



    }
    @GetMapping(value="/getMaterialDetails")
    @ResponseBody
    public List<MaterialDto>getMaterialDetails(@RequestParam("plant") String plant,@RequestParam("materialCode") String materialCode)
    {
        List<MaterialDto> materials = new ArrayList<>();
        log.debug("IN getMaterial details"+plant+"matCode"+materialCode);
        try {

            JCoDestination destination = rfcReadSAPService.getDestination();
            JCoRepository repository = destination.getRepository();
            JCoFunction poFunction = repository.getFunction("BAPI_MATERIAL_GET_DETAIL");
            //JCoFunction commitFunction = repository.getFunction("BAPI_TRANSACTION_COMMIT");

            System.out.println("SAP Connection established successfully!");
            System.out.println("Connected User: " + destination.getUser());
            JCoParameterList importParams = poFunction.getImportParameterList();
            importParams.setValue("MATERIAL", String.format("%018d", Long.parseLong(materialCode)));
            importParams.setValue("PLANT", plant);
            importParams.setValue("VALUATIONAREA", plant);




            System.out.println("Executing BAPI_MATERIAL_GET_DETAIL");
            try {
                JCoContext.begin(destination);
                poFunction.execute(destination);
                //commitFunction.execute(destination);
                JCoContext.end(destination);
            }catch(Exception e){}

            JCoStructure returnStruct = poFunction.getExportParameterList().getStructure("RETURN");
            if (returnStruct != null && !"".equals(returnStruct.getString("MESSAGE"))) {
                String returnType = returnStruct.getString("TYPE");
                String returnMsg = returnStruct.getString("MESSAGE");
                System.out.println("SAP RETURN Message [" + returnType + "]: " + returnMsg);

                if ("E".equals(returnType) || "A".equals(returnType)) {
                    System.out.println("Error returned by BAPI: " + returnMsg);

                }
            }

            JCoParameterList exportParams = poFunction.getExportParameterList();
            JCoStructure generalData = exportParams.getStructure("MATERIAL_GENERAL_DATA");
            JCoStructure valuationData = exportParams.getStructure("MATERIALVALUATIONDATA");

            String matDesc = generalData.getString("MATL_DESC");
            String matGrp = generalData.getString("MATL_GROUP");
            String matUom = generalData.getString("BASE_UOM");
            String valPrice="0";
            try {
                Object valObj = valuationData.getValue("MOVING_PR");
                if (valObj instanceof BigDecimal) {
                    valPrice = ((BigDecimal) valObj).setScale(2, java.math.RoundingMode.HALF_UP).toString();
                } else if (valObj != null) {
                    valPrice = new BigDecimal(valObj.toString()).setScale(2, java.math.RoundingMode.HALF_UP).toString();
                } else {
                    System.out.println("MOVING_PR is null");
                }
            } catch (Exception ex) {
                System.out.println("Error processing MOVING_PR: " + ex.getMessage());
            }
//***************GET CASNO********************************

            String[] outputFields =null;
            String[] queryValues=null;
            String tabName="";
            String casNO="";
            String materialPass=String.format("%018d", Long.parseLong(materialCode));
            try {

                outputFields = new String[]{"ZZCAS_NO", "ZCATNO", "ZMAN", "ZZBRAND"};
                queryValues = new String[]{"MATNR EQ '" + materialPass + "'"};
                tabName = "MARA";
                List<String[]> dataList = rfcReadSAPService.readRFCTable(tabName, outputFields, queryValues);
                if (dataList != null) {
                    for (String row[] : dataList) {
                        casNO = row[0];
                    }
                }
            }catch(Exception e){}
            System.out.println("getCasNo"+casNO+"materialPass"+materialPass);
//**************************************************

            MaterialDto m1=new MaterialDto();
            m1.setMaterialCode(materialCode);
            m1.setDescription(matDesc);
            m1.setMaterialGroup(matGrp);
            m1.setUom(matUom);
            m1.setUnitPrice(valPrice);
            m1.setCasNo(casNO);
            materials.add(m1);

        } catch (Exception e1) {
            System.out.println("Exception while preparing or executing BAPI_MATERIAL_GET_DETAIL: " + e1.getMessage());
        }

        //System.out.println("materials"+materials);
        return materials;
    }
    @GetMapping("/checkReleaseStrategy")
    @ResponseBody
    public boolean checkReleaseStrategy(@RequestParam("plant") String plant,
                                        @RequestParam("purGrp") String purGrp,
                                        @RequestParam("division") String division,
                                        @RequestParam("department") String department)
    {
        boolean isMaintained = false;
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        Users userObj = (Users)authentication.getPrincipal();
        String loggedUser=(String)userObj.getUserId();
        //   String logUserName=(String)userDet.getUsername();
        try {
            System.out.println("IN::checkRelSt:: TRY"+"plant"+plant+"purGrp"+purGrp+"division"+division+"department"+department+"loggedUser"+loggedUser);
            JCoDestination destination = rfcReadSAPService.getDestination();
            JCoRepository repository = destination.getRepository();
            JCoFunction poFunction = repository.getFunction("ZEZ_PR_USER_DATA");
            JCoParameterList importParams = poFunction.getImportParameterList();
            importParams.setValue("S_UNAME", loggedUser);//22800
            importParams.setValue("S_WERKS", plant);
            importParams.setValue("S_EKGRP", purGrp);
            importParams.setValue("S_ZZBU", division);
            importParams.setValue("S_ZZDEPT", department);
            System.out.println("Executing ZEZ_PR_USER_DATA");
            try {
                JCoContext.begin(destination);
                poFunction.execute(destination);
                //commitFunction.execute(destination);
                JCoContext.end(destination);
            }catch(Exception e){}

            JCoTable resultTable = poFunction.getTableParameterList().getTable("PR_USER_DATA");
            int cnt=0;
            if (resultTable != null && resultTable.getNumRows() > 0) {
                cnt=resultTable.getNumRows();

                String  FRGGR= (String)resultTable.getValue("FRGGR");
                String  FRGSX= (String)resultTable.getValue("FRGSX");
                System.out.println("FRGGR: " +FRGGR+"FRGSX"+FRGSX);
                if(FRGGR!=null && FRGSX!=null && FRGGR!="" && FRGSX!="")
                    isMaintained=true;
            }
            System.out.println("SAP Connection established successfully!"+isMaintained);
            System.out.println("resultTable count: " +cnt);


        }
        catch (JCoException e) {
            System.out.println("Error connecting to SAP: " + e.getMessage());
            e.printStackTrace();
        }
        return isMaintained;
    }
    @PostMapping(value="prCreate/postPR")
    public ResponseEntity<Map<String, Object>> createPR(@RequestBody PRRequest prRequest)
    {


        Map<String, Object> response = new HashMap<>();
        try {
            System.out.println("IN::createPR:: TRY");
            JCoDestination destination = rfcReadSAPService.getDestination();
            JCoRepository repository = destination.getRepository();
            JCoFunction poFunction = repository.getFunction("ZBAPI_PR_CREATE");
            //JCoFunction commitFunction = repository.getFunction("BAPI_TRANSACTION_COMMIT");

            System.out.println("SAP Connection established successfully!");
            System.out.println("Connected User: " + destination.getUser());

            JCoParameterList imp = poFunction.getImportParameterList();
            JCoParameterList tab = poFunction.getTableParameterList();


            JCoStructure header = imp.getStructure("PRHEADER");
            JCoStructure headerX = imp.getStructure("PRHEADERX");
            if (prRequest.getDocType() == null || prRequest.getDocType().isEmpty()) {
                return ResponseEntity.badRequest().body(Map.of("status", "ERROR", "message", "Missing Document Type"));
            }
            if (prRequest.getPlant() == null || prRequest.getPlant().isEmpty()) {
                return ResponseEntity.badRequest().body(Map.of("status", "ERROR", "message", "Missing Plant"));
            }
            if (prRequest.getPurGrp() == null || prRequest.getPurGrp().isEmpty()) {
                return ResponseEntity.badRequest().body(Map.of("status", "ERROR", "message", "Missing Purchase Group"));
            }
            if (prRequest.getDivision() == null || prRequest.getDivision().isEmpty()) {
                return ResponseEntity.badRequest().body(Map.of("status", "ERROR", "message", "Missing Division"));
            }
            if (prRequest.getDepartment() == null || prRequest.getDepartment().isEmpty()) {
                return ResponseEntity.badRequest().body(Map.of("status", "ERROR", "message", "Missing Department"));
            }
            if (prRequest.getItems() == null || prRequest.getItems().isEmpty()) {
                return ResponseEntity.badRequest().body(Map.of("status", "ERROR", "message", "No items provided"));
            }
            String docType=prRequest.getDocType();
            System.out.println("docType"+docType);
            header.setValue("PR_TYPE", docType);
            headerX.setValue("PR_TYPE", "X");

          /*  if ("ZRSR".equals(prRequest.getDocType())) {
                header.setValue("ITEM_INTVL", "00001");
                header.setValue("CTRL_IND", "R");
                header.setValue("LAST_ITEM", "00001");
                headerX.setValue("ITEM_INTVL", "X");
                headerX.setValue("CTRL_IND", "X");
                headerX.setValue("LAST_ITEM", "X");
            }*/

            JCoTable itemTable = tab.getTable("PRITEM");
            JCoTable itemXTable = tab.getTable("PRITEMX");
            JCoTable accTab = tab.getTable("PRACCOUNT");
            JCoTable accTabX = tab.getTable("PRACCOUNTX");
            JCoTable extTab = tab.getTable("EXTENSIONIN");
            JCoTable addTab = tab.getTable("ADDITIONAL_DATA");
            JCoTable addTabX = tab.getTable("ADDITIONAL_DATAX");


            SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd");
            SimpleDateFormat sapFormat = new SimpleDateFormat("yyyyMMdd");
            List<PRItem> prItems=new ArrayList<>();
            PRItem item1 =new PRItem();
           /* item1.setItemNumber("00001");
            item1.setShortText("1A,25-DIHYDROXYVITAMIN D3");
            item1.setMaterial("000000004300000676");
            item1.setPlant("1202");
            item1.setQuantity(1.0);
            item1.setUnit("EA");
            item1.setMaterialGrp("1001");
            item1.setDeliveryDate("15.10.2025");
            item1.setShortText("1A,25-DIHYDROXYVITAMIN D3");
            item1.setPeriodInd("D");
            item1.setAccAss("P");
            item1.setPurGrp("K01");
            item1.setReqName("SARIEH A");
            item1.setGlAct("0040201520");
            item1.setWbsElement("CB-31390-024");
            prItems.add(item1);*/

            int counter = 1;
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            Users userObj = (Users)authentication.getPrincipal();
            String loggedUser=(String)userObj.getUserId();
            String prUserName="SARIEH A";
            prUserName=(String) userObj.getFirstName()+""+(String) userObj.getLastName();

            for (PRItem item : prRequest.getItems())
            {
                Date parsedDate = inputFormat.parse(item.getDeliveryDate());
                String formattedDate = sapFormat.format(parsedDate);
                int sapItemNumber = counter * 10;
                String itemNumber = String.format("%05d", sapItemNumber);  // creates 00001, 00002, etc.
                System.out.println("shortText"+item.getShortText());
                String matCode = item.getMatNumber();
                if (matCode != null) {
                    // Pad with leading zeros to make 18 digits
                    matCode = String.format("%18s", matCode).replace(' ', '0');
                } else {
                    matCode = "000000000000000000"; // fallback if null
                }
                itemTable.appendRow();
                itemTable.setValue("PREQ_ITEM", itemNumber);
                itemTable.setValue("PREQ_NAME", prUserName);
                System.out.println("itemNumber"+itemNumber+"prUserName"+prUserName);
                itemTable.setValue("SHORT_TEXT", item.getShortText());
                itemTable.setValue("STORE_LOC", item.getStorageLoc());
                System.out.println("getStrgLoc"+item.getStorageLoc());
                itemTable.setValue("PLANT", item.getPlant());
                itemTable.setValue("QUANTITY", item.getQuantity());
                itemTable.setValue("MATERIAL",matCode);
                System.out.println("getMatCode"+matCode);
                itemTable.setValue("MATL_GROUP", item.getMaterialGroup());
                itemTable.setValue("UNIT", item.getUom());
                itemTable.setValue("DELIV_DATE", formattedDate);
                System.out.println("formattedDate"+formattedDate);
                itemTable.setValue("PREQ_PRICE", item.getValPrice());
                itemTable.setValue("PERIOD_IND_EXPIRATION_DATE","D");
                itemTable.setValue("ACCTASSCAT",prRequest.getAccAsmt());
                itemTable.setValue("ITEM_CAT",prRequest.getItemCateg());
                itemTable.setValue("PUR_GROUP",item.getPurGrp());
                itemTable.setValue("TRACKINGNO", item.getTrackNo());
                System.out.println("getPurGrp"+item.getPurGrp());
                //itemTable.setValue("PREQ_NAME",item.getReqName());
                System.out.println("formatted Date " + item.getReqName());
                System.out.println("formatted Date " + itemTable.getValue("DELIV_DATE"));
                log.debug("ACCTASSCAT"+prRequest.getAccAsmt()+"docType"+docType);
                if("ZOSO".equals(docType))
                {
                    String aggrement=checkNull((String)item.getAgreement());
                    if(!"".equals(aggrement))
                        aggrement=aggrement.split("#")[0];
                    itemTable.setValue("AGREEMENT", aggrement);
                    itemTable.setValue("AGMT_ITEM", item.getAggrItem());
                    itemTable.setValue("FIXED_VEND", item.getFixVendor());
                    System.out.println("Aggrement"+item.getAgreement());
                }

                itemXTable.appendRow();
                itemXTable.setValue("PREQ_ITEM", itemNumber);
                itemXTable.setValue("PREQ_ITEMX", "X");
                itemXTable.setValue("PUR_GROUP", "X");
                itemXTable.setValue("PREQ_NAME", "X");
                itemXTable.setValue("MATERIAL", "X");
                itemXTable.setValue("MATL_GROUP", "X");
                itemXTable.setValue("SHORT_TEXT", "X");
                itemXTable.setValue("STORE_LOC", "X");
                itemXTable.setValue("PLANT", "X");
                itemXTable.setValue("QUANTITY", "X");
                itemXTable.setValue("UNIT", "X");
                itemXTable.setValue("DELIV_DATE", "X");
                itemXTable.setValue("PREQ_PRICE", "X");
                itemXTable.setValue("ACCTASSCAT", "X");
                itemXTable.setValue("ITEM_CAT", "X");
                itemXTable.setValue("TRACKINGNO", "X");
                itemXTable.setValue("VAL_TYPE", "X");
                itemXTable.setValue("CURRENCY", "X");
                if("ZOSO".equals(docType))
                {
                    itemXTable.setValue("AGREEMENT", "X");
                    itemXTable.setValue("AGMT_ITEM", "X");
                    itemXTable.setValue("FIXED_VEND", "X");

                }


                accTab.appendRow();
                accTab.setValue("PREQ_ITEM", itemNumber);
                accTab.setValue("SERIAL_NO","01");
                //  accTab.setValue("GL_ACCOUNT",item.getGlAcc());
                if ("F".equalsIgnoreCase(prRequest.getAccAsmt())) {
                    accTab.setValue("ORDERID", item.getInternalOrder());
                }
                else if ("P".equalsIgnoreCase(prRequest.getAccAsmt()) || "Q".equalsIgnoreCase(prRequest.getAccAsmt())) {
                    accTab.setValue("WBS_ELEMENT", item.getWbsElement());
                }
                else if("N".equalsIgnoreCase(prRequest.getAccAsmt()))
                {
                    accTab.setValue("NETWORK", item.getNetwork());
                }
                else if("K".equalsIgnoreCase(prRequest.getAccAsmt()))
                {
                    accTab.setValue("COSTCENTER", item.getCostCenter());
                }
                else
                {
                    accTab.setValue("WBS_ELEMENT", item.getWbsElement());
                }

                accTabX.appendRow();
                accTabX.setValue("PREQ_ITEM", itemNumber);
                accTabX.setValue("SERIAL_NO","01");
                accTabX.setValue("PREQ_ITEMX","X");
                accTabX.setValue("SERIAL_NOX","X");
                // accTabX.setValue("GL_ACCOUNT","X");
                if ("F".equalsIgnoreCase(prRequest.getAccAsmt())) {

                    accTabX.setValue("ORDERID","X");
                }
                else if ("P".equalsIgnoreCase(prRequest.getAccAsmt()) || "Q".equalsIgnoreCase(prRequest.getAccAsmt())) {

                    accTabX.setValue("WBS_ELEMENT", "X");
                }
                else if ("N".equalsIgnoreCase(prRequest.getAccAsmt())) {

                    accTabX.setValue("NETWORK","X");
                }
                else if("K".equalsIgnoreCase(prRequest.getAccAsmt()))
                {
                    accTabX.setValue("COSTCENTER", "X");
                }
                else {
                    accTabX.setValue("WBS_ELEMENT", "X");
                }


                String valuePart1=itemNumber+item.getDivision()+item.getDepartment()+" "+loggedUser;
                System.out.println("valuePart1: " + valuePart1);
                extTab.appendRow();
                extTab.setValue("STRUCTURE","BAPI_TE_MEREQITEM");
                extTab.setValue("VALUEPART1",valuePart1);

                extTab.appendRow();
                extTab.setValue("STRUCTURE","BAPI_TE_MEREQITEMX");
                extTab.setValue("VALUEPART1","00001XX X");

                String packSize=item.getPackSize();
                packSize=String.format("%10s", packSize).replace(' ', '0');
                System.out.println("packSize: " + packSize);
                addTab.appendRow();
                addTab.setValue("PREQ_ITEM",itemNumber);
                addTab.setValue("ZZBU",item.getDivision());
                addTab.setValue("ZZDEPT",item.getDepartment());
                addTab.setValue("ZZPACK",packSize);
                addTab.setValue("ZZCOA",item.getCoa());
                addTab.setValue("ZZMSDS",item.getMsds());
                addTab.setValue("ZZUSER",loggedUser);
                addTab.setValue("ZZREASON",item.getReason());
                addTab.setValue("ZZPASS",item.getPassThrough());

                addTabX.appendRow();
                addTabX.setValue("PREQ_ITEM",itemNumber);
                addTabX.setValue("ZZBU","X");
                addTabX.setValue("ZZDEPT","X");
                addTabX.setValue("ZZPACK","X");
                addTabX.setValue("ZZCOA","X");
                addTabX.setValue("ZZMSDS","X");
                addTabX.setValue("ZZUSER","X");
                addTabX.setValue("ZZREASON","X");
                addTabX.setValue("ZZPASS","X");


                prItems.add(item);
                counter++;
            }

            JCoContext.begin(destination);
            poFunction.execute(destination);
            //commitFunction.execute(destination);
            JCoContext.end(destination);

            String sapPrNum = poFunction.getExportParameterList().getString("NUMBER");
            JCoTable returnTable = poFunction.getTableParameterList().getTable("RETURN");
            List<String> errorMessages = new ArrayList<>();
            List<String> successMessages = new ArrayList<>();
            for (int i = 0; i < returnTable.getNumRows(); i++) {
                returnTable.setRow(i);
                String type = returnTable.getString("TYPE");   // E, S, W
                String message = returnTable.getString("MESSAGE");

                if ("E".equals(type)) {          // Error
                    errorMessages.add(message);
                } else if ("S".equals(type)) {   // Success
                    successMessages.add(message);
                }
            }
            if (!errorMessages.isEmpty())
            {
                response.put("status", "ERROR");
                response.put("sapPrNumber", sapPrNum);
                response.put("message", errorMessages);
            } else {
                response.put("status", "success");
                response.put("sapPrNumber", sapPrNum);
                response.put("message", successMessages);
            }

            if (sapPrNum != null && !sapPrNum.contains("#"))
            {
                List<EzPurchaseRequisitionItems> prItemList=new ArrayList<>();

                // Build header entity
                EzPurchaseRequisitionHeader headerDt = new EzPurchaseRequisitionHeader();
                headerDt.setReqNumber(sapPrNum);
                headerDt.setDocType(prRequest.getDocType());
                headerDt.setDivision(prRequest.getDivision());
                headerDt.setPlant(prRequest.getPlant());
                headerDt.setAccAsmt(prRequest.getAccAsmt());
                headerDt.setItemCat(prRequest.getItemCateg()); // some DTOs may name differently
                headerDt.setPurGrp(prRequest.getPurGrp());
                headerDt.setDept(prRequest.getDepartment());
                // headerDt.setHeaderText(prRequest.getHeaderText());
                headerDt.setCreatedBy(loggedUser);
                headerDt.setCreatedOn(LocalDateTime.now());
                headerDt.setStatus("UNRELEASED");
                counter=1;
                for (PRItem itemDto : prRequest.getItems())
                {
                    int sapItemNumber = counter * 10;
                    String itemNumber = String.format("%02d", sapItemNumber);
                    String sapitemNumber = String.format("%05d", sapItemNumber);
                    EzPurchaseRequisitionItems itemEntity = new EzPurchaseRequisitionItems();

                    // Map commonly used fields - extend mapping if your entity has more fields
                    //    itemEntity.setReqNo(sapPrNum);
                    itemEntity.setMatNumber(itemDto.getMatNumber());
                    // if PRItem has an itemNumber field use that, else we can auto-generate or leave null
                    itemEntity.setItemNO(itemNumber);
                    itemEntity.setSapPrNo(sapPrNum);
                    itemEntity.setSapPrItemNo(sapitemNumber);
                    itemEntity.setShortText(itemDto.getShortText());
                    //  itemEntity.setItemCat(itemDto.getItemCat());
                    itemEntity.setPlant(itemDto.getPlant());
                    itemEntity.setStorageLoc(itemDto.getStorageLoc());
                    itemEntity.setPurchaseGroup(itemDto.getPurGrp());
                    itemEntity.setMaterialGroup(itemDto.getMaterialGroup());
                    itemEntity.setQuantity(itemDto.getQuantity() != null? itemDto.getQuantity(): BigDecimal.ZERO);
                    itemEntity.setValPrice(itemDto.getValPrice() != null ? itemDto.getValPrice():BigDecimal.ZERO);
                    itemEntity.setUom(itemDto.getUom());
                    itemEntity.setAccAssignCat(prRequest.getAccAsmt());
                    if ("F".equalsIgnoreCase(prRequest.getAccAsmt())) {

                        itemEntity.setWbsElement(itemDto.getInternalOrder());
                    }
                    else if ("P".equalsIgnoreCase(prRequest.getAccAsmt()) || "Q".equalsIgnoreCase(prRequest.getAccAsmt())) {

                        itemEntity.setWbsElement(itemDto.getWbsElement());
                    }
                    else if("N".equalsIgnoreCase(prRequest.getAccAsmt()))
                    {
                        itemEntity.setNetwork(itemDto.getNetwork());
                    }
                    else
                    {
                        itemEntity.setWbsElement(itemDto.getWbsElement());
                    }
                    // itemEntity.setWbsElement(itemDto.getWbsElement()); // maps to EPRI_WBS_ELEMENT
                    itemEntity.setCas(itemDto.getCas() != null ? itemDto.getCas() : itemDto.getCas());
                    //  itemEntity.setVendor(itemDto.getVendor());
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    Date deliveryDt = sdf.parse(itemDto.getDeliveryDate());
                    System.out.print("deliveryDt"+deliveryDt);
                    itemEntity.setDeliveryDate(deliveryDt);
                    itemEntity.setTrackNo(itemDto.getTrackNo() != null ? itemDto.getTrackNo() : itemDto.getTrackNo());
                    itemEntity.setPackSize(itemDto.getPackSize());
                    itemEntity.setCoa(itemDto.getCoa());
                    itemEntity.setPassThrough(itemDto.getPassThrough());
                    itemEntity.setMsds(itemDto.getMsds());
                    itemEntity.setReason(itemDto.getReason());
                    if("ZOSO".equals(docType))
                    {
                        String aggrement = checkNull((String) itemDto.getAgreement());
                        if (!"".equals(aggrement))
                            aggrement = aggrement.split("#")[0];
                        itemEntity.setAgreement(aggrement);
                        itemEntity.setAggrItem(itemDto.getAggrItem());
                        itemEntity.setFixVendor(itemDto.getFixVendor());
                    }
                    // set default statuses if present in your entity
                    // itemEntity.setEpriStatus("CREATED");

                    itemEntity.setHeader(headerDt);
                    prItemList.add(itemEntity);

                    headerDt.getItems().removeIf(item -> item == null || item.getSapPrItemNo() == null);
                    counter++;
                } // end for prItems
                System.out.println("prItemList " + prItemList.size());
                headerDt.setItems(prItemList);
                System.out.println("Header items size: " + headerDt.getItems().size());


                headerRepo.save(headerDt);
                mailService.sendPRCreationMail(headerDt);


            }

        } catch (JCoException e) {
            System.out.println("Error connecting to SAP: " + e.getMessage());
            e.printStackTrace();
        }
        catch (Exception e) {
            response.put("status", "error");
            response.put("message", e.getMessage());
        }



        return ResponseEntity.ok(response);

    }

    @GetMapping("prCreate/list")
    public String showList(@RequestParam(required = false) String status,
                           @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date fromDate,
                           @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date toDate,
                           Model model)
    {
        System.out.print("in prCreate/List status"+status);
        String loggedUser="";
        List<EzcMasterData> docTypeList = masterRepo.findByEmdKey("DOCTYPE");
        try {
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            Users userObj = (Users) authentication.getPrincipal();
            loggedUser = (String) userObj.getUserId();

        }catch (Exception e){}
        if (fromDate == null || toDate == null) {
            Calendar cal = Calendar.getInstance();
            // Set toDate to today
            toDate = cal.getTime();
            // Set fromDate to 6 months back
            cal.add(Calendar.MONTH, -6);
            fromDate = cal.getTime();
        }
        System.out.print("loggedUser"+loggedUser);
        LocalDateTime from = null;
        LocalDateTime to = null;

        if (fromDate != null) {
            from = fromDate.toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime();
        }
        if (toDate != null) {
            to = toDate.toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime();
        }
        if("U".equals(status))status="UNRELEASED";
        else if("P".equals(status))status="PENDING";
        else if("R".equals(status))status="RELEASED";

        List<EzPurchaseRequisitionHeader> headers = headerService.getFilteredHeaders(from, to, status, loggedUser);
        System.out.print("headers in Prcreate List"+headers.size()+"from"+from+"to"+to+"END"+"status"+status);

        model.addAttribute("docTypes",docTypeList);
        model.addAttribute("headers",headers);
        model.addAttribute("fromDate", fromDate);
        model.addAttribute("toDate", toDate);
        return "prCreation/prList";
    }



    @GetMapping("/prCreate/list/filter")
    public String filterPRItems(
            @RequestParam(required = false) String docType,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date fromDate,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date toDate,
            Model model)
    {
        System.out.print("in filterPRItems - docType: " + docType);
        String loggedUser = "";
        List<EzcMasterData> docTypeList = masterRepo.findByEmdKey("DOCTYPE");

        try {
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            Users userObj = (Users) authentication.getPrincipal();
            loggedUser = (String) userObj.getUserId();
        } catch (Exception e) {}

        if (fromDate == null || toDate == null) {
            Calendar cal = Calendar.getInstance();
            // Set toDate to today
            toDate = cal.getTime();
            // Set fromDate to 6 months back
            cal.add(Calendar.MONTH, -6);
            fromDate = cal.getTime();
        }

        System.out.print("loggedUser: " + loggedUser);
        LocalDateTime from = null;
        LocalDateTime to = null;

        if (fromDate != null) {
            from = fromDate.toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime();
        }
        if (toDate != null) {
            to = toDate.toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime();
        }

        List<EzPurchaseRequisitionHeader> headers = headerService.getFilteredHeadersByDocType(from, to, docType, loggedUser);
        System.out.print("headers in filterPRItems: " + headers.size() + " from: " + from + " to: " + to + " docType: " + docType);

        model.addAttribute("docTypes", docTypeList);
        model.addAttribute("headers", headers);
        model.addAttribute("fromDate", fromDate);
        model.addAttribute("toDate", toDate);
        model.addAttribute("selectedDocType", docType);

        return "prCreation/prList";
    }
    @GetMapping("prCreate/addService")
    public String showCreateServicePage(Model model)
    {
        String loggedUser = "";
        String documentType="";
        List<String> docTypesList=new ArrayList<String>();
        try {
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            Users userObj = (Users)authentication.getPrincipal();
            loggedUser=(String)userObj.getUserId();
            Set<UserDefaults> defaults = userObj.getUserDefaults();
            if (defaults != null) {
                for (UserDefaults def : defaults)
                {
                    if ("DOCTYPE".equalsIgnoreCase(def.getKey())) {
                        documentType = def.getValue();
                        log.debug("User documentType: " + documentType);
                        break; // if only one documentType per user
                    }
                }
                if (documentType.contains("##"))
                {
                    String[] docTypeArr = documentType.split("##");


                    for (int i = 0; i < docTypeArr.length; i++) {
                        String currDocType = docTypeArr[i];
                        docTypesList.add(currDocType);
                        // Add additional logic here if you want to handle more than 2 plants
                    }
                }
                else {
                    docTypesList.add(documentType);
                }
            }

        } catch (Exception e) {

        }
        List<EzcMasterData> accAssgList = masterRepo.findByEmdKey("ACCASSG");
        List<EzcMasterData> plantList = masterRepo.findByEmdKey("PLANT");
        List<EzcMasterData> itemCategList = masterRepo.findByEmdKey("ITEMCATEG");
        List<EzcMasterData> docTypeList = masterRepo.findByEmdKey("DOCTYPE");
        List<EzcMasterData> divisionList = masterRepo.findByEmdKey("DIVISION");
        List<EzcMasterData> purchaseGroupList = masterRepo.findByEmdKey("PURGRP");
        List<EzcMasterData> storLocList = masterRepo.findByEmdKey("STRGLOC");
        List<EzcMasterData> servCodeList = masterRepo.findByEmdKey("SERVICECD");
        List<EzcMasterData> matGrpList = masterRepo.findByEmdKey("MATGRP");

        // List<MaterialDto> serviceCodes = getServiceCode();
        System.out.print("serviceCodes"+servCodeList);
        divisionList = divisionList != null ? divisionList : new ArrayList<>();
        purchaseGroupList = purchaseGroupList != null ? purchaseGroupList : new ArrayList<>();
        model.addAttribute("divisions", divisionList);
        model.addAttribute("purchaseGroups", purchaseGroupList);
        model.addAttribute("docTypes",docTypeList);
        model.addAttribute("plants",plantList);
        model.addAttribute("accAssgs",accAssgList);
        model.addAttribute("itemCategs",itemCategList);
        model.addAttribute("storgLocs",storLocList);
        model.addAttribute("serviceCodes",servCodeList);
        model.addAttribute("matGrpList",matGrpList);
        model.addAttribute("prForm", new EzPurchaseRequisitionHeader());

        return "prCreation/createServicePR";
    }
    @PostMapping("prCreate/edit")
    public String editPR(@RequestParam("reqNumber") String reqNumber, Model model) {

        System.out.print("reqNumber"+reqNumber);
        List<EzPurchaseRequisitionHeader> headers = headerService.findByReqNumberWithItems(reqNumber);
        //EzPurchaseRequisitionHeader header = headers.get(0);

        EzPurchaseRequisitionHeader header = new EzPurchaseRequisitionHeader();
        if (header == null) {
            model.addAttribute("error", "PR not found for number: " + reqNumber);
            return "errorPage"; // optional error page
        }

        List<EzcMasterData> accAssgList = Optional.ofNullable(masterRepo.findByEmdKey("ACCASSG")).orElse(new ArrayList<>());
        List<EzcMasterData> plantList = Optional.ofNullable(masterRepo.findByEmdKey("PLANT")).orElse(new ArrayList<>());
        List<EzcMasterData> itemCategList = Optional.ofNullable(masterRepo.findByEmdKey("ITEMCATEG")).orElse(new ArrayList<>());
        List<EzcMasterData> docTypeList = Optional.ofNullable(masterRepo.findByEmdKey("DOCTYPE")).orElse(new ArrayList<>());
        List<EzcMasterData> divisionList = Optional.ofNullable(masterRepo.findByEmdKey("DIVISION")).orElse(new ArrayList<>());
        List<EzcMasterData> purchaseGroupList = Optional.ofNullable(masterRepo.findByEmdKey("PURGRP")).orElse(new ArrayList<>());
        List<EzcMasterData> storLocList = Optional.ofNullable(masterRepo.findByEmdKey("STRGLOC")).orElse(new ArrayList<>());

        divisionList = divisionList != null ? divisionList : new ArrayList<>();
        purchaseGroupList = purchaseGroupList != null ? purchaseGroupList : new ArrayList<>();

        try {

            List<MaterialDto> wbsElements =new ArrayList<>();// getWBSElements(plant, ""); // query can be blank
//            System.out.print("wbsElements"+wbsElements);
            model.addAttribute("wbsElements", wbsElements);
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("wbsElements", new ArrayList<>()); // fallback
        }


        for (EzPurchaseRequisitionItems item : header.getItems()) {
            if (item.getDeliveryDate() != null) {
                // Convert to yyyy-MM-dd string
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                String formattedDate = sdf.format(item.getDeliveryDate());

                // Override the date field with trimmed date
                // (optional but safe since browser will parse yyyy-MM-dd)
                try {
                    item.setDeliveryDate(sdf.parse(formattedDate));
                } catch (ParseException e) {
                    e.printStackTrace();
                }
            }
        }
        //***************SAP CALL *****************************
        try {
            JCoDestination destination = rfcReadSAPService.getDestination();
            JCoRepository repository = destination.getRepository();
            JCoFunction poFunction = repository.getFunction("ZEZ_BAPI_PR_GETDETAIL");

            if (poFunction == null) throw new RuntimeException("ZEZ_BAPI_PR_GETDETAIL not found");
            System.out.println("ZEZ_BAPI_PR_GETDETAIL started"+reqNumber);
            JCoParameterList imports = poFunction.getImportParameterList();
            imports.setValue("NUMBER", reqNumber);
            imports.setValue("ACCOUNT_ASSIGNMENT","X");

            try {
                JCoContext.begin(destination);
                poFunction.execute(destination);
                JCoContext.end(destination);
            }catch(Exception e){}

            JCoStructure headerRet = poFunction.getExportParameterList().getStructure("PRHEADER");

            JCoTable prItems   = poFunction.getTableParameterList().getTable("PRITEM");
            JCoTable prAcc   = poFunction.getTableParameterList().getTable("PRACCOUNT");
            JCoTable prAddData   = poFunction.getTableParameterList().getTable("ADDITIONAL_DATA");

            if (headerRet != null) {

                header.setReqNumber(reqNumber);
                header.setDocType(headerRet.getString("PR_TYPE"));

            }

            System.out.println("SAP ITESM SIZE"+prItems.getNumRows()+"docType"+headerRet.getString("PR_TYPE"));
            System.out.println("SAP prAcc SIZE"+prAcc.getNumRows()+"SAP prAddData SIZE"+prAddData.getNumRows());
            List<EzPurchaseRequisitionItems> sapItems = new ArrayList<>();

            for (int i = 0; i < prItems.getNumRows(); i++) {
                prItems.setRow(i);

                EzPurchaseRequisitionItems item = new EzPurchaseRequisitionItems();
                String itemNo = prItems.getString("PREQ_ITEM");

                /* -------- ITEM BASIC DATA -------- */
                item.setItemNO(itemNo);
                item.setMatNumber(prItems.getString("MATERIAL"));
                item.setShortText(prItems.getString("SHORT_TEXT"));
                item.setQuantity(prItems.getBigDecimal("QUANTITY"));
                item.setUom(prItems.getString("UNIT"));
                item.setValPrice(prItems.getBigDecimal("PREQ_PRICE"));
                //item.setTotal(prItems.getString("TARGET_VAL"));
                item.setMaterialGroup(prItems.getString("MATL_GROUP"));
                item.setDelInd(prItems.getString("DELETE_IND"));
                item.setRelStatus(prItems.getString("PROC_STAT"));
                System.out.println("aggrement"+prItems.getString("AGREEMENT")+"#"+prItems.getString("FIXED_VEND")+"#"+prItems.getString("AGMT_ITEM"));
                item.setAgreement(prItems.getString("AGREEMENT")+"#"+prItems.getString("FIXED_VEND")+"#"+prItems.getString("AGMT_ITEM"));
                item.setAggrItem(prItems.getString("AGMT_ITEM"));
                item.setFixVendor(prItems.getString("FIXED_VEND"));
                String delivStr = prItems.getString("DELIV_DATE");   // Example: "20250112"

                if (delivStr != null && !delivStr.isBlank()) {
                    try {
                        SimpleDateFormat sapFmt = new SimpleDateFormat("yyyy-MM-dd");
                        Date delivDate = sapFmt.parse(delivStr.trim());
                        item.setDeliveryDate(delivDate);
                    } catch (Exception e) {
                        System.out.println("❌ Failed to parse delivery date: " + delivStr);
                    }
                }
                //item.setDeliveryDate((java.util.Date)prItems.getString("DELIV_DATE"));
                item.setPlant(prItems.getString("PLANT"));
                // item.setPurGrp(prItems.getString("PUR_GROUP"));
                item.setStorageLoc(prItems.getString("STORE_LOC"));
                item.setTrackNo(prItems.getString("TRACKINGNO"));
                item.setItemCat(prItems.getString("ITEM_CAT"));

                prAcc.firstRow();
                for (int j = 0; j < prAcc.getNumRows(); j++, prAcc.nextRow()) {
                    if (prAcc.getString("PREQ_ITEM").equals(itemNo)) {
                        item.setWbsElement(prAcc.getString("WBS_ELEMENT"));
                        item.setCostCenter(prAcc.getString("COSTCENTER"));
                        item.setInternalOrder(prAcc.getString("ORDERID"));
                        // item.setGlAccount(prAcc.getString("G_L_ACCT"));
                        break;
                    }
                }
                prAddData.firstRow();
                for (int j = 0; j < prAddData.getNumRows(); j++, prAddData.nextRow()) {
                    if (prAddData.getString("PREQ_ITEM").equals(itemNo)) {
                        //item.set(prAddData.getString("ZZCASNR"));
                        item.setCoa(prAddData.getString("ZZCOA"));
                        item.setMsds(prAddData.getString("ZZMSDS"));
                        item.setPackSize(removeLeadingZeros(prAddData.getString("ZZPACK")));
                        item.setPassThrough(prAddData.getString("ZZPASS"));
                        if (header.getDept() == null || header.getDept().isEmpty())
                            header.setDept(prAddData.getString("ZZDEPT"));
                        if (header.getDivision() == null || header.getDivision().isEmpty())
                            header.setDivision(prAddData.getString("ZZBU"));


                        break;
                    }
                }

                if (header.getPurGrp() == null || header.getPurGrp().isEmpty())
                    header.setPurGrp(prItems.getString("PUR_GROUP"));

                if (header.getPlant() == null || header.getPlant().isEmpty())
                    header.setPlant(item.getPlant());

                if (header.getAccAsmt() == null || header.getAccAsmt().isEmpty())
                    header.setAccAsmt(prItems.getString("ACCTASSCAT"));

                if (header.getItemCat() == null || header.getItemCat().isEmpty())
                    header.setItemCat(prItems.getString("ITEM_CAT"));
                item.setHeader(header);

                sapItems.add(item);
            }
            System.out.print("SAP sapItems"+sapItems);
            if (!sapItems.isEmpty()) {
                header.setItems(sapItems);
            }

        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "SAP Error while reading PR: " + e.getMessage());
            return "errorPage";
        }

        System.out.print("SAP header"+header);
        String division = header.getDivision();
        String plant = header.getPlant();
        try {
            List<EzcMasterData> departments = getDepartments(division, plant);
            for(EzcMasterData dept : departments) {
                if(dept.getEmdValue1() != null && dept.getEmdValue1().contains("#")) {
                    dept.setEmdValue1(dept.getEmdValue1().split("#")[0]);
                }
            }

            model.addAttribute("departments", departments);
            //System.out.println("Departments loaded: " + (departments != null ? departments.size() : 0));
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("departments", new ArrayList<>());
        }
        model.addAttribute("divisions", divisionList);
        model.addAttribute("purchaseGroups", purchaseGroupList);
        model.addAttribute("docTypes",docTypeList);
        model.addAttribute("plants",plantList);
        model.addAttribute("accAssgs",accAssgList);
        model.addAttribute("itemCategs",itemCategList);
        model.addAttribute("storgLocs",storLocList);
        // model.addAttribute("headers", headers);

        model.addAttribute("prHeader", header);
        //model.addAttribute("prItems", header.getItems());



        // System.out.print("header"+header+"items"+header.getItems()+"divisionList"+divisionList+"header div"+header.getDivision());
//        divisionList.forEach(div ->
//                System.out.println("Division -> " + div.getEmdValue1() + " : " + div.getEmdValue2())
//        );
        return "prCreation/editPR"; // your edit page name
    }

    @PostMapping(value="prCreate/postServicePR")
    public ResponseEntity<Map<String, Object>> createServicePR(@RequestBody PRRequest prRequest)
    {


        Map<String, Object> response = new HashMap<>();
        try {
            System.out.println("IN::createServicePR:: TRY");
            JCoDestination destination = rfcReadSAPService.getDestination();
            JCoRepository repository = destination.getRepository();
            JCoFunction poFunction = repository.getFunction("ZBAPI_PR_CREATE");
            //JCoFunction commitFunction = repository.getFunction("BAPI_TRANSACTION_COMMIT");

            System.out.println("SAP Connection established successfully!");
            System.out.println("Connected User: " + destination.getUser());

            JCoParameterList imp = poFunction.getImportParameterList();
            JCoParameterList tab = poFunction.getTableParameterList();


            JCoStructure header = imp.getStructure("PRHEADER");
            JCoStructure headerX = imp.getStructure("PRHEADERX");

            String docType=prRequest.getDocType();
            System.out.println("docType"+docType);
            header.setValue("PR_TYPE", docType);
            headerX.setValue("PR_TYPE", "X");


            JCoTable itemTable = tab.getTable("PRITEM");
            JCoTable itemXTable = tab.getTable("PRITEMX");
            JCoTable accTab = tab.getTable("PRACCOUNT");
            JCoTable accTabX = tab.getTable("PRACCOUNTX");
            JCoTable extTab = tab.getTable("EXTENSIONIN");
            JCoTable addTab = tab.getTable("ADDITIONAL_DATA");
            JCoTable addTabX = tab.getTable("ADDITIONAL_DATAX");
            JCoTable PrServiceLines = tab.getTable("SERVICELINES");
            JCoTable PrServiceLinesX= tab.getTable("SERVICELINESX");
            JCoTable PrServiceAcc   = tab.getTable("SERVICEACCOUNT");
            JCoTable PrServiceAccX  = tab.getTable("SERVICEACCOUNTX");


            SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd");
            SimpleDateFormat sapFormat = new SimpleDateFormat("yyyyMMdd");
            List<PRItem> prItems=new ArrayList<>();
            List<PRService> prServs=new ArrayList<>();
            PRItem item1 =new PRItem();

            int counter = 1;
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            Users userObj = (Users)authentication.getPrincipal();
            String loggedUser=(String)userObj.getUserId();
            String prUserName="SARIEH A";
            prUserName=(String) userObj.getFirstName()+""+(String) userObj.getLastName();
            int indPos=0;
            String itemPckgNo="";
            for (PRItem item : prRequest.getItems()) {
                Date parsedDate = inputFormat.parse(item.getDeliveryDate());
                String formattedDate = sapFormat.format(parsedDate);
                int sapItemNumber = counter * 10;
                String itemNumber = String.format("%05d", sapItemNumber);  // creates 00001, 00002, etc.
                System.out.println("shortText" + item.getShortText());
                String matCode = item.getMatNumber();
                if (matCode != null) {
                    // Pad with leading zeros to make 18 digits
                    matCode = String.format("%18s", matCode).replace(' ', '0');
                } else {
                    matCode = "000000000000000000"; // fallback if null
                }
                itemTable.appendRow();
                itemTable.setValue("PREQ_ITEM", itemNumber);
                itemTable.setValue("PREQ_NAME", prUserName);
                System.out.println("itemNumber" + itemNumber + "prUserName" + prUserName);
                itemTable.setValue("SHORT_TEXT", item.getShortText());
                // itemTable.setValue("STORE_LOC", item.getStorageLoc());
                System.out.println("plant" + prRequest.getPlant());
                itemTable.setValue("PLANT", prRequest.getPlant());
                itemTable.setValue("QUANTITY", item.getQuantity());
                //  itemTable.setValue("MATERIAL", matCode);
                //System.out.println("getMatCode" + matCode);
                itemTable.setValue("MATL_GROUP", item.getMaterialGroup());
                itemTable.setValue("UNIT", "EA");
                itemTable.setValue("DELIV_DATE", formattedDate);
                System.out.println("formattedDate" + formattedDate);
                itemTable.setValue("PREQ_PRICE", item.getValPrice());
                itemTable.setValue("PERIOD_IND_EXPIRATION_DATE", "D");
                itemTable.setValue("ACCTASSCAT", prRequest.getAccAsmt());
                itemTable.setValue("ITEM_CAT", prRequest.getItemCateg());
                itemTable.setValue("PUR_GROUP", prRequest.getPurGrp());
                itemTable.setValue("TRACKINGNO", item.getTrackNo());
                System.out.println("getPurGrp" + prRequest.getPurGrp());
                //   itemTable.setValue("PREQ_NAME",item.getReqName());
                System.out.println("formatted Date " + item.getReqName());
                System.out.println("formatted Date " + itemTable.getValue("DELIV_DATE"));
                System.out.println("ACCTASSCAT" + prRequest.getAccAsmt());

                if (indPos == 0)
                {
                    itemPckgNo = "0000000000"+((indPos*2)+1);
                    itemPckgNo = itemPckgNo.substring(itemPckgNo.length()-10,itemPckgNo.length());

                    itemTable.setValue("PCKG_NO",itemPckgNo);
                }
                else
                {
                    itemPckgNo = "0000000000"+((indPos*2)+2);
                    itemPckgNo = itemPckgNo.substring(itemPckgNo.length()-10,itemPckgNo.length());

                    itemTable.setValue("PCKG_NO",itemPckgNo);
                }

                itemXTable.appendRow();
                itemXTable.setValue("PREQ_ITEM", itemNumber);
                itemXTable.setValue("PREQ_ITEMX", "X");
                itemXTable.setValue("PUR_GROUP", "X");
                itemXTable.setValue("PREQ_NAME", "X");
                itemXTable.setValue("MATERIAL", "X");
                itemXTable.setValue("MATL_GROUP", "X");
                itemXTable.setValue("SHORT_TEXT", "X");
                itemXTable.setValue("STORE_LOC", "X");
                itemXTable.setValue("PLANT", "X");
                itemXTable.setValue("QUANTITY", "X");
                itemXTable.setValue("UNIT", "X");
                itemXTable.setValue("DELIV_DATE", "X");
                itemXTable.setValue("PREQ_PRICE", "X");
                itemXTable.setValue("ACCTASSCAT", "X");
                itemXTable.setValue("ITEM_CAT", "X");
                itemXTable.setValue("TRACKINGNO", "X");
                itemXTable.setValue("VAL_TYPE", "X");
                itemXTable.setValue("PCKG_NO", "X");
                itemXTable.setValue("CURRENCY", "X");


                accTab.appendRow();
                accTab.setValue("PREQ_ITEM", itemNumber);
                accTab.setValue("SERIAL_NO", indPos+1);
                //  accTab.setValue("GL_ACCOUNT",item.getGlAcc());
                if ("F".equalsIgnoreCase(prRequest.getAccAsmt())) {
                    accTab.setValue("ORDERID", item.getInternalOrder());
                }
                else if ("P".equalsIgnoreCase(prRequest.getAccAsmt()) || "Q".equalsIgnoreCase(prRequest.getAccAsmt())) {
                    accTab.setValue("WBS_ELEMENT", item.getWbsElement());
                }
                else if("N".equalsIgnoreCase(prRequest.getAccAsmt()))
                {
                    accTab.setValue("NETWORK", item.getNetwork());
                }
                else if("K".equalsIgnoreCase(prRequest.getAccAsmt()))
                {
                    accTab.setValue("COSTCENTER", item.getCostCenter());
                }
                else
                {
                    accTab.setValue("WBS_ELEMENT", item.getWbsElement());
                }
                //accTab.setValue("WBS_ELEMENT", item.getWbsElement());

                accTabX.appendRow();
                accTabX.setValue("PREQ_ITEM", itemNumber);
                accTabX.setValue("SERIAL_NO", indPos+1);
                accTabX.setValue("PREQ_ITEMX", "X");
                accTabX.setValue("SERIAL_NOX", "X");
                // accTabX.setValue("GL_ACCOUNT","X");
                //accTabX.setValue("WBS_ELEMENT", "X");
                if ("F".equalsIgnoreCase(prRequest.getAccAsmt())) {

                    accTabX.setValue("ORDERID","X");
                }
                else if ("P".equalsIgnoreCase(prRequest.getAccAsmt()) || "Q".equalsIgnoreCase(prRequest.getAccAsmt())) {

                    accTabX.setValue("WBS_ELEMENT", "X");
                }
                else if ("N".equalsIgnoreCase(prRequest.getAccAsmt())) {

                    accTabX.setValue("NETWORK","X");
                }
                else if("K".equalsIgnoreCase(prRequest.getAccAsmt()))
                {
                    accTabX.setValue("COSTCENTER", "X");
                }
                else {
                    accTabX.setValue("WBS_ELEMENT", "X");
                }

                String valuePart1 = itemNumber + item.getDivision() + item.getDepartment() + " " + loggedUser;
                System.out.println("valuePart1: " + valuePart1);
                extTab.appendRow();
                extTab.setValue("STRUCTURE", "BAPI_TE_MEREQITEM");
                extTab.setValue("VALUEPART1", valuePart1);

                extTab.appendRow();
                extTab.setValue("STRUCTURE", "BAPI_TE_MEREQITEMX");
                extTab.setValue("VALUEPART1", "00001XX X");

                String packSize = item.getPackSize();
                packSize = String.format("%10s", packSize).replace(' ', '0');
                System.out.println("packSize: " + packSize);
                addTab.appendRow();
                addTab.setValue("PREQ_ITEM", itemNumber);
                addTab.setValue("ZZBU", item.getDivision());
                addTab.setValue("ZZDEPT", item.getDepartment());
                // addTab.setValue("ZZPACK", packSize);
                //addTab.setValue("ZZCOA", item.getCoa());
                //addTab.setValue("ZZMSDS", item.getMsds());
                addTab.setValue("ZZUSER", loggedUser);
                addTab.setValue("ZZPASS", item.getPassThrough());

                addTabX.appendRow();
                addTabX.setValue("PREQ_ITEM", itemNumber);
                addTabX.setValue("ZZBU", "X");
                addTabX.setValue("ZZDEPT", "X");
                // addTabX.setValue("ZZPACK", "X");
                //addTabX.setValue("ZZCOA", "X");
                // addTabX.setValue("ZZMSDS", "X");
                addTabX.setValue("ZZUSER", "X");
                addTabX.setValue("ZZPASS", "X");

                int r=0;
                for (PRService serv : item.getServices())
                {

                    String tempServiceNo ="", outLine ="", srvLine ="";
                    if(r==0)
                    {
                        outLine = "0000000000"+"1";
                    }
                    else
                    {
                        outLine = "0000000000";
                    }
                    int servItemNumber = (r+1) * 10;
                    outLine = outLine.substring(outLine.length()-10,outLine.length());

                    srvLine = "0000000000"+ servItemNumber;
                    srvLine = srvLine.substring(srvLine.length()-10,srvLine.length());

                    if("N/A".equals(serv.getServNo()))
                    {
                        tempServiceNo = " ";
                    }
                    else
                    {
                        tempServiceNo = serv.getServNo();
                    }
                    PrServiceLines.appendRow();
                    PrServiceLines.setValue("DOC_ITEM", itemNumber);
                    PrServiceLines.setValue("OUTLINE", outLine);
                    PrServiceLines.setValue("SRV_LINE", srvLine);
                    PrServiceLines.setValue("SERVICE", tempServiceNo);
                    PrServiceLines.setValue("SHORT_TEXT", serv.getServDesc());
                    PrServiceLines.setValue("QUANTITY", serv.getServQty());
                    PrServiceLines.setValue("UOM", serv.getServUnit());
                    PrServiceLines.setValue("GROSS_PRICE", serv.getServPrice());
                    PrServiceLines.setValue("CURRENCY", "INR");
                    PrServiceLines.setValue("NET_PRICE", serv.getServNetPrice());

                    PrServiceLinesX.appendRow();
                    PrServiceLinesX.setValue("DOC_ITEM", itemNumber);
                    PrServiceLinesX.setValue("OUTLINE", outLine);
                    PrServiceLinesX.setValue("SRV_LINE", srvLine);
                    PrServiceLinesX.setValue("SERVICE", "X");
                    PrServiceLinesX.setValue("SHORT_TEXT", "X");
                    PrServiceLinesX.setValue("QUANTITY", "X");
                    PrServiceLinesX.setValue("UOM", "X");
                    PrServiceLinesX.setValue("GROSS_PRICE", "X");
                    PrServiceLinesX.setValue("CURRENCY", "X");
                    PrServiceLinesX.setValue("NET_PRICE", "X");


                    PrServiceAcc.appendRow();
                    PrServiceAcc.setValue("DOC_ITEM", itemNumber);
                    PrServiceAcc.setValue("OUTLINE", outLine);
                    PrServiceAcc.setValue("SRV_LINE", srvLine);
                    PrServiceAcc.setValue("SERIAL_NO", indPos+1);
                    PrServiceAcc.setValue("SERIAL_NO_ITEM", indPos+1);
                    PrServiceAcc.setValue("QUANTITY", serv.getServQty());
                    PrServiceAcc.setValue("PERCENT", "100");
                    PrServiceAcc.setValue("NET_VALUE", serv.getServNetPrice());

                    PrServiceAccX.appendRow();
                    PrServiceAccX.setValue("DOC_ITEM", itemNumber);
                    PrServiceAccX.setValue("OUTLINE", outLine);
                    PrServiceAccX.setValue("SRV_LINE", srvLine);
                    PrServiceAccX.setValue("SERIAL_NO", "01");
                    PrServiceAccX.setValue("SERIAL_NO_ITEM", "X");
                    PrServiceAccX.setValue("QUANTITY", "X");
                    PrServiceAccX.setValue("PERCENT", "X");
                    PrServiceAccX.setValue("NET_VALUE", "X");

                    prServs.add(serv);
                    r++;
                }
                indPos=indPos+1;
                prItems.add(item);
                counter++;
            }
            try{
                JCoContext.begin(destination);
                poFunction.execute(destination);
                //commitFunction.execute(destination);
                JCoContext.end(destination);
            }catch(Exception e){}
            String sapPrNum = poFunction.getExportParameterList().getString("NUMBER");
            JCoTable returnTable = poFunction.getTableParameterList().getTable("RETURN");
            List<String> errorMessages = new ArrayList<>();
            List<String> successMessages = new ArrayList<>();
            for (int i = 0; i < returnTable.getNumRows(); i++) {
                returnTable.setRow(i);
                String type = returnTable.getString("TYPE");   // E, S, W
                String message = returnTable.getString("MESSAGE");

                if ("E".equals(type)) {          // Error
                    errorMessages.add(message);
                } else if ("S".equals(type)) {   // Success
                    successMessages.add(message);
                }
            }
            if (!errorMessages.isEmpty())
            {
                response.put("status", "ERROR");
                response.put("sapPrNumber", sapPrNum);
                response.put("message", errorMessages);
            } else {
                response.put("status", "success");
                response.put("sapPrNumber", sapPrNum);
                response.put("message", successMessages);
            }

            if (sapPrNum != null && !sapPrNum.contains("#"))
            {
                List<EzPurchaseRequisitionItems> prItemList=new ArrayList<>();

                // Build header entity
                EzPurchaseRequisitionHeader headerDt = new EzPurchaseRequisitionHeader();
                headerDt.setReqNumber(sapPrNum);
                headerDt.setDocType(prRequest.getDocType());
                headerDt.setDivision(prRequest.getDivision());
                headerDt.setPlant(prRequest.getPlant());
                headerDt.setAccAsmt(prRequest.getAccAsmt());
                headerDt.setItemCat(prRequest.getItemCateg()); // some DTOs may name differently
                headerDt.setPurGrp(prRequest.getPurGrp());
                headerDt.setDept(prRequest.getDepartment());
                // headerDt.setHeaderText(prRequest.getHeaderText());
                headerDt.setCreatedBy(loggedUser);
                headerDt.setCreatedOn(LocalDateTime.now());
                headerDt.setStatus("UNRELEASED");
                counter=1;
                for (PRItem itemDto : prRequest.getItems())
                {

                    int sapItemNumber = counter * 10;
                    String itemNumber = String.format("%02d", sapItemNumber);
                    String sapitemNumber = String.format("%05d", sapItemNumber);

                    EzPurchaseRequisitionItems itemEntity = new EzPurchaseRequisitionItems();

                    // Map commonly used fields - extend mapping if your entity has more fields
                    //    itemEntity.setReqNo(sapPrNum);
                    itemEntity.setMatNumber(itemDto.getMatNumber());
                    // if PRItem has an itemNumber field use that, else we can auto-generate or leave null
                    itemEntity.setItemNO(itemNumber);
                    itemEntity.setSapPrNo(sapPrNum);
                    itemEntity.setSapPrItemNo(sapitemNumber);
                    itemEntity.setShortText(itemDto.getShortText());
                    //  itemEntity.setItemCat(itemDto.getItemCat());
                    itemEntity.setPlant(itemDto.getPlant());
                    itemEntity.setStorageLoc(itemDto.getStorageLoc());
                    itemEntity.setPurchaseGroup(itemDto.getPurGrp());
                    itemEntity.setMaterialGroup(itemDto.getMaterialGroup());
                    itemEntity.setQuantity(itemDto.getQuantity() != null? itemDto.getQuantity(): BigDecimal.ZERO);
                    itemEntity.setValPrice(itemDto.getValPrice() != null ? itemDto.getValPrice():BigDecimal.ZERO);
                    itemEntity.setUom(itemDto.getUom());
                    itemEntity.setAccAssignCat(prRequest.getAccAsmt());
                    itemEntity.setWbsElement(itemDto.getWbsElement()); // maps to EPRI_WBS_ELEMENT
                    itemEntity.setCas(itemDto.getCas() != null ? itemDto.getCas() : itemDto.getCas());
                    //  itemEntity.setVendor(itemDto.getVendor());
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    Date deliveryDt = sdf.parse(itemDto.getDeliveryDate());
                    System.out.print("deliveryDt"+deliveryDt);
                    itemEntity.setDeliveryDate(deliveryDt);
                    itemEntity.setTrackNo(itemDto.getTrackNo() != null ? itemDto.getTrackNo() : itemDto.getTrackNo());
                    itemEntity.setPackSize(itemDto.getPackSize());
                    itemEntity.setCoa(itemDto.getCoa());
                    itemEntity.setPassThrough(itemDto.getPassThrough());
                    itemEntity.setMsds(itemDto.getMsds());
                    itemEntity.setHeader(headerDt);
                    // set default statuses if present in your entity
                    // itemEntity.setEpriStatus("CREATED");

                    List<EzPurchaseRequisitionServices>serviceList = new ArrayList<>();
                    //ADDDING SERVICES
                    if (itemDto.getServices() != null && !itemDto.getServices().isEmpty()) {
                        for (PRService serv : itemDto.getServices()) {
                            EzPurchaseRequisitionServices servEntity = new EzPurchaseRequisitionServices();
                            servEntity.setReqNumber(sapPrNum);
                            servEntity.setItemNo(itemNumber);
                            servEntity.setServLine(serv.getServLine());
                            servEntity.setServNo(serv.getServNo());
                            servEntity.setServDesc(serv.getServDesc());
                            servEntity.setServQty(safeBigDecimal(serv.getServQty()));
                            servEntity.setServUnit(serv.getServUnit());
                            servEntity.setServPrice(safeBigDecimal(serv.getServPrice()));
                            servEntity.setServNetPrice(safeBigDecimal(serv.getServNetPrice()));

                            servEntity.setItem(itemEntity);

                            serviceList.add(servEntity);


                        }
                    }
                    itemEntity.setServices(serviceList);
                    System.out.println("serviceList " + serviceList.size());
                    prItemList.add(itemEntity);

                    counter++;
                } // end for prItems
                System.out.println("prItemList " + prItemList.size());
                headerDt.setItems(prItemList);
                System.out.println("Header items size: " + headerDt.getItems().size());


                headerRepo.save(headerDt);


            }

        } catch (JCoException e) {
            System.out.println("Error connecting to SAP: " + e.getMessage());
            e.printStackTrace();
        }
        catch (Exception e) {
            response.put("status", "error");
            response.put("message", e.getMessage());
        }



        return ResponseEntity.ok(response);

    }


    @PostMapping( value = "/prCreate/update")
    public ResponseEntity<Map<String, Object>> updatePR(@RequestBody PRRequest prRequest) {

        System.out.println("Updating PR: " );

        String sapPrNum=prRequest.getReqNumber();
        Map<String, Object> response = new HashMap<>();
        try {
            System.out.println("IN::Updating:: TRY"+sapPrNum);
            JCoDestination destination = rfcReadSAPService.getDestination();
            JCoRepository repository = destination.getRepository();
            JCoFunction poFunction = repository.getFunction("ZBAPI_PR_CHANGE");


            System.out.println("poFunction ZBAPI_PR_CHANGE"+poFunction);
            System.out.println("Connected User: " + destination.getUser());

            JCoParameterList imp = poFunction.getImportParameterList();
            JCoParameterList tab = poFunction.getTableParameterList();


            JCoStructure header = imp.getStructure("PRHEADER");
            JCoStructure headerX = imp.getStructure("PRHEADERX");
            System.out.println("SAP PR Number set:1 " + sapPrNum);
            imp.setValue("NUMBER", sapPrNum);
            System.out.println("SAP PR Number set: 2" + sapPrNum);
            String docType=prRequest.getDocType();
            System.out.println("docType"+docType);
            header.setValue("PR_TYPE", docType);
            header.setValue("PREQ_NO", sapPrNum);
            headerX.setValue("PR_TYPE", "X");
            headerX.setValue("PREQ_NO", "X");


            JCoTable itemTable = tab.getTable("PRITEM");
            JCoTable itemXTable = tab.getTable("PRITEMX");
            JCoTable accTab = tab.getTable("PRACCOUNT");
            JCoTable accTabX = tab.getTable("PRACCOUNTX");
            JCoTable extTab = tab.getTable("EXTENSIONIN");
            JCoTable addTab = tab.getTable("ADDITIONAL_DATA");
            JCoTable addTabX = tab.getTable("ADDITIONAL_DATAX");



            SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd");
            SimpleDateFormat sapFormat = new SimpleDateFormat("yyyyMMdd");
            List<PRItem> prItems=new ArrayList<>();
            List<PRService> prServs=new ArrayList<>();
            PRItem item1 =new PRItem();
            int counter = 1;
            int indPos=0;
            String itemPckgNo="";
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            Users userObj = (Users)authentication.getPrincipal();
            String loggedUser=(String)userObj.getUserId();
            String prUserName="SARIEH A";
            prUserName=(String) userObj.getFirstName()+""+(String) userObj.getLastName();
            System.out.println("itemSize"+prRequest.getItems().size());
            for (PRItem item : prRequest.getItems()) {
                Date parsedDate = inputFormat.parse(item.getDeliveryDate());
                String formattedDate = sapFormat.format(parsedDate);
                int sapItemNumber = counter * 10;
                String itemNumber = String.format("%05d", sapItemNumber);  // creates 00001, 00002, etc.
                System.out.println("itemNumber" + itemNumber);
                String matCode = item.getMatNumber();
                if (matCode != null) {
                    // Pad with leading zeros to make 18 digits
                    matCode = String.format("%18s", matCode).replace(' ', '0');
                } else {
                    matCode = "000000000000000000"; // fallback if null
                }
                itemTable.appendRow();
                itemTable.setValue("PREQ_ITEM", itemNumber);
                itemTable.setValue("PREQ_NAME", prUserName);
                System.out.println("itemNumber" + itemNumber + "prUserName" + prUserName);
                itemTable.setValue("SHORT_TEXT", item.getShortText());
                itemTable.setValue("STORE_LOC", item.getStorageLoc());
                System.out.println("getStrgLoc" + item.getStorageLoc());
                System.out.println("getStrgLoc" + item.getStorageLoc() + "status" + item.getStatus());
                if ("D".equalsIgnoreCase(item.getStatus())) {
                    itemTable.setValue("DELETE_IND", "X");
                }
                itemTable.setValue("PLANT", item.getPlant());
                itemTable.setValue("QUANTITY", item.getQuantity());
                itemTable.setValue("MATERIAL", matCode);
                System.out.println("getMatCode" + matCode);
                itemTable.setValue("MATL_GROUP", item.getMaterialGroup());
                itemTable.setValue("UNIT", item.getUom());
                itemTable.setValue("DELIV_DATE", formattedDate);
                System.out.println("formattedDate" + formattedDate);
                itemTable.setValue("PREQ_PRICE", safeDecimal(item.getValPrice()));
                itemTable.setValue("PERIOD_IND_EXPIRATION_DATE", "D");
                itemTable.setValue("ACCTASSCAT", prRequest.getAccAsmt());
                itemTable.setValue("ITEM_CAT", prRequest.getItemCateg());
                itemTable.setValue("PUR_GROUP", item.getPurGrp());
                itemTable.setValue("TRACKINGNO", item.getTrackNo());
                System.out.println("getPurGrp" + item.getPurGrp());
                //itemTable.setValue("PREQ_NAME",item.getReqName());
                System.out.println("formatted Date " + item.getReqName());
                System.out.println("formatted Date " + itemTable.getValue("DELIV_DATE"));
                System.out.println("ACCTASSCAT" + prRequest.getAccAsmt());

                itemXTable.appendRow();
                itemXTable.setValue("PREQ_ITEM", itemNumber);
                itemXTable.setValue("PREQ_ITEMX", "X");
                if ("D".equalsIgnoreCase(item.getStatus())) {
                    itemXTable.setValue("DELETE_IND", "X");
                }
                itemXTable.setValue("PUR_GROUP", "X");
                itemXTable.setValue("PREQ_NAME", "X");
                itemXTable.setValue("MATERIAL", "X");
                itemXTable.setValue("MATL_GROUP", "X");
                itemXTable.setValue("SHORT_TEXT", "X");
                itemXTable.setValue("STORE_LOC", "X");
                itemXTable.setValue("PLANT", "X");
                itemXTable.setValue("QUANTITY", "X");
                itemXTable.setValue("UNIT", "X");
                itemXTable.setValue("DELIV_DATE", "X");
                itemXTable.setValue("PREQ_PRICE", "X");
                itemXTable.setValue("ACCTASSCAT", "X");
                itemXTable.setValue("ITEM_CAT", "X");
                itemXTable.setValue("TRACKINGNO", "X");
                itemXTable.setValue("VAL_TYPE", "X");
                itemXTable.setValue("CURRENCY", "X");


                accTab.appendRow();
                accTab.setValue("PREQ_ITEM", itemNumber);
                //accTab.setValue("SERIAL_NO", "01");
                accTab.setValue("SERIAL_NO", indPos+1);
                //  accTab.setValue("GL_ACCOUNT",item.getGlAcc());
                accTab.setValue("WBS_ELEMENT", item.getWbsElement());

                accTabX.appendRow();
                accTabX.setValue("PREQ_ITEM", itemNumber);
                //accTabX.setValue("SERIAL_NO", "01");
                accTab.setValue("SERIAL_NO", indPos+1);
                accTabX.setValue("PREQ_ITEMX", "X");
                accTabX.setValue("SERIAL_NOX", "X");
                // accTabX.setValue("GL_ACCOUNT","X");
                accTabX.setValue("WBS_ELEMENT", "X");

                String valuePart1 = itemNumber + item.getDivision() + item.getDepartment() + " " + loggedUser;
                System.out.println("valuePart1: " + valuePart1);
                extTab.appendRow();
                extTab.setValue("STRUCTURE", "BAPI_TE_MEREQITEM");
                extTab.setValue("VALUEPART1", valuePart1);

                extTab.appendRow();
                extTab.setValue("STRUCTURE", "BAPI_TE_MEREQITEMX");
                extTab.setValue("VALUEPART1", "00001XX X");

                String packSize = item.getPackSize();
                packSize = String.format("%10s", packSize).replace(' ', '0');
                System.out.println("packSize: " + packSize);
                addTab.appendRow();
                addTab.setValue("PREQ_ITEM", itemNumber);
                addTab.setValue("ZZBU", item.getDivision());
                addTab.setValue("ZZDEPT", item.getDepartment());
                addTab.setValue("ZZPACK", packSize);
                addTab.setValue("ZZCOA", item.getCoa());
                addTab.setValue("ZZMSDS", item.getMsds());
                addTab.setValue("ZZUSER", loggedUser);
                addTab.setValue("ZZPASS", item.getPassThrough());

                System.out.println("AFTER ADDTAB: ");

                addTabX.appendRow();
                addTabX.setValue("PREQ_ITEM", itemNumber);
                addTabX.setValue("ZZBU", "X");
                addTabX.setValue("ZZDEPT", "X");
                addTabX.setValue("ZZPACK", "X");
                addTabX.setValue("ZZCOA", "X");
                addTabX.setValue("ZZMSDS", "X");
                addTabX.setValue("ZZUSER", "X");
                addTabX.setValue("ZZPASS", "X");
                System.out.println("AFTER ADDTABX: ");

                indPos=indPos+1;

                prItems.add(item);
                counter++;
            }
            try{
                JCoContext.begin(destination);
                poFunction.execute(destination);
                //commitFunction.execute(destination);
                JCoContext.end(destination);
            }catch(Exception e){}

            //   String sapPrNum = poFunction.getExportParameterList().getString("NUMBER");
            JCoTable returnTable = poFunction.getTableParameterList().getTable("RETURN");
            List<String> errorMessages = new ArrayList<>();
            List<String> successMessages = new ArrayList<>();
            for (int i = 0; i < returnTable.getNumRows(); i++) {
                returnTable.setRow(i);
                String type = returnTable.getString("TYPE");   // E, S, W
                String message = returnTable.getString("MESSAGE");

                if ("E".equals(type)) {          // Error
                    errorMessages.add(message);
                } else if ("S".equals(type)) {   // Success
                    successMessages.add(message);
                }
            }
            if (!errorMessages.isEmpty())
            {
                response.put("status", "ERROR");
                response.put("sapPrNumber", sapPrNum);
                response.put("message", errorMessages);
            } else {
                response.put("status", "success");
                response.put("sapPrNumber", sapPrNum);
                response.put("message", successMessages);
            }

            if (sapPrNum != null && !sapPrNum.contains("#"))
            {
                List<EzPurchaseRequisitionHeader> headerList = headerRepo.findByReqNumber(sapPrNum);

                EzPurchaseRequisitionHeader headerDt;
                if (headerList != null && !headerList.isEmpty()) {
                    headerDt = headerList.get(0); // assuming PR number is unique

                    // Update header-level fields
                    headerDt.setDocType(prRequest.getDocType());
                    headerDt.setDivision(prRequest.getDivision());
                    headerDt.setPlant(prRequest.getPlant());
                    headerDt.setAccAsmt(prRequest.getAccAsmt());
                    headerDt.setItemCat(prRequest.getItemCateg());
                    headerDt.setPurGrp(prRequest.getPurGrp());
                    headerDt.setDept(prRequest.getDepartment());
                    headerDt.setModifiedBy(loggedUser);
                    headerDt.setModifiedOn(LocalDateTime.now());
                } else {
                    // If not found, create new header
                    headerDt = new EzPurchaseRequisitionHeader();
                    headerDt.setReqNumber(sapPrNum);
                    headerDt.setDocType(prRequest.getDocType());
                    headerDt.setDivision(prRequest.getDivision());
                    headerDt.setPlant(prRequest.getPlant());
                    headerDt.setAccAsmt(prRequest.getAccAsmt());
                    headerDt.setItemCat(prRequest.getItemCateg());
                    headerDt.setPurGrp(prRequest.getPurGrp());
                    headerDt.setDept(prRequest.getDepartment());
                    headerDt.setCreatedBy(loggedUser);
                    headerDt.setCreatedOn(LocalDateTime.now());
                    headerDt.setStatus("UNRELEASED");
                }

                List<EzPurchaseRequisitionItems> existingItems = headerDt.getItems();
                Map<String, EzPurchaseRequisitionItems> existingItemMap = new HashMap<>();

                if (existingItems != null) {
                    for (EzPurchaseRequisitionItems item : existingItems) {
                        existingItemMap.put(item.getSapPrItemNo(), item);
                    }
                } else {
                    existingItems = new ArrayList<>();
                }

                counter = 1;
                for (PRItem itemDto : prRequest.getItems())
                {
                    int sapItemNumber = counter * 10;

                    String sapitemNumber = String.format("%05d", sapItemNumber);
                    String itemNumber = String.format("%02d", sapItemNumber);


                    EzPurchaseRequisitionItems itemEntity = existingItemMap.getOrDefault(sapitemNumber, new EzPurchaseRequisitionItems());

                    // Always keep header relationship intact
                    itemEntity.setHeader(headerDt);
                    itemEntity.setSapPrNo(sapPrNum);
                    itemEntity.setSapPrItemNo(sapitemNumber);

                    // Update mutable fields
                    itemEntity.setShortText(itemDto.getShortText());
                    itemEntity.setMatNumber(itemDto.getMatNumber());
                    itemEntity.setItemNO(itemNumber);
                    itemEntity.setPlant(itemDto.getPlant());
                    itemEntity.setStorageLoc(itemDto.getStorageLoc());
                    itemEntity.setPurchaseGroup(itemDto.getPurGrp());
                    itemEntity.setMaterialGroup(itemDto.getMaterialGroup());
                    itemEntity.setQuantity(safeDecimal(itemDto.getQuantity()));
                    itemEntity.setValPrice(safeDecimal(itemDto.getValPrice()));
                    itemEntity.setQuantity(itemDto.getQuantity() != null ? itemDto.getQuantity() : BigDecimal.ZERO);
                    itemEntity.setValPrice(itemDto.getValPrice() != null ? itemDto.getValPrice() : BigDecimal.ZERO);
                    itemEntity.setUom(itemDto.getUom());
                    itemEntity.setAccAssignCat(prRequest.getAccAsmt());
                    itemEntity.setWbsElement(itemDto.getWbsElement());
                    itemEntity.setCas(itemDto.getCas());
                    itemEntity.setTrackNo(itemDto.getTrackNo());
                    itemEntity.setPackSize(itemDto.getPackSize());
                    itemEntity.setCoa(itemDto.getCoa());
                    itemEntity.setPassThrough(itemDto.getPassThrough());
                    itemEntity.setMsds(itemDto.getMsds());

                    // Convert date safely
                    if (itemDto.getDeliveryDate() != null && !itemDto.getDeliveryDate().isEmpty()) {
                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                        Date deliveryDt = sdf.parse(itemDto.getDeliveryDate());
                        itemEntity.setDeliveryDate(deliveryDt);
                    }

                    // Preserve status if already present
                    if (itemDto.getStatus() == null) { itemEntity.setStatus("UPDATED"); }
                    else if("D".equalsIgnoreCase(itemDto.getStatus()))
                    { itemEntity.setStatus("DELETED"); }
                    else
                    { itemEntity.setStatus("UPDATED");}

                    // If this was a new item, add it to the list
                    if (!existingItemMap.containsKey(sapitemNumber)) {
                        existingItems.add(itemEntity);
                    }

                    counter++;
                }

                headerDt.setItems(existingItems);
                headerRepo.save(headerDt);

            }

        } catch (JCoException e) {
            System.out.println("Error connecting to SAP: " + e.getMessage());
            e.printStackTrace();
        }
        catch (Exception e) {
            response.put("status", "error");
            response.put("message", e.getMessage());
        }



        return ResponseEntity.ok(response);

        //  headerService.saveOrUpdate(prForm);

    }
    @PostMapping("/sendReminder/{prId}")
    public ResponseEntity<String> sendPRReminder(@PathVariable String prId) {

        System.out.println("Reminder mail triggered for PR ID: " + prId);
        return ResponseEntity.ok("Reminder mail sent successfully for PR ID: " + prId);
    }



    @Transactional
    @PostMapping("prServiceLine/edit")
    public String editServicePR(@RequestParam("reqNumber") String reqNumber, Model model) {
        log.debug("==========editServicePR=============================="+reqNumber);

        System.out.println("reqNumber: " + reqNumber);
        List<EzPurchaseRequisitionHeader> headers = headerService.findByReqNumberWithItems(reqNumber);
        //  EzPurchaseRequisitionHeader header = headers.get(0);
        EzPurchaseRequisitionHeader header = new EzPurchaseRequisitionHeader();



        // Load master data for dropdowns
        List<EzcMasterData> accAssgList = Optional.ofNullable(masterRepo.findByEmdKey("ACCASSG")).orElse(new ArrayList<>());
        List<EzcMasterData> plantList = Optional.ofNullable(masterRepo.findByEmdKey("PLANT")).orElse(new ArrayList<>());
        List<EzcMasterData> itemCategList = Optional.ofNullable(masterRepo.findByEmdKey("ITEMCATEG")).orElse(new ArrayList<>());
        List<EzcMasterData> docTypeList = Optional.ofNullable(masterRepo.findByEmdKey("DOCTYPE")).orElse(new ArrayList<>());
        List<EzcMasterData> divisionList = Optional.ofNullable(masterRepo.findByEmdKey("DIVISION")).orElse(new ArrayList<>());
        List<EzcMasterData> purchaseGroupList = Optional.ofNullable(masterRepo.findByEmdKey("PURGRP")).orElse(new ArrayList<>());
        List<EzcMasterData> storLocList = Optional.ofNullable(masterRepo.findByEmdKey("STRGLOC")).orElse(new ArrayList<>());
        List<EzcMasterData> serviceCodes = Optional.ofNullable(masterRepo.findByEmdKey("SERVICECD")).orElse(new ArrayList<>());
        List<EzcMasterData> matGrpList = Optional.ofNullable(masterRepo.findByEmdKey("MATGRP")).orElse(new ArrayList<>());

        divisionList = divisionList != null ? divisionList : new ArrayList<>();
        purchaseGroupList = purchaseGroupList != null ? purchaseGroupList : new ArrayList<>();

        //  String plant = header.getPlant();
        try {
            List<MaterialDto> wbsElements = new ArrayList<>(); // getWBSElements(plant, "");
            model.addAttribute("wbsElements", wbsElements);
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("wbsElements", new ArrayList<>());
        }

        //  String division = header.getDivision();


        //***************SAP CALL FOR SERVICE PR*****************************
        try {
            JCoDestination destination = rfcReadSAPService.getDestination();
            JCoRepository repository = destination.getRepository();
            JCoFunction poFunction = repository.getFunction("ZEZ_BAPI_PR_GETDETAIL");

            if (poFunction == null) throw new RuntimeException("ZEZ_BAPI_PR_GETDETAIL not found");

            JCoParameterList imports = poFunction.getImportParameterList();
            imports.setValue("NUMBER", reqNumber);
            imports.setValue("ACCOUNT_ASSIGNMENT", "X");
            imports.setValue("SERVICES", "X");

            try {
                JCoContext.begin(destination);
                poFunction.execute(destination);
                JCoContext.end(destination);
            } catch (Exception e) {}

            JCoStructure headerRet = poFunction.getExportParameterList().getStructure("PRHEADER");
            JCoTable prItems = poFunction.getTableParameterList().getTable("PRITEM");
            JCoTable prAcc = poFunction.getTableParameterList().getTable("PRACCOUNT");
            JCoTable prAddData   = poFunction.getTableParameterList().getTable("ADDITIONAL_DATA");
            JCoTable prServiceLines = poFunction.getTableParameterList().getTable("SERVICELINES");

            if (headerRet != null) {
                header.setReqNumber(reqNumber);
                header.setDocType(headerRet.getString("PR_TYPE"));
            }

            System.out.println("SAP ITEMS SIZE: " + prItems.getNumRows());
            System.out.println("SAP SERVICE LINES SIZE: " + prServiceLines.getNumRows());
            System.out.println("SAP ADDITIONAL LINES SIZE: " + prAddData.getNumRows());


            List<EzPurchaseRequisitionItems> sapItems = new ArrayList<>();

            for (int i = 0; i < prItems.getNumRows(); i++) {
                prItems.setRow(i);

                EzPurchaseRequisitionItems item = new EzPurchaseRequisitionItems();
                String itemNo = prItems.getString("PREQ_ITEM");

                /* -------- ITEM BASIC DATA -------- */
                item.setItemNO(itemNo);
                item.setMatNumber(prItems.getString("MATERIAL"));
                item.setShortText(prItems.getString("SHORT_TEXT"));
                item.setQuantity(prItems.getBigDecimal("QUANTITY"));
                item.setUom(prItems.getString("UNIT"));
                item.setValPrice(prItems.getBigDecimal("PREQ_PRICE"));
                // item.setTotal(prItems.getString("TARGET_VAL"));
                item.setMaterialGroup(prItems.getString("MATL_GROUP"));

                String delivStr = prItems.getString("DELIV_DATE");
                if (delivStr != null && !delivStr.isBlank()) {
                    try {
                        SimpleDateFormat sapFmt = new SimpleDateFormat("yyyy-MM-dd");
                        Date delivDate = sapFmt.parse(delivStr.trim());
                        item.setDeliveryDate(delivDate);
                    } catch (Exception e) {
                        System.out.println("❌ Failed to parse delivery date: " + delivStr);
                    }
                }

                item.setPlant(prItems.getString("PLANT"));
                item.setStorageLoc(prItems.getString("STORE_LOC"));
                item.setTrackNo(prItems.getString("TRACKINGNO"));
                item.setItemCat(prItems.getString("ITEM_CAT"));

                // Account assignment
                prAcc.firstRow();
                for (int j = 0; j < prAcc.getNumRows(); j++, prAcc.nextRow()) {
                    if (prAcc.getString("PREQ_ITEM").equals(itemNo)) {
                        item.setWbsElement(prAcc.getString("WBS_ELEMENT"));
                        item.setCostCenter(prAcc.getString("COSTCENTER"));
                        item.setInternalOrder(prAcc.getString("ORDERID"));
                        break;
                    }
                }

//LOAD additional data
                prAddData.firstRow();
                for (int j = 0; j < prAddData.getNumRows(); j++, prAddData.nextRow()) {
                    if (prAddData.getString("PREQ_ITEM").equals(itemNo)) {
                        //item.set(prAddData.getString("ZZCASNR"));
                        item.setCoa(prAddData.getString("ZZCOA"));
                        item.setMsds(prAddData.getString("ZZMSDS"));
                        //  item.setPackSize(removeLeadingZeros(prAddData.getString("ZZPACK")));
                        item.setPassThrough(prAddData.getString("ZZPASS"));
                        if (header.getDept() == null || header.getDept().isEmpty())
                            header.setDept(prAddData.getString("ZZDEPT"));
                        if (header.getDivision() == null || header.getDivision().isEmpty())
                            header.setDivision(prAddData.getString("ZZBU"));


                        break;
                    }
                }

                // Load service lines for this item
                List<EzPurchaseRequisitionServices> serviceList = new ArrayList<>();
                prServiceLines.firstRow();
                for (int k = 0; k < prServiceLines.getNumRows(); k++, prServiceLines.nextRow()) {
                    String serviceItemNo = prServiceLines.getString("DOC_ITEM");
                    if (serviceItemNo.equals(itemNo)) {
                        EzPurchaseRequisitionServices service = new EzPurchaseRequisitionServices();
                        service.setReqNumber(reqNumber);
                        service.setItemNo(itemNo);
                        service.setServLine(prServiceLines.getString("SRV_LINE"));
                        service.setServNo(prServiceLines.getString("SERVICE"));
                        service.setServDesc(prServiceLines.getString("SHORT_TEXT"));
                        service.setServQty(prServiceLines.getBigDecimal("QUANTITY"));
                        service.setServUnit(prServiceLines.getString("UOM"));
                        service.setServPrice(prServiceLines.getBigDecimal("GROSS_PRICE"));
                        service.setServNetPrice(prServiceLines.getBigDecimal("NET_PRICE"));
                        service.setItem(item);

                        serviceList.add(service);
                        System.out.println("  Service Line: " + service.getServLine() + " - " + service.getServDesc());
                    }
                }
                item.setServices(serviceList);
                System.out.println("Item " + itemNo + " loaded with " + serviceList.size() + " service lines");

                // Set header-level fields from first item
                if (header.getPurGrp() == null || header.getPurGrp().isEmpty())
                    header.setPurGrp(prItems.getString("PUR_GROUP"));

                if (header.getPlant() == null || header.getPlant().isEmpty())
                    header.setPlant(prItems.getString("PLANT"));

                if (header.getAccAsmt() == null || header.getAccAsmt().isEmpty())
                    header.setAccAsmt(prItems.getString("ACCTASSCAT"));

                if (header.getItemCat() == null || header.getItemCat().isEmpty())
                    header.setItemCat(prItems.getString("ITEM_CAT"));

                item.setHeader(header);
                sapItems.add(item);
            }
            System.out.print("SAP sap serviceItems"+sapItems);
            if (!sapItems.isEmpty()) {
                header.setItems(sapItems);
            }

        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "SAP Error while reading Service PR: " + e.getMessage());
            return "errorPage";
        }

        System.out.println("SAP Service PR header: " + header);
        String division = header.getDivision();
        String plant = header.getPlant();
        try {
            List<EzcMasterData> departments = getDepartments(division, plant);
            for(EzcMasterData dept: departments)
            {
                String deptVal=checkNull(dept.getEmdValue1());
                if(!"".equals(deptVal) && dept.getEmdValue1().contains("#"))
                {
                    dept.setEmdValue1(deptVal.split("#")[0]);
                }
            }


            model.addAttribute("departments", departments);
            //System.out.println("Departments loaded: " + (departments != null ? departments.size() : 0));
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("departments", new ArrayList<>());
        }


        // Add all master data to model
        model.addAttribute("divisions", divisionList);
        model.addAttribute("purchaseGroups", purchaseGroupList);
        model.addAttribute("docTypes", docTypeList);
        model.addAttribute("plants", plantList);
        model.addAttribute("accAssgs", accAssgList);
        model.addAttribute("itemCategs", itemCategList);
        model.addAttribute("storgLocs", storLocList);
        model.addAttribute("serviceCodes", serviceCodes);
        model.addAttribute("matGrpList", matGrpList);

        // Add header to model for Thymeleaf
        model.addAttribute("prHeader", header);
        model.addAttribute("prHeaderObj", header);

        // Serialize header (with items and service lines) to JSON for JavaScript initialization
        try {
            System.out.println("Starting JSON serialization...");
            com.fasterxml.jackson.databind.ObjectMapper mapper = new com.fasterxml.jackson.databind.ObjectMapper();

            // Configure mapper to handle dates and prevent serialization failures
            mapper.registerModule(new com.fasterxml.jackson.datatype.jsr310.JavaTimeModule());
            mapper.disable(com.fasterxml.jackson.databind.SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
            mapper.disable(com.fasterxml.jackson.databind.SerializationFeature.FAIL_ON_EMPTY_BEANS);

            String json = mapper.writeValueAsString(header);
            System.out.println("JSON serialization successful!");
            System.out.println("JSON length: " + json.length() + " characters");
            System.out.println("JSON preview (first 500 chars): " + (json.length() > 500 ? json.substring(0, 500) + "..." : json));

            model.addAttribute("prHeaderJson", json);

            if (header.getItems() != null) {
                System.out.println("Service PR JSON prepared with " + header.getItems().size() + " items");
            }
        } catch (Exception ex) {
            System.out.println("ERROR: JSON serialization failed!");
            System.out.println("Error message: " + ex.getMessage());
            ex.printStackTrace();
            model.addAttribute("prHeaderJson", "{}");
        }

        System.out.println("========================================");
        System.out.println("Returning to editServicePR view");
        System.out.println("========================================");

        return "prCreation/editServicePR";
    }
    @PostMapping( value = "/prCreate/updateServicePR")
    public ResponseEntity<Map<String, Object>> updateServciePR(@RequestBody PRRequest prRequest) {

        System.out.println("Updating Servcie PR: " );

        String sapPrNum=prRequest.getReqNumber();
        Map<String, Object> response = new HashMap<>();
        try {
            System.out.println("IN::Updating:: TRY"+sapPrNum);
            JCoDestination destination = rfcReadSAPService.getDestination();
            JCoRepository repository = destination.getRepository();
            JCoFunction poFunction = repository.getFunction("ZBAPI_PR_CHANGE");
            //JCoFunction commitFunction = repository.getFunction("BAPI_TRANSACTION_COMMIT");

            System.out.println("poFunction ZBAPI_PR_CHANGE"+poFunction);
            System.out.println("Connected User: " + destination.getUser());

            JCoParameterList imp = poFunction.getImportParameterList();
            JCoParameterList tab = poFunction.getTableParameterList();


            JCoStructure header = imp.getStructure("PRHEADER");
            JCoStructure headerX = imp.getStructure("PRHEADERX");
          /*  if (prRequest.getDocType() == null || prRequest.getDocType().isEmpty()) {
                return ResponseEntity.badRequest().body(Map.of(
                        "status", "error",
                        "message", "Missing Document Type"
                ));
            }*/
            System.out.println("SAP PR Number set:1 " + sapPrNum);
            imp.setValue("NUMBER", sapPrNum);
            System.out.println("SAP PR Number set: 2" + sapPrNum);
            String docType=prRequest.getDocType();
            System.out.println("docType"+docType);
            header.setValue("PR_TYPE", docType);
            header.setValue("PREQ_NO", sapPrNum);
            headerX.setValue("PR_TYPE", "X");
            headerX.setValue("PREQ_NO", "X");


            JCoTable itemTable = tab.getTable("PRITEM");
            JCoTable itemXTable = tab.getTable("PRITEMX");
            JCoTable accTab = tab.getTable("PRACCOUNT");
            JCoTable accTabX = tab.getTable("PRACCOUNTX");
            JCoTable extTab = tab.getTable("EXTENSIONIN");
            JCoTable addTab = tab.getTable("ADDITIONAL_DATA");
            JCoTable addTabX = tab.getTable("ADDITIONAL_DATAX");
            JCoTable PrServiceLines = tab.getTable("SERVICELINES");
            JCoTable PrServiceLinesX= tab.getTable("SERVICELINESX");
            JCoTable PrServiceAcc   = tab.getTable("SERVICEACCOUNT");
            JCoTable PrServiceAccX  = tab.getTable("SERVICEACCOUNTX");



            SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd");
            SimpleDateFormat sapFormat = new SimpleDateFormat("yyyyMMdd");
            List<PRItem> prItems=new ArrayList<>();
            List<PRService> prServs=new ArrayList<>();
            PRItem item1 =new PRItem();
            int counter = 1;
            int indPos=0;
            String itemPckgNo="";
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            Users userObj = (Users)authentication.getPrincipal();
            String loggedUser=(String)userObj.getUserId();
            String prUserName="SARIEH A";
            prUserName=(String) userObj.getFirstName()+""+(String) userObj.getLastName();
            System.out.println("itemSize"+prRequest.getItems().size());
            for (PRItem item : prRequest.getItems()) {
                Date parsedDate = inputFormat.parse(item.getDeliveryDate());
                String formattedDate = sapFormat.format(parsedDate);
                int sapItemNumber = counter * 10;
                String itemNumber = String.format("%05d", sapItemNumber);  // creates 00001, 00002, etc.
                System.out.println("itemNumber" + itemNumber);
                String matCode = item.getMatNumber();
                if (matCode != null) {
                    // Pad with leading zeros to make 18 digits
                    matCode = String.format("%18s", matCode).replace(' ', '0');
                } else {
                    matCode = "000000000000000000"; // fallback if null
                }
                itemTable.appendRow();
                itemTable.setValue("PREQ_ITEM", itemNumber);
                itemTable.setValue("PREQ_NAME", prUserName);
                System.out.println("itemNumber" + itemNumber + "prUserName" + prUserName);
                itemTable.setValue("SHORT_TEXT", item.getShortText());
                // itemTable.setValue("STORE_LOC", item.getStorageLoc());
                System.out.println("getStrgLoc" + item.getStorageLoc());
                System.out.println("getStrgLoc" + item.getStorageLoc() + "status" + item.getStatus());
                if ("D".equalsIgnoreCase(item.getStatus())) {
                    itemTable.setValue("DELETE_IND", "X");
                }
                itemTable.setValue("PLANT", prRequest.getPlant());
                itemTable.setValue("QUANTITY", item.getQuantity());
                itemTable.setValue("MATERIAL", matCode);
                System.out.println("getMatCode" + matCode);
                itemTable.setValue("MATL_GROUP", item.getMaterialGroup());
                itemTable.setValue("UNIT", item.getUom());
                itemTable.setValue("DELIV_DATE", formattedDate);
                System.out.println("formattedDate" + formattedDate);
                itemTable.setValue("PREQ_PRICE", safeDecimal(item.getValPrice()));
                itemTable.setValue("PERIOD_IND_EXPIRATION_DATE", "D");
                itemTable.setValue("ACCTASSCAT", prRequest.getAccAsmt());
                itemTable.setValue("ITEM_CAT", prRequest.getItemCateg());
                itemTable.setValue("PUR_GROUP", prRequest.getPurGrp());
                itemTable.setValue("TRACKINGNO", item.getTrackNo());
                System.out.println("getPurGrp" + item.getPurGrp());
                //itemTable.setValue("PREQ_NAME",item.getReqName());
                System.out.println("formatted Date " + item.getReqName());
                System.out.println("formatted Date " + itemTable.getValue("DELIV_DATE"));
                System.out.println("ACCTASSCAT" + prRequest.getAccAsmt());

                if (item.getServices() != null && !item.getServices().isEmpty()) {
                    if (indPos == 0) {
                        itemPckgNo = "0000000000" + ((indPos * 2) + 1);
                        itemPckgNo = itemPckgNo.substring(itemPckgNo.length() - 10, itemPckgNo.length());

                        itemTable.setValue("PCKG_NO", itemPckgNo);

                    } else {
                        itemPckgNo = "0000000000" + ((indPos * 2) + 2);
                        itemPckgNo = itemPckgNo.substring(itemPckgNo.length() - 10, itemPckgNo.length());

                        itemTable.setValue("PCKG_NO", itemPckgNo);

                    }

                }
                itemXTable.appendRow();
                if (item.getServices() != null && !item.getServices().isEmpty()) {
                    itemXTable.setValue("PCKG_NO", "X");
                }
                itemXTable.setValue("PREQ_ITEM", itemNumber);
                itemXTable.setValue("PREQ_ITEMX", "X");
                if ("D".equalsIgnoreCase(item.getStatus())) {
                    itemXTable.setValue("DELETE_IND", "X");
                }
                itemXTable.setValue("PUR_GROUP", "X");
                itemXTable.setValue("PREQ_NAME", "X");
                itemXTable.setValue("MATERIAL", "X");
                itemXTable.setValue("MATL_GROUP", "X");
                itemXTable.setValue("SHORT_TEXT", "X");
                itemXTable.setValue("STORE_LOC", "X");
                itemXTable.setValue("PLANT", "X");
                itemXTable.setValue("QUANTITY", "X");
                itemXTable.setValue("UNIT", "X");
                itemXTable.setValue("DELIV_DATE", "X");
                itemXTable.setValue("PREQ_PRICE", "X");
                itemXTable.setValue("ACCTASSCAT", "X");
                itemXTable.setValue("ITEM_CAT", "X");
                itemXTable.setValue("TRACKINGNO", "X");
                itemXTable.setValue("VAL_TYPE", "X");
                itemXTable.setValue("CURRENCY", "X");


                accTab.appendRow();
                accTab.setValue("PREQ_ITEM", itemNumber);
                //accTab.setValue("SERIAL_NO", "01");
                accTab.setValue("SERIAL_NO", indPos+1);
                //  accTab.setValue("GL_ACCOUNT",item.getGlAcc());
                if ("F".equalsIgnoreCase(prRequest.getAccAsmt())) {
                    accTab.setValue("ORDERID", item.getInternalOrder());
                }
                else if ("P".equalsIgnoreCase(prRequest.getAccAsmt()) || "Q".equalsIgnoreCase(prRequest.getAccAsmt())) {
                    accTab.setValue("WBS_ELEMENT", item.getWbsElement());
                }
                else if("N".equalsIgnoreCase(prRequest.getAccAsmt()))
                {
                    accTab.setValue("NETWORK", item.getNetwork());
                }
                else if("K".equalsIgnoreCase(prRequest.getAccAsmt()))
                {
                    accTab.setValue("COSTCENTER", item.getCostCenter());
                }
                else
                {
                    accTab.setValue("WBS_ELEMENT", item.getWbsElement());
                }



                accTabX.appendRow();
                accTabX.setValue("PREQ_ITEM", itemNumber);
                //accTabX.setValue("SERIAL_NO", "01");
                accTab.setValue("SERIAL_NO", indPos+1);
                accTabX.setValue("PREQ_ITEMX", "X");
                accTabX.setValue("SERIAL_NOX", "X");
                if ("F".equalsIgnoreCase(prRequest.getAccAsmt())) {

                    accTabX.setValue("ORDERID","X");
                }
                else if ("P".equalsIgnoreCase(prRequest.getAccAsmt()) || "Q".equalsIgnoreCase(prRequest.getAccAsmt())) {

                    accTabX.setValue("WBS_ELEMENT", "X");
                }
                else if ("N".equalsIgnoreCase(prRequest.getAccAsmt())) {

                    accTabX.setValue("NETWORK","X");
                }
                else if("K".equalsIgnoreCase(prRequest.getAccAsmt()))
                {
                    accTabX.setValue("COSTCENTER", "X");
                }
                else {
                    accTabX.setValue("WBS_ELEMENT", "X");
                }
                // accTabX.setValue("GL_ACCOUNT","X");


                String valuePart1 = itemNumber + item.getDivision() + item.getDepartment() + " " + loggedUser;
                System.out.println("valuePart1: " + valuePart1);
                extTab.appendRow();
                extTab.setValue("STRUCTURE", "BAPI_TE_MEREQITEM");
                extTab.setValue("VALUEPART1", valuePart1);

                extTab.appendRow();
                extTab.setValue("STRUCTURE", "BAPI_TE_MEREQITEMX");
                extTab.setValue("VALUEPART1", "00001XX X");

                String packSize = item.getPackSize();
                //  packSize = String.format("%10s", packSize).replace(' ', '0');
                //System.out.println("packSize: " + packSize);
                addTab.appendRow();
                addTab.setValue("PREQ_ITEM", itemNumber);
                addTab.setValue("ZZBU", item.getDivision());
                addTab.setValue("ZZDEPT", item.getDepartment());
                //addTab.setValue("ZZPACK", packSize);
                //addTab.setValue("ZZCOA", item.getCoa());
                //addTab.setValue("ZZMSDS", item.getMsds());
                addTab.setValue("ZZUSER", loggedUser);
                addTab.setValue("ZZPASS", item.getPassThrough());

                System.out.println("AFTER ADDTAB: ");

                addTabX.appendRow();
                addTabX.setValue("PREQ_ITEM", itemNumber);
                addTabX.setValue("ZZBU", "X");
                addTabX.setValue("ZZDEPT", "X");
                addTabX.setValue("ZZUSER", "X");
                addTabX.setValue("ZZPASS", "X");
                System.out.println("AFTER ADDTABX: ");


                int r = 0;
                System.out.println("Updating " + item.getServices().size() + " service lines for item " + itemNumber);

                for (PRService serv : item.getServices())
                {

                    String tempServiceNo = "", outLine = "", srvLine = "";
                    if (r == 0) {
                        outLine = "0000000000" + "1";
                    } else {
                        outLine = "0000000000";
                    }
                    int servItemNumber = (r + 1) * 10;
                    outLine = outLine.substring(outLine.length() - 10, outLine.length());

                    srvLine = "0000000000" + servItemNumber;
                    srvLine = srvLine.substring(srvLine.length() - 10, srvLine.length());

                    if ("N/A".equals(serv.getServNo())) {
                        tempServiceNo = " ";
                    } else {
                        tempServiceNo = serv.getServNo();
                    }
                    PrServiceLines.appendRow();
                    PrServiceLines.setValue("DOC_ITEM", itemNumber);
                    PrServiceLines.setValue("OUTLINE", outLine);
                    PrServiceLines.setValue("SRV_LINE", srvLine);
                    PrServiceLines.setValue("SERVICE", tempServiceNo);
                    PrServiceLines.setValue("SHORT_TEXT", serv.getServDesc());
                    PrServiceLines.setValue("QUANTITY", serv.getServQty());
                    PrServiceLines.setValue("UOM", serv.getServUnit());
                    PrServiceLines.setValue("GROSS_PRICE", serv.getServPrice());
                    PrServiceLines.setValue("CURRENCY", "INR");
                    PrServiceLines.setValue("NET_PRICE", serv.getServNetPrice());

                    PrServiceLinesX.appendRow();
                    PrServiceLinesX.setValue("DOC_ITEM", itemNumber);
                    PrServiceLinesX.setValue("OUTLINE", outLine);
                    PrServiceLinesX.setValue("SRV_LINE", srvLine);
                    PrServiceLinesX.setValue("SERVICE", "X");
                    PrServiceLinesX.setValue("SHORT_TEXT", "X");
                    PrServiceLinesX.setValue("QUANTITY", "X");
                    PrServiceLinesX.setValue("UOM", "X");
                    PrServiceLinesX.setValue("GROSS_PRICE", "X");
                    PrServiceLinesX.setValue("CURRENCY", "X");
                    PrServiceLinesX.setValue("NET_PRICE", "X");


                    PrServiceAcc.appendRow();
                    PrServiceAcc.setValue("DOC_ITEM", itemNumber);
                    PrServiceAcc.setValue("OUTLINE", outLine);
                    PrServiceAcc.setValue("SRV_LINE", srvLine);
                    PrServiceAcc.setValue("SERIAL_NO", indPos + 1);
                    PrServiceAcc.setValue("SERIAL_NO_ITEM", indPos + 1);
                    PrServiceAcc.setValue("QUANTITY", serv.getServQty());
                    PrServiceAcc.setValue("PERCENT", "100");
                    PrServiceAcc.setValue("NET_VALUE", serv.getServNetPrice());

                    PrServiceAccX.appendRow();
                    PrServiceAccX.setValue("DOC_ITEM", itemNumber);
                    PrServiceAccX.setValue("OUTLINE", outLine);
                    PrServiceAccX.setValue("SRV_LINE", srvLine);
                    PrServiceAccX.setValue("SERIAL_NO", "01");
                    PrServiceAccX.setValue("SERIAL_NO_ITEM", "X");
                    PrServiceAccX.setValue("QUANTITY", "X");
                    PrServiceAccX.setValue("PERCENT", "X");
                    PrServiceAccX.setValue("NET_VALUE", "X");

                    prServs.add(serv);
                    r++;

                }

                indPos=indPos+1;

                prItems.add(item);
                counter++;
            }
            try{
                JCoContext.begin(destination);
                poFunction.execute(destination);
                //commitFunction.execute(destination);
                JCoContext.end(destination);
            }catch(Exception e){}

            //   String sapPrNum = poFunction.getExportParameterList().getString("NUMBER");
            JCoTable returnTable = poFunction.getTableParameterList().getTable("RETURN");
            List<String> errorMessages = new ArrayList<>();
            List<String> successMessages = new ArrayList<>();
            for (int i = 0; i < returnTable.getNumRows(); i++) {
                returnTable.setRow(i);
                String type = returnTable.getString("TYPE");   // E, S, W
                String message = returnTable.getString("MESSAGE");

                if ("E".equals(type)) {          // Error
                    errorMessages.add(message);
                } else if ("S".equals(type)) {   // Success
                    successMessages.add(message);
                }
            }
            if (!errorMessages.isEmpty())
            {
                response.put("status", "ERROR");
                response.put("sapPrNumber", sapPrNum);
                response.put("message", errorMessages);
            } else {
                response.put("status", "success");
                response.put("sapPrNumber", sapPrNum);
                response.put("message", successMessages);
            }

            if (sapPrNum != null && !sapPrNum.contains("#"))
            {
                List<EzPurchaseRequisitionHeader> headerList = headerRepo.findByReqNumber(sapPrNum);

                EzPurchaseRequisitionHeader headerDt;
                if (headerList != null && !headerList.isEmpty()) {
                    headerDt = headerList.get(0); // assuming PR number is unique

                    // Update header-level fields
                    headerDt.setDocType(prRequest.getDocType());
                    headerDt.setDivision(prRequest.getDivision());
                    headerDt.setPlant(prRequest.getPlant());
                    headerDt.setAccAsmt(prRequest.getAccAsmt());
                    headerDt.setItemCat(prRequest.getItemCateg());
                    headerDt.setPurGrp(prRequest.getPurGrp());
                    headerDt.setDept(prRequest.getDepartment());
                    headerDt.setModifiedBy(loggedUser);
                    headerDt.setModifiedOn(LocalDateTime.now());
                } else {
                    // If not found, create new header
                    headerDt = new EzPurchaseRequisitionHeader();
                    headerDt.setReqNumber(sapPrNum);
                    headerDt.setDocType(prRequest.getDocType());
                    headerDt.setDivision(prRequest.getDivision());
                    headerDt.setPlant(prRequest.getPlant());
                    headerDt.setAccAsmt(prRequest.getAccAsmt());
                    headerDt.setItemCat(prRequest.getItemCateg());
                    headerDt.setPurGrp(prRequest.getPurGrp());
                    headerDt.setDept(prRequest.getDepartment());
                    headerDt.setCreatedBy(loggedUser);
                    headerDt.setCreatedOn(LocalDateTime.now());
                    headerDt.setStatus("UNRELEASED");
                }

                List<EzPurchaseRequisitionItems> existingItems = headerDt.getItems();
                Map<String, EzPurchaseRequisitionItems> existingItemMap = new HashMap<>();

                if (existingItems != null) {
                    for (EzPurchaseRequisitionItems item : existingItems) {
                        existingItemMap.put(item.getSapPrItemNo(), item);
                    }
                } else {
                    existingItems = new ArrayList<>();
                }

                counter = 1;
                for (PRItem itemDto : prRequest.getItems())
                {
                    int sapItemNumber = counter * 10;

                    String sapitemNumber = String.format("%05d", sapItemNumber);
                    String itemNumber = String.format("%02d", sapItemNumber);


                    EzPurchaseRequisitionItems itemEntity = existingItemMap.getOrDefault(sapitemNumber, new EzPurchaseRequisitionItems());

                    // Always keep header relationship intact
                    itemEntity.setHeader(headerDt);
                    itemEntity.setSapPrNo(sapPrNum);
                    itemEntity.setSapPrItemNo(sapitemNumber);

                    // Update mutable fields
                    itemEntity.setShortText(itemDto.getShortText());
                    itemEntity.setMatNumber(itemDto.getMatNumber());
                    itemEntity.setItemNO(itemNumber);
                    itemEntity.setPlant(itemDto.getPlant());
                    itemEntity.setStorageLoc(itemDto.getStorageLoc());
                    itemEntity.setPurchaseGroup(itemDto.getPurGrp());
                    itemEntity.setMaterialGroup(itemDto.getMaterialGroup());
                    itemEntity.setQuantity(safeDecimal(itemDto.getQuantity()));
                    itemEntity.setValPrice(safeDecimal(itemDto.getValPrice()));
                    itemEntity.setQuantity(itemDto.getQuantity() != null ? itemDto.getQuantity() : BigDecimal.ZERO);
                    itemEntity.setValPrice(itemDto.getValPrice() != null ? itemDto.getValPrice() : BigDecimal.ZERO);
                    itemEntity.setUom(itemDto.getUom());
                    itemEntity.setAccAssignCat(prRequest.getAccAsmt());
                    itemEntity.setWbsElement(itemDto.getWbsElement());
                    itemEntity.setCas(itemDto.getCas());
                    itemEntity.setTrackNo(itemDto.getTrackNo());
                    itemEntity.setPackSize(itemDto.getPackSize());
                    itemEntity.setCoa(itemDto.getCoa());
                    itemEntity.setPassThrough(itemDto.getPassThrough());
                    itemEntity.setMsds(itemDto.getMsds());

                    // Convert date safely
                    if (itemDto.getDeliveryDate() != null && !itemDto.getDeliveryDate().isEmpty()) {
                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                        Date deliveryDt = sdf.parse(itemDto.getDeliveryDate());
                        itemEntity.setDeliveryDate(deliveryDt);
                    }

                    // Preserve status if already present
                    if (itemDto.getStatus() == null) { itemEntity.setStatus("UPDATED"); }
                    else if("D".equalsIgnoreCase(itemDto.getStatus()))
                    { itemEntity.setStatus("DELETED"); }
                    else
                    { itemEntity.setStatus("UPDATED");}


                    List<EzPurchaseRequisitionServices>serviceList = new ArrayList<>();
                    //ADDDING SERVICES
                    if (itemDto.getServices() != null && !itemDto.getServices().isEmpty()) {
                        for (PRService serv : itemDto.getServices()) {
                            EzPurchaseRequisitionServices servEntity = new EzPurchaseRequisitionServices();
                            servEntity.setReqNumber(sapPrNum);
                            servEntity.setItemNo(itemNumber);
                            servEntity.setServLine(serv.getServLine());
                            servEntity.setServNo(serv.getServNo());
                            servEntity.setServDesc(serv.getServDesc());
                            servEntity.setServQty(safeBigDecimal(serv.getServQty()));
                            servEntity.setServUnit(serv.getServUnit());
                            servEntity.setServPrice(safeBigDecimal(serv.getServPrice()));
                            servEntity.setServNetPrice(safeBigDecimal(serv.getServNetPrice()));

                            servEntity.setItem(itemEntity);

                            serviceList.add(servEntity);


                        }
                    }
                    //itemEntity.setServices(serviceList);
                    itemEntity.getServices().clear();
                    itemEntity.getServices().addAll(serviceList);

                    System.out.println("serviceList " + serviceList.size());


                    // If this was a new item, add it to the list
                    if (!existingItemMap.containsKey(sapitemNumber)) {
                        existingItems.add(itemEntity);
                    }

                    counter++;
                }

                headerDt.setItems(existingItems);
                headerRepo.save(headerDt);

            }

        } catch (JCoException e) {
            System.out.println("Error connecting to SAP: " + e.getMessage());
            e.printStackTrace();
        }
        catch (Exception e) {
            response.put("status", "error");
            response.put("message", e.getMessage());
        }



        return ResponseEntity.ok(response);

        //  headerService.saveOrUpdate(prForm);

    }

    @Transactional
    @GetMapping("prServiceLine/edit")
    public String editServicePRGet(@RequestParam("reqNumber") String reqNumber, Model model) {
        // GET wrapper that delegates to POST handler for convenience
        return editServicePR(reqNumber, model);
    }
    @GetMapping("/getMaterialsFromCas")
    @ResponseBody
    public List<MaterialDto> getMaterailsFromCas(@RequestParam("casNumber") String casNumber) {
        log.debug("Fetching materials for CAS Number: " + casNumber);
        String[] outputFields = null;
        String[] queryValues = null;
        String tabName = "";
        String matNO = "";
        List<MaterialDto> materials = new ArrayList<>();
        try {

            outputFields = new String[]{"MATNR", "ZCATNO", "ZMAN", "ZZBRAND"};
            queryValues = new String[]{"ZZCAS_NO EQ '" + casNumber + "'"};
            tabName = "MARA";
            List<String[]> dataList = rfcReadSAPService.readRFCTable(tabName, outputFields, queryValues);
            if (dataList != null) {
                for (String row[] : dataList) {
                    matNO = row[0];
                    log.debug("matNO"+matNO);
                    //String materialPass = String.format("%018d", Long.parseLong(matNO));
                    MaterialDto m1 = new MaterialDto();
                    m1.setMaterialCode(matNO);
                    materials.add(m1);

                }
            }
        } catch (Exception e) {
            log.error("Error fetching materials from CAS number: " + e.getMessage());
            e.printStackTrace();
        }
//**************************************************
        log.debug("Found " + materials.size() + " materials for CAS Number: " + casNumber);
        return materials;
    }
}