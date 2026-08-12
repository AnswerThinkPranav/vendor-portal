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
        return wfPricingConditionRepository.findMaxLevel(template)
                .map(max -> level != null && level.intValue() >= max.intValue())
                .orElse(true);
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
        Integer template = resolveTemplate(docType, compCode, plant, category).orElse(null);
        if (template == null) {
            return Optional.empty();
        }
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
        WfDocHistoryHeader header = requireHeader(docType, docId);
        requireAuthorized(header, plant, category, actorUserId);

        int template = header.getTemplateCode().intValue();
        int nextLevelNo = header.getCurrentStep().intValue() + 1;
        List<WfPricingCondition> nextLevels = wfPricingConditionRepository.findByTemplateAndLevel(template, nextLevelNo);

        LocalDateTime now = LocalDateTime.now();
        if (nextLevels.isEmpty()) {
            // No further level configured - caller should route to the terminal action instead.
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

    @Override
    @Transactional
    public void sendBack(String docType, String docId, String actorUserId, String comments) {
        WfDocHistoryHeader header = requireHeader(docType, docId);
        Optional<WfPricingCondition> level1 = header.getTemplateCode() == null
                ? Optional.empty() : getFirstLevel(header.getTemplateCode().intValue());

        LocalDateTime now = LocalDateTime.now();
        header.setWfStatus("RESUBMITTED");
        header.setCurrentStep(BigDecimal.ZERO);
        header.setNextParticipant(level1.map(WfPricingCondition::getGroup).orElse(""));
        header.setModifiedBy(actorUserId);
        header.setModifiedOn(now);
        wfDocHistoryHeaderRepository.save(header);

        addAudit(docId, docType, actorUserId, "U", "Sent back to originator by " + actorUserId, now);
        addComment(docType, docId, comments, actorUserId, now);
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
