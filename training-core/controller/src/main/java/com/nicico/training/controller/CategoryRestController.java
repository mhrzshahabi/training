package com.nicico.training.controller;/*
com.nicico.training.controller
@author : banifatemi
@Date : 6/8/2019
@Time :12:05 PM
    */

import com.nicico.copper.core.dto.search.SearchDTO;
import com.nicico.copper.core.util.Loggable;
import com.nicico.training.dto.CategoryDTO;
import com.nicico.training.dto.SubCategoryDTO;
import com.nicico.training.iservice.ICategoryService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/category")
public class CategoryRestController {

    private final ICategoryService categoryService;

    // ------------------------------

    @Loggable
    @GetMapping(value = "/{id}")
    @PreAuthorize("hasAuthority('r_category')")
    public ResponseEntity<CategoryDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(categoryService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
    @PreAuthorize("hasAuthority('r_category')")
    public ResponseEntity<List<CategoryDTO.Info>> list() {
        return new ResponseEntity<>(categoryService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
    @PreAuthorize("hasAuthority('c_category')")
    public ResponseEntity<CategoryDTO.Info> create(@Validated @RequestBody CategoryDTO.Create request) {
        return new ResponseEntity<>(categoryService.create(request), HttpStatus.CREATED);
    }

    @Loggable
    @PutMapping(value = "/{id}")
    @PreAuthorize("hasAuthority('u_category')")
    public ResponseEntity<CategoryDTO.Info> update(@PathVariable Long id, @Validated @RequestBody CategoryDTO.Update request) {
        return new ResponseEntity<>(categoryService.update(id, request), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/{id}")
    @PreAuthorize("hasAuthority('d_category')")
    public ResponseEntity<Boolean> delete(@PathVariable Long id) {

        boolean flag=true;
        HttpStatus httpStatus=HttpStatus.OK;

        try {
            categoryService.delete(id);
        } catch (Exception e) {
            httpStatus=HttpStatus.NO_CONTENT;
            flag=false;
        }
        return new ResponseEntity<>(flag,httpStatus);

    }

    @Loggable
    @DeleteMapping(value = "/list")
    @PreAuthorize("hasAuthority('d_category')")
    public ResponseEntity<Boolean> delete(@Validated @RequestBody CategoryDTO.Delete request) {
        boolean flag=true;
        HttpStatus httpStatus=HttpStatus.OK;
        try {
            categoryService.delete(request);
        } catch (Exception e) {
            httpStatus=HttpStatus.NO_CONTENT;
            flag=false;
        }
        return new ResponseEntity<>(flag,httpStatus);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
    @PreAuthorize("hasAuthority('r_category')")
    public ResponseEntity<CategoryDTO.CategorySpecRs> list(@RequestParam(value = "_startRow", required = false) Integer startRow, @RequestParam("_endRow") Integer endRow, @RequestParam(value = "operator", required = false) String operator, @RequestParam(value = "criteria", required = false) String criteria) {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        request.setStartIndex(startRow)
                .setCount(endRow - startRow);

        SearchDTO.SearchRs<CategoryDTO.Info> response = categoryService.search(request);

        final CategoryDTO.SpecRs specResponse = new CategoryDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getTotalCount().intValue())
                .setTotalRows(response.getTotalCount().intValue());

        final CategoryDTO.CategorySpecRs specRs = new CategoryDTO.CategorySpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    // ---------------

    @Loggable
    @PostMapping(value = "/search")
    @PreAuthorize("hasAuthority('r_category')")
    public ResponseEntity<SearchDTO.SearchRs<CategoryDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(categoryService.search(request), HttpStatus.OK);
    }

    // ------------------------------

    @Loggable
    @GetMapping(value = "{categoryId}/sub-categories")
    @PreAuthorize("hasAnyAuthority('r_sub_Category')")
    public ResponseEntity<SubCategoryDTO.SubCategorySpecRs> getSubCategories(@PathVariable Long categoryId) {

        SearchDTO.SearchRq request = new SearchDTO.SearchRq();

        List<SubCategoryDTO.Info> subCategories = categoryService.getSubCategories(categoryId);

        final SubCategoryDTO.SpecRs specResponse = new SubCategoryDTO.SpecRs();
        specResponse.setData(subCategories)
                .setStartRow(0)
                .setEndRow( subCategories.size())
                .setTotalRows(subCategories.size());

        final SubCategoryDTO.SubCategorySpecRs specRs = new SubCategoryDTO.SubCategorySpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "sub-categories/dummy")
    @PreAuthorize("hasAuthority('r_category')")
    public ResponseEntity<SubCategoryDTO.SubCategorySpecRs> dummy(@RequestParam("_startRow") Integer startRow, @RequestParam("_endRow") Integer endRow, @RequestParam(value = "operator", required = false) String operator, @RequestParam(value = "criteria", required = false) String criteria) {
        return new ResponseEntity<SubCategoryDTO.SubCategorySpecRs>(new SubCategoryDTO.SubCategorySpecRs(), HttpStatus.OK);
    }

}
