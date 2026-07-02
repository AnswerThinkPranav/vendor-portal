package com.ezc.aragenPR.webapp.repository.pr;

import com.ezc.aragenPR.webapp.model.pr.DBFile;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface DBFileRepo extends JpaRepository<DBFile, Integer> {
}