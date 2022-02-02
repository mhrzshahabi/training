package com.nicico.training.repository.needsassessment;

import com.nicico.training.model.NeedsAssessmentTemp;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface NeedsAssessmentTempRepo extends JpaRepository<NeedsAssessmentTemp, Long> {

    List<NeedsAssessmentTemp> findAllByObjectCodeAndMainWorkflowStatus(String code, String status);
}
