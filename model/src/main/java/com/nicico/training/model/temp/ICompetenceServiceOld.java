package com.nicico.training.iservice;

/*
AUTHOR: ghazanfari_f
DATE: 6/8/2019
TIME: 12:21 PM
*/

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.*;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface ICompetenceServiceOld {

    CompetenceDTOOld.Info get(Long id);

    List<CompetenceDTOOld.Info> list();

    CompetenceDTOOld.Info create(CompetenceDTOOld.Create request);

    CompetenceDTOOld.Info update(Long id, CompetenceDTOOld.Update request);

    void delete(Long id);

    void delete(CompetenceDTOOld.Delete request);

    SearchDTO.SearchRs<CompetenceDTOOld.Info> search(SearchDTO.SearchRq request);

    List<CompetenceDTOOld.Info> getOtherCompetence(Long jobId);

    List<JobCompetenceDTO.Info> getJobCompetence(Long competenceId);

    @Transactional(readOnly = true)
    List<SkillDTO.Info> getSkills(Long competenceId);

    @Transactional(readOnly = true)
    List<SkillGroupDTO.Info> getSkillGroups(Long competenceId);

    @Transactional(readOnly = true)
    List<CourseDTO.Info> getCourses(Long competenceId);
}
