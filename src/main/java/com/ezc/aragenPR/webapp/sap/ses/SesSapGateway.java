package com.ezc.aragenPR.webapp.sap.ses;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.ezc.aragenPR.webapp.model.user.Users;
import com.ezc.aragenPR.webapp.sap.SapIntegrationMode;
import com.ezc.aragenPR.webapp.sap.SapIntegrationModeConfig;
import com.ezc.aragenPR.webapp.sap.SapOperationCode;
import com.ezc.aragenPR.webapp.service.shared.RFCReadSAPService;
import com.sap.conn.jco.JCoContext;
import com.sap.conn.jco.JCoDestination;
import com.sap.conn.jco.JCoException;
import com.sap.conn.jco.JCoFunction;
import com.sap.conn.jco.JCoRepository;
import com.sap.conn.jco.JCoTable;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

/**
 * The actual SAP I/O for Service Entry Sheet release - moved out of
 * {@code service.ses.SESService} (which now only calls this gateway). Switchable per
 * {@code sap.mode.SES_RELEASE} (see {@link SapIntegrationModeConfig}).
 */
@Slf4j
@Component
public class SesSapGateway implements ISesSapGateway {

    @Autowired
    private RFCReadSAPService rfcReadSAPService;

    @Autowired
    private SapIntegrationModeConfig sapIntegrationModeConfig;

    @Override
    public Map<String, Object> releaseServiceEntrySheet(String sesNumber) {
        SapIntegrationMode mode = sapIntegrationModeConfig.effectiveMode(SapOperationCode.SES_RELEASE);
        log.info("[SAP] SES_RELEASE for {} via {}", sesNumber, mode);
        return switch (mode) {
            case FM -> fmReleaseServiceEntrySheet(sesNumber);
            case ODATA -> odataReleaseServiceEntrySheet(sesNumber);
        };
    }

    // ---- FM (JCo / standard BAPI) - moved verbatim from SESService ---------------------------

    private Map<String, Object> fmReleaseServiceEntrySheet(String sesNumber) {
        try {
            Map<String, Object> response = new HashMap<>();
            JCoDestination destination = rfcReadSAPService.getDestination();
            JCoRepository repository = destination.getRepository();
            JCoFunction function = repository.getFunction("BAPI_ENTRYSHEET_RELEASE");

            if (function == null) {
                throw new RuntimeException("BAPI_ENTRYSHEET_RELEASE not found in SAP.");
            }
            String uName = "";
            try {
                Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
                Users userObj = (Users) authentication.getPrincipal();
                uName = userObj.getUserId();
            } catch (Exception e) {
            }

            function.getImportParameterList().setValue("ENTRYSHEET", sesNumber);
            String releaseCode = fmGetReleaseCode(uName);
            if (releaseCode != null && !releaseCode.isEmpty()) {
                function.getImportParameterList().setValue("REL_CODE", releaseCode);
            }

            JCoContext.begin(destination);
            function.execute(destination);
            JCoContext.end(destination);

            JCoTable returnTable = function.getTableParameterList().getTable("RETURN");
            List<String> messages = new ArrayList<>();
            String status = "SUCCESS";
            for (int i = 0; i < returnTable.getNumRows(); i++) {
                returnTable.setRow(i);
                String type = returnTable.getString("TYPE");
                String message = returnTable.getString("MESSAGE");
                messages.add(type + " - " + message);
                if ("E".equals(type) || "A".equals(type)) {
                    status = "FAILED";
                }
            }

            response.put("status", status);
            response.put("messages", messages);
            return response;
        } catch (JCoException e) {
            throw new RuntimeException("SAP (FM) SES release failed: " + e.getMessage(), e);
        }
    }

    /** ZEZ_PR_USER_DATA (same FM shared with SapOperationCode.PR_USER_DATA elsewhere). */
    private String fmGetReleaseCode(String userName) {
        try {
            JCoDestination destination = rfcReadSAPService.getDestination();
            JCoRepository repository = destination.getRepository();
            JCoFunction function = repository.getFunction("ZEZ_PR_USER_DATA");
            if (function == null) {
                throw new RuntimeException("ZEZ_PR_USER_DATA not found in SAP.");
            }

            function.getImportParameterList().setValue("S_UNAME", userName);
            function.getImportParameterList().setValue("PR_REL_STRATEGY", "");
            function.getImportParameterList().setValue("PR_SE_REL_STRATEGY", "X");

            JCoContext.begin(destination);
            function.execute(destination);
            JCoContext.end(destination);

            JCoTable returnTable = function.getTableParameterList().getTable("PR_USER_DATA_SE");
            String relCode = "";
            for (int i = 0; i < returnTable.getNumRows(); i++) {
                returnTable.setRow(i);
                relCode = returnTable.getString("FRGC1");
            }
            return relCode;
        } catch (JCoException e) {
            throw new RuntimeException("SAP (FM) release-code lookup failed: " + e.getMessage(), e);
        }
    }

    // ---- OData - not configured yet, fails loudly rather than guessing an endpoint ----------

    private Map<String, Object> odataReleaseServiceEntrySheet(String sesNumber) {
        String service = sapIntegrationModeConfig.odataServiceName(SapOperationCode.SES_RELEASE);
        if (service == null) {
            throw new IllegalStateException("sap.odata.service.SES_RELEASE is not configured - "
                    + "set it once the real service name is confirmed, or switch sap.mode.SES_RELEASE=FM");
        }
        throw new UnsupportedOperationException("OData SES_RELEASE not implemented yet");
    }
}
