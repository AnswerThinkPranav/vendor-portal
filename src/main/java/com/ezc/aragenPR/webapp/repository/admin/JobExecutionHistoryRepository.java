package com.ezc.aragenPR.webapp.repository.admin;

import com.ezc.aragenPR.webapp.model.admin.JobExecutionHistory;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface JobExecutionHistoryRepository extends JpaRepository<JobExecutionHistory, Long> {
    List<JobExecutionHistory> findTop20ByOrderByExecutedAtDesc();
}