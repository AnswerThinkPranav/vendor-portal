package com.ezc.aragenPR.webapp.config.security;

import java.io.IOException;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.filter.OncePerRequestFilter;

import com.ezc.aragenPR.webapp.model.user.Users;
import com.ezc.aragenPR.webapp.repository.user.UserRepository;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Authenticates requests carrying the X-MCP-Api-Key header against the configured
 * key hash, on success loading the dedicated MCP service-account Users row as the
 * SecurityContext principal (matching the principal type PRController expects from
 * SecurityContextHolder). Runs only within McpApiKeySecurityConfig's stateless chain,
 * so it never touches the browser session/SessionRegistry.
 */
public class McpApiKeyAuthFilter extends OncePerRequestFilter {

    public static final String HEADER_NAME = "X-MCP-Api-Key";

    private final McpApiKeyProperties properties;
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public McpApiKeyAuthFilter(McpApiKeyProperties properties, UserRepository userRepository,
            PasswordEncoder passwordEncoder) {
        this.properties = properties;
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
            throws ServletException, IOException {
        String presentedKey = request.getHeader(HEADER_NAME);
        String configuredHash = properties.getApiKeyHash();

        if (configuredHash == null || configuredHash.isBlank()
                || presentedKey == null || presentedKey.isBlank()
                || !passwordEncoder.matches(presentedKey, configuredHash)) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Invalid MCP API key");
            return;
        }

        Users serviceAccount = userRepository.findByUserId(properties.getServiceAccountUserId());
        if (serviceAccount == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "MCP service account not provisioned");
            return;
        }

        java.util.Collection<? extends GrantedAuthority> authorities =
                AuthorityUtils.createAuthorityList("ROLE_MCP_SERVICE");
        SecurityContextHolder.getContext().setAuthentication(
                new UsernamePasswordAuthenticationToken(serviceAccount, null, authorities));

        chain.doFilter(request, response);
    }
}
