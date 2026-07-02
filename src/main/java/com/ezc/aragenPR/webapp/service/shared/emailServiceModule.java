package com.ezc.aragenPR.webapp.service.shared;

import com.ezc.aragenPR.webapp.model.user.Users;

import java.util.List;

public interface emailServiceModule {
    void sendMonthlyEmail(List<Users> usersList, String subject);
    void sendReminderEmail(List<Users> usersList, String subject);

}
