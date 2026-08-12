package com.ezc.aragenPR.webapp.dto.vendorreg;

import java.time.LocalDateTime;

/** One row of {@link com.ezc.aragenPR.webapp.model.vendorreg.VendorQuery} for display - see ezShowQuery2.jsp. */
public record VendorQueryEntry(
        Long id,
        String raisedBy,
        LocalDateTime raisedOn,
        String queryText,
        String repliedBy,
        LocalDateTime repliedOn,
        String replyText) {
}
