package com.ezc.aragenPR.webapp.repository.rfq;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.ezc.aragenPR.webapp.model.rfq.QcfQuery;

public interface QcfQueryRepository extends JpaRepository<QcfQuery, Long> {

    List<QcfQuery> findByQcfNoOrderByRaisedOnDesc(String qcfNo);

    boolean existsByQcfNoAndRepliedOnIsNull(String qcfNo);

    Optional<QcfQuery> findFirstByQcfNoAndRepliedOnIsNullOrderByRaisedOnDesc(String qcfNo);
}
