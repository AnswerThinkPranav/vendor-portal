package com.ezc.aragenPR.webapp.config;

import javax.sql.DataSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.quartz.SchedulerFactoryBean;

import java.util.Properties;

@Configuration
public class QuartzSchedulerConfig {

    @Autowired
    private DataSource dataSource;

    @Autowired
    private ApplicationContext applicationContext;

    @Bean
    public AutowiringSpringBeanJobFactory jobFactory() {
        AutowiringSpringBeanJobFactory jobFactory = new AutowiringSpringBeanJobFactory();
        jobFactory.setApplicationContext(applicationContext);
        return jobFactory;
    }

    @Bean
    public SchedulerFactoryBean schedulerFactoryBean() {
        SchedulerFactoryBean schedulerFactory = new SchedulerFactoryBean();
        schedulerFactory.setDataSource(dataSource);
        schedulerFactory.setJobFactory(jobFactory());
        schedulerFactory.setOverwriteExistingJobs(false);
        schedulerFactory.setAutoStartup(true);
        schedulerFactory.setWaitForJobsToCompleteOnShutdown(true);

        Properties quartzProperties = new Properties();
        quartzProperties.put("org.quartz.jobStore.driverDelegateClass", "org.quartz.impl.jdbcjobstore.StdJDBCDelegate");
        quartzProperties.put("org.quartz.jobStore.tablePrefix", "QRTZ_");
        quartzProperties.put("org.quartz.jobStore.isClustered", "false");
        quartzProperties.put("org.quartz.threadPool.threadCount", "5");
        quartzProperties.put("org.quartz.jobStore.useProperties", "true"); // Important for persistence

        schedulerFactory.setQuartzProperties(quartzProperties);

        return schedulerFactory;
    }
}
