package com.ezc.aragenPR.webapp.dto.rfq;

import java.time.LocalDateTime;

/** One query/reply pair on a QCF - see ezShowQuery2.jsp / VendorQueryEntry for the equivalent on Vendor Registration. */
public record QcfQueryEntry(Long id, String raisedBy, LocalDateTime raisedOn, String queryText,
        String repliedBy, LocalDateTime repliedOn, String replyText) {
}
