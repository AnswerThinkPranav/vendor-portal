package com.ezc.aragenPR.webapp.repository.master;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.ezc.aragenPR.webapp.model.master.EzConditionSeqMap;
import com.ezc.aragenPR.webapp.model.master.EzConditionSeqMapKey;

public interface ConditionSeqMapRepo extends JpaRepository<EzConditionSeqMap,EzConditionSeqMapKey> {
	
	List<EzConditionSeqMap> findByConditionType(String conditionType);
	List<EzConditionSeqMap> findByUserId(String userId);
	Long deleteByUserId(String userId);

}
