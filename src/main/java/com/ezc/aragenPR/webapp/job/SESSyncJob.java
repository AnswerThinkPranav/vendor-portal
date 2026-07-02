package com.ezc.aragenPR.webapp.job;

import com.ezc.aragenPR.webapp.service.ses.SESService;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class SESSyncJob implements Job {

    private static final Logger logger = LoggerFactory.getLogger(SESSyncJob.class);

    @Autowired
    private SESService sesService;

    @Override
    public void execute(JobExecutionContext context) throws JobExecutionException {
        logger.info("SES Sync JOB Job started");
        try{
            sesService.syncFromSAP();
            logger.info("SES Sync JOB Job completed successfully");
        }
        catch (Exception e){
            logger.error("Error executing SES Sync Job", e);
            throw new JobExecutionException("Failed to execute SES Sync Job", e);
        }
    }
}
