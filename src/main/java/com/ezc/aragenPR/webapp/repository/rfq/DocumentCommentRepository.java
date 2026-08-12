package com.ezc.aragenPR.webapp.repository.rfq;

import java.util.List;

import com.ezc.aragenPR.webapp.model.rfq.DocumentComment;
import org.springframework.data.jpa.repository.JpaRepository;

public interface DocumentCommentRepository extends JpaRepository<DocumentComment, Long> {

    List<DocumentComment> findByDocIdAndDocTypeOrderByDateAsc(String docId, String docType);
}
