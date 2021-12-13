package com.nicico.training.iservice;/*
com.nicico.training.iservice
@author : banifatemi
@Date : 6/8/2019
@Time :9:04 AM
    */

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.CategoryDTO;
import com.nicico.training.dto.SubcategoryDTO;
import com.nicico.training.model.Category;
import com.nicico.training.model.Subcategory;

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

    // ---------------

    CategoryDTO.Info getCategory(Long categoryId);

    Set<Subcategory> getSubcategoriesByIds(List<Long> subCategoryIds);
}
