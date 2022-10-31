package com.nicico.training.iservice;

import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.CompetenceDTO;
import com.nicico.training.dto.NeedsAssessmentDTO;
import com.nicico.training.model.Competence;
import com.nicico.training.model.NeedsAssessmentWithGap;

import javax.servlet.http.HttpServletResponse;
import java.util.List;

public interface ICompetenceService {
    List<CompetenceDTO.Info> list();

    CompetenceDTO.Info checkAndCreate(CompetenceDTO.Create create, HttpServletResponse response);

    List<NeedsAssessmentDTO.Info> getUsedList(Long id);

    Boolean checkUsed(Long id);

    CompetenceDTO.Info checkAndUpdate(Long id, CompetenceDTO.Update update, HttpServletResponse response);

    CompetenceDTO.Info delete(Long id);

    TotalResponse<CompetenceDTO.Info> search(NICICOCriteria nicicoCriteria);

    SearchDTO.SearchRs<CompetenceDTO.Info> search(SearchDTO.SearchRq request);
    SearchDTO.SearchRs<CompetenceDTO.Posts> searchPosts(Long id, Integer startRow, Integer endRow);
    SearchDTO.SearchRs<CompetenceDTO.Posts> searchTempPosts(Long id, Integer startRow, Integer endRow);

    Competence getCompetence(Long id);

    List<CompetenceDTO.Info> getInfos(List<NeedsAssessmentWithGap> ids);

}
