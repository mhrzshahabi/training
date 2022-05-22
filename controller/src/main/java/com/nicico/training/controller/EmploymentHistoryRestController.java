package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.controller.util.CriteriaUtil;
import com.nicico.training.dto.CategoryDTO;
import com.nicico.training.dto.EmploymentHistoryDTO;
import com.nicico.training.dto.SubcategoryDTO;
import com.nicico.training.iservice.ICategoryService;
import com.nicico.training.iservice.IEmploymentHistoryService;
import com.nicico.training.iservice.ISubcategoryService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.modelmapper.ModelMapper;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.List;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/employmentHistory")
public class EmploymentHistoryRestController {

    private final IEmploymentHistoryService employmentHistoryService;
    private final ISubcategoryService subCategoryService;
    private final ICategoryService categoryService;
    private final ModelMapper modelMapper;
    private final ObjectMapper objectMapper;

    @Loggable
    @GetMapping(value = "/{id}")
    public ResponseEntity<EmploymentHistoryDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(employmentHistoryService.get(id), HttpStatus.OK);
    }

    @GetMapping(value = "/iscList/{teacherId}")
    public ResponseEntity<ISC<EmploymentHistoryDTO.Info>> list(HttpServletRequest iscRq, @PathVariable Long teacherId) throws IOException {
        int startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
            startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<EmploymentHistoryDTO.Info> searchRs = employmentHistoryService.search(searchRq, teacherId);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

    private SearchDTO.SearchRq setSearchCriteria(@RequestParam(value = "_startRow", required = false) Integer startRow,
                                                 @RequestParam(value = "_endRow", required = false) Integer endRow,
                                                 @RequestParam(value = "_constructor", required = false) String constructor,
                                                 @RequestParam(value = "operator", required = false) String operator,
                                                 @RequestParam(value = "criteria", required = false) String criteria,
                                                 @RequestParam(value = "id", required = false) Long id,
                                                 @RequestParam(value = "_sortBy", required = false) String sortBy) throws IOException {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();

        SearchDTO.CriteriaRq criteriaRq;
        if (StringUtils.isNotEmpty(constructor) && constructor.equals("AdvancedCriteria")) {
            criteria = "[" + criteria + "]";
            criteriaRq = new SearchDTO.CriteriaRq();
            criteriaRq.setOperator(EOperator.valueOf(operator))
                    .setCriteria(objectMapper.readValue(criteria, new TypeReference<List<SearchDTO.CriteriaRq>>() {
                    }));


            request.setCriteria(criteriaRq);
        }

        if (StringUtils.isNotEmpty(sortBy)) {
            request.setSortBy(sortBy);
        }
        if (id != null) {
            criteriaRq = new SearchDTO.CriteriaRq();
            criteriaRq.setOperator(EOperator.equals)
                    .setFieldName("id")
                    .setValue(id);
            request.setCriteria(criteriaRq);
            startRow = 0;
            endRow = 1;
        }
        request.setStartIndex(startRow)
                .setCount(endRow - startRow);
        return request;
    }

    @Loggable
    @PostMapping(value = "/{teacherId}")
    @Transactional
    public ResponseEntity addEmploymentHistory(@Validated @RequestBody LinkedHashMap request, @PathVariable Long teacherId) {
        List<CategoryDTO.Info> categories = null;
        List<SubcategoryDTO.Info> subCategories = null;

        if (request.get("categories") != null && !((List)request.get("categories")).isEmpty())
            categories = setCats(request);
        if (request.get("subCategories") != null && !((List)request.get("subCategories")).isEmpty())
            subCategories = setSubCats(request);

        EmploymentHistoryDTO.Create create = modelMapper.map(request, EmploymentHistoryDTO.Create.class);
        create.setTeacherId(teacherId);
        if (categories != null && categories.size() > 0)
            create.setCategories(categories);
        if (subCategories != null && subCategories.size() > 0)
            create.setSubCategories(subCategories);
        try {
            employmentHistoryService.addEmploymentHistory(create, teacherId);
            return new ResponseEntity(HttpStatus.OK);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @DeleteMapping(value = "/{teacherId},{id}")
    public ResponseEntity deleteEmploymentHistory(@PathVariable Long teacherId, @PathVariable Long id) {
        try {
            employmentHistoryService.deleteEmploymentHistory(teacherId, id);
            return new ResponseEntity(HttpStatus.OK);
        } catch (TrainingException | DataIntegrityViolationException e) {
            return new ResponseEntity<>(
                    new TrainingException(TrainingException.ErrorType.NotDeletable).getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @PutMapping(value = "/{id}")
    public ResponseEntity update(@PathVariable Long id, @Validated @RequestBody LinkedHashMap request) {
        List<CategoryDTO.Info> categories = null;
        List<SubcategoryDTO.Info> subCategories = null;

        if (request.get("categories") != null)
            categories = setCats(request);
        if (request.get("subCategories") != null)
            subCategories = setSubCats(request);

        EmploymentHistoryDTO.Update update = modelMapper.map(request, EmploymentHistoryDTO.Update.class);
        if (categories != null && categories.size() > 0)
            update.setCategories(categories);
        if (subCategories != null && subCategories.size() > 0)
            update.setSubCategories(subCategories);
        try {
            return new ResponseEntity<>(employmentHistoryService.update(id, update), HttpStatus.OK);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    private List<CategoryDTO.Info> setCats(LinkedHashMap request) {
        SearchDTO.SearchRq categoriesRequest = new SearchDTO.SearchRq();
//        SearchDTO.CriteriaRq criteriaRq = new SearchDTO.CriteriaRq();
//        criteriaRq.setOperator(EOperator.inSet);
//        criteriaRq.setFieldName("id");
//        criteriaRq.setValue(request.get("categories"));
//        categoriesRequest.setCriteria(criteriaRq);
        categoriesRequest.setCriteria(
                CriteriaUtil.createCriteria(EOperator.inSet, "id", request.get("categories"))
        );
        List<CategoryDTO.Info> categories = categoryService.search(categoriesRequest).getList();
        request.remove("categories");
        return categories;

    }

    private List<SubcategoryDTO.Info> setSubCats(LinkedHashMap request) {
        SearchDTO.SearchRq subCategoriesRequest = new SearchDTO.SearchRq();
//        SearchDTO.CriteriaRq criteriaRq = new SearchDTO.CriteriaRq();
//        criteriaRq.setOperator(EOperator.inSet);
//        criteriaRq.setFieldName("id");
//        criteriaRq.setValue(request.get("subCategories"));
//        subCategoriesRequest.setCriteria(criteriaRq);
        subCategoriesRequest.setCriteria(
                CriteriaUtil.createCriteria(EOperator.inSet, "id", request.get("subCategories"))
        );
        List<SubcategoryDTO.Info> subCategories = subCategoryService.search(subCategoriesRequest).getList();
        request.remove("subCategories");
        return subCategories;
    }

}
