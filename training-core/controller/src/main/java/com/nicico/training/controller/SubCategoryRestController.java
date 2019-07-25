package com.nicico.training.controller;/*
com.nicico.training.controller
@author : banifatemi
@Date : 6/8/2019
@Time :1:24 PM
    */

import com.nicico.copper.core.dto.search.SearchDTO;
import com.nicico.copper.core.util.Loggable;
import com.nicico.training.dto.SubCategoryDTO;
import com.nicico.training.iservice.ISubCategoryService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/sub-category")
public class SubCategoryRestController {

    private final ISubCategoryService subCategoryService;

    // ------------------------------

    @Loggable
    @GetMapping(value = "/{id}")
    @PreAuthorize("hasAuthority('r_sub_Category')")
    public ResponseEntity<SubCategoryDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(subCategoryService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
    @PreAuthorize("hasAuthority('r_sub_Category')")
    public ResponseEntity<List<SubCategoryDTO.Info>> list() {
        return new ResponseEntity<>(subCategoryService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
    @PreAuthorize("hasAuthority('c_sub_Category')")
    public ResponseEntity<SubCategoryDTO.Info> create(@RequestBody Object request) {
        //SubCategoryDTO.Create create=(new ModelMapper()).map(request,SubCategoryDTO.Create.class);

        return new ResponseEntity<>(subCategoryService.create(request), HttpStatus.CREATED);
    }

    @Loggable
    @PutMapping(value = "/{id}")
    @PreAuthorize("hasAuthority('u_sub_Category')")
    public ResponseEntity<SubCategoryDTO.Info> update(@PathVariable Long id, @RequestBody Object request) {
//        SubCategoryDTO.Update update=(new ModelMapper()).map(request,SubCategoryDTO.Update.class);

        return new ResponseEntity<>(subCategoryService.update(id, request), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/{id}")
    @PreAuthorize("hasAuthority('d_sub_Category')")
    public ResponseEntity<Boolean> delete(@PathVariable Long id) {
        boolean flag=true;
        HttpStatus httpStatus=HttpStatus.OK;

        try {
            subCategoryService.delete(id);
        } catch (Exception e) {
            httpStatus=HttpStatus.NO_CONTENT;
            flag=false;
        }
        return new ResponseEntity<>(flag,httpStatus);
    }

    @Loggable
    @DeleteMapping(value = "/list")
    @PreAuthorize("hasAuthority('d_sub_Category')")
    public ResponseEntity<Boolean> delete(@Validated @RequestBody SubCategoryDTO.Delete request) {

        boolean flag=true;
        HttpStatus httpStatus=HttpStatus.OK;

        try {
            subCategoryService.delete(request);
        } catch (Exception e) {
            httpStatus=HttpStatus.NO_CONTENT;
            flag=false;
        }
        return new ResponseEntity<>(flag,httpStatus);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
    @PreAuthorize("hasAuthority('r_sub_Category')")
    public ResponseEntity<SubCategoryDTO.SubCategorySpecRs> list(@RequestParam("_startRow") Integer startRow, @RequestParam("_endRow") Integer endRow, @RequestParam(value = "operator", required = false) String operator, @RequestParam(value = "criteria", required = false) String criteria) {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();
        request.setStartIndex(startRow)
                .setCount(endRow - startRow);

        SearchDTO.SearchRs<SubCategoryDTO.Info> response = subCategoryService.search(request);

        final SubCategoryDTO.SpecRs specResponse = new SubCategoryDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getTotalCount().intValue())
                .setTotalRows(response.getTotalCount().intValue());

        final SubCategoryDTO.SubCategorySpecRs specRs = new SubCategoryDTO.SubCategorySpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    // ---------------

    @Loggable
    @PostMapping(value = "/search")
    @PreAuthorize("hasAuthority('r_sub_Category')")
    public ResponseEntity<SearchDTO.SearchRs<SubCategoryDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(subCategoryService.search(request), HttpStatus.OK);
    }



}
