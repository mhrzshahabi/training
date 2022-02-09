package com.nicico.training.controller;/*
com.nicico.training.controller
@author : banifatemi
@Date : 6/8/2019
@Time :12:05 PM
    */

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.CategoryDTO;
import com.nicico.training.dto.SubcategoryDTO;
import com.nicico.training.iservice.ICategoryService;
import com.nicico.training.iservice.IWorkGroupService;
import com.nicico.training.service.WorkGroupService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.List;

import static com.nicico.training.service.BaseService.makeNewCriteria;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/category")
public class CategoryRestController {

    private final ICategoryService categoryService;
    private final ObjectMapper objectMapper;
    private final ModelMapper modelMapper;
    private final IWorkGroupService iWorkGroupService;

    // ------------------------------

    @Loggable
    @GetMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('r_category')")
    public ResponseEntity<CategoryDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(categoryService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
//    @PreAuthorize("hasAuthority('r_category')")
    public ResponseEntity<List<CategoryDTO.Info>> list() {
        return new ResponseEntity<>(categoryService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
//    @PreAuthorize("hasAuthority('c_category')")
    public ResponseEntity<CategoryDTO.Info> create(@Validated @RequestBody CategoryDTO.Create request) {
        HttpStatus httpStatus = HttpStatus.CREATED;
        CategoryDTO.Info categoryInfo = null;
        try {
            categoryInfo = categoryService.create(request);

        } catch (Exception e) {
            httpStatus = HttpStatus.NO_CONTENT;
            categoryInfo = null;
        }
        return new ResponseEntity<>(categoryInfo, httpStatus);
    }

    @Loggable
    @PutMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('u_category')")
    public ResponseEntity<CategoryDTO.Info> update(@PathVariable Long id, @Validated @RequestBody CategoryDTO.Update request) {
        HttpStatus httpStatus = HttpStatus.OK;
        CategoryDTO.Info categoryInfo = null;
        try {
            categoryInfo = categoryService.update(id, request);

        } catch (Exception e) {
            httpStatus = HttpStatus.NO_CONTENT;
            categoryInfo = null;
        }
        return new ResponseEntity<>(categoryInfo, httpStatus);
    }

    @Loggable
    @DeleteMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('d_category')")
    public ResponseEntity<Boolean> delete(@PathVariable Long id) {

        boolean flag = true;
        HttpStatus httpStatus = HttpStatus.OK;

        try {
            categoryService.delete(id);
        } catch (Exception e) {
            httpStatus = HttpStatus.NO_CONTENT;
            flag = false;
        }
        return new ResponseEntity<>(flag, httpStatus);

    }

    @Loggable
    @DeleteMapping(value = "/list")
//    @PreAuthorize("hasAuthority('d_category')")
    public ResponseEntity<Boolean> delete(@Validated @RequestBody CategoryDTO.Delete request) {
        boolean flag = true;
        HttpStatus httpStatus = HttpStatus.OK;
        try {
            categoryService.delete(request);
        } catch (Exception e) {
            httpStatus = HttpStatus.NO_CONTENT;
            flag = false;
        }
        return new ResponseEntity<>(flag, httpStatus);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
//    @PreAuthorize("hasAuthority('r_category')")
    public ResponseEntity<CategoryDTO.CategorySpecRs> list(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
                                                           @RequestParam(value = "_endRow", defaultValue = "50") Integer endRow,
                                                           @RequestParam(value = "_constructor", required = false) String constructor,
                                                           @RequestParam(value = "operator", required = false) String operator,
                                                           @RequestParam(value = "criteria", required = false) String criteria,
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
        request.setStartIndex(startRow)
                .setCount(endRow - startRow);

        if (StringUtils.isNotEmpty(sortBy)) {
            request.setSortBy(sortBy);
        }

        request.setCriteria(iWorkGroupService.addPermissionToCriteria("id", request.getCriteria()));

        SearchDTO.SearchRs<CategoryDTO.Info> response = categoryService.search(request);

        final CategoryDTO.SpecRs specResponse = new CategoryDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        final CategoryDTO.CategorySpecRs specRs = new CategoryDTO.CategorySpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @GetMapping(value = "/iscList")
    public ResponseEntity<ISC<CategoryDTO.Info>> list(HttpServletRequest iscRq) throws IOException {
        Integer startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
            startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<CategoryDTO.Info> searchRs = categoryService.search(searchRq);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

    // ---------------

    @Loggable
    @PostMapping(value = "/search")
//    @PreAuthorize("hasAuthority('r_category')")
    public ResponseEntity<SearchDTO.SearchRs<CategoryDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(categoryService.search(request), HttpStatus.OK);
    }

    // ------------------------------

    @Loggable
    @GetMapping(value = "{categoryId}/sub-categories")
//    @PreAuthorize("hasAnyAuthority('r_sub_Category')")
    public ResponseEntity<SubcategoryDTO.SubCategorySpecRs> getSubCategories(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
                                                                             @RequestParam(value = "_endRow", defaultValue = "50") Integer endRow,
                                                                             @RequestParam(value = "_constructor", required = false) String constructor,
                                                                             @RequestParam(value = "operator", required = false) String operator,
                                                                             @RequestParam(value = "criteria", required = false) String criteria,
                                                                             @RequestParam(value = "_sortBy", required = false) String sortBy,
                                                                             @PathVariable Long categoryId) throws IOException {

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
        request.setStartIndex(startRow)
                .setCount(endRow - startRow);

        if (StringUtils.isNotEmpty(sortBy)) {
            request.setSortBy(sortBy);
        }
        List<SubcategoryDTO.Info> subCategories = categoryService.getSubCategories(categoryId);

        final SubcategoryDTO.SpecRs specResponse = new SubcategoryDTO.SpecRs();
        specResponse.setData(subCategories)
                .setStartRow(0)
                .setEndRow(subCategories.size())
                .setTotalRows(subCategories.size());

        final SubcategoryDTO.SubCategorySpecRs specRs = new SubcategoryDTO.SubCategorySpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "sub-categories/dummy")
//    @PreAuthorize("hasAuthority('r_category')")
    public ResponseEntity<SubcategoryDTO.SubCategorySpecRs> dummy(@RequestParam("_startRow") Integer startRow, @RequestParam("_endRow") Integer endRow, @RequestParam(value = "operator", required = false) String operator, @RequestParam(value = "criteria", required = false) String criteria) {
        return new ResponseEntity<SubcategoryDTO.SubCategorySpecRs>(new SubcategoryDTO.SubCategorySpecRs(), HttpStatus.OK);
    }

    @GetMapping(value = "/iscTupleList")
    public ResponseEntity<ISC<CategoryDTO.CategoryTitle>> list(HttpServletRequest iscRq, @RequestParam(required = false) Long id) throws IOException {
        int startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
            startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        if (id != null) {
            searchRq.setCriteria(makeNewCriteria("id", id, EOperator.equals, null));
        }
        SearchDTO.SearchRs<CategoryDTO.CategoryTitle> searchRs = categoryService.search(searchRq, i -> modelMapper.map(i, CategoryDTO.CategoryTitle.class));
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

}
