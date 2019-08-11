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
import com.nicico.training.dto.SubCategoryDTO;
import com.nicico.training.iservice.ICategoryService;
import com.nicico.training.model.Category;
import com.nicico.training.model.SubCategory;
import com.nicico.training.repository.CategoryDAO;
import com.nicico.training.repository.SubCategoryDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Service
@RequiredArgsConstructor
public class CategoryService  implements ICategoryService {

    private final ModelMapper modelMapper;
    private final CategoryDAO categoryDAO;
    private final SubCategoryDAO subCategoryDAO;


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

    @Transactional
    @Override
    public CategoryDTO.Info create(CategoryDTO.Create request) {
        final Category category = modelMapper.map(request, Category.class);

        return save(category, request.getSubCategoryIds());
    }

    @Transactional
    @Override
    public CategoryDTO.Info update(Long id, CategoryDTO.Update request) {
        final Optional<Category> cById = categoryDAO.findById(id);
        final Category category = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CategoryNotFound));

        Category updating = new Category();
        modelMapper.map(category, updating);
        modelMapper.map(request, updating);

        return save(updating, request.getSubCategoryIds());
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

    // ------------------------------

    private CategoryDTO.Info save(Category category, Set<Long> subCategoryIds) {
        final Set<SubCategory> subCategorySet = new HashSet<>();
        Optional.ofNullable(subCategoryIds)
                .ifPresent(subCategoryIdSet -> subCategoryIdSet
                        .forEach(subCategoryIdss ->
                                subCategorySet.add(subCategoryDAO.findById(subCategoryIdss)
                                        .orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SubCategoryNotFound)))
                        ));

        category.setSubCategorySet(subCategorySet);
        final Category saved = categoryDAO.saveAndFlush(category);
        return modelMapper.map(saved, CategoryDTO.Info.class);
    }


    @Transactional(readOnly = true)
    @Override
    public List<SubCategoryDTO.Info> getSubCategories(Long categoryId) {
        final Optional<Category> ssById = categoryDAO.findById(categoryId);
        final Category category = ssById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CategoryNotFound));

        List<SubCategoryDTO.Info> subCategoryInfoSet = new ArrayList<>();
        Optional.ofNullable(category.getSubCategorySet())
                .ifPresent(subCategories ->
                        subCategories.forEach(subCategory ->
                                subCategoryInfoSet.add(modelMapper.map(subCategory, SubCategoryDTO.Info.class))
                        ));

        return subCategoryInfoSet;
    }
}
