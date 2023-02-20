package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.SubcategoryDTO;
import com.nicico.training.iservice.ISubcategoryService;
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
import java.util.Set;

import static com.nicico.training.service.BaseService.makeNewCriteria;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/subcategory")
public class SubcategoryRestController {

    private final ISubcategoryService subCategoryService;
    private final ObjectMapper objectMapper;
    private final ModelMapper modelMapper;

    // ------------------------------

    @Loggable
    @GetMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('r_sub_Category')")
    public ResponseEntity<SubcategoryDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(subCategoryService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
//    @PreAuthorize("hasAuthority('r_sub_Category')")
    public ResponseEntity<List<SubcategoryDTO.Info>> list() {
        return new ResponseEntity<>(subCategoryService.list(), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
//    @PreAuthorize("hasAuthority('c_sub_Category')")
    public ResponseEntity<SubcategoryDTO.Info> create(@RequestBody Object request) {
        //SubcategoryDTO.Create create=(new ModelMapper()).map(request,SubcategoryDTO.Create.class);
        HttpStatus httpStatus = HttpStatus.CREATED;
        SubcategoryDTO.Info subCategoryInfo = null;
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
    public ResponseEntity<SubcategoryDTO.Info> update(@PathVariable Long id, @RequestBody Object request) {
//        SubcategoryDTO.Update update=(new ModelMapper()).map(request,SubcategoryDTO.Update.class);
        HttpStatus httpStatus = HttpStatus.OK;
        SubcategoryDTO.Info subCategoryInfo = null;
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
    public ResponseEntity<Boolean> delete(@Validated @RequestBody SubcategoryDTO.Delete request) {

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
    public ResponseEntity<ISC<SubcategoryDTO.Info>> list(HttpServletRequest iscRq) throws IOException {
        Integer startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
            startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<SubcategoryDTO.Info> searchRs = subCategoryService.search(searchRq);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/spec-list")
//    @PreAuthorize("hasAuthority('r_sub_Category')")
    public ResponseEntity<SubcategoryDTO.SubCategorySpecRs> list(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
                                                                 @RequestParam(value = "_endRow", defaultValue = "50") Integer endRow,
                                                                 @RequestParam(value = "_constructor", required = false) String constructor,
                                                                 @RequestParam(value = "operator", required = false) String operator,
                                                                 @RequestParam(value = "criteria", required = false) String criteria,
                                                                 @RequestParam(value = "id", required = false) Long id,
                                                                 @RequestParam(value = "categoryId", required = false) Long categoryId,
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
        }if (categoryId != null) {
            criteriaRq = new SearchDTO.CriteriaRq();
            criteriaRq.setOperator(EOperator.equals)
                    .setFieldName("categoryId")
                    .setValue(categoryId);
            request.setCriteria(criteriaRq);
            startRow = 0;
            endRow = 1;
        }
        request.setStartIndex(startRow)
                .setCount(endRow - startRow);

        SearchDTO.SearchRs<SubcategoryDTO.Info> response = subCategoryService.search(request);
        final SubcategoryDTO.SpecRs specResponse = new SubcategoryDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        final SubcategoryDTO.SubCategorySpecRs specRs = new SubcategoryDTO.SubCategorySpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    // ---------------

    @Loggable
    @PostMapping(value = "/search")
//    @PreAuthorize("hasAuthority('r_sub_Category')")
    public ResponseEntity<SearchDTO.SearchRs<SubcategoryDTO.Info>> search(@RequestBody SearchDTO.SearchRq request) {
        return new ResponseEntity<>(subCategoryService.search(request), HttpStatus.OK);
    }


    @GetMapping(value = "/iscTupleList")
    public ResponseEntity<ISC<SubcategoryDTO.SubCategoryInfoTuple>> list(HttpServletRequest iscRq, @RequestParam(required = false) Long id) throws IOException {
        int startRow = 0;
        if (iscRq.getParameter("_startRow") != null)
            startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        if (id != null) {
            searchRq.setCriteria(makeNewCriteria("id", id, EOperator.equals, null));
        }
        SearchDTO.SearchRs<SubcategoryDTO.SubCategoryInfoTuple> searchRs = subCategoryService.search(searchRq, i -> modelMapper.map(i, SubcategoryDTO.SubCategoryInfoTuple.class));
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

    @Loggable
    @PutMapping(value = "/add-classification/{subCategoryId}")
    public ResponseEntity addClassificationToSubCategory(@PathVariable Long subCategoryId, @RequestBody Set<Long> classificationIds) {
        try {
            subCategoryService.addClassificationToSubCategory(subCategoryId, classificationIds);
            return new ResponseEntity<>(null, HttpStatus.OK);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @PutMapping(value = "/remove-classification/{subCategoryId}/{classificationId}")
    public ResponseEntity removeClassificationFromSubCategory(@PathVariable Long subCategoryId, @PathVariable Long classificationId) {
        try {
            subCategoryService.removeClassificationFromSubCategory(subCategoryId, classificationId);
            return new ResponseEntity<>(null, HttpStatus.OK);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @GetMapping(value = "/classification-list/{id}")
    public ResponseEntity<ISC<SubcategoryDTO.ClassificationList>> classificationList(HttpServletRequest iscRq, @PathVariable Long id) throws IOException {

        List<SubcategoryDTO.ClassificationList> classificationList = subCategoryService.classificationList(id);
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);

        SearchDTO.SearchRs<SubcategoryDTO.ClassificationList> searchRs = new SearchDTO.SearchRs<>();
        searchRs.setTotalCount((long) classificationList.size());
        searchRs.setList(classificationList);

        ISC<SubcategoryDTO.ClassificationList> infoISC = ISC.convertToIscRs(searchRs, searchRq.getStartIndex());
        return new ResponseEntity<>(infoISC, HttpStatus.OK);
    }

}
