package com.nicico.training.service;/*
com.nicico.training.service
@author : banifatemi
@Date : 6/8/2019
@Time :9:14 AM
    */


import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.CategoryDTO;
import com.nicico.training.dto.SubcategoryDTO;
import com.nicico.training.iservice.ICategoryService;
import com.nicico.training.model.Category;
import com.nicico.training.model.Subcategory;
import com.nicico.training.repository.CategoryDAO;
import com.nicico.training.repository.SubcategoryDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import response.question.dto.ElsCategoryDto;

import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CategoryService implements ICategoryService {

    private final ModelMapper modelMapper;
    private final CategoryDAO categoryDAO;
    private final SubcategoryDAO subCategoryDAO;


    @Transactional(readOnly = true)
    @Override
    public CategoryDTO.Info get(Long id) {
        final Optional<Category> cById = categoryDAO.findById(id);
        final Category category = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.EquipmentNotFound));

        return modelMapper.map(category, CategoryDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public List<CategoryDTO.Info> list() {
        final List<Category> cAll = categoryDAO.findAll();

        return modelMapper.map(cAll, new TypeToken<List<CategoryDTO.Info>>() {
        }.getType());
    }

    @Override
    public Set<Category> getCategoriesByIds(List<Long> categoryIds) {
        if (!categoryIds.isEmpty() && categoryIds.size() > 0) {
            List<Category> list = categoryDAO.findAllById(categoryIds);
            Set<Category> set = list.stream().collect(Collectors.toSet());
            return set;
        } else
            return null;
    }

    @Transactional
    @Override
    public CategoryDTO.Info create(CategoryDTO.Create request) {
        final Category category = modelMapper.map(request, Category.class);

        return save(category, request.getSubCategoryIds(),false);
    }

    @Transactional
    @Override
    public CategoryDTO.Info update(Long id, CategoryDTO.Update request) {
        final Optional<Category> cById = categoryDAO.findById(id);
        final Category category = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CategoryNotFound));

        Category updating = new Category();
        modelMapper.map(category, updating);
        modelMapper.map(request, updating);

        return save(updating, request.getSubCategoryIds(),true);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        categoryDAO.deleteById(id);
    }

    @Transactional
    @Override
    public void delete(CategoryDTO.Delete request) {
        final List<Category> cAllById = categoryDAO.findAllById(request.getIds());

        categoryDAO.deleteAll(cAllById);
    }

    @Transactional
    @Override
    public SearchDTO.SearchRs<CategoryDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(categoryDAO, request, category -> modelMapper.map(category, CategoryDTO.Info.class));
    }

    @Transactional(readOnly = true)
    @Override
    public <T> SearchDTO.SearchRs<T> search(SearchDTO.SearchRq request, Function converter) {
        return SearchUtil.search(categoryDAO, request, converter);
    }

    // ------------------------------

    private CategoryDTO.Info save(Category category, Set<Long> subCategoryIds,boolean isUpdate) {

        if(!isUpdate){
            final Set<Subcategory> subCategorySet = new HashSet<>();
            Optional.ofNullable(subCategoryIds)
                    .ifPresent(subCategoryIdSet -> subCategoryIdSet
                            .forEach(subCategoryIdss ->
                                    subCategorySet.add(subCategoryDAO.findById(subCategoryIdss)
                                            .orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SubCategoryNotFound)))
                            ));

            category.setSubCategorySet(subCategorySet);
        }

        final Category saved = categoryDAO.saveAndFlush(category);
        return modelMapper.map(saved, CategoryDTO.Info.class);
    }


    @Transactional(readOnly = true)
    @Override
    public List<SubcategoryDTO.Info> getSubCategories(Long categoryId) {
        final Optional<Category> ssById = categoryDAO.findById(categoryId);
        final Category category = ssById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CategoryNotFound));

        List<SubcategoryDTO.Info> subCategoryInfoSet = new ArrayList<>();
        Optional.ofNullable(category.getSubCategorySet())
                .ifPresent(subCategories ->
                        subCategories.forEach(subCategory ->
                                subCategoryInfoSet.add(modelMapper.map(subCategory, SubcategoryDTO.Info.class))
                        ));

        return subCategoryInfoSet;
    }

    @Override
    public List<Long> findCategoryByTeacher(Long teacherId) {
        return categoryDAO.findAllWithTeacher(teacherId);
    }

    @Transactional(readOnly = true)
    public List<ElsCategoryDto> getCategoriesForEls() {

        List<ElsCategoryDto> categoryDtoList = new ArrayList<>();
        List<CategoryDTO.Info> categories = list();
        categories.forEach(category -> {
            ElsCategoryDto elsCategoryDto = new ElsCategoryDto();
            elsCategoryDto.setCategoryId(category.getId());
            elsCategoryDto.setCategoryCode(category.getCode());
            elsCategoryDto.setCategoryName(category.getTitleFa());
            elsCategoryDto.setCategoryNameEn(category.getTitleEn());
            categoryDtoList.add(elsCategoryDto);
        });
        return categoryDtoList;
    }

}
