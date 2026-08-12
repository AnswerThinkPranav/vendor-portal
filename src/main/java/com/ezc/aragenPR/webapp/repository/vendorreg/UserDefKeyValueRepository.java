package com.ezc.aragenPR.webapp.repository.vendorreg;

import java.util.List;

import com.ezc.aragenPR.webapp.model.vendorreg.UserDefKeyValue;
import com.ezc.aragenPR.webapp.model.vendorreg.UserDefKeyValueId;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserDefKeyValueRepository extends JpaRepository<UserDefKeyValue, UserDefKeyValueId> {

    List<UserDefKeyValue> findByUserIdAndKey(String userId, String key);
}
