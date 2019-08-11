package com.nicico.training.iservice;/*
com.nicico.training.iservice
@author : banifatemi
@Date : 6/8/2019
@Time :9:04 AM
    */

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.CompetenceDTO;
import com.nicico.training.dto.JobDTO;
import com.nicico.training.dto.SkillDTO;
import com.nicico.training.dto.SkillGroupDTO;

import java.util.List;
import java.util.Set;

public interface ISkillGroupService {
    SkillGroupDTO.Info get(Long id);

    List<SkillGroupDTO.Info> list();

    SkillGroupDTO.Info create(SkillGroupDTO.Create request);

    SkillGroupDTO.Info update(Long id, SkillGroupDTO.Update request);

    void delete(Long id);

    void delete(SkillGroupDTO.Delete request);

    void addSkill(Long skillGroupId,Long skillId);
    void addSkills(Long skillGroupId,Set<Long> skillIds);
    void removeSkill(Long skillGroupId,Long skillId);
    void removeSkills(Long skillGroupId,Set<Long> skillIds);
    void removeFromCompetency(Long skillGroupId,Long competenceId);
    void removeFromAllCompetences(Long skillGroupId);
    Set<SkillDTO.Info> unAttachSkills(Long skillGroupId);
    boolean canDelete(Long skillGroupId);

    SearchDTO.SearchRs<SkillGroupDTO.Info> search(SearchDTO.SearchRq request);

    List<CompetenceDTO.Info> getCompetence(Long skillGroupID);
    List<JobDTO.Info> getJobs(Long skillGroupID);
    List<SkillDTO.Info> getSkills(Long skillGroupID);


}
