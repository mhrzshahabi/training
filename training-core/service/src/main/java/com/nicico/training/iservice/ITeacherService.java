package com.nicico.training.iservice;

import com.nicico.copper.core.dto.search.SearchDTO;
import com.nicico.training.dto.CategoryDTO;
import com.nicico.training.dto.TeacherDTO;
import com.nicico.training.model.Category;

import java.util.List;
import java.util.Set;

public interface ITeacherService {

	TeacherDTO.Info get(Long id);

	List<TeacherDTO.Info> list();

	TeacherDTO.Info create(TeacherDTO.Create request);

	TeacherDTO.Info update(Long id, TeacherDTO.Update request);

	void delete(Long id);

	void delete(TeacherDTO.Delete request);

	SearchDTO.SearchRs<TeacherDTO.Info> search(SearchDTO.SearchRq request);

	void addCategories(CategoryDTO.Delete  request, Long teacherId);

//	Set<Category> getCategories(Long teacherId);
}
