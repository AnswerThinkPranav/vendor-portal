package com.ezc.aragenPR.webapp.repository.rfq;

import java.util.List;
import java.util.Optional;

import com.ezc.aragenPR.webapp.dto.rfq.QcfSummaryProjection;
import com.ezc.aragenPR.webapp.model.rfq.RfqHeader;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface RfqHeaderRepository extends JpaRepository<RfqHeader, String>, JpaSpecificationExecutor<RfqHeader> {

    List<RfqHeader> findByCollectiveRfqNo(String collectiveRfqNo);

    /**
     * Locks the whole table for the duration of the caller's transaction while reading
     * the current max RFQ number, so two concurrent "Create RFQ" submissions can't be
     * assigned the same number - the legacy JSP's read-then-insert (a fresh
     * "SELECT MAX(ERH_RFQ_NO)+1" per vendor, in a loop, with no locking at all) was a
     * real race condition; this fixes it. Falls back to 7000000001 to match the
     * legacy default when the table is empty.
     */
    @Query(value = "SELECT CAST(MAX(ERH_RFQ_NO) AS UNSIGNED) FROM ezc_rfq_header FOR UPDATE", nativeQuery = true)
    Optional<Long> lockMaxRfqNo();

    @Query(value = "SELECT MAX(SUBSTRING(ERH_COLLETIVE_RFQ_NO, LENGTH(:purGrp) + 1, 10)) "
            + "FROM ezc_rfq_header WHERE ERH_PUR_GRP = :purGrp FOR UPDATE", nativeQuery = true)
    Optional<String> lockMaxCollectiveRfqSuffix(@Param("purGrp") String purGrp);

    /**
     * "New" QCFs (ezListQcfs.jsp type=New) - QCFs where NO vendor row has been submitted into
     * the approval workflow yet (ERH_STATUS='S'). NO_OF_VENDORS = vendor RFQs sent; FOR_BUYER_APPROVAL
     * = vendor RFQs already quoted (status='P', i.e. "offer received").
     */
    @Query(value = "SELECT ERH_COLLETIVE_RFQ_NO as qcfNo, MAX(ERH_EXT3) as qcfTitle, MAX(ERH_PLANT) as plant, "
            + "MAX(ERH_CREATED_BY) as createdBy, MIN(ERH_RFQ_DATE) as rfqDate, MIN(ERH_VALID_UPTO) as validUpto, "
            + "COUNT(ERH_SOLD_TO) as noOfVendors, COUNT(CASE WHEN ERH_STATUS = 'P' THEN 1 END) as forBuyerApproval "
            + "FROM ezc_rfq_header WHERE ERH_STATUS NOT IN ('S') AND ERH_EXT2 = :rfqType AND ERH_CREATED_BY = :buyerId "
            + "AND ERH_COLLETIVE_RFQ_NO NOT IN "
            + "(SELECT ERH_COLLETIVE_RFQ_NO FROM ezc_rfq_header WHERE ERH_STATUS = 'S' AND ERH_EXT2 = :rfqType) "
            + "GROUP BY ERH_COLLETIVE_RFQ_NO ORDER BY ERH_COLLETIVE_RFQ_NO DESC", nativeQuery = true)
    List<QcfSummaryProjection> findNewQcfs(@Param("rfqType") String rfqType, @Param("buyerId") String buyerId);

    /**
     * "Submitted" QCFs (ezListQcfs.jsp type=Sub) - QCFs where vendor rows have been submitted
     * into the approval workflow (ERH_STATUS='S'), i.e. already gone through the Quotation
     * Comparison Form. NO_OF_VENDORS/FOR_BUYER_APPROVAL here only count the submitted rows.
     */
    @Query(value = "SELECT ERH_COLLETIVE_RFQ_NO as qcfNo, MAX(ERH_EXT3) as qcfTitle, MAX(ERH_PLANT) as plant, "
            + "MAX(ERH_CREATED_BY) as createdBy, MIN(ERH_RFQ_DATE) as rfqDate, MIN(ERH_VALID_UPTO) as validUpto, "
            + "COUNT(ERH_SOLD_TO) as noOfVendors, COUNT(ERH_SOLD_TO) as forBuyerApproval "
            + "FROM ezc_rfq_header WHERE ERH_STATUS = 'S' AND ERH_EXT2 = :rfqType AND ERH_CREATED_BY = :buyerId "
            + "GROUP BY ERH_COLLETIVE_RFQ_NO ORDER BY ERH_COLLETIVE_RFQ_NO DESC", nativeQuery = true)
    List<QcfSummaryProjection> findSubmittedQcfs(@Param("rfqType") String rfqType, @Param("buyerId") String buyerId);
}
