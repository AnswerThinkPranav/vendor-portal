package com.ezc.aragenPR.webapp.controller.reservation;


import com.ezc.aragenPR.webapp.dto.pr.MaterialDto;
import com.ezc.aragenPR.webapp.dto.pr.PRItem;
import com.ezc.aragenPR.webapp.dto.pr.PRRequest;
import com.ezc.aragenPR.webapp.dto.reservation.ReservationDTO;
import com.ezc.aragenPR.webapp.repository.master.EzcMasterDataRepo;
import com.ezc.aragenPR.webapp.repository.reservation.EzcReservationHeaderRepo;
import com.ezc.aragenPR.webapp.service.shared.RFCReadSAPService;
import com.ezc.aragenPR.webapp.service.reservation.ReservationService;
import com.sap.conn.jco.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import com.ezc.aragenPR.webapp.model.master.EzcMasterData;
import com.ezc.aragenPR.webapp.model.reservation.EzcReservationHeader;
import com.ezc.aragenPR.webapp.model.reservation.EzcReservationItems;
import com.ezc.aragenPR.webapp.model.user.Users;
import java.util.*;

@Slf4j
@Controller
public class ReservationController {
    @Autowired
    private EzcMasterDataRepo masterRepo;

    @Autowired
    private RFCReadSAPService rfcReadSAPService;

    @Autowired
    private ReservationService reservationService;

    @Autowired
    private EzcReservationHeaderRepo headerRepo;

    @GetMapping(value = "/getWBSElementsWithConversion")
    @ResponseBody
    public List<MaterialDto> getWBSElementsWithConversion(@RequestParam("plant") String plant, @RequestParam(required = false) String query) {
        List<MaterialDto> wbsElements = new ArrayList<>();
        log.debug("IN getWBSElements" + plant + "query" + query);
        try {

            JCoDestination destination = rfcReadSAPService.getDestination();
            JCoRepository repository = destination.getRepository();
            JCoFunction poFunction = repository.getFunction("ZEZ_ACTIVE_WBS");


            log.debug("SAP Connection established successfully!");
            log.debug("Connected User: " + destination.getUser());

            try {


                JCoTable matShortDescSel = poFunction.getTableParameterList().getTable("I_WBS");

                matShortDescSel.appendRow();

                matShortDescSel.setValue("SIGN", "I");

                matShortDescSel.setValue("OPTION", "CP");

                matShortDescSel.setValue("LOW", query + "*");

            } catch (Exception execEx) {

                log.debug("start 123: " + execEx.getMessage());

            }

            System.out.println("Executing ZEZ_ACTIVE_WBS in getWBSElementsWithConversion");
            try {
                JCoContext.begin(destination);
                poFunction.execute(destination);
                //commitFunction.execute(destination);
                JCoContext.end(destination);
            } catch (Exception e) {
            }

            JCoTable wbsTable = poFunction.getTableParameterList().getTable("E_WBS");

            try {
                if (wbsTable != null && wbsTable.getNumRows() > 0) {
                    log.debug("Material num of Rows" + wbsTable.getNumRows());
                    do {
                        MaterialDto m1 = new MaterialDto();
                        String rawCode = (String) wbsTable.getValue("PSPNR");
                        String wbsCodeDesc = (String) wbsTable.getValue("POSID");
                        String wbsCode = (String) wbsTable.getValue("OBJNR");
                        wbsCode = wbsCode.replaceFirst("^[A-Za-z]+", "");

                        String plantFromSAP = (String) wbsTable.getValue("WERKS");
                        //System.out.println("rawCode"+rawCode +"wbsCode"+wbsCode);
                        // if(plant.equals(plantFromSAP))
                        //  {
                        m1.setWbsCode(wbsCode);
                        m1.setWbsCodeDesc(wbsCodeDesc);
                        wbsElements.add(m1);
                        //}
                    }
                    while (wbsTable.nextRow());
                }
            } catch (Exception e) {
                log.debug("Exception in output " + e);
            }


        } catch (JCoException e) {
            log.debug("Error connecting to SAP: " + e.getMessage());
            e.printStackTrace();
        }
        log.debug("WBSmaterials size" + wbsElements.size());
        return wbsElements;
    }

