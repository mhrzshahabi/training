package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.SkillStandardGroupDTO;

import java.util.List;

public interface ISkillStandardGroupService {
	SkillStandardGroupDTO.Info get(Long id);

	List<SkillStandardGroupDTO.Info> list();

	SkillStandardGroupDTO.Info create(SkillStandardGroupDTO.Create request);

	SkillStandardGroupDTO.Info update(Long id, SkillStandardGroupDTO.Update request);

	void delete(Long id);

	void delete(SkillStandardGroupDTO.Delete request);

	SearchDTO.SearchRs<SkillStandardGroupDTO.Info> search(SearchDTO.SearchRq request);
}
