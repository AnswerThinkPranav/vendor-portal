
package com.ezc.aragenPR.webapp.controller.admin;

import com.ezc.aragenPR.webapp.model.admin.JobInfo;
import com.ezc.aragenPR.webapp.repository.admin.JobScanner;
import com.ezc.aragenPR.webapp.service.admin.JobHistoryService;
import org.quartz.JobKey;
import org.quartz.Scheduler;
import org.quartz.SchedulerException;
import org.quartz.Trigger;
import org.quartz.impl.matchers.GroupMatcher;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.ArrayList;
import java.util.List;

@Controller
public class EmailJobController {

    @Autowired
    private Scheduler scheduler;

    @Autowired
    private JobScanner jobScanner;

    @Autowired
    private JobHistoryService jobHistoryService;

    @GetMapping("/jobs")
    public String dashboard(Model model) throws SchedulerException {
        List<JobInfo> jobs = new ArrayList<>();

        for (String groupName : scheduler.getJobGroupNames()) {
            for (JobKey jobKey : scheduler.getJobKeys(GroupMatcher.jobGroupEquals(groupName))) {
                List<? extends Trigger> triggers = scheduler.getTriggersOfJob(jobKey);
                for (Trigger trigger : triggers) {
                    JobInfo info = new JobInfo();
                    info.setJobName(jobKey.getName());
                    info.setLastExecution(trigger.getPreviousFireTime());
                    info.setNextExecution(trigger.getNextFireTime());
                    jobs.add(info);
                }
            }
        }

        model.addAttribute("jobs", jobs);
        model.addAttribute("history", jobHistoryService.getRecentHistory());
        model.addAttribute("availableJobs", jobScanner.findAllJobClassNames());
        return "modals/jobDashboard";
    }
}
