package com.nicico.training.iservice;

import com.nicico.training.TrainingException;
import com.nicico.training.dto.NeedsAssessmentDTO;

import java.util.List;

public interface INeedsAssessmentTempService {
    void verify(String objectType, Long objectId);

    Boolean rollback(String objectType, Long objectId);

    Boolean copyNA(String typeCopyOf, Long idCopyOf, Long competenceId, String typeCopyTo, Long idCopyTo);

    List<NeedsAssessmentDTO.Info> getValuesForCopyNA(String typeCopyOf, Long idCopyOf, Long competenceId, String typeCopyTo, Long idCopyTo);

    TrainingException checkCategoryNotEquals(NeedsAssessmentDTO.Create create);

    Boolean isEditable(String objectType, Long objectId);

    NeedsAssessmentDTO.Info create(NeedsAssessmentDTO.Create create);

    Boolean createOrUpdateList(List<NeedsAssessmentDTO.Create> createList);

    Boolean isCreatedByCurrentUser(String objectType, Long objectId);

    Integer updateNeedsAssessmentTempMainWorkflow(String objectType, Long objectId, Integer workflowStatusCode, String workflowStatus);

    NeedsAssessmentDTO.Info delete(Long id);

    NeedsAssessmentDTO.Info update(Long id, NeedsAssessmentDTO.Update update);

    Integer readOnlyStatus(String objectType, Long objectId);

    Long createOrUpdateListForNewSkill(List<NeedsAssessmentDTO.Create> createList, Long skillId);
}
