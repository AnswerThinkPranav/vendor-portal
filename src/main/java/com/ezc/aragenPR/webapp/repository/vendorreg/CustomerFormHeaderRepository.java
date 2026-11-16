package com.ezc.aragenPR.webapp.repository.vendorreg;

import java.time.LocalDate;
import java.util.List;

import com.ezc.aragenPR.webapp.model.vendorreg.CustomerFormHeader;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface CustomerFormHeaderRepository extends JpaRepository<CustomerFormHeader, String> {

    /** "New" list - see ezTempVendList.jsp: vendors invited by this buyer. */
    @Query("SELECT h FROM CustomerFormHeader h WHERE h.createdBy = :createdBy AND h.venType = :venType "
            + "AND h.status IN :statuses "
            + "AND (:fromDate IS NULL OR h.createdOn >= :fromDate) "
            + "AND (:toDate IS NULL OR h.createdOn <= :toDate) "
            + "ORDER BY h.docId DESC")
    List<CustomerFormHeader> findMyInvites(@Param("createdBy") String createdBy,
                                            @Param("venType") String venType,
                                            @Param("statuses") List<String> statuses,
                                            @Param("fromDate") LocalDate fromDate,
                                            @Param("toDate") LocalDate toDate);

    /**
     * "List" (VNR) - see ezVNRList.jsp. Filtered here by ECFH_STATUS and venType. Plant/category
     * authorization scoping (the legacy CONCAT(PLANT,'#',CATEGORY) IN (...) check) and, for the
     * "To Act" queue specifically, the EZC_WF_DOC_HISTORY_HEADER next-participant/workgroup check
     * (see findToActDocIds below) are applied in the service layer.
     */
    @Query("SELECT h FROM CustomerFormHeader h WHERE h.venType = :venType "
            + "AND (:statuses IS NULL OR h.status IN :statuses) "
            + "AND (:fromDate IS NULL OR h.createdOn >= :fromDate) "
            + "AND (:toDate IS NULL OR h.createdOn <= :toDate) "
            + "ORDER BY h.docId DESC")
    List<CustomerFormHeader> findForVnrList(@Param("venType") String venType,
                                             @Param("statuses") List<String> statuses,
                                             @Param("fromDate") LocalDate fromDate,
                                             @Param("toDate") LocalDate toDate);

    /**
     * Doc ids currently sitting at a workflow step this buyer can act on - see legacy
     * ezWelcomePageCounts.jsp's dashboard tile query: joins EZC_WF_DOC_HISTORY_HEADER
     * (WF_STATUS='SUBMITTED') to EZC_WF_WORKGROUP_USERS on the doc's EWDHH_NEXT_PARTICIPANT
     * group, scoped to plant/category combinations the buyer is authorized for
     * (EZC_USER_DEF_KEY_VALUES, key=CATEGORY) - the same scoping WfWorkgroupUserRepository
     * uses for turn-based authorization elsewhere (see WorkflowEngineServiceImpl.resolveGroupUsers).
     * Unlike the legacy query, REJECTED is intentionally excluded: in this app REJECTED clears
     * EWDHH_NEXT_PARTICIPANT (terminal state, nobody's turn), unlike the legacy engine which kept
     * REJECTED docs live in the same participant's queue.
     */
    @Query(value = "SELECT DISTINCT h.ECFH_DOC_ID FROM ezc_customer_form_header h "
            + "JOIN ezc_wf_doc_history_header w ON w.EWDHH_DOC_ID = h.ECFH_DOC_ID AND w.EWDHH_AUTH_KEY = 'VNR' "
            + "JOIN ezc_wf_workgroup_users wgu ON wgu.EWWU_GROUP = w.EWDHH_NEXT_PARTICIPANT AND wgu.EWWU_USER = :buyerUserId "
            + "JOIN ezc_user_def_key_values udkv ON udkv.EUDKV_USER_ID = :buyerUserId AND udkv.EUDKV_KEY = 'CATEGORY' "
            + "AND udkv.EUDKV_VALUE = CONCAT(h.ECFH_PLANT, '#', h.ECFH_CATEGORY) "
            + "WHERE h.ECFH_VEN_TYPE = :venType AND w.EWDHH_WF_STATUS = 'SUBMITTED'",
            nativeQuery = true)
    List<String> findToActDocIds(@Param("buyerUserId") String buyerUserId, @Param("venType") String venType);

    /** Dashboard tile count backing getDomesticVendorPendingApprovalCount/getImportVendorPendingApprovalCount - see findToActDocIds. */
    @Query(value = "SELECT COUNT(DISTINCT h.ECFH_DOC_ID) FROM ezc_customer_form_header h "
            + "JOIN ezc_wf_doc_history_header w ON w.EWDHH_DOC_ID = h.ECFH_DOC_ID AND w.EWDHH_AUTH_KEY = 'VNR' "
            + "JOIN ezc_wf_workgroup_users wgu ON wgu.EWWU_GROUP = w.EWDHH_NEXT_PARTICIPANT AND wgu.EWWU_USER = :buyerUserId "
            + "JOIN ezc_user_def_key_values udkv ON udkv.EUDKV_USER_ID = :buyerUserId AND udkv.EUDKV_KEY = 'CATEGORY' "
            + "AND udkv.EUDKV_VALUE = CONCAT(h.ECFH_PLANT, '#', h.ECFH_CATEGORY) "
            + "WHERE h.ECFH_VEN_TYPE = :venType AND w.EWDHH_WF_STATUS = 'SUBMITTED'",
            nativeQuery = true)
    long countToAct(@Param("buyerUserId") String buyerUserId, @Param("venType") String venType);
}
