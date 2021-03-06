package com.nicico.training.repository;

import com.nicico.training.model.NeedsAssessmentTemp;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import java.util.Optional;

public interface NeedsAssessmentTempDAO extends BaseDAO<NeedsAssessmentTemp, Long> {
    Optional<NeedsAssessmentTemp> findFirstByObjectIdAndObjectTypeAndCompetenceIdAndSkillIdAndNeedsAssessmentDomainIdAndNeedsAssessmentPriorityId(
            Long objectId, String objectType, Long competenceId, Long skillId, Long needsAssessmentDomainId, Long needsAssessmentPriorityId
    );

    @Modifying
    @Query(value = "delete from TBL_NEEDS_ASSESSMENT_TEMP where F_OBJECT = :objectId and C_OBJECT_TYPE = :objectType", nativeQuery = true)
    void deleteAllByObjectIdAndObjectType(Long objectId, String objectType);

    @Modifying
    @Query(value = "delete from TBL_NEEDS_ASSESSMENT_TEMP where F_OBJECT = :objectId and C_OBJECT_TYPE = :objectType and N_MAIN_WORKFLOW_STATUS_CODE is null", nativeQuery = true)
    void deleteAllNotSentByObjectIdAndObjectType(Long objectId, String objectType);

    Optional<NeedsAssessmentTemp> findFirstByCompetenceId(Long competenceId);

    @Modifying
    @Query(value = "update TBL_NEEDS_ASSESSMENT_TEMP SET N_MAIN_WORKFLOW_STATUS_CODE = :mainWorkflowStatusCode , C_MAIN_WORKFLOW_STATUS = :mainWorkflowStatus WHERE f_object = :objectId AND c_object_type = :objectType", nativeQuery = true)
    Integer updateNeedsAssessmentTempWorkflowMainStatus(String objectType, Long objectId, Integer mainWorkflowStatusCode, String mainWorkflowStatus);
}