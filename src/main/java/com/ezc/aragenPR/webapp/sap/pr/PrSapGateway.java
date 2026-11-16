package com.ezc.aragenPR.webapp.sap.pr;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.ezc.aragenPR.webapp.model.pr.EzPurchaseRequisitionHeader;
import com.ezc.aragenPR.webapp.model.pr.EzPurchaseRequisitionItems;
import com.ezc.aragenPR.webapp.model.pr.EzPurchaseRequisitionServices;
import com.ezc.aragenPR.webapp.sap.SapIntegrationMode;
import com.ezc.aragenPR.webapp.sap.SapIntegrationModeConfig;
import com.ezc.aragenPR.webapp.sap.SapOperationCode;
import com.ezc.aragenPR.webapp.service.shared.RFCReadSAPService;
import com.sap.conn.jco.JCoContext;
import com.sap.conn.jco.JCoDestination;
import com.sap.conn.jco.JCoParameterList;
import com.sap.conn.jco.JCoRepository;
import com.sap.conn.jco.JCoStructure;
import com.sap.conn.jco.JCoTable;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * The actual SAP I/O for Purchase Requisitions - migration in progress, see
 * {@link IPrSapGateway}'s javadoc for what's moved here vs. still inline in
 * {@code controller.pr.PRController}. Switchable per {@code sap.mode.PR_GETDETAIL} etc. (see
 * {@link SapIntegrationModeConfig}).
 */
@Slf4j
@Component
public class PrSapGateway implements IPrSapGateway {

    @Autowired
    private RFCReadSAPService rfcReadSAPService;

    @Autowired
    private SapIntegrationModeConfig sapIntegrationModeConfig;

    @Override
    public void getPrDetail(String reqNumber, EzPurchaseRequisitionHeader header) {
        SapIntegrationMode mode = sapIntegrationModeConfig.effectiveMode(SapOperationCode.PR_GETDETAIL);
        log.info("[SAP] PR_GETDETAIL for {} via {}", reqNumber, mode);
        switch (mode) {
            case FM -> fmGetPrDetail(reqNumber, header);
            case ODATA -> odataGetPrDetail(reqNumber, header);
        }
    }

    // ---- FM (JCo / Z-RFC) - moved verbatim from PRController.editPR -------------------------

