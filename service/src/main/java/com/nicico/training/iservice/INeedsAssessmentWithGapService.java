package com.nicico.training.iservice;

  import com.nicico.copper.common.dto.search.SearchDTO;
  import com.nicico.training.dto.CompetenceDTO;
  import com.nicico.training.dto.NeedsAssessmentWithGapDTO;
  import com.nicico.training.dto.SkillDTO;
  import response.BaseResponse;

  import java.util.List;
  import java.util.Set;


public interface INeedsAssessmentWithGapService {

    SearchDTO.SearchRs<SkillDTO.Info2> fullSearchForSkills(Long objectId, String objectType,Long competenceId);

    BaseResponse addSkills(NeedsAssessmentWithGapDTO.CreateNeedAssessment createNeedAssessment);

    Set<Long> searchWithoutPermission(Long competenceId, Long objectId, String objectType);

    BaseResponse sendToWorkFlow(Long objectId, String objectType);
    BaseResponse deleteUnCompleteData(Long objectId, String objectType);

    Boolean canChangeData(String objectType, Long objectId);

    SearchDTO.SearchRs<CompetenceDTO.Info> fullSearchForCompetences(Long objectId, String objectType);
}
