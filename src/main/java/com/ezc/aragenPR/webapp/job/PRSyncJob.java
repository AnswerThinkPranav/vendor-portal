package com.ezc.aragenPR.webapp.job;

import com.ezc.aragenPR.webapp.service.admin.JobHistoryService;
import com.ezc.aragenPR.webapp.service.pr.PRReleaseInfoService;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.beans.factory.annotation.Autowired;

public class PRSyncJob implements Job {
    @Autowired
    private PRReleaseInfoService prReleaseInfoService;
    @Autowired
    private JobHistoryService jobHistoryService;

    @Override
    public void execute(JobExecutionContext context) throws JobExecutionException {
        System.out.println("PR Sync Job started");
        try {
            prReleaseInfoService.getPendingPRsFromDBAndSAP();
            System.out.println("PR Sync Job completed successfully");
            jobHistoryService.saveJobExecution(context.getJobDetail().getKey().getName(), "SUCCESS", null);
        } catch (Exception e) {
            System.err.println("PR Sync Job failed: " + e.getMessage());
            e.printStackTrace();
            jobHistoryService.saveJobExecution(context.getJobDetail().getKey().getName(), "FAILED", e.getMessage());
        }
    }
}
