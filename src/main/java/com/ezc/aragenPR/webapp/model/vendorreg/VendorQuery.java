package com.ezc.aragenPR.webapp.model.vendorreg;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

import lombok.Data;

/**
 * A buyer-raised query on a vendor registration that blocks further workflow action until
 * the vendor replies - see ezVendReg.jsp's "Query" button / ezShowQuery2.jsp / the "* Query
 * has not been replied..." banner. Simplified from the legacy EZC_QCF_COMMENTS
 * EQC_QUERY_MAP-summed-counter threading (which tracks reply status via a signed-integer
 * sum across a comment group) down to one row per query with a nullable reply - equivalent
 * blocking behavior (open = repliedOn IS NULL), far simpler to reason about.
 */
@Entity
@Table(name = "ezc_vendor_query")
@Data
public class VendorQuery {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "EVQ_DOC_ID", length = 10, nullable = false)
    private String docId;

    @Column(name = "EVQ_RAISED_BY", length = 10, nullable = false)
    private String raisedBy;

    @Column(name = "EVQ_RAISED_ON", nullable = false)
    private LocalDateTime raisedOn;

    @Column(name = "EVQ_QUERY_TEXT", length = 1000, nullable = false)
    private String queryText;

    @Column(name = "EVQ_REPLIED_BY", length = 10)
    private String repliedBy;

    @Column(name = "EVQ_REPLIED_ON")
    private LocalDateTime repliedOn;

    @Column(name = "EVQ_REPLY_TEXT", length = 1000)
    private String replyText;
}
