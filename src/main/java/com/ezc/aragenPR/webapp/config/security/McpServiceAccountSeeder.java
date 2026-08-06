package com.ezc.aragenPR.webapp.config.security;

import java.util.ArrayList;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import com.ezc.aragenPR.webapp.model.user.Users;
import com.ezc.aragenPR.webapp.model.user.UserType;
import com.ezc.aragenPR.webapp.repository.user.UserRepository;

/**
 * Idempotently provisions the dedicated MCP service-account Users row on startup so
 * McpApiKeyAuthFilter always has a principal to load. The account's password is a
 * random value nobody is given - it can never sign in through the browser form-login
 * chain, only through the X-MCP-Api-Key header.
 */
@Component
public class McpServiceAccountSeeder implements ApplicationRunner {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private McpApiKeyProperties mcpApiKeyProperties;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public void run(ApplicationArguments args) {
        String serviceAccountUserId = mcpApiKeyProperties.getServiceAccountUserId();
        if (userRepository.findByUserId(serviceAccountUserId) != null) {
            return;
        }

        Users serviceAccount = new Users(
                serviceAccountUserId,
                "MCP",
                "Service Account",
                serviceAccountUserId + "@aragen.local",
                passwordEncoder.encode(UUID.randomUUID().toString()),
                true);
        serviceAccount.setRoles(new ArrayList<>());
        // EU_TYPE/EUG_ID/EU_BUSINESS_PARTNER are NOT NULL on the merged legacy EZC_USERS table;
        // this account never logs in via form-login, so these are sentinel values only.
        serviceAccount.setUserType(UserType.BUYER.getCode());
        serviceAccount.setUserGroupId(0);
        serviceAccount.setVendorCode("");
        userRepository.save(serviceAccount);
    }
}
