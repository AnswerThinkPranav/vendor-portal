package com.ezc.aragenPR.webapp.config;

import java.util.Optional;

import org.springframework.data.domain.AuditorAware;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

import com.ezc.aragenPR.webapp.model.user.Users;

class AuditorAwareImpl implements AuditorAware<String> {

    @Override
    public Optional<String> getCurrentAuditor() {
    	Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

    	if (authentication == null || !authentication.isAuthenticated()
    	        || !(authentication.getPrincipal() instanceof Users)) {
    	    return Optional.empty();
    	}
    	return Optional.of(((Users) authentication.getPrincipal()).getUserId());
    	

    	
    	
       // return Optional.of("Admin");
    }
}