    private void fmGetPrDetail(String reqNumber, EzPurchaseRequisitionHeader header) {
        try {
            JCoDestination destination = rfcReadSAPService.getDestination();
            JCoRepository repository = destination.getRepository();
            com.sap.conn.jco.JCoFunction poFunction = repository.getFunction("ZEZ_BAPI_PR_GETDETAIL");

            if (poFunction == null) {
                throw new RuntimeException("ZEZ_BAPI_PR_GETDETAIL not found");
            }
            JCoParameterList imports = poFunction.getImportParameterList();
            imports.setValue("NUMBER", reqNumber);
            imports.setValue("ACCOUNT_ASSIGNMENT", "X");

            try {
                JCoContext.begin(destination);
                poFunction.execute(destination);
                JCoContext.end(destination);
            } catch (Exception e) {
            }

            JCoStructure headerRet = poFunction.getExportParameterList().getStructure("PRHEADER");
            JCoTable prItems = poFunction.getTableParameterList().getTable("PRITEM");
            JCoTable prAcc = poFunction.getTableParameterList().getTable("PRACCOUNT");
            JCoTable prAddData = poFunction.getTableParameterList().getTable("ADDITIONAL_DATA");

            if (headerRet != null) {
                header.setReqNumber(reqNumber);
                header.setDocType(headerRet.getString("PR_TYPE"));
            }

            List<EzPurchaseRequisitionItems> sapItems = new ArrayList<>();

            for (int i = 0; i < prItems.getNumRows(); i++) {
                prItems.setRow(i);

                EzPurchaseRequisitionItems item = new EzPurchaseRequisitionItems();
                String itemNo = prItems.getString("PREQ_ITEM");

                item.setItemNO(itemNo);
                item.setMatNumber(prItems.getString("MATERIAL"));
                item.setShortText(prItems.getString("SHORT_TEXT"));
                item.setQuantity(prItems.getBigDecimal("QUANTITY"));
                item.setUom(prItems.getString("UNIT"));
                item.setValPrice(prItems.getBigDecimal("PREQ_PRICE"));
                item.setMaterialGroup(prItems.getString("MATL_GROUP"));
                item.setDelInd(prItems.getString("DELETE_IND"));
                item.setRelStatus(prItems.getString("PROC_STAT"));
                item.setAgreement(prItems.getString("AGREEMENT") + "#" + prItems.getString("FIXED_VEND") + "#"
                        + prItems.getString("AGMT_ITEM"));
                item.setAggrItem(prItems.getString("AGMT_ITEM"));
                item.setFixVendor(prItems.getString("FIXED_VEND"));
                String delivStr = prItems.getString("DELIV_DATE");
                if (delivStr != null && !delivStr.isBlank()) {
                    try {
                        SimpleDateFormat sapFmt = new SimpleDateFormat("yyyy-MM-dd");
                        Date delivDate = sapFmt.parse(delivStr.trim());
                        item.setDeliveryDate(delivDate);
                    } catch (Exception e) {
                        log.debug("Failed to parse delivery date: " + delivStr);
                    }
                }
                item.setPlant(prItems.getString("PLANT"));
                item.setStorageLoc(prItems.getString("STORE_LOC"));
                item.setTrackNo(prItems.getString("TRACKINGNO"));
                item.setItemCat(prItems.getString("ITEM_CAT"));

                prAcc.firstRow();
                for (int j = 0; j < prAcc.getNumRows(); j++, prAcc.nextRow()) {
                    if (prAcc.getString("PREQ_ITEM").equals(itemNo)) {
                        item.setWbsElement(prAcc.getString("WBS_ELEMENT"));
                        item.setCostCenter(prAcc.getString("COSTCENTER"));
                        item.setInternalOrder(prAcc.getString("ORDERID"));
                        break;
                    }
                }
                prAddData.firstRow();
                for (int j = 0; j < prAddData.getNumRows(); j++, prAddData.nextRow()) {
                    if (prAddData.getString("PREQ_ITEM").equals(itemNo)) {
                        item.setCoa(prAddData.getString("ZZCOA"));
                        item.setMsds(prAddData.getString("ZZMSDS"));
                        item.setPackSize(removeLeadingZeros(prAddData.getString("ZZPACK")));
                        item.setPassThrough(prAddData.getString("ZZPASS"));
                        if (header.getDept() == null || header.getDept().isEmpty()) {
                            header.setDept(prAddData.getString("ZZDEPT"));
                        }
                        if (header.getDivision() == null || header.getDivision().isEmpty()) {
                            header.setDivision(prAddData.getString("ZZBU"));
                        }
                        break;
                    }
                }

                if (header.getPurGrp() == null || header.getPurGrp().isEmpty()) {
                    header.setPurGrp(prItems.getString("PUR_GROUP"));
                }
                if (header.getPlant() == null || header.getPlant().isEmpty()) {
                    header.setPlant(item.getPlant());
                }
                if (header.getAccAsmt() == null || header.getAccAsmt().isEmpty()) {
                    header.setAccAsmt(prItems.getString("ACCTASSCAT"));
                }
                if (header.getItemCat() == null || header.getItemCat().isEmpty()) {
                    header.setItemCat(prItems.getString("ITEM_CAT"));
                }
                item.setHeader(header);

                sapItems.add(item);
            }
            if (!sapItems.isEmpty()) {
                header.setItems(sapItems);
            }
        } catch (Exception e) {
            throw new RuntimeException("SAP (FM) PR GETDETAIL failed: " + e.getMessage(), e);
        }
    }

    @Override
    public void getServicePrDetail(String reqNumber, EzPurchaseRequisitionHeader header) {
        SapIntegrationMode mode = sapIntegrationModeConfig.effectiveMode(SapOperationCode.PR_GETDETAIL);
        log.info("[SAP] PR_GETDETAIL (service) for {} via {}", reqNumber, mode);
        switch (mode) {
            case FM -> fmGetServicePrDetail(reqNumber, header);
            case ODATA -> odataGetPrDetail(reqNumber, header);
        }
    }

    // ---- FM (JCo / Z-RFC) - moved verbatim from PRController.editServicePR ------------------

