package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.SkillStandardCategoryDTO;

import java.util.List;

public interface ISkillStandardCategoryService {

	SkillStandardCategoryDTO.Info get(Long id);

	List<SkillStandardCategoryDTO.Info> list();

	SkillStandardCategoryDTO.Info create(SkillStandardCategoryDTO.Create request);

	SkillStandardCategoryDTO.Info update(Long id, SkillStandardCategoryDTO.Update request);

	void delete(Long id);

	void delete(SkillStandardCategoryDTO.Delete request);

	SearchDTO.SearchRs<SkillStandardCategoryDTO.Info> search(SearchDTO.SearchRq request);

}
