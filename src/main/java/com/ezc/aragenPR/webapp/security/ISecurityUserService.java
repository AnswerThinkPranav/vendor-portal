package com.ezc.aragenPR.webapp.security;

public interface ISecurityUserService {

    String validatePasswordResetToken(String id, String token);

}