    @GetMapping("/reservation/createReservation")
    public String showReservationPage(Model model) {
        List<EzcMasterData> plantList = masterRepo.findByEmdKey("PLANT");
        model.addAttribute("plants", plantList);
        model.addAttribute("costCenters", masterRepo.findByEmdKey("COSTCENTER"));
        model.addAttribute("glAccounts", masterRepo.findByEmdKey("GLACCOUNT"));
        model.addAttribute("movementTypes", getMovementTypes());


        // Fetch movement types from SAP and add to model
//        List<Map<String, String>> movementTypes = getMovementTypes();
//        model.addAttribute("movementTypes", movementTypes);

        return "reservation/createReservation";
    }

    @GetMapping(value = "/getMovementTypes")
    public List<Map<String, String>> getMovementTypes() {
        List<Map<String, String>> movementTypes = new ArrayList<>();
        System.out.println("IN getMovementTypes - Fetching from SAP");

        try {
            String[] outputFields = new String[]{"BWART", "BTEXT"};

            // Define the query condition: SPRAS EQ 'E' AND TCODE EQ 'MB21'
            String[] queryValues = new String[]{"SPRAS EQ 'E'"};

            String tabName = "T156T";

            log.debug("Calling RFC_READ_TABLE for table: " + tabName);


            List<String[]> dataList = rfcReadSAPService.readRFCTable(tabName, outputFields, queryValues);

            if (dataList != null && !dataList.isEmpty()) {
                log.debug("Retrieved " + dataList.size() + " movement types from SAP");

                for (String[] row : dataList) {
                    Map<String, String> movementType = new HashMap<>();
                    movementType.put("emdValue1", row[0]);
                    movementType.put("emdValue2", row[1]);
                    movementTypes.add(movementType);

                    //  System.out.print("Movement Type: " + row[0] + " - " + row[1]);
                }
            } else {
                log.warn("No movement types found in SAP for the given criteria");
            }

        } catch (Exception e) {
            log.error("Error fetching movement types from SAP: " + e.getMessage(), e);
        }

        return movementTypes;
    }

