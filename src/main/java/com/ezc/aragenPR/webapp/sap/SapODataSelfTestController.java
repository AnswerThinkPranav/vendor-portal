package com.ezc.aragenPR.webapp.sap;

import com.fasterxml.jackson.databind.JsonNode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

/**
 * The "provision just for testing" for the generic SAP OData layer: drives the real
 * {@link SapODataClient} (the exact same class every genericXxx/odataXxx service method uses)
 * through a full CSRF-fetch + POST round trip against {@link MockSapODataController}, so the
 * client's handshake/parsing logic is proven correct over real HTTP before ever pointing it at a
 * real SAP Gateway. Gated by the same {@code sap.odata.mock.enabled} switch as the mock itself -
 * both are inert unless a dev box explicitly turns the mock on.
 */
@RestController
@RequestMapping("/mock-sap")
@ConditionalOnProperty(name = "sap.odata.mock.enabled", havingValue = "true")
public class SapODataSelfTestController {

    @Autowired
    private SapODataClient sapODataClient;

    @GetMapping("/self-test")
    public ResponseEntity<Map<String, Object>> selfTest() {
        String baseUrl = sapODataClient.getBaseUrl();
        try {
            JsonNode response = sapODataClient.post(baseUrl, "/API_SUPPLIER", "/API_SUPPLIER/A_Supplier",
                    Map.of("SupplierName", "SAP ODATA SELF TEST"));
            String supplier = response.path("d").path("Supplier").asText(null);
            boolean pass = supplier != null && !supplier.isBlank();
            return ResponseEntity.ok(Map.of(
                    "pass", pass,
                    "baseUrl", baseUrl,
                    "supplierReturned", supplier,
                    "rawResponse", response
            ));
        } catch (Exception e) {
            return ResponseEntity.ok(Map.of(
                    "pass", false,
                    "baseUrl", baseUrl,
                    "error", String.valueOf(e.getMessage())
            ));
        }
    }
}
