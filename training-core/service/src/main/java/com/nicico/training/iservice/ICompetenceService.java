package com.nicico.training.iservice;

/*
AUTHOR: ghazanfari_f
DATE: 6/8/2019
TIME: 12:21 PM
*/

import com.nicico.copper.core.dto.search.SearchDTO;
import com.nicico.training.dto.CompetenceDTO;
import com.nicico.training.dto.JobCompetenceDTO;
import com.nicico.training.dto.SkillDTO;
import com.nicico.training.dto.SkillGroupDTO;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface ICompetenceService {

    CompetenceDTO.Info get(Long id);

    List<CompetenceDTO.Info> list();

    CompetenceDTO.Info create(CompetenceDTO.Create request);

    CompetenceDTO.Info update(Long id, CompetenceDTO.Update request);

    void delete(Long id);

    void delete(CompetenceDTO.Delete request);

    SearchDTO.SearchRs<CompetenceDTO.Info> search(SearchDTO.SearchRq request);

    List<CompetenceDTO.Info> getOtherCompetence(Long jobId);

    List<JobCompetenceDTO.Info> getJobCompetence(Long competenceId);

    @Transactional(readOnly = true)
    List<SkillDTO.Info> getSkills(Long competenceId);

    @Transactional(readOnly = true)
    List<SkillGroupDTO.Info> getSkillGroups(Long competenceId);
}
