package com.ezc.aragenPR.webapp.repository.user;

import com.ezc.aragenPR.webapp.model.user.UserPrivilege;
import org.springframework.data.jpa.repository.JpaRepository;

public interface EzPrivilegesRepo extends JpaRepository<UserPrivilege, String> {

}
