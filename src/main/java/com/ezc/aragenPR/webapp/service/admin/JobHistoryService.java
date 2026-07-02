package com.ezc.aragenPR.webapp.service.admin;

import com.ezc.aragenPR.webapp.model.admin.JobExecutionHistory;
import com.ezc.aragenPR.webapp.repository.admin.JobExecutionHistoryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class JobHistoryService {

    @Autowired
    private JobExecutionHistoryRepository repo;

    public void saveJobExecution(String jobName, String status, String message) {
        JobExecutionHistory history = new JobExecutionHistory();
        history.setJobName(jobName);
        history.setStatus(status);
        history.setMessage(message);
        repo.save(history);
    }

    public List<JobExecutionHistory> getRecentHistory() {
        return repo.findTop20ByOrderByExecutedAtDesc();
    }
}