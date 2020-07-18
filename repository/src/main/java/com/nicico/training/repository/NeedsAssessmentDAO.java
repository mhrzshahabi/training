/*
ghazanfari_f,
1/14/2020,
1:55 PM
*/
package com.nicico.training.repository;

import com.nicico.training.model.NeedsAssessment;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface NeedsAssessmentDAO extends BaseDAO<NeedsAssessment, Long> {

    @Modifying
    @Query(value = "update TBL_NEEDS_ASSESSMENT SET N_WORKFLOW_STATUS_CODE = :workflowStatusCode , C_WORKFLOW_STATUS = :workflowStatus WHERE f_object = (SELECT  f_object FROM TBL_NEEDS_ASSESSMENT WHERE id = :needsAssessmentId)", nativeQuery = true)
    public Integer updateNeedsAssessmentWorkflowStatus(Long needsAssessmentId, Integer workflowStatusCode, String workflowStatus);

    @Modifying
    @Query(value = "update TBL_NEEDS_ASSESSMENT SET N_MAIN_WORKFLOW_STATUS_CODE = :mainWorkflowStatusCode , C_MAIN_WORKFLOW_STATUS = :mainWorkflowStatus WHERE f_object = (SELECT  f_object FROM TBL_NEEDS_ASSESSMENT WHERE id = :needsAssessmentId)", nativeQuery = true)
    public Integer updateNeedsAssessmentWorkflowMainStatus(Long needsAssessmentId, Integer mainWorkflowStatusCode, String mainWorkflowStatus);


    @Query(value = "select seq_needs_assessment_id.nextval from dual", nativeQuery = true)
    public Long getNextId();

    Optional<NeedsAssessment> findFirstByCompetenceId(Long competenceId);

    Boolean existsByCompetenceId(Long competenceId);

}



