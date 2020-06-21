package com.nicico.training.repository;

import com.nicico.training.model.NeedsAssessmentTemp;

import java.util.Optional;

public interface NeedsAssessmentTempDAO extends BaseDAO<NeedsAssessmentTemp, Long> {
    Optional<NeedsAssessmentTemp> findFirstByObjectIdAndObjectTypeAndCompetenceIdAndSkillIdAndNeedsAssessmentDomainIdAndNeedsAssessmentPriorityId(
            Long objectId, String objectType, Long competenceId, Long skillId, Long needsAssessmentDomainId, Long needsAssessmentPriorityId
    );

}



