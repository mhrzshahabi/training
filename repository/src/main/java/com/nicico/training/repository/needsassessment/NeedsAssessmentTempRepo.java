package com.nicico.training.repository.needsassessment;

import com.nicico.training.model.NeedsAssessmentTemp;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface NeedsAssessmentTempRepo extends JpaRepository<NeedsAssessmentTemp, Long> {

    List<NeedsAssessmentTemp> findAllByObjectCodeAndMainWorkflowStatus(String code, String status);
    List<NeedsAssessmentTemp> findAllByObjectTypeAndObjectIdAndCompetenceId(String type,Long id,Long competenceId);
    List<NeedsAssessmentTemp> findByObjectCode(String code);
}
