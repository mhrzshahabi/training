
package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.NeedAssessmentSkillBasedDTO;

import java.util.List;

public interface INeedAssessmentSkillBasedService {

    NeedAssessmentSkillBasedDTO.Info get(Long id);

    NeedAssessmentSkillBasedDTO.Info create(NeedAssessmentSkillBasedDTO.Create request);

    NeedAssessmentSkillBasedDTO.Info update(Long id, NeedAssessmentSkillBasedDTO.Update request);

    void delete(Long id);

    void delete(NeedAssessmentSkillBasedDTO.Delete request);

    List<NeedAssessmentSkillBasedDTO.Info> list();

    SearchDTO.SearchRs<NeedAssessmentSkillBasedDTO.Info> search(SearchDTO.SearchRq request);

    SearchDTO.SearchRs<NeedAssessmentSkillBasedDTO.Info> deepSearch(SearchDTO.SearchRq request, String objectType, Long objectId);

}
