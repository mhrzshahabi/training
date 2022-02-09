package com.nicico.training.iservice;

import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.CompetenceDTO;
import com.nicico.training.dto.NeedsAssessmentDTO;

import javax.servlet.http.HttpServletResponse;
import java.util.List;

public interface ICompetenceService {
    List<CompetenceDTO.Info> list();

    CompetenceDTO.Info checkAndCreate(CompetenceDTO.Create create, HttpServletResponse response);

    List<NeedsAssessmentDTO.Info> checkUsed(Long id);

    CompetenceDTO.Info checkAndUpdate(Long id, CompetenceDTO.Update update, HttpServletResponse response);

    CompetenceDTO.Info delete(Long id);

    TotalResponse<CompetenceDTO.Info> search(NICICOCriteria nicicoCriteria);

    SearchDTO.SearchRs<CompetenceDTO.Info> search(SearchDTO.SearchRq request);
}
