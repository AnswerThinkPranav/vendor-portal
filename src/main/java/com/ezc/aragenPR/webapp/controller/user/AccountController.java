package com.ezc.aragenPR.webapp.controller.user;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ezc.aragenPR.webapp.model.user.Users;
import com.ezc.aragenPR.webapp.service.user.IUserService;

import lombok.extern.slf4j.Slf4j;

/**
 * Self-service "change my own password" for an already-authenticated user (see legacy
 * ezPassword.jsp?fromMenu=Y). Deliberately kept separate from the /user/updatePassword +
 * /user/savePassword pair - those belong to the forgot-password reset-token flow and are
 * gated behind a temporary CHANGE_PASSWORD_PRIVILEGE authority that an ordinary logged-in
 * user never holds.
 *
 * <p>Note: CustomAuthenticationProvider swaps the authenticated principal to the real
 * {@link Users} entity after login (not the Spring Security UserDetails wrapper
 * CustomUserServiceImpl.loadUserByUsername returns), so {@code authentication.getName()}
 * is unusable here - Users implements neither UserDetails nor Principal, so getName()
 * falls back to Users.toString(). Cast the principal directly instead.</p>
 */
@Slf4j
@Controller
@RequestMapping("/account")
public class AccountController {

    @Autowired
    private IUserService userService;

    @GetMapping("/changePassword")
    public String showChangePasswordPage() {
        return "account/changePassword";
    }

    @PostMapping("/changePassword")
    @ResponseBody
    public ResponseEntity<Map<String, String>> changePassword(Authentication authentication,
            @RequestParam String oldPassword,
            @RequestParam String newPassword,
            @RequestParam String confirmPassword) {
        try {
            if (oldPassword == null || oldPassword.isBlank()) {
                return ResponseEntity.badRequest().body(Map.of("status", "ERROR", "message", "Current password is required."));
            }
            if (newPassword == null || newPassword.isBlank() || newPassword.length() < 6) {
                return ResponseEntity.badRequest().body(Map.of("status", "ERROR", "message", "New password must be at least 6 characters."));
            }
            if (!newPassword.equals(confirmPassword)) {
                return ResponseEntity.badRequest().body(Map.of("status", "ERROR", "message", "New password and confirmation do not match."));
            }

            if (!(authentication.getPrincipal() instanceof Users user)) {
                return ResponseEntity.badRequest().body(Map.of("status", "ERROR", "message", "User not found."));
            }
            if (!userService.checkIfValidOldPassword(user, oldPassword)) {
                return ResponseEntity.badRequest().body(Map.of("status", "ERROR", "message", "Current password is incorrect."));
            }
            if (oldPassword.equals(newPassword)) {
                return ResponseEntity.badRequest().body(Map.of("status", "ERROR", "message", "New password must be different from the current password."));
            }

            userService.changeUserPassword(user, newPassword);
            log.info("Password changed by user {}", user.getUserId());
            return ResponseEntity.ok(Map.of("status", "OK", "message", "Password changed successfully."));
        } catch (Exception e) {
            log.error("changePassword error: {}", e.getMessage(), e);
            return ResponseEntity.badRequest().body(Map.of("status", "ERROR", "message", "Could not change password: " + e.getMessage()));
        }
    }
}
