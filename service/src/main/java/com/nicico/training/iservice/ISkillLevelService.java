package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.SkillLevelDTO;

import java.util.List;

public interface ISkillLevelService {

    SkillLevelDTO.Info get(Long id);

    List<SkillLevelDTO.Info> list();

    SkillLevelDTO.Info create(SkillLevelDTO.Create request);

    SkillLevelDTO.Info update(Long id, SkillLevelDTO.Update request);

    void delete(Long id);

    void delete(SkillLevelDTO.Delete request);

    SearchDTO.SearchRs<SkillLevelDTO.Info> search(SearchDTO.SearchRq request);
}
