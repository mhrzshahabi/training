/*
ghazanfari_f, 9/7/2019, 10:55 AM
*/
package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.NeedAssessmentDTO;

import java.util.List;

public interface INeedAssessmentService {

    NeedAssessmentDTO.Info get(Long id);

    NeedAssessmentDTO.Info create(NeedAssessmentDTO.Create request);

    NeedAssessmentDTO.Info update(Long id, NeedAssessmentDTO.Update request);

    void delete(Long id);

    void delete(NeedAssessmentDTO.Delete request);

    List<NeedAssessmentDTO.Info> list();

    SearchDTO.SearchRs<NeedAssessmentDTO.Info> search(SearchDTO.SearchRq request);

}
