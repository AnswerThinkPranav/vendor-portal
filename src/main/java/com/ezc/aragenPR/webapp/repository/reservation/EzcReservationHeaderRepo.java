package com.ezc.aragenPR.webapp.repository.reservation;
import com.ezc.aragenPR.webapp.model.pr.EzPurchaseRequisitionHeader;
import com.ezc.aragenPR.webapp.model.reservation.EzcReservationHeader;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface EzcReservationHeaderRepo extends JpaRepository<EzcReservationHeader, String> {
    @Query("SELECT h FROM EzcReservationHeader h   WHERE (:status IS NULL OR h.status = :status)  AND (:userId IS NULL OR h.createdBy = :userId)  AND (:fromDate IS NULL OR h.createdOn >= :fromDate)  AND (:toDate IS NULL OR h.createdOn <= :toDate) ")
    List<EzcReservationHeader> getFilteredHeaders(@Param("fromDate") LocalDateTime fromDate,
                                                  @Param("toDate") LocalDateTime toDate,
                                                  @Param("status") String status,
                                                  @Param("userId") String userId);

    @Query("SELECT h FROM EzcReservationHeader h WHERE (:movementType IS NULL OR :movementType = '' OR h.movementType = :movementType) AND (:userId IS NULL OR h.createdBy = :userId) AND (:fromDate IS NULL OR h.createdOn >= :fromDate) AND (:toDate IS NULL OR h.createdOn <= :toDate)")
    List<EzcReservationHeader> getFilteredHeadersByMovementType(@Param("fromDate") LocalDateTime fromDate,
                                                                @Param("toDate") LocalDateTime toDate,
                                                                @Param("movementType") String movementType,
                                                                @Param("userId") String userId);

    @Query("SELECT h FROM EzcReservationHeader h WHERE (:status IS NULL OR h.status = :status) AND (:userId IS NULL OR h.createdBy = :userId) AND (:fromDate IS NULL OR h.createdOn >= :fromDate) AND (:toDate IS NULL OR h.createdOn <= :toDate)")
    List<EzcReservationHeader> getFilteredHeaders(LocalDateTime fromDate, LocalDateTime toDate, String userId);

    Optional<EzcReservationHeader> findByReservationNo(String reservationNumber);
}
