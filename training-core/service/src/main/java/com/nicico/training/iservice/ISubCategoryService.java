package com.nicico.training.iservice;/*
com.nicico.training.iservice
@author : banifatemi
@Date : 6/8/2019
@Time :9:04 AM
    */

import com.nicico.copper.core.dto.search.SearchDTO;
import com.nicico.training.dto.CategoryDTO;
import com.nicico.training.dto.SubCategoryDTO;

import java.util.List;

public interface ISubCategoryService {
    SubCategoryDTO.Info get(Long id);

    List<SubCategoryDTO.Info> list();

    SubCategoryDTO.Info create(Object request);

    SubCategoryDTO.Info update(Long id, Object request);

    void delete(Long id);

    void delete(SubCategoryDTO.Delete request);

    SearchDTO.SearchRs<SubCategoryDTO.Info> search(SearchDTO.SearchRq request);

    // ---------------

    CategoryDTO.Info getCategory(Long categoryId);

}
