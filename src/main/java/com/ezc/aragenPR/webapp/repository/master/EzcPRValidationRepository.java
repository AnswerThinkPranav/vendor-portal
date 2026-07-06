package com.ezc.aragenPR.webapp.repository.master;


import com.ezc.aragenPR.webapp.model.master.EzcPRValidationCompKey;
import com.ezc.aragenPR.webapp.model.master.EzcPRValidationMaster;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface EzcPRValidationRepository extends JpaRepository<EzcPRValidationMaster, EzcPRValidationCompKey> {

    List<EzcPRValidationMaster>
    findByCompanyCodeAndDocTypeAndAccountAssignmentAndActive(
            String companyCode,
            String docType,
            String accountAssignment,
            String active);
}