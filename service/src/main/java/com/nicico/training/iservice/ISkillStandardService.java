package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.CourseDTO;
import com.nicico.training.dto.SkillStandardDTO;

import java.util.List;
import java.util.Set;

public interface ISkillStandardService {

	SkillStandardDTO.Info get(Long id);

	List<SkillStandardDTO.Info> list();

	SkillStandardDTO.Info create(SkillStandardDTO.Create request);

	SkillStandardDTO.Info update(Long id, SkillStandardDTO.Update request);

	void delete(Long id);

	void delete(SkillStandardDTO.Delete request);

	SearchDTO.SearchRs<SkillStandardDTO.Info> search(SearchDTO.SearchRq request);

	// ---------------

	Set<CourseDTO.Info> getCourses(Long skillStandardId);
}
