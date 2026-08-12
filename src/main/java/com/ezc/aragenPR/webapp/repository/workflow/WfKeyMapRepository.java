package com.ezc.aragenPR.webapp.repository.workflow;

import java.util.Optional;

import com.ezc.aragenPR.webapp.model.workflow.WfKeyMap;
import com.ezc.aragenPR.webapp.model.workflow.WfKeyMapId;
import org.springframework.data.jpa.repository.JpaRepository;

public interface WfKeyMapRepository extends JpaRepository<WfKeyMap, WfKeyMapId> {

    Optional<WfKeyMap> findByDocTypeAndCompCodeAndPlantAndCategory(String docType, String compCode, String plant, String category);
}
