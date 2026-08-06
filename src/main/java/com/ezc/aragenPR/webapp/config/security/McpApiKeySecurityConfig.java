package com.ezc.aragenPR.webapp.config.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import com.ezc.aragenPR.webapp.repository.user.UserRepository;

/**
 * Second, independent auth path for the standalone MCP server: any request carrying
 * X-MCP-Api-Key is routed through this stateless, CSRF-exempt chain instead of the
 * browser form-login chain in SecurityConfiguration. Requests without the header are
 * untouched and fall through to the existing chain.
 */
@Configuration
@EnableConfigurationProperties(McpApiKeyProperties.class)
public class McpApiKeySecurityConfig {

    @Autowired
    private McpApiKeyProperties mcpApiKeyProperties;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Bean
    @Order(1)
    public SecurityFilterChain mcpApiKeyFilterChain(HttpSecurity http) throws Exception {
        McpApiKeyAuthFilter mcpApiKeyAuthFilter =
                new McpApiKeyAuthFilter(mcpApiKeyProperties, userRepository, passwordEncoder);

        http
            .securityMatcher(request -> request.getHeader(McpApiKeyAuthFilter.HEADER_NAME) != null)
            .csrf(AbstractHttpConfigurer::disable)
            .sessionManagement(sm -> sm.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            .addFilterBefore(mcpApiKeyAuthFilter, UsernamePasswordAuthenticationFilter.class)
            .authorizeHttpRequests(auth -> auth.anyRequest().authenticated());

        return http.build();
    }
}