    @PostMapping("/reservation/save")
    @ResponseBody
    public ResponseEntity<?> createReservationInSAP(@RequestBody ReservationDTO reservationDTO) {

        Map<String, Object> response = new HashMap<>();

        try {
            System.out.print("Creating reservation in SAP: {}" + reservationDTO);

            Map<String, Object> result = reservationService.createReservation(reservationDTO);
            boolean success = (boolean) result.get("success");
            System.out.println("result" + result);
            if (success) {
                return ResponseEntity.ok(result);
            } else {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(result);
            }

        } catch (Exception e) {
            log.error("Error creating reservation", e);

            e.printStackTrace();

            Map<String, Object> errorMap = new HashMap<>();
            errorMap.put("success", false);
            errorMap.put("errors", List.of(e.getMessage()));

            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorMap);
        }


    }

    @GetMapping("reservation/list")
    public String showList(@RequestParam(required = false) String movementType,
                           @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date fromDate,
                           @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date toDate,
                           Model model) {
        System.out.print("in reservation/List movementType: " + movementType);
        String loggedUser = "";

        try {
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            Users userObj = (Users) authentication.getPrincipal();
            loggedUser = (String) userObj.getUserId();

        } catch (Exception e) {
        }
        if (fromDate == null || toDate == null) {
            Calendar cal = Calendar.getInstance();
            // Set toDate to today
            toDate = cal.getTime();
            // Set fromDate to 6 months back
            cal.add(Calendar.MONTH, -6);
            fromDate = cal.getTime();
        }

        // Convert empty string to null for "All Movement Types"
        if (movementType != null && movementType.trim().isEmpty()) {
            movementType = null;
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

        List<EzcReservationHeader> headers = headerRepo.getFilteredHeadersByMovementType(from, to, movementType, loggedUser);
        System.out.print("headers in reservation List: " + headers.size() + " from: " + from + " to: " + to + " movementType: " + movementType);

        model.addAttribute("movementTypes", getMovementTypes());
        model.addAttribute("headers", headers);
        model.addAttribute("fromDate", fromDate);
        model.addAttribute("toDate", toDate);
        model.addAttribute("selectedMovementType", movementType);

        return "reservation/reservationList";
    }


    @GetMapping("/reservation/list/filter")
    public String filterReservation(
            @RequestParam(required = false) String movementType,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date fromDate,
            @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd") Date toDate,
            Model model) {
        System.out.print("in filterReservation - movementType: " + movementType);
        String loggedUser = "";
        try {
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            Users userObj = (Users) authentication.getPrincipal();
            loggedUser = (String) userObj.getUserId();
        } catch (Exception e) {
        }
        if (fromDate == null || toDate == null) {
            Calendar cal = Calendar.getInstance();
            // Set toDate to today
            toDate = cal.getTime();
            // Set fromDate to 6 months back
            cal.add(Calendar.MONTH, -6);
            fromDate = cal.getTime();
        }

        // Convert empty string to null for "All Movement Types"
        if (movementType != null && movementType.trim().isEmpty()) {
            movementType = null;
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

        List<EzcReservationHeader> headers = headerRepo.getFilteredHeadersByMovementType(from, to, movementType, loggedUser);
        System.out.print("headers in filterReservation: " + headers.size() + " from: " + from + " to: " + to + " movementType: " + movementType);

        model.addAttribute("movementTypes", getMovementTypes());
        model.addAttribute("headers", headers);
        model.addAttribute("fromDate", fromDate);
        model.addAttribute("toDate", toDate);
        model.addAttribute("selectedMovementType", movementType);

        return "reservation/reservationList";
    }

    @GetMapping("reservation/edit")
    public String editReservation(@RequestParam("reservationNo") String reservationNo, Model model) {
        EzcReservationHeader header = new EzcReservationHeader();
        System.out.print("reservationNo" + reservationNo);
        try {
            JCoDestination destination = rfcReadSAPService.getDestination();
            JCoRepository repository = destination.getRepository();
            JCoFunction poFunction = repository.getFunction("ZEZ_BAPI_RESERVATION_GETDETAIL");

            if (poFunction == null) throw new RuntimeException("ZEZ_BAPI_RESERVATION_GETDETAIL not found");
            System.out.println("ZEZ_BAPI_RESERVATION_GETDETAIL started" + reservationNo);
            JCoParameterList imports = poFunction.getImportParameterList();
            imports.setValue("RESERVATION", reservationNo);


            try {
                JCoContext.begin(destination);
                poFunction.execute(destination);
                JCoContext.end(destination);
            } catch (Exception e) {
            }

            JCoStructure headerRet = poFunction.getExportParameterList().getStructure("RESERVATION_HEADER");

            JCoTable reservationItems = poFunction.getTableParameterList().getTable("RESERVATION_ITEMS");
            JCoTable addData = poFunction.getTableParameterList().getTable("ADDITIONAL_DATA");

            if (headerRet != null) {

                String sapDate = headerRet.getString("RES_DATE");
                System.out.println("sapDate" + sapDate);
                if (sapDate != null && !sapDate.isEmpty()) {

                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
                    LocalDate date = LocalDate.parse(sapDate, formatter);

                    header.setReqDate(date);
                }
                header.setReservationNo(headerRet.getString("RES_NO"));
                header.setMovementType(headerRet.getString("MOVE_TYPE"));
                header.setWbs(headerRet.getString("WBS_ELEM_E"));
                header.setCostCenter(headerRet.getString("COST_CTR"));
                header.setGoodsReceipt(headerRet.getString("GR_RCPT"));
                header.setNetwork(headerRet.getString("NETWORK"));
                header.setGlAccount(headerRet.getString("G_L_ACCT"));
                header.setInternalOrder(headerRet.getString("ORDER_NO"));
                header.setReqDate(LocalDate.parse(headerRet.getString("RES_DATE")));


            }

            System.out.println("SAP ITESM SIZE" + reservationItems.getNumRows() + "docType" + headerRet.getString("MOVE_TYPE"));

            List<EzcReservationItems> sapItems = new ArrayList<>();

            for (int i = 0; i < reservationItems.getNumRows(); i++) {
                reservationItems.setRow(i);
                addData.setRow(i);
                EzcReservationItems item = new EzcReservationItems();
                String itemNo = reservationItems.getString("RES_ITEM");
                String withdrawalQty = reservationItems.getString("WITHD_QUAN");
                String labStrgLoc="";
                String itemNOinAddData=addData.getString("RSPOS");
                System.out.print("itemNOinAddData"+itemNOinAddData);
                if(Integer.valueOf(itemNo)==Integer.valueOf(itemNOinAddData))
                    labStrgLoc=addData.getString("ZLGORT");


                if (header.getGoodsReceipt() == null || header.getGoodsReceipt().isEmpty())
                    header.setGoodsReceipt(reservationItems.getString("GR_RCPT"));

                System.out.print("itemNOinAddData"+itemNOinAddData+"labStrgLoc"+labStrgLoc+"goodrcpt"+reservationItems.getString("GR_RCPT"));
                item.setItemNo(Integer.valueOf(itemNo));
                item.setMaterial(reservationItems.getString("MATERIAL"));
                item.setShortText(reservationItems.getString("SHORT_TEXT"));
                item.setQty(reservationItems.getDouble("QUANTITY"));
                item.setWithDrawQty(Double.valueOf(withdrawalQty));
                item.setUom(reservationItems.getString("UNIT"));
                item.setStorageLoc(reservationItems.getString("STORE_LOC"));
                item.setBatch(reservationItems.getString("BATCH"));
                item.setMovementAllowed(reservationItems.getString("MOVEMENT"));
                item.setStorageLoc(reservationItems.getString("STORE_LOC"));
                item.setLabStorageLoc(labStrgLoc);
                item.setPlant(reservationItems.getString("PLANT"));
                BigDecimal withdrawalQtyBD = new BigDecimal(withdrawalQty);
                BigDecimal itemQtyBD = BigDecimal.valueOf(item.getQty());
                System.out.print("withdrawalQty"+withdrawalQtyBD+"item.getQty()"+itemQtyBD);
                if (withdrawalQtyBD.compareTo(itemQtyBD) == 0) {

                    item.setStatus("C");
                }
                else if(withdrawalQtyBD.compareTo(BigDecimal.ZERO) > 0  &&   withdrawalQtyBD.compareTo(itemQtyBD) < 0){
                    item.setStatus("P");
                }
                else if(withdrawalQtyBD.compareTo(BigDecimal.ZERO) == 0){
                    item.setStatus("O");
                }


                item.setHeader(header);

                sapItems.add(item);
            }
            System.out.print("SAP sapItems" + sapItems);
            if (!sapItems.isEmpty()) {
                header.setLineItems(sapItems);
            }

        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "SAP Error while reading Reservation: " + e.getMessage());
            return "errorPage";
        }

        System.out.print("SAP header" + header);
        List<EzcMasterData> plantList = masterRepo.findByEmdKey("PLANT");
        model.addAttribute("plants", plantList);
        model.addAttribute("costCenters", masterRepo.findByEmdKey("COSTCENTER"));
        model.addAttribute("glAccounts", masterRepo.findByEmdKey("GLACCOUNT"));
        model.addAttribute("movementTypes", getMovementTypes());

        model.addAttribute("reservation", header);


        return "reservation/editReservation"; // your edit page name
    }

    @PostMapping(value = "/reservation/update")
    @ResponseBody
    public ResponseEntity<?> updateReservation(@RequestBody ReservationDTO reservationDTO) {
        Map<String, Object> response = new HashMap<>();
        String reservationNo=reservationDTO.getReservationNo();

        try {
            System.out.print("Updating reservation in SAP: {}" + reservationDTO);

            Map<String, Object> result = reservationService.updateReservation(reservationDTO,reservationNo);
            boolean success = (boolean) result.get("success");
            System.out.println("result" + result);
            if (success) {
                return ResponseEntity.ok(result);
            } else {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(result);
            }

        } catch (Exception e) {
            log.error("Error creating reservation", e);

            e.printStackTrace();

            Map<String, Object> errorMap = new HashMap<>();
            errorMap.put("success", false);
            errorMap.put("errors", List.of(e.getMessage()));

            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorMap);
        }

    }
}