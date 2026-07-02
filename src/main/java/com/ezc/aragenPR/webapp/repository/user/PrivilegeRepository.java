package com.ezc.aragenPR.webapp.repository.user;

import org.springframework.data.jpa.repository.JpaRepository;

import com.ezc.aragenPR.webapp.model.user.Privilages;

public interface PrivilegeRepository extends JpaRepository<Privilages, Long> {

	Privilages findByName(String name);

    @Override
    void delete(Privilages privilege);

}
