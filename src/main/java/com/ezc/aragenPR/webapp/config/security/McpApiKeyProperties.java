package com.ezc.aragenPR.webapp.config.security;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "mcp")
public class McpApiKeyProperties {

    /**
     * BCrypt hash of the raw API key handed to the MCP server process.
     * Sourced from the MCP_API_KEY_HASH env var - never store the raw key here.
     */
    private String apiKeyHash;

    private String serviceAccountUserId = "mcp-service-account";

    public String getApiKeyHash() {
        return apiKeyHash;
    }

    public void setApiKeyHash(String apiKeyHash) {
        this.apiKeyHash = apiKeyHash;
    }

    public String getServiceAccountUserId() {
        return serviceAccountUserId;
    }

    public void setServiceAccountUserId(String serviceAccountUserId) {
        this.serviceAccountUserId = serviceAccountUserId;
    }
}
