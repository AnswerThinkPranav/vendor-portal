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
     * "List" (VNR) - see ezVNRList.jsp. Legacy scopes this by an INNER JOIN against
     * EZC_WF_DOC_HISTORY_HEADER (workflow status) which doesn't exist in the merged
     * system yet - filtered here by ECFH_STATUS instead, and by venType. Plant/category
     * authorization scoping (the legacy CONCAT(PLANT,'#',CATEGORY) IN (...) check) is
     * applied in the service layer against the buyer's already-loaded allowed combos.
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
}
