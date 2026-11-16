package com.ezc.aragenPR.webapp.sap.material;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import com.ezc.aragenPR.webapp.dto.pr.MaterialDto;
import com.ezc.aragenPR.webapp.sap.SapIntegrationMode;
import com.ezc.aragenPR.webapp.sap.SapIntegrationModeConfig;
import com.ezc.aragenPR.webapp.sap.SapODataClient;
import com.ezc.aragenPR.webapp.sap.SapOperationCode;
import com.ezc.aragenPR.webapp.service.shared.RFCReadSAPService;
import com.sap.conn.jco.JCoContext;
import com.sap.conn.jco.JCoDestination;
import com.sap.conn.jco.JCoException;
import com.sap.conn.jco.JCoFunction;
import com.sap.conn.jco.JCoParameterList;
import com.sap.conn.jco.JCoRepository;
import com.sap.conn.jco.JCoStructure;
import com.sap.conn.jco.JCoTable;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * The actual SAP I/O for material search/detail - moved out of {@code PRController} (which now
 * only builds the HTTP request/response and calls this gateway for the SAP part). Switchable per
 * {@code sap.mode.MATERIAL_SEARCH}/{@code MATERIAL_GETDETAIL} (see {@link SapIntegrationModeConfig}).
 */
@Slf4j
@Component
public class MaterialSapGateway implements IMaterialSapGateway {

    @Autowired
    private RFCReadSAPService rfcReadSAPService;

    @Autowired
    private SapIntegrationModeConfig sapIntegrationModeConfig;

    @Autowired
    private SapODataClient sapODataClient;

    @Override
    public List<MaterialDto> searchMaterials(String plant, String query, String searchType) {
        SapIntegrationMode mode = sapIntegrationModeConfig.effectiveMode(SapOperationCode.MATERIAL_SEARCH);
        log.info("[SAP] MATERIAL_SEARCH for plant {} via {}", plant, mode);
        return switch (mode) {
            case FM -> fmSearchMaterials(plant, query, searchType);
            case ODATA -> odataSearchMaterials(plant, query, searchType);
        };
    }

    @Override
    public List<MaterialDto> getMaterialDetails(String plant, String materialCode) {
        SapIntegrationMode mode = sapIntegrationModeConfig.effectiveMode(SapOperationCode.MATERIAL_GETDETAIL);
        log.info("[SAP] MATERIAL_GETDETAIL for {} via {}", materialCode, mode);
        return switch (mode) {
            case FM -> fmGetMaterialDetails(plant, materialCode);
            case ODATA -> odataGetMaterialDetails(plant, materialCode);
        };
    }

    // ---- FM (JCo / standard BAPI) - moved verbatim from PRController ------------------------

    private List<MaterialDto> fmSearchMaterials(String plant, String query, String searchType) {
        List<MaterialDto> materials = new ArrayList<>();
        try {
            JCoDestination destination = rfcReadSAPService.getDestination();
            JCoRepository repository = destination.getRepository();
            JCoFunction poFunction = repository.getFunction("BAPI_MATERIAL_GETLIST");

            try {
                if ("shortText".equals(searchType)) {
                    JCoTable matShortDescSel = poFunction.getTableParameterList().getTable("MATERIALSHORTDESCSEL");
                    matShortDescSel.appendRow();
                    matShortDescSel.setValue("SIGN", "I");
                    matShortDescSel.setValue("OPTION", "CP");
                    matShortDescSel.setValue("DESCR_LOW", query + "*");
                }
                if ("matNumber".equals(searchType)) {
                    JCoTable matnrSel = poFunction.getTableParameterList().getTable("MATNRSELECTION");
                    matnrSel.appendRow();
                    matnrSel.setValue("SIGN", "I");
                    matnrSel.setValue("OPTION", "CP");
                    matnrSel.setValue("MATNR_LOW", "*" + query);
                }
            } catch (Exception execEx) {
                log.debug("start 123: " + execEx.getMessage());
            }

            JCoTable plantSel = poFunction.getTableParameterList().getTable("PLANTSELECTION");
            plantSel.appendRow();
            plantSel.setValue("SIGN", "I");
            plantSel.setValue("OPTION", "EQ");
            plantSel.setValue("PLANT_LOW", plant);

            try {
                JCoContext.begin(destination);
                poFunction.execute(destination);
                JCoContext.end(destination);
            } catch (Exception e) {
            }

            JCoTable matListTable = poFunction.getTableParameterList().getTable("MATNRLIST");
            try {
                if (matListTable != null && matListTable.getNumRows() > 0) {
                    do {
                        MaterialDto m1 = new MaterialDto();
                        String rawCode = (String) matListTable.getValue("MATERIAL");
                        String trimmedCode = rawCode != null ? rawCode.replaceFirst("^0+(?!$)", "") : "";
                        m1.setMaterialCode(trimmedCode);
                        m1.setDescription((String) matListTable.getValue("MATL_DESC"));
                        materials.add(m1);
                    } while (matListTable.nextRow());
                }
            } catch (Exception e) {
                log.debug("Exception in output " + e);
            }
        } catch (JCoException e) {
            log.debug("Error connecting to SAP: " + e.getMessage());
        }
        return materials;
    }

