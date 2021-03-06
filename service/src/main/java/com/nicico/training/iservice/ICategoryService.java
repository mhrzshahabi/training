package com.nicico.training.iservice;/* com.nicico.training.iservice
@Author:jafari-h
@Date:6/2/2019
@Time:1:30 PM
*/

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.CategoryDTO;
import com.nicico.training.dto.SubcategoryDTO;

import java.util.List;
import java.util.function.Function;

public interface ICategoryService {
    CategoryDTO.Info get(Long id);

    List<CategoryDTO.Info> list();

    CategoryDTO.Info create(CategoryDTO.Create request);

    CategoryDTO.Info update(Long id, CategoryDTO.Update request);

    void delete(Long id);

    void delete(CategoryDTO.Delete request);

    SearchDTO.SearchRs<CategoryDTO.Info> search(SearchDTO.SearchRq request);

    <T> SearchDTO.SearchRs<T> search(SearchDTO.SearchRq request, Function converter);

    // ---------------

    List<SubcategoryDTO.Info> getSubCategories(Long categoryId);

}
