package com.ezc.aragenPR.webapp.repository.vendorreg;

import java.util.List;
import java.util.Optional;

import com.ezc.aragenPR.webapp.model.vendorreg.VendorQuery;
import org.springframework.data.jpa.repository.JpaRepository;

public interface VendorQueryRepository extends JpaRepository<VendorQuery, Long> {

    List<VendorQuery> findByDocIdOrderByRaisedOnDesc(String docId);

    boolean existsByDocIdAndRepliedOnIsNull(String docId);

    Optional<VendorQuery> findFirstByDocIdAndRepliedOnIsNullOrderByRaisedOnDesc(String docId);
}
