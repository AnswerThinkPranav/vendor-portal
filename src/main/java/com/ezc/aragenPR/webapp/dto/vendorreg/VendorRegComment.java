package com.ezc.aragenPR.webapp.dto.vendorreg;

import java.time.LocalDateTime;

/** One past comment logged against this registration (submit/forward/reject/etc.) - see getJGLDocComments / ezVendReg.jsp's read-only User/Date/Comments table. */
public record VendorRegComment(String userId, String userName, LocalDateTime date, String comments) {
}
