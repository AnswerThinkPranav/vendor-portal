package com.ezc.aragenPR.webapp.dto.vendorreg;

import java.util.List;

/** Result of the SAP vendor-master pre-validation call (Z_RFC_VENDOR_VALIDATE) - see ezPrePostVendorToSAP.jsp. */
public record SapValidationResult(boolean ok, List<String> messages) {
}
