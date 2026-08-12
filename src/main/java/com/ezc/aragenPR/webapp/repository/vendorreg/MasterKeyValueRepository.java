package com.ezc.aragenPR.webapp.repository.vendorreg;

import java.util.List;

import com.ezc.aragenPR.webapp.model.vendorreg.MasterKeyValue;
import com.ezc.aragenPR.webapp.model.vendorreg.MasterKeyValueId;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MasterKeyValueRepository extends JpaRepository<MasterKeyValue, MasterKeyValueId> {

    List<MasterKeyValue> findByMasterTypeOrderByKeyAsc(String masterType);
}
