package com.ezc.aragenPR.webapp.service.workflow;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

import com.ezc.aragenPR.webapp.model.user.Users;
import com.ezc.aragenPR.webapp.model.workflow.WfDocHistoryHeader;
import com.ezc.aragenPR.webapp.model.workflow.WfPricingCondition;

/**
 * Generic multi-level approval workflow engine, ported from Vendor Portal/JSP/Misc/
 * ezWFCommonMethods.jsp + Vendor Portal/JSP/Misc/ezSubmitVendRegOthMat.jsp. Reusable
 * across document types (auth key) - currently wired for VNR (vendor registration);
 * QCF's simplified single-step submission (QcfServiceImpl) predates this and is a
 * candidate to migrate onto this engine later, once real EZC_WF_* template data exists
 * for QCF too.
 */
public interface IWorkflowEngineService {

    /** EZC_WF_KEY_MAP lookup - which template governs this (docType, compCode, plant, category) combination. */
    Optional<Integer> resolveTemplate(String docType, String compCode, String plant, String category);

    /** The real, currently-authorized users for a workflow group, scoped to plant+category. */
    List<Users> resolveGroupUsers(String group, String plant, String category);

    /** A user's legacy single-value role code (EZC_USER_DEFAULTS, key=USERROLE) - e.g. VAR/LB/SCA/PP/FIH. */
    String getUserRole(String userId);

    /** Whether this level is the last one in the template (no further forwarding possible - the terminal action applies instead). */
    boolean isFinalLevel(Integer template, Integer level);

    /**
     * Value-threshold-aware version: the template's escalation chain is a single sequential ladder
     * (level 1, 2, 3, ... - exactly one row per level), but a document's actual stopping point
     * depends on its value against each level's EWPC_QCF_FLAG ("LE"/"GE") + EWPC_QCF_RELEASE (e.g.
     * level 4 "LE 500000", level 5 "LE 2499999", level 6 "GE 2500000" - a ₹300,000 document's final
     * level is 4, even though levels 5-6 exist in the same template for larger documents).
     * {@code docValue} may be null (same as {@link #isFinalLevel(Integer, Integer)} - final = the
     * template's max level, e.g. Vendor Registration's templates, which don't use value routing).
     */
    boolean isFinalLevel(Integer template, Integer level, BigDecimal docValue);

    /** Level 1's config for a template, if any levels are configured. */
    Optional<WfPricingCondition> getFirstLevel(Integer template);

    /** The current level's config for a doc already in workflow. */
    Optional<WfPricingCondition> getCurrentLevel(String docType, String docId);

    /**
     * Starts routing: resolves the template, creates the EZC_WF_DOC_HISTORY_HEADER row at
     * level 1 with status SUBMITTED, and logs the audit trail entry. Returns the level-1
     * config (so the caller can notify that group), or empty if no template is configured
     * for this combination.
     */
    Optional<WfPricingCondition> startWorkflow(String docType, String docId, String compCode, String plant,
            String category, String startedByUserId, String comments);

    /**
     * Same as {@link #startWorkflow(String, String, String, String, String, String, String)} but
     * carries the document's value through so later {@link #forward} calls can resolve the right
     * stopping level via {@link #isFinalLevel(Integer, Integer, BigDecimal)} - level 1 itself is
     * never value-dependent (the ladder always starts there), only where it stops.
     */
    Optional<WfPricingCondition> startWorkflow(String docType, String docId, String compCode, String plant,
            String category, String startedByUserId, String comments, BigDecimal docValue);

    /**
     * Forwards from the current level to the next one (intermediate approver action - matches
     * actionSts='S'). The caller must have already verified the actor is authorized for the
     * current level (see resolveGroupUsers). Returns the new current level's config, or empty
     * if the current level was already the last one (caller should use the terminal action
     * instead - e.g. SAP posting for VNR).
     */
    Optional<WfPricingCondition> forward(String docType, String docId, String plant, String category,
            String actorUserId, String comments);

    /**
     * Same as {@link #forward} but value-threshold-aware: won't advance past the current level if
     * it's already this document's resolved stopping point (see
     * {@link #isFinalLevel(Integer, Integer, BigDecimal)}), even if a higher level physically
     * exists in the template for larger documents.
     */
    Optional<WfPricingCondition> forward(String docType, String docId, String plant, String category,
            String actorUserId, String comments, BigDecimal docValue);

    /** Terminal rejection (actionSts='R') - closes the workflow as REJECTED. */
    void reject(String docType, String docId, String actorUserId, String comments);

    /** Sends the document back to its originator for correction (actionSts='B') - resets to level 1 on resubmission. */
    void sendBack(String docType, String docId, String actorUserId, String comments);

    /** Marks the workflow fully approved/closed (e.g. once ezPostVendorToSAP-equivalent succeeds). */
    void markApproved(String docType, String docId, String actorUserId, String comments);

    WfDocHistoryHeader getDocHistory(String docType, String docId);
}
