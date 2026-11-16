package com.ezc.aragenPR.webapp.service.workflow;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import com.ezc.aragenPR.webapp.model.rfq.DocumentComment;
import com.ezc.aragenPR.webapp.model.user.UserDefaults;
import com.ezc.aragenPR.webapp.model.user.Users;
import com.ezc.aragenPR.webapp.model.workflow.WfAuditTrail;
import com.ezc.aragenPR.webapp.model.workflow.WfDocHistoryHeader;
import com.ezc.aragenPR.webapp.model.workflow.WfPricingCondition;
import com.ezc.aragenPR.webapp.repository.rfq.DocumentCommentRepository;
import com.ezc.aragenPR.webapp.repository.user.UserDefRepository;
import com.ezc.aragenPR.webapp.repository.user.UserRepository;
import com.ezc.aragenPR.webapp.repository.workflow.WfAuditTrailRepository;
import com.ezc.aragenPR.webapp.repository.workflow.WfDocHistoryHeaderRepository;
import com.ezc.aragenPR.webapp.repository.workflow.WfKeyMapRepository;
import com.ezc.aragenPR.webapp.repository.workflow.WfPricingConditionRepository;
import com.ezc.aragenPR.webapp.repository.workflow.WfWorkgroupUserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class WorkflowEngineServiceImpl implements IWorkflowEngineService {

    /** Aragen targets a single downstream system, unlike the legacy multi-SAP-system routing (see UserDefaults.sysKey). */
    private static final String SYS_KEY = "ARAGEN";

    @Autowired
    private WfKeyMapRepository wfKeyMapRepository;

    @Autowired
    private WfPricingConditionRepository wfPricingConditionRepository;

    @Autowired
    private WfWorkgroupUserRepository wfWorkgroupUserRepository;

    @Autowired
    private WfDocHistoryHeaderRepository wfDocHistoryHeaderRepository;

    @Autowired
    private WfAuditTrailRepository wfAuditTrailRepository;

    @Autowired
    private UserDefRepository userDefRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private DocumentCommentRepository documentCommentRepository;

    @Override
    public Optional<Integer> resolveTemplate(String docType, String compCode, String plant, String category) {
        return wfKeyMapRepository.findByDocTypeAndCompCodeAndPlantAndCategory(docType, compCode, plant, category)
                .map(com.ezc.aragenPR.webapp.model.workflow.WfKeyMap::getTemplate);
    }

    @Override
    public List<Users> resolveGroupUsers(String group, String plant, String category) {
        List<String> userIds = wfWorkgroupUserRepository.findGroupUserIds(group, plant, category);
        return userRepository.findAllById(userIds);
    }

    @Override
    public String getUserRole(String userId) {
        UserDefaults ud = userDefRepository.findByuserIdAndKey(userId, "USERROLE");
        return ud == null || ud.getValue() == null ? "" : ud.getValue();
    }

    @Override
    public boolean isFinalLevel(Integer template, Integer level) {
        return isFinalLevel(template, level, null);
    }

    @Override
    public boolean isFinalLevel(Integer template, Integer level, BigDecimal docValue) {
        return resolveFinalLevel(template, docValue).map(fl -> level != null && level.intValue() >= fl.intValue()).orElse(true);
    }

    /**
     * Real shape of value-threshold routing (see EWPC_QCF_FLAG/EWPC_QCF_RELEASE): it's a single
     * sequential ladder (level 1, 2, 3, ... in order - exactly one row per level, no branching
     * within a level), where the escalation LENGTH depends on the document's value rather than
     * the row chosen at any one level. A real example: levels 1-3 (PUR_PERSON/LEADBUYER/SITEFI)
     * carry a dummy "LE 0" (never satisfied by a real positive amount, so never a stopping point -
     * every document always climbs past them), then level 4 (BUHEAD) is "LE 500000", level 5
     * (FIHEAD) is "LE 2499999", level 6 (CEO) is "GE 2500000". A ₹300,000 document's final level
     * is 4 (BUHEAD) - it must never continue to level 5/6, even though those levels physically
     * exist in the same template for larger documents. This resolves that stopping level: scan
     * every level that has a real LE/GE condition, sorted by release value ascending, and return
     * the first one the document value satisfies.
     */
    private Optional<Integer> resolveFinalLevel(Integer template, BigDecimal docValue) {
        List<WfPricingCondition> rows = wfPricingConditionRepository.findByTemplateOrderByLevelAsc(template);
        if (rows.isEmpty()) {
            return Optional.empty();
        }
        if (docValue == null) {
            // No value-based routing requested (e.g. Vendor Registration's templates, which don't
            // use EWPC_QCF_FLAG at all) - preserve the old "final = max level" behavior exactly.
            return Optional.of(rows.get(rows.size() - 1).getLevel());
        }

        List<WfPricingCondition> thresholdRows = rows.stream()
                .filter(r -> r.getConditionFlag() != null && !r.getConditionFlag().isBlank() && r.getConditionValue() != null)
                .sorted(java.util.Comparator.comparing(WfPricingCondition::getConditionValue))
                .toList();
        for (WfPricingCondition r : thresholdRows) {
            if (matchesCondition(r, docValue)) {
                return Optional.of(r.getLevel());
            }
        }
        // No threshold matched - shouldn't happen with a well-formed template (the top GE level
        // should catch every value above the highest LE), but fall back to the highest configured
        // level rather than leaving the document stuck with no resolvable final level.
        if (!thresholdRows.isEmpty()) {
            return Optional.of(thresholdRows.get(thresholdRows.size() - 1).getLevel());
        }
        return Optional.of(rows.get(rows.size() - 1).getLevel());
    }

    private boolean matchesCondition(WfPricingCondition c, BigDecimal docValue) {
        String flag = c.getConditionFlag();
        if (flag == null || flag.isBlank() || c.getConditionValue() == null) {
            return false;
        }
        BigDecimal release = BigDecimal.valueOf(c.getConditionValue());
        return switch (flag) {
            case "LE" -> docValue.compareTo(release) <= 0;
            case "GE" -> docValue.compareTo(release) >= 0;
            default -> false;
        };
    }

    @Override
    public Optional<WfPricingCondition> getFirstLevel(Integer template) {
        return wfPricingConditionRepository.findByTemplateAndLevel(template, 1).stream().findFirst();
    }

    @Override
    public Optional<WfPricingCondition> getCurrentLevel(String docType, String docId) {
        WfDocHistoryHeader header = wfDocHistoryHeaderRepository.findByAuthKeyAndDocId(docType, docId).orElse(null);
        if (header == null || header.getTemplateCode() == null || header.getCurrentStep() == null) {
            return Optional.empty();
        }
        return wfPricingConditionRepository.findByTemplateAndLevel(header.getTemplateCode().intValue(), header.getCurrentStep().intValue())
                .stream().findFirst();
    }

    @Override
    public WfDocHistoryHeader getDocHistory(String docType, String docId) {
        return wfDocHistoryHeaderRepository.findByAuthKeyAndDocId(docType, docId).orElse(null);
    }

    @Override
    @Transactional
    public Optional<WfPricingCondition> startWorkflow(String docType, String docId, String compCode, String plant,
            String category, String startedByUserId, String comments) {
        return startWorkflow(docType, docId, compCode, plant, category, startedByUserId, comments, null);
    }

    @Override
    @Transactional
    public Optional<WfPricingCondition> startWorkflow(String docType, String docId, String compCode, String plant,
            String category, String startedByUserId, String comments, BigDecimal docValue) {
        Integer template = resolveTemplate(docType, compCode, plant, category).orElse(null);
        if (template == null) {
            return Optional.empty();
        }
        // Level 1 is always level 1 regardless of document value - value only decides how far up
        // the ladder the document climbs before stopping (see resolveFinalLevel), never which row
        // to start at.
        Optional<WfPricingCondition> level1 = getFirstLevel(template);
        if (level1.isEmpty()) {
            return Optional.empty();
        }

        LocalDateTime now = LocalDateTime.now();
        WfDocHistoryHeader header = wfDocHistoryHeaderRepository.findByAuthKeyAndDocId(docType, docId)
                .orElseGet(WfDocHistoryHeader::new);
        boolean isNew = header.getAuthKey() == null;
        header.setAuthKey(docType);
        header.setDocId(docId);
        header.setSysKey(SYS_KEY);
        header.setTemplateCode(BigDecimal.valueOf(template));
        header.setWfStatus("SUBMITTED");
        header.setCurrentStep(BigDecimal.valueOf(level1.get().getLevel()));
        header.setNextParticipant(level1.get().getGroup());
        if (isNew) {
            header.setCreatedBy(startedByUserId);
            header.setCreatedOn(now);
        }
        header.setModifiedBy(startedByUserId);
        header.setModifiedOn(now);
        wfDocHistoryHeaderRepository.save(header);

        addComment(docType, docId, comments, startedByUserId, now);
        addAudit(docId, docType, startedByUserId, "U", "Submitted for approval by " + startedByUserId, now);

        return level1;
    }

    @Override
    @Transactional
    public Optional<WfPricingCondition> forward(String docType, String docId, String plant, String category,
            String actorUserId, String comments) {
        return forward(docType, docId, plant, category, actorUserId, comments, null);
    }

    @Override
    @Transactional
    public Optional<WfPricingCondition> forward(String docType, String docId, String plant, String category,
            String actorUserId, String comments, BigDecimal docValue) {
        WfDocHistoryHeader header = requireHeader(docType, docId);
        requireAuthorized(header, plant, category, actorUserId);

        int template = header.getTemplateCode().intValue();
        int currentLevelNo = header.getCurrentStep().intValue();
        LocalDateTime now = LocalDateTime.now();

        // The current level may already be this document's resolved stopping point even though a
        // higher-numbered level row physically exists in the template (it's there for documents
        // with a bigger value that climb further) - never advance past it in that case.
        if (isFinalLevel(template, currentLevelNo, docValue)) {
            addAudit(docId, docType, actorUserId, "U", "Reviewed by " + actorUserId + " (final level)", now);
            addComment(docType, docId, comments, actorUserId, now);
            return Optional.empty();
        }

        int nextLevelNo = currentLevelNo + 1;
        List<WfPricingCondition> nextLevels = wfPricingConditionRepository.findByTemplateAndLevel(template, nextLevelNo);
        if (nextLevels.isEmpty()) {
            // No further level configured at all - safety net for a malformed template.
            addAudit(docId, docType, actorUserId, "U", "Reviewed by " + actorUserId + " (final level)", now);
            addComment(docType, docId, comments, actorUserId, now);
            return Optional.empty();
        }

        WfPricingCondition next = nextLevels.get(0);
        header.setWfStatus("SUBMITTED");
        header.setCurrentStep(BigDecimal.valueOf(next.getLevel()));
        header.setNextParticipant(next.getGroup());
        header.setModifiedBy(actorUserId);
        header.setModifiedOn(now);
        wfDocHistoryHeaderRepository.save(header);

        addAudit(docId, docType, actorUserId, "U", "Forwarded by " + actorUserId + " to " + next.getGroup(), now);
        addComment(docType, docId, comments, actorUserId, now);

        return Optional.of(next);
    }

    @Override
    @Transactional
    public void reject(String docType, String docId, String actorUserId, String comments) {
        WfDocHistoryHeader header = requireHeader(docType, docId);
        LocalDateTime now = LocalDateTime.now();
        header.setWfStatus("REJECTED");
        header.setModifiedBy(actorUserId);
        header.setModifiedOn(now);
        wfDocHistoryHeaderRepository.save(header);

        addAudit(docId, docType, actorUserId, "U", "Rejected by " + actorUserId, now);
        addComment(docType, docId, comments, actorUserId, now);
    }

    /**
     * Unlike the legacy JSP (which keeps the workflow row alive, resetting it to level 1 with
     * wf_status='RESUBMITTED'), Send Back here hands the document fully back to the vendor: the
     * workflow row is deleted outright and the vendor's doc reverts to INITIATED - the same state
     * as a fresh invite, requiring a full re-submit (see VendorRegistrationServiceImpl's SEND_BACK
     * case and submitVendorRegistration, which recreates this row from scratch on the next submit).
     */
    @Override
    @Transactional
    public void sendBack(String docType, String docId, String actorUserId, String comments) {
        WfDocHistoryHeader header = requireHeader(docType, docId);
        LocalDateTime now = LocalDateTime.now();

        addAudit(docId, docType, actorUserId, "U", "Sent back to originator by " + actorUserId, now);
        addComment(docType, docId, comments, actorUserId, now);

        wfDocHistoryHeaderRepository.delete(header);
    }

    @Override
    @Transactional
    public void markApproved(String docType, String docId, String actorUserId, String comments) {
        WfDocHistoryHeader header = requireHeader(docType, docId);
        LocalDateTime now = LocalDateTime.now();
        header.setWfStatus("APPROVED");
        header.setCurrentStep(BigDecimal.ZERO);
        header.setNextParticipant("");
        header.setModifiedBy(actorUserId);
        header.setModifiedOn(now);
        wfDocHistoryHeaderRepository.save(header);

        addAudit(docId, docType, actorUserId, "U", "Approved by " + actorUserId, now);
        addComment(docType, docId, comments, actorUserId, now);
    }

    private WfDocHistoryHeader requireHeader(String docType, String docId) {
        return wfDocHistoryHeaderRepository.findByAuthKeyAndDocId(docType, docId)
                .orElseThrow(() -> new IllegalStateException("No workflow in progress for " + docType + " " + docId));
    }

    /** Confirms the actor is actually a member of the doc's current routing group for its own plant+category - fails loudly rather than letting an unauthorized user silently advance the document. */
    private void requireAuthorized(WfDocHistoryHeader header, String plant, String category, String actorUserId) {
        String group = header.getNextParticipant();
        if (group == null || group.isBlank()) {
            throw new IllegalStateException("This document has no pending approval step.");
        }
        boolean authorized = resolveGroupUsers(group, plant, category).stream()
                .anyMatch(u -> actorUserId.equals(u.getUserId()));
        if (!authorized) {
            throw new IllegalStateException("You are not authorized to act on this document at its current step (" + group + ").");
        }
    }

    private void addAudit(String docId, String docType, String actorUserId, String participantType, String comments, LocalDateTime now) {
        int nextAuditNo = wfAuditTrailRepository.findMaxAuditNo(docId).orElse(0) + 1;
        WfAuditTrail audit = new WfAuditTrail();
        audit.setAuditNo(String.valueOf(nextAuditNo));
        audit.setDocId(docId);
        audit.setDocType(docType);
        audit.setSourceParticipant(actorUserId);
        audit.setSourceParticipantType(participantType);
        audit.setDestParticipant("");
        audit.setDestParticipantType("");
        audit.setComments(comments);
        audit.setDate(now);
        wfAuditTrailRepository.save(audit);
    }

    private void addComment(String docType, String docId, String comments, String userId, LocalDateTime now) {
        if (comments == null || comments.isBlank()) {
            return;
        }
        DocumentComment comment = new DocumentComment();
        comment.setDocId(docId);
        comment.setDocType(docType);
        comment.setComments(comments);
        comment.setUserId(userId);
        comment.setDate(now);
        documentCommentRepository.save(comment);
    }
}
