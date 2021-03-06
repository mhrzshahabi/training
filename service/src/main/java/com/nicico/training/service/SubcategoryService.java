package com.nicico.training.service;/*
com.nicico.training.service
@author : banifatemi
@Date : 6/8/2019
@Time :9:15 AM
    */

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.CategoryDTO;
import com.nicico.training.dto.SubcategoryDTO;
import com.nicico.training.iservice.ISubcategoryService;
import com.nicico.training.model.Category;
import com.nicico.training.model.Subcategory;
import com.nicico.training.repository.CategoryDAO;
import com.nicico.training.repository.SubcategoryDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import response.question.dto.ElsSubCategoryDto;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.function.Function;

@Service
@RequiredArgsConstructor
public class SubcategoryService implements ISubcategoryService {

    private final ModelMapper modelMapper;
    private final SubcategoryDAO subCategoryDAO;
    private final CategoryDAO categoryDAO;

    @Transactional(readOnly = true)
    @Override
    public SubcategoryDTO.Info get(Long id) {
        final Optional<Subcategory> cById = subCategoryDAO.findById(id);
        final Subcategory subCategory = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.EquipmentNotFound));

        return modelMapper.map(subCategory, SubcategoryDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public List<SubcategoryDTO.Info> list() {
        final List<Subcategory> cAll = subCategoryDAO.findAll();

        return modelMapper.map(cAll, new TypeToken<List<SubcategoryDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public SubcategoryDTO.Info create(Object request) {
        final Subcategory subCategory = modelMapper.map(request, Subcategory.class);

        return save(subCategory, subCategory.getCategoryId());
    }

    @Transactional
    @Override
    public SubcategoryDTO.Info update(Long id, Object request) {
        final Optional<Subcategory> cById = subCategoryDAO.findById(id);
        final Subcategory subCategory = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SubCategoryNotFound));
        SubcategoryDTO.Update update = modelMapper.map(request, SubcategoryDTO.Update.class);
        Subcategory updating = new Subcategory();
        modelMapper.map(subCategory, updating);
        modelMapper.map(update, updating);

        return save(updating, update.getCategoryId());
    }

    @Transactional
    @Override
    public void delete(Long id) {
        subCategoryDAO.deleteById(id);
    }

    @Transactional
    @Override
    public void delete(SubcategoryDTO.Delete request) {
        final List<Subcategory> cAllById = subCategoryDAO.findAllById(request.getIds());

        subCategoryDAO.deleteAll(cAllById);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<SubcategoryDTO.Info> search(SearchDTO.SearchRq request) {
        request.setCount(115);
        return SearchUtil.search(subCategoryDAO, request, subCategory -> modelMapper.map(subCategory, SubcategoryDTO.Info.class));
    }

    @Transactional(readOnly = true)
    @Override
    public <T> SearchDTO.SearchRs<T> search(SearchDTO.SearchRq request, Function converter) {
        return SearchUtil.search(subCategoryDAO, request, converter);
    }

    // ------------------------------

    private SubcategoryDTO.Info save(Subcategory subCategory, Long categoryId) {

        Optional<Category> optionalCategory = categoryDAO.findById(categoryId);
        Category category = optionalCategory.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CategoryNotFound));


        subCategory.setCategory(category);
        final Subcategory saved = subCategoryDAO.saveAndFlush(subCategory);
        return modelMapper.map(saved, SubcategoryDTO.Info.class);
    }


    @Transactional(readOnly = true)
    @Override
    public CategoryDTO.Info getCategory(Long subCategoryId) {
        final Optional<Subcategory> ssById = subCategoryDAO.findById(subCategoryId);
        final Subcategory subCategory = ssById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SubCategoryNotFound));

        return modelMapper.map(subCategory.getCategory(), CategoryDTO.Info.class);
    }

    @Transactional(readOnly = true)
    public List<ElsSubCategoryDto> getSubCategoriesForEls(Long categoryId) {

        List<ElsSubCategoryDto> subCategoryDtoList = new ArrayList<>();

        List<Subcategory> subCategories = subCategoryDAO.findAllByCategoryId(categoryId);
        subCategories.forEach(subcategory -> {
            ElsSubCategoryDto elsSubCategoryDto = new ElsSubCategoryDto();
            elsSubCategoryDto.setSubCategoryId(subcategory.getId());
            elsSubCategoryDto.setSubCategoryCode(subcategory.getCode());
            elsSubCategoryDto.setSubCategoryName(subcategory.getTitleFa());
            elsSubCategoryDto.setSubCategoryNameEn(subcategory.getTitleEn());
            elsSubCategoryDto.setCategoryId(categoryId);
            subCategoryDtoList.add(elsSubCategoryDto);
        });

        return subCategoryDtoList;
    }
}
