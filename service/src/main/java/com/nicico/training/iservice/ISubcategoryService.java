package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.CategoryDTO;
import com.nicico.training.dto.SubcategoryDTO;
import com.nicico.training.model.Subcategory;
import response.question.dto.ElsSubCategoryDto;

import java.util.List;
import java.util.Set;
import java.util.function.Function;

public interface ISubcategoryService {

    SubcategoryDTO.Info get(Long id);

    List<SubcategoryDTO.Info> list();

    SubcategoryDTO.Info create(Object request);

    SubcategoryDTO.Info update(Long id, Object request);

    void delete(Long id);

    void delete(SubcategoryDTO.Delete request);

    SearchDTO.SearchRs<SubcategoryDTO.Info> search(SearchDTO.SearchRq request);

    <T> SearchDTO.SearchRs<T> search(SearchDTO.SearchRq request, Function converter);

    CategoryDTO.Info getCategory(Long categoryId);

    Set<Subcategory> getSubcategoriesByIds(List<Long> subCategoryIds);

    List<Long> findSubCategoriesByTeacher(Long teacherId);

    List<String> findSubCategoryNamesByEmpHistoryId(Long empHistoryId);

    List<String> findSubCategoryNamesByTeachHistoryId(Long teachHistoryId);

    List<ElsSubCategoryDto> getAllSubCategoriesForEls();

}
