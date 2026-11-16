package com.ezc.aragenPR.webapp.sap;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.env.Environment;

/**
 * Resolves which transport ({@link SapIntegrationMode}) each SAP operation
 * ({@link SapOperationCode}) should use, from {@code sap.mode.<OPERATION_CODE>} in
 * sap.properties (overridable per-environment the same way every other sap.* value already is -
 * via an uncommitted application-prod.properties).
 *
 * Default is ODATA for every operation with no explicit {@code sap.mode.*} entry - OData is the
 * intended path everywhere, FM is the explicit fallback. But defaulting to ODATA is only safe
 * when a real {@code sap.odata.service.<OPERATION_CODE>} name has actually been confirmed and
 * configured (see SapOperationCode's javadoc - most of those are still empty, deliberately, since
 * the real service names for the 19 custom Z-functions can only come from the client's own
 * Gateway catalog, never guessed). So {@link #effectiveMode} treats "ODATA but no service name
 * configured yet" as FM, with a log line, rather than crashing or silently guessing a path - this
 * is what makes "OData by default" safe to ship today instead of breaking every unconfigured
 * operation.
 *
 * This is the single switch point each generic*() method (e.g.
 * {@code VendorSapPostingServiceImpl.genericVendorRegistration}) checks before choosing between
 * its fm*()/odata*() implementation - see that class for the pattern.
 */
@Slf4j
@Configuration
@PropertySource("classpath:sap.properties")
public class SapIntegrationModeConfig {

    @Autowired
    private Environment env;

    /** Raw configured mode, ignoring whether an OData service name actually exists yet. */
    public SapIntegrationMode resolve(String operationCode) {
        String configured = env.getProperty("sap.mode." + operationCode);
        if (configured == null || configured.isBlank()) {
            return SapIntegrationMode.ODATA;
        }
        try {
            return SapIntegrationMode.valueOf(configured.trim().toUpperCase());
        } catch (IllegalArgumentException ex) {
            throw new IllegalStateException("Invalid sap.mode." + operationCode + "=" + configured
                    + " - expected FM or ODATA");
        }
    }

    /** The OData service/entity-set name for this operation, or null if not yet configured. */
    public String odataServiceName(String operationCode) {
        String value = env.getProperty("sap.odata.service." + operationCode);
        return (value == null || value.isBlank()) ? null : value.trim();
    }

    /**
     * What a genericXxx() dispatcher should actually use: resolve() says ODATA, but if no
     * service name is configured for this operation yet, fall back to FM automatically (logged
     * once per call) instead of either crashing or guessing an endpoint.
     */
    public SapIntegrationMode effectiveMode(String operationCode) {
        SapIntegrationMode configured = resolve(operationCode);
        if (configured == SapIntegrationMode.ODATA && odataServiceName(operationCode) == null) {
            log.warn("[SAP] {} defaulted to ODATA but sap.odata.service.{} is not configured yet - "
                    + "falling back to FM until the real service name is confirmed (Business "
                    + "Accelerator Hub for standard operations, the client's own Gateway catalog "
                    + "for custom Z-functions) and set.", operationCode, operationCode);
            return SapIntegrationMode.FM;
        }
        return configured;
    }

    public boolean isOdata(String operationCode) {
        return effectiveMode(operationCode) == SapIntegrationMode.ODATA;
    }
}
