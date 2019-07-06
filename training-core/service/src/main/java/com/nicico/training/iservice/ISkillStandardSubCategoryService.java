package com.nicico.training.iservice;

import com.nicico.copper.core.dto.search.SearchDTO;
import com.nicico.training.dto.SkillStandardSubCategoryDTO;

import java.util.List;

public interface ISkillStandardSubCategoryService {

	SkillStandardSubCategoryDTO.Info get(Long id);

	List<SkillStandardSubCategoryDTO.Info> list();

	SkillStandardSubCategoryDTO.Info create(SkillStandardSubCategoryDTO.Create request);

	SkillStandardSubCategoryDTO.Info update(Long id, SkillStandardSubCategoryDTO.Update request);

	void delete(Long id);

	void delete(SkillStandardSubCategoryDTO.Delete request);

	SearchDTO.SearchRs<SkillStandardSubCategoryDTO.Info> search(SearchDTO.SearchRq request);
}
