package com.ezc.aragenPR.webapp.repository.vendorreg;

import java.util.List;

import com.ezc.aragenPR.webapp.model.vendorreg.CustomerFormDetail;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CustomerFormDetailRepository extends JpaRepository<CustomerFormDetail, Long> {

    List<CustomerFormDetail> findByDocId(String docId);

    List<CustomerFormDetail> findByDocIdAndTabName(String docId, String tabName);

    void deleteByDocIdAndTabName(String docId, String tabName);

    void deleteByDocIdAndTabNameAndFieldIn(String docId, String tabName, List<String> fields);
}
