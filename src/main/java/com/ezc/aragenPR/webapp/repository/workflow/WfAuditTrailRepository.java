package com.ezc.aragenPR.webapp.repository.workflow;

import java.util.List;
import java.util.Optional;

import com.ezc.aragenPR.webapp.model.workflow.WfAuditTrail;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface WfAuditTrailRepository extends JpaRepository<WfAuditTrail, Long> {

    List<WfAuditTrail> findByDocIdOrderByDateAsc(String docId);

    @Query("SELECT MAX(CAST(a.auditNo AS int)) FROM WfAuditTrail a WHERE a.docId = :docId")
    Optional<Integer> findMaxAuditNo(@Param("docId") String docId);
}