    private List<MaterialDto> fmGetMaterialDetails(String plant, String materialCode) {
        List<MaterialDto> materials = new ArrayList<>();
        try {
            JCoDestination destination = rfcReadSAPService.getDestination();
            JCoRepository repository = destination.getRepository();
            JCoFunction poFunction = repository.getFunction("BAPI_MATERIAL_GET_DETAIL");

            JCoParameterList importParams = poFunction.getImportParameterList();
            importParams.setValue("MATERIAL", String.format("%018d", Long.parseLong(materialCode)));
            importParams.setValue("PLANT", plant);
            importParams.setValue("VALUATIONAREA", plant);

            try {
                JCoContext.begin(destination);
                poFunction.execute(destination);
                JCoContext.end(destination);
            } catch (Exception e) {
            }

            JCoStructure returnStruct = poFunction.getExportParameterList().getStructure("RETURN");
            if (returnStruct != null && !"".equals(returnStruct.getString("MESSAGE"))) {
                String returnType = returnStruct.getString("TYPE");
                String returnMsg = returnStruct.getString("MESSAGE");
                if ("E".equals(returnType) || "A".equals(returnType)) {
                    log.debug("Error returned by BAPI_MATERIAL_GET_DETAIL: " + returnMsg);
                }
            }

            JCoParameterList exportParams = poFunction.getExportParameterList();
            JCoStructure generalData = exportParams.getStructure("MATERIAL_GENERAL_DATA");
            JCoStructure valuationData = exportParams.getStructure("MATERIALVALUATIONDATA");

            String matDesc = generalData.getString("MATL_DESC");
            String matGrp = generalData.getString("MATL_GROUP");
            String matUom = generalData.getString("BASE_UOM");
            String valPrice = "0";
            try {
                Object valObj = valuationData.getValue("MOVING_PR");
                if (valObj instanceof BigDecimal) {
                    valPrice = ((BigDecimal) valObj).setScale(2, java.math.RoundingMode.HALF_UP).toString();
                } else if (valObj != null) {
                    valPrice = new BigDecimal(valObj.toString()).setScale(2, java.math.RoundingMode.HALF_UP).toString();
                }
            } catch (Exception ex) {
                log.debug("Error processing MOVING_PR: " + ex.getMessage());
            }

            // Supplementary lookup for custom MARA fields (CAS number / catalog) - same
            // RFC_READ_TABLE path as every other generic master-data read in this app.
            String casNO = "";
            String catlogNO = "";
            try {
                String materialPass = String.format("%018d", Long.parseLong(materialCode));
                String[] outputFields = {"ZZCAS_NO", "ZCATNO", "ZMAN", "ZZBRAND"};
                String[] queryValues = {"MATNR EQ '" + materialPass + "'"};
                List<String[]> dataList = rfcReadSAPService.readRFCTable("MARA", outputFields, queryValues);
                if (dataList != null) {
                    for (String[] row : dataList) {
                        casNO = row[0];
                        catlogNO = row[1];
                    }
                }
            } catch (Exception e) {
            }

            MaterialDto m1 = new MaterialDto();
            m1.setMaterialCode(materialCode);
            m1.setDescription(matDesc);
            m1.setMaterialGroup(matGrp);
            m1.setUom(matUom);
            m1.setUnitPrice(valPrice);
            m1.setCasNo(casNO);
            m1.setCatalog(catlogNO);
            materials.add(m1);
        } catch (Exception e1) {
            log.debug("Exception while preparing or executing BAPI_MATERIAL_GET_DETAIL: " + e1.getMessage());
        }
        return materials;
    }

    // ---- OData - not configured yet, fails loudly rather than guessing an endpoint ----------

    private List<MaterialDto> odataSearchMaterials(String plant, String query, String searchType) {
        requireODataService(SapOperationCode.MATERIAL_SEARCH);
        throw new UnsupportedOperationException("OData MATERIAL_SEARCH not implemented yet");
    }

    private List<MaterialDto> odataGetMaterialDetails(String plant, String materialCode) {
        requireODataService(SapOperationCode.MATERIAL_GETDETAIL);
        throw new UnsupportedOperationException("OData MATERIAL_GETDETAIL not implemented yet");
    }

    private String requireODataService(String operationCode) {
        String service = sapIntegrationModeConfig.odataServiceName(operationCode);
        if (service == null) {
            throw new IllegalStateException("sap.odata.service." + operationCode + " is not configured - "
                    + "set it once the real service name is confirmed (Business Accelerator Hub), or "
                    + "switch sap.mode." + operationCode + "=FM");
        }
        return service;
    }
}
