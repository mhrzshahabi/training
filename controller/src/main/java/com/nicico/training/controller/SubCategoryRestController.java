package com.nicico.training.controller;/*
com.nicico.training.controller
@author : banifatemi
@Date : 6/8/2019
@Time :1:24 PM
    */

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.SubCategoryDTO;
import com.nicico.training.iservice.ISubCategoryService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.List;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/sub-category")
public class SubCategoryRestController {

    private final ISubCategoryService subCategoryService;
    private final ObjectMapper objectMapper;


    // ------------------------------

    @Loggable
    @GetMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('r_sub_Category')")
    public ResponseEntity<SubCategoryDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(subCategoryService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
//    @PreAuthorize("hasAuthority('r_sub_Category')")
    public ResponseEntity<List<SubCategoryDTO.Info>> list() {
        return new ResponseEntity<>(subCategoryService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
//    @PreAuthorize("hasAuthority('c_sub_Category')")
    public ResponseEntity<SubCategoryDTO.Info> create(@RequestBody Object request) {
        //SubCategoryDTO.Create create=(new ModelMapper()).map(request,SubCategoryDTO.Create.class);
        HttpStatus httpStatus = HttpStatus.CREATED;
        SubCategoryDTO.Info subCategoryInfo = null;
        try {
            subCategoryInfo = subCategoryService.create(request);

        } catch (Exception e) {
            httpStatus = HttpStatus.NO_CONTENT;
        }
        return new ResponseEntity<>(subCategoryInfo, httpStatus);

    }

    @Loggable
    @PutMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('u_sub_Category')")
    public ResponseEntity<SubCategoryDTO.Info> update(@PathVariable Long id, @RequestBody Object request) {
//        SubCategoryDTO.Update update=(new ModelMapper()).map(request,SubCategoryDTO.Update.class);
        HttpStatus httpStatus = HttpStatus.OK;
        SubCategoryDTO.Info subCategoryInfo = null;
        try {
            subCategoryInfo = subCategoryService.update(id, request);

        } catch (Exception e) {
            httpStatus = HttpStatus.NO_CONTENT;
        }
        return new ResponseEntity<>(subCategoryInfo, httpStatus);
    }

    @Loggable
    @DeleteMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('d_sub_Category')")
    public ResponseEntity<Boolean> delete(@PathVariable Long id) {
        boolean flag = true;
        HttpStatus httpStatus = HttpStatus.OK;

        try {
            subCategoryService.delete(id);
        } catch (Exception e) {
            httpStatus = HttpStatus.NO_CONTENT;
            flag = false;
        }
        return new ResponseEntity<>(flag, httpStatus);
    }

    @Loggable
    @DeleteMapping(value = "/list")
//    @PreAuthorize("hasAuthority('d_sub_Category')")
    public ResponseEntity<Boolean> delete(@Validated @RequestBody SubCategoryDTO.Delete request) {

        boolean flag = true;
        HttpStatus httpStatus = HttpStatus.OK;

        try {
            subCategoryService.delete(request);
        } catch (Exception e) {
            httpStatus = HttpStatus.NO_CONTENT;
            flag = false;
        }
        return new ResponseEntity<>(flag, httpStatus);
    }

    @GetMapping(value = "/iscList")
    public ResponseEntity<ISC<SubCategoryDTO.Info>> list(HttpServletRequest iscRq) throws IOException {
        Integer startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
            startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<SubCategoryDTO.Info> searchRs = subCategoryService.search(searchRq);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
//    @PreAuthorize("hasAuthority('r_sub_Category')")
    public ResponseEntity<SubCategoryDTO.SubCategorySpecRs> list(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
                                                                 @RequestParam(value = "_endRow", defaultValue = "50") Integer endRow,
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
//    @PreAuthorize("hasAuthority('r_sub_Category')")
    public ResponseEntity<SearchDTO.SearchRs<SubCategoryDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(subCategoryService.search(request), HttpStatus.OK);
    }


}
