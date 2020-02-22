/*
ghazanfari_f,
1/14/2020,
1:55 PM
*/
package com.nicico.training.repository;

import com.nicico.training.model.NeedsAssessment;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

public interface NeedsAssessmentDAO extends BaseDAO<NeedsAssessment, Long> {

    @Modifying
    @Query(value = "update TBL_NEEDS_ASSESSMENT SET N_WORKFLOW_STATUS_CODE = :workflowStatusCode , C_WORKFLOW_STATUS = :workflowStatus WHERE f_object = (SELECT  f_object FROM TBL_NEEDS_ASSESSMENT WHERE id = :needsAssessmentId)", nativeQuery = true)
    public Integer updateNeedsAssessmentWorkflowStatus(Long needsAssessmentId, Integer workflowStatusCode, String workflowStatus);
}



