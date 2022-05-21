package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.controller.util.CriteriaUtil;
import com.nicico.training.dto.CategoryDTO;
import com.nicico.training.dto.SubcategoryDTO;
import com.nicico.training.dto.TeacherCertificationDTO;
import com.nicico.training.iservice.ICategoryService;
import com.nicico.training.iservice.ISubcategoryService;
import com.nicico.training.iservice.ITeacherCertificationService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.modelmapper.ModelMapper;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.List;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/teacherCertification")
public class TeacherCertificationRestController {

    private final ITeacherCertificationService teacherCertificationService;
    private final ISubcategoryService subCategoryService;
    private final ICategoryService categoryService;
    private final ModelMapper modelMapper;

    @GetMapping(value = "/iscList/{teacherId}")
    public ResponseEntity<ISC<TeacherCertificationDTO.Info>> list(HttpServletRequest iscRq, @PathVariable Long teacherId) throws IOException {
        Integer startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<TeacherCertificationDTO.Info> searchRs = teacherCertificationService.search(searchRq, teacherId);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }

    @Loggable
    @PutMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('u_educationLevel')")
    public ResponseEntity update(@PathVariable Long id, @Validated @RequestBody LinkedHashMap request, HttpServletResponse response) {
        List<CategoryDTO.Info> categories = null;
        List<SubcategoryDTO.Info> subCategories = null;

        if (request.get("categories") != null && !((List)request.get("categories")).isEmpty())
            categories = setCats(request);
        if (request.get("subCategories") != null && !((List)request.get("subCategories")).isEmpty())
            subCategories = setSubCats(request);

        TeacherCertificationDTO.Update update = modelMapper.map(request, TeacherCertificationDTO.Update.class);
        if (categories != null && categories.size() > 0)
            update.setCategories(categories);
        if (subCategories != null && subCategories.size() > 0)
            update.setSubCategories(subCategories);
        try {
            return new ResponseEntity<>(teacherCertificationService.update(id, update,response), HttpStatus.OK);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @PostMapping(value = "/{teacherId}")
    @Transactional
//    @PreAuthorize("hasAuthority('d_tclass')")
    public ResponseEntity addTeacherCertification(@Validated @RequestBody LinkedHashMap request, @PathVariable Long teacherId,HttpServletResponse response) {
        List<CategoryDTO.Info> categories = null;
        List<SubcategoryDTO.Info> subCategories = null;

        if (request.get("categories") != null)
            categories = setCats(request);
        if (request.get("subCategories") != null)
            subCategories = setSubCats(request);

        TeacherCertificationDTO.Create create = modelMapper.map(request, TeacherCertificationDTO.Create.class);
        create.setTeacherId(teacherId);
        if (categories != null && categories.size() > 0)
            create.setCategories(categories);
        if (subCategories != null && subCategories.size() > 0)
            create.setSubCategories(subCategories);
        try {
            teacherCertificationService.addTeacherCertification(create, teacherId,response);
            return new ResponseEntity(HttpStatus.OK);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @DeleteMapping(value = "/{teacherId},{id}")
//    @PreAuthorize("hasAuthority('d_teacher')")
    public ResponseEntity deleteTeacherCertification(@PathVariable Long teacherId, @PathVariable Long id) {
        try {
            teacherCertificationService.deleteTeacherCertification(teacherId, id);
            return new ResponseEntity(HttpStatus.OK);
        } catch (TrainingException | DataIntegrityViolationException e) {
            return new ResponseEntity<>(
                    new TrainingException(TrainingException.ErrorType.NotDeletable).getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    private List<CategoryDTO.Info> setCats(LinkedHashMap request) {
        SearchDTO.SearchRq categoriesRequest = new SearchDTO.SearchRq();

        categoriesRequest.setCriteria(
                CriteriaUtil.createCriteria(EOperator.inSet, "id", request.get("categories"))
        );

        List<CategoryDTO.Info> categories = categoryService.search(categoriesRequest).getList();
        request.remove("categories");
        return categories;

    }

    private List<SubcategoryDTO.Info> setSubCats(LinkedHashMap request) {
        SearchDTO.SearchRq subCategoriesRequest = new SearchDTO.SearchRq();

        subCategoriesRequest.setCriteria(
                CriteriaUtil.createCriteria(EOperator.inSet, "id", request.get("subCategories"))
        );

        List<SubcategoryDTO.Info> subCategories = subCategoryService.search(subCategoriesRequest).getList();
        request.remove("subCategories");
        return subCategories;
    }
}
