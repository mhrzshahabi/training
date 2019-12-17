package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.CategoryDTO;
import com.nicico.training.dto.EmploymentHistoryDTO;
import com.nicico.training.dto.SubCategoryDTO;
import com.nicico.training.iservice.ICategoryService;
import com.nicico.training.iservice.IEmploymentHistoryService;
import com.nicico.training.iservice.ISubCategoryService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/employmentHistory")
public class EmploymentHistoryRestController {

    private final IEmploymentHistoryService employmentHistoryService;
    private final ISubCategoryService subCategoryService;
    private final ICategoryService categoryService;
    private final ModelMapper modelMapper;

    @Loggable
    @GetMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('r_educationLevel')")
    public ResponseEntity<EmploymentHistoryDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(employmentHistoryService.get(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/list")
//    @PreAuthorize("hasAuthority('r_educationLevel')")
    public ResponseEntity<List<EmploymentHistoryDTO.Info>> list() {
        return new ResponseEntity<>(employmentHistoryService.list(), HttpStatus.OK);
    }

    @GetMapping(value = "/iscList/{teacherId}")
    public ResponseEntity<ISC<EmploymentHistoryDTO.Info>> list(HttpServletRequest iscRq, @PathVariable Long teacherId) throws IOException {
        Integer startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<EmploymentHistoryDTO.Info> searchRs = employmentHistoryService.search(searchRq, teacherId);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/create")
//    @PreAuthorize("hasAuthority('c_educationLevel')")
    public ResponseEntity create(@Validated @RequestBody EmploymentHistoryDTO.Create request) {
        try {
            return new ResponseEntity<>(employmentHistoryService.create(request), HttpStatus.OK);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @PutMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('u_educationLevel')")
    public ResponseEntity update(@PathVariable Long id, @Validated @RequestBody LinkedHashMap request) {
        List<CategoryDTO.Info> categories = new ArrayList<>();
        List<SubCategoryDTO.Info> subCategories = new ArrayList<>();

        if (request.get("categories") != null) {
            SearchDTO.SearchRq categoriesRequest = new SearchDTO.SearchRq();
            SearchDTO.CriteriaRq criteriaRq = new SearchDTO.CriteriaRq();
            criteriaRq.setOperator(EOperator.inSet);
            criteriaRq.setFieldName("id");
            criteriaRq.setValue(request.get("categories"));
            categoriesRequest.setCriteria(criteriaRq);
            categories = categoryService.search(categoriesRequest).getList();
            request.remove("categories");
        }
        if (request.get("subCategories") != null) {
            SearchDTO.SearchRq subCategoriesRequest = new SearchDTO.SearchRq();
            SearchDTO.CriteriaRq criteriaRq = new SearchDTO.CriteriaRq();
            criteriaRq.setOperator(EOperator.inSet);
            criteriaRq.setFieldName("id");
            criteriaRq.setValue(request.get("subCategories"));
            subCategoriesRequest.setCriteria(criteriaRq);
            subCategories = subCategoryService.search(subCategoriesRequest).getList();
            request.remove("subCategories");
        }
        EmploymentHistoryDTO.Update update = modelMapper.map(request, EmploymentHistoryDTO.Update.class);
        if (categories.size() > 0)
            update.setCategories(categories);
        if (subCategories.size() > 0)
            update.setSubCategories(subCategories);
        try {
            return new ResponseEntity<>(employmentHistoryService.update(id, update), HttpStatus.OK);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @DeleteMapping(value = "delete/{id}")
//    @PreAuthorize("hasAuthority('d_educationLevel')")
    public ResponseEntity delete(@PathVariable Long id) {
        try {
            employmentHistoryService.delete(id);
            return new ResponseEntity<>(HttpStatus.OK);
        } catch (TrainingException | DataIntegrityViolationException e) {
            return new ResponseEntity<>(
                    new TrainingException(TrainingException.ErrorType.NotDeletable).getMessage(),
                    HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @DeleteMapping(value = "/list")
//    @PreAuthorize("hasAuthority('d_educationLevel')")
    public ResponseEntity<Void> delete(@Validated @RequestBody EmploymentHistoryDTO.Delete request) {
        employmentHistoryService.delete(request);
        return new ResponseEntity<>(HttpStatus.OK);
    }
}
