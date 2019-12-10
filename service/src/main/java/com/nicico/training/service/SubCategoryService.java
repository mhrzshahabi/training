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
import com.nicico.training.dto.SubCategoryDTO;
import com.nicico.training.iservice.ISubCategoryService;
import com.nicico.training.model.Category;
import com.nicico.training.model.SubCategory;
import com.nicico.training.repository.CategoryDAO;
import com.nicico.training.repository.SubCategoryDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class SubCategoryService implements ISubCategoryService {

    private final ModelMapper modelMapper;
    private final SubCategoryDAO subCategoryDAO;
    private final CategoryDAO categoryDAO;

    @Transactional(readOnly = true)
    @Override
    public SubCategoryDTO.Info get(Long id) {
        final Optional<SubCategory> cById = subCategoryDAO.findById(id);
        final SubCategory subCategory = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.EquipmentNotFound));

        return modelMapper.map(subCategory, SubCategoryDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public List<SubCategoryDTO.Info> list() {
        final List<SubCategory> cAll = subCategoryDAO.findAll();

        return modelMapper.map(cAll, new TypeToken<List<SubCategoryDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public SubCategoryDTO.Info create(Object request) {
        final SubCategory subCategory = modelMapper.map(request, SubCategory.class);

        return save(subCategory, subCategory.getCategoryId());
    }

    @Transactional
    @Override
    public SubCategoryDTO.Info update(Long id, Object request) {
        final Optional<SubCategory> cById = subCategoryDAO.findById(id);
        final SubCategory subCategory = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SubCategoryNotFound));
        SubCategoryDTO.Update update = modelMapper.map(request, SubCategoryDTO.Update.class);
        SubCategory updating = new SubCategory();
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
    public void delete(SubCategoryDTO.Delete request) {
        final List<SubCategory> cAllById = subCategoryDAO.findAllById(request.getIds());

        subCategoryDAO.deleteAll(cAllById);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<SubCategoryDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(subCategoryDAO, request, subCategory -> modelMapper.map(subCategory, SubCategoryDTO.Info.class));
    }

    // ------------------------------

    private SubCategoryDTO.Info save(SubCategory subCategory, Long categoryId) {

        Optional<Category> optionalCategory = categoryDAO.findById(categoryId);
        Category category = optionalCategory.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CategoryNotFound));


        subCategory.setCategory(category);
        final SubCategory saved = subCategoryDAO.saveAndFlush(subCategory);
        return modelMapper.map(saved, SubCategoryDTO.Info.class);
    }


    @Transactional(readOnly = true)
    @Override
    public CategoryDTO.Info getCategory(Long subCategoryId) {
        final Optional<SubCategory> ssById = subCategoryDAO.findById(subCategoryId);
        final SubCategory subCategory = ssById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SubCategoryNotFound));

        return modelMapper.map(subCategory.getCategory(), CategoryDTO.Info.class);
    }
}
