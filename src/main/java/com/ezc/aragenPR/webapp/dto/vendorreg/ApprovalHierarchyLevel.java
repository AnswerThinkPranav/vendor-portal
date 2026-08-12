package com.ezc.aragenPR.webapp.dto.vendorreg;

/**
 * One level of the resolved workflow template - see ezWFUsers.jsp / ezShowVNRApprovalHirearchy.jsp.
 * {@code user} is the comma-joined "USERID[Full Name]" list for the level's group (USER_STR in the
 * legacy JSP); {@code type} is "Submit" or "Approve", derived from the level's condition flag
 * (LE -> Submit, GE -> Approve) exactly as the legacy page's dispStatus does. The group code itself
 * is intentionally not exposed here - it's an internal routing key, not something a buyer needs to see.
 */
public record ApprovalHierarchyLevel(int level, String role, String user, String type) {
}
