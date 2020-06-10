package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.SkillLevelDTO;

import javax.servlet.http.HttpServletResponse;
import java.util.List;

public interface ISkillLevelService {

    SkillLevelDTO.Info get(Long id);

    List<SkillLevelDTO.Info> list();

    SkillLevelDTO.Info create(SkillLevelDTO.Create request, HttpServletResponse response);

    SkillLevelDTO.Info update(Long id, SkillLevelDTO.Update request,HttpServletResponse response);

    void delete(Long id);

    void delete(SkillLevelDTO.Delete request);

    SearchDTO.SearchRs<SkillLevelDTO.Info> search(SearchDTO.SearchRq request);
}
