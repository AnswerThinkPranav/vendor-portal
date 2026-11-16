package com.ezc.aragenPR.webapp.sap;

import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseCookie;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * Stands in for a real SAP NetWeaver Gateway OData service, purely for exercising
 * {@link SapODataClient} end-to-end without needing an actual SAP connection. Off by default
 * (gated by {@code sap.odata.mock.enabled}) so it can never accidentally activate outside a dev
 * box. To use it: set
 * <pre>
 *   sap.odata.mock.enabled=true
 *   sap.odata.base-url=http://localhost:&lt;server.port&gt;/mock-sap
 *   sap.mode.VENDOR_CREATE=ODATA
 * </pre>
 * then exercise the real Vendor Registration "post to SAP" flow (or any other ODATA-mode
 * operation pointed at this same base URL) - it will hit this controller over real HTTP, go
 * through the real CSRF-token handshake {@link SapODataClient} performs, and get back a
 * plausible canned OData response, proving the whole client works before ever touching a real
 * SAP system. Flip both properties back (or just sap.mode.* back to FM) to return to the real
 * JCo path - nothing else in the app needs to change either way.
 */
@RestController
@RequestMapping("/mock-sap")
@ConditionalOnProperty(name = "sap.odata.mock.enabled", havingValue = "true")
public class MockSapODataController {

    private final Map<String, Boolean> issuedTokens = new ConcurrentHashMap<>();
    private int nextSupplierSeq = 100001;

    /**
     * CSRF "Fetch" handshake - real SAP Gateway services only honor this on a GET carrying the
     * X-CSRF-Token: Fetch header, replying with a fresh token + a session cookie that the
     * subsequent write must replay.
     */
    @GetMapping("/{service}")
    public ResponseEntity<Map<String, Object>> fetchToken(@PathVariable String service,
            @RequestHeader(value = "X-CSRF-Token", required = false) String csrfHeader) {
        if (!"Fetch".equalsIgnoreCase(csrfHeader)) {
            return ResponseEntity.ok(Map.of("d", Map.of("EntitySets", service)));
        }
        String token = UUID.randomUUID().toString();
        issuedTokens.put(token, Boolean.TRUE);
        ResponseCookie sessionCookie = ResponseCookie.from("sap-mock-session", UUID.randomUUID().toString())
                .path("/mock-sap")
                .build();
        return ResponseEntity.ok()
                .header("X-CSRF-Token", token)
                .header("Set-Cookie", sessionCookie.toString())
                .body(Map.of("d", Map.of("EntitySets", service)));
    }

    /**
     * Canned "create" response for /mock-sap/API_SUPPLIER/A_Supplier (or any other entity path -
     * the path itself is ignored, this always returns a fresh fake supplier number), rejecting
     * the call with 403 if the token from fetchToken() wasn't replayed, exactly like real SAP.
     */
    @PostMapping("/API_SUPPLIER/A_Supplier")
    public ResponseEntity<Map<String, Object>> createSupplier(
            @RequestHeader(value = "X-CSRF-Token", required = false) String csrfHeader,
            @RequestBody(required = false) Map<String, Object> body) {
        if (csrfHeader == null || !issuedTokens.containsKey(csrfHeader)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(Map.of("error", Map.of("message", Map.of("value", "CSRF token validation failed"))));
        }
        String supplierCode = String.valueOf(nextSupplierSeq++);
        return ResponseEntity.ok(Map.of("d", Map.of(
                "Supplier", supplierCode,
                "SupplierName", body == null ? "" : String.valueOf(body.getOrDefault("SupplierName", "")),
                "echo", body == null ? Map.of() : body
        )));
    }
}
