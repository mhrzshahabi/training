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
    @Query(value = "update TBL_NEEDS_ASSESSMENT_TEMP SET e_deleted = 75 WHERE id = :id", nativeQuery = true)
    public void softDelete(Long id);

    @Modifying
    @Query(value = "update TBL_NEEDS_ASSESSMENT_TEMP SET e_deleted = null WHERE id = :id", nativeQuery = true)
    public void recycle(Long id);

}



