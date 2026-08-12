package com.ezc.aragenPR.webapp.repository.workflow;

import java.util.List;

import com.ezc.aragenPR.webapp.model.workflow.WfWorkgroupUser;
import com.ezc.aragenPR.webapp.model.workflow.WfWorkgroupUserId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface WfWorkgroupUserRepository extends JpaRepository<WfWorkgroupUser, WfWorkgroupUserId> {

    /**
     * User ids authorized to act for a workflow group, scoped to a specific plant+category -
     * matches ezWFCommonMethods.jsp#getWorkFlowMails / getWFHirearchy: group membership
     * (EZC_WF_WORKGROUP_USERS) is global, but a user only participates for plant/category
     * combinations they're individually authorized for (EZC_USER_DEF_KEY_VALUES, key=CATEGORY,
     * value='{plant}#{category}'). Returns ids rather than joining straight to Users - a native
     * "SELECT u.*" across a JOIN doesn't reliably map back onto the Users entity (Hibernate
     * falls back to Object[] rows and throws ConversionFailedException); the caller looks the
     * ids up via UserRepository instead (see WorkflowEngineServiceImpl.resolveGroupUsers).
     */
    @Query(value = "SELECT DISTINCT w.EWWU_USER FROM ezc_wf_workgroup_users w "
            + "WHERE w.EWWU_GROUP = :group "
            + "AND w.EWWU_USER IN (SELECT EUDKV_USER_ID FROM ezc_user_def_key_values "
            + "WHERE EUDKV_KEY = 'CATEGORY' AND EUDKV_VALUE = CONCAT(:plant, '#', :category))",
            nativeQuery = true)
    List<String> findGroupUserIds(@Param("group") String group, @Param("plant") String plant, @Param("category") String category);

    /** Whether the given user is currently a member of this group (regardless of plant/category scoping) - used for a coarse membership check. */
    boolean existsByGroupAndUser(String group, String user);
}
