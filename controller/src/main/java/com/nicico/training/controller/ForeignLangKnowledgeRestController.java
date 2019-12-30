package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.CategoryDTO;
import com.nicico.training.dto.ForeignLangKnowledgeDTO;
import com.nicico.training.dto.SubCategoryDTO;
import com.nicico.training.iservice.ICategoryService;
import com.nicico.training.iservice.IForeignLangKnowledgeService;
import com.nicico.training.iservice.ISubCategoryService;
import com.nicico.training.iservice.ITeacherService;
import com.nicico.training.model.ForeignLangKnowledge;
import com.nicico.training.model.Teacher;
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
import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Set;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/foreignLangKnowledge")
public class ForeignLangKnowledgeRestController {

    private final IForeignLangKnowledgeService foreignLangKnowledgeService;
    private final ModelMapper modelMapper;

    @Loggable
    @GetMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('r_educationLevel')")
    public ResponseEntity<ForeignLangKnowledgeDTO.Info> get(@PathVariable Long id) {
        return new ResponseEntity<>(foreignLangKnowledgeService.get(id), HttpStatus.OK);
    }

    @GetMapping(value = "/iscList/{teacherId}")
    public ResponseEntity<ISC<ForeignLangKnowledgeDTO.Info>> list(HttpServletRequest iscRq, @PathVariable Long teacherId) throws IOException {
        Integer startRow = Integer.parseInt(iscRq.getParameter("_startRow"));
        SearchDTO.SearchRq searchRq = ISC.convertToSearchRq(iscRq);
        SearchDTO.SearchRs<ForeignLangKnowledgeDTO.Info> searchRs = foreignLangKnowledgeService.search(searchRq, teacherId);
        return new ResponseEntity<>(ISC.convertToIscRs(searchRs, startRow), HttpStatus.OK);
    }


    @Loggable
    @PutMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('u_educationLevel')")
    public ResponseEntity update(@PathVariable Long id, @Validated @RequestBody LinkedHashMap request) {
        ForeignLangKnowledgeDTO.Update update = modelMapper.map(request, ForeignLangKnowledgeDTO.Update.class);
        try {
            return new ResponseEntity<>(foreignLangKnowledgeService.update(id, update), HttpStatus.OK);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @PostMapping(value = "/{teacherId}")
    public ResponseEntity addForeignLangKnowledge(@Validated @RequestBody LinkedHashMap request, @PathVariable Long teacherId) {
        ForeignLangKnowledgeDTO.Create create = modelMapper.map(request, ForeignLangKnowledgeDTO.Create.class);
        create.setTeacherId(teacherId);
        try {
            foreignLangKnowledgeService.addForeignLangKnowledge(create, teacherId);
            return new ResponseEntity(HttpStatus.OK);
        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @DeleteMapping(value = "/{teacherId},{id}")
//    @PreAuthorize("hasAuthority('d_teacher')")
    public ResponseEntity deleteForeignLangKnowledge(@PathVariable Long teacherId, @PathVariable Long id) {
        try {
            foreignLangKnowledgeService.deleteForeignLangKnowledge(teacherId, id);
            return new ResponseEntity(HttpStatus.OK);
        } catch (TrainingException | DataIntegrityViolationException e) {
            return new ResponseEntity<>(
                    new TrainingException(TrainingException.ErrorType.NotDeletable).getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

}