    private void fmGetServicePrDetail(String reqNumber, EzPurchaseRequisitionHeader header) {
        try {
            JCoDestination destination = rfcReadSAPService.getDestination();
            JCoRepository repository = destination.getRepository();
            com.sap.conn.jco.JCoFunction poFunction = repository.getFunction("ZEZ_BAPI_PR_GETDETAIL");

            if (poFunction == null) {
                throw new RuntimeException("ZEZ_BAPI_PR_GETDETAIL not found");
            }

            JCoParameterList imports = poFunction.getImportParameterList();
            imports.setValue("NUMBER", reqNumber);
            imports.setValue("ACCOUNT_ASSIGNMENT", "X");
            imports.setValue("SERVICES", "X");

            try {
                JCoContext.begin(destination);
                poFunction.execute(destination);
                JCoContext.end(destination);
            } catch (Exception e) {
            }

            JCoStructure headerRet = poFunction.getExportParameterList().getStructure("PRHEADER");
            JCoTable prItems = poFunction.getTableParameterList().getTable("PRITEM");
            JCoTable prAcc = poFunction.getTableParameterList().getTable("PRACCOUNT");
            JCoTable prAddData = poFunction.getTableParameterList().getTable("ADDITIONAL_DATA");
            JCoTable prServiceLines = poFunction.getTableParameterList().getTable("SERVICELINES");

            if (headerRet != null) {
                header.setReqNumber(reqNumber);
                header.setDocType(headerRet.getString("PR_TYPE"));
            }

            List<EzPurchaseRequisitionItems> sapItems = new ArrayList<>();

            for (int i = 0; i < prItems.getNumRows(); i++) {
                prItems.setRow(i);

                EzPurchaseRequisitionItems item = new EzPurchaseRequisitionItems();
                String itemNo = prItems.getString("PREQ_ITEM");

                item.setItemNO(itemNo);
                item.setMatNumber(prItems.getString("MATERIAL"));
                item.setShortText(prItems.getString("SHORT_TEXT"));
                item.setQuantity(prItems.getBigDecimal("QUANTITY"));
                item.setUom(prItems.getString("UNIT"));
                item.setValPrice(prItems.getBigDecimal("PREQ_PRICE"));
                item.setMaterialGroup(prItems.getString("MATL_GROUP"));

                String delivStr = prItems.getString("DELIV_DATE");
                if (delivStr != null && !delivStr.isBlank()) {
                    try {
                        SimpleDateFormat sapFmt = new SimpleDateFormat("yyyy-MM-dd");
                        Date delivDate = sapFmt.parse(delivStr.trim());
                        item.setDeliveryDate(delivDate);
                    } catch (Exception e) {
                        log.debug("Failed to parse delivery date: " + delivStr);
                    }
                }

                item.setPlant(prItems.getString("PLANT"));
                item.setStorageLoc(prItems.getString("STORE_LOC"));
                item.setTrackNo(prItems.getString("TRACKINGNO"));
                item.setItemCat(prItems.getString("ITEM_CAT"));

                prAcc.firstRow();
                for (int j = 0; j < prAcc.getNumRows(); j++, prAcc.nextRow()) {
                    if (prAcc.getString("PREQ_ITEM").equals(itemNo)) {
                        item.setWbsElement(prAcc.getString("WBS_ELEMENT"));
                        item.setCostCenter(prAcc.getString("COSTCENTER"));
                        item.setInternalOrder(prAcc.getString("ORDERID"));
                        break;
                    }
                }

                prAddData.firstRow();
                for (int j = 0; j < prAddData.getNumRows(); j++, prAddData.nextRow()) {
                    if (prAddData.getString("PREQ_ITEM").equals(itemNo)) {
                        item.setCoa(prAddData.getString("ZZCOA"));
                        item.setMsds(prAddData.getString("ZZMSDS"));
                        item.setPassThrough(prAddData.getString("ZZPASS"));
                        if (header.getDept() == null || header.getDept().isEmpty()) {
                            header.setDept(prAddData.getString("ZZDEPT"));
                        }
                        if (header.getDivision() == null || header.getDivision().isEmpty()) {
                            header.setDivision(prAddData.getString("ZZBU"));
                        }
                        break;
                    }
                }

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
                    }
                }
                item.setServices(serviceList);

                if (header.getPurGrp() == null || header.getPurGrp().isEmpty()) {
                    header.setPurGrp(prItems.getString("PUR_GROUP"));
                }
                if (header.getPlant() == null || header.getPlant().isEmpty()) {
                    header.setPlant(prItems.getString("PLANT"));
                }
                if (header.getAccAsmt() == null || header.getAccAsmt().isEmpty()) {
                    header.setAccAsmt(prItems.getString("ACCTASSCAT"));
                }
                if (header.getItemCat() == null || header.getItemCat().isEmpty()) {
                    header.setItemCat(prItems.getString("ITEM_CAT"));
                }

                item.setHeader(header);
                sapItems.add(item);
            }
            if (!sapItems.isEmpty()) {
                header.setItems(sapItems);
            }
        } catch (Exception e) {
            throw new RuntimeException("SAP (FM) Service PR GETDETAIL failed: " + e.getMessage(), e);
        }
    }

    private String removeLeadingZeros(String value) {
        if (value == null) {
            return "";
        }
        return value.replaceFirst("^0+(?!$)", "");
    }

    // ---- OData - not configured yet, fails loudly rather than guessing an endpoint ----------

    private void odataGetPrDetail(String reqNumber, EzPurchaseRequisitionHeader header) {
        String service = sapIntegrationModeConfig.odataServiceName(SapOperationCode.PR_GETDETAIL);
        if (service == null) {
            throw new IllegalStateException("sap.odata.service.PR_GETDETAIL is not configured - "
                    + "set it once the real service name is confirmed, or switch sap.mode.PR_GETDETAIL=FM");
        }
        throw new UnsupportedOperationException("OData PR_GETDETAIL not implemented yet");
    }
}
