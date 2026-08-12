package com.ezc.aragenPR.webapp.repository.workflow;

import java.util.List;
import java.util.Optional;

import com.ezc.aragenPR.webapp.dto.rfq.QcsSummaryProjection;
import com.ezc.aragenPR.webapp.model.workflow.WfDocHistoryHeader;
import com.ezc.aragenPR.webapp.model.workflow.WfDocHistoryHeaderId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface WfDocHistoryHeaderRepository extends JpaRepository<WfDocHistoryHeader, WfDocHistoryHeaderId> {

    Optional<WfDocHistoryHeader> findByAuthKeyAndDocId(String authKey, String docId);

    /**
     * QCS list (ezQCSList.jsp) - QCFs already submitted into the approval workflow. Simplified
     * vs. the legacy page: this app doesn't yet have configured workflow templates/participants
     * (see WfDocHistoryHeader javadoc), so this only reflects the single "SUBMITTED" step this
     * app itself writes - no multi-level Approved/Rejected/Pending-with-X routing yet.
     */
    @Query(value = "SELECT w.EWDHH_DOC_ID as qcfNo, w.EWDHH_WF_STATUS as wfStatus, w.EWDHH_MODIFIED_ON as modifiedOn, "
            + "w.EWDHH_CREATED_BY as buyer, "
            + "(SELECT MAX(h.ERH_EXT3) FROM ezc_rfq_header h WHERE h.ERH_COLLETIVE_RFQ_NO = w.EWDHH_DOC_ID) as qcfTitle, "
            + "(SELECT MAX(h.ERH_PLANT) FROM ezc_rfq_header h WHERE h.ERH_COLLETIVE_RFQ_NO = w.EWDHH_DOC_ID) as plant, "
            + "(SELECT MAX(h.ERH_FINAL_VALUE) FROM ezc_rfq_header h WHERE h.ERH_COLLETIVE_RFQ_NO = w.EWDHH_DOC_ID) as docValue, "
            + "(SELECT COUNT(*) FROM ezc_rfq_header h WHERE h.ERH_COLLETIVE_RFQ_NO = w.EWDHH_DOC_ID) as noOfVendors, "
            + "(SELECT COUNT(*) FROM ezc_rfq_header h WHERE h.ERH_COLLETIVE_RFQ_NO = w.EWDHH_DOC_ID AND h.ERH_STATUS = 'S') as forBuyerApproval "
            + "FROM ezc_wf_doc_history_header w "
            + "WHERE w.EWDHH_AUTH_KEY = 'QCF' AND w.EWDHH_CREATED_BY = :buyerId "
            + "AND (:wfStatus = 'ALL' OR w.EWDHH_WF_STATUS = :wfStatus) "
            + "ORDER BY w.EWDHH_MODIFIED_ON DESC", nativeQuery = true)
    List<QcsSummaryProjection> findQcsList(@Param("buyerId") String buyerId, @Param("wfStatus") String wfStatus);
}
