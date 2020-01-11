package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.training.controller.util.CriteriaUtil;
import com.nicico.training.dto.QuestionnaireQuestionDTO;
import com.nicico.training.service.QuestionnaireQuestionService;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.MultiValueMap;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/questionnaireQuestion")
public class QuestionnaireQuestionRestController {

    private final QuestionnaireQuestionService questionnaireQuestionValueService;
    private final ModelMapper modelMapper;

    @Loggable
    @GetMapping("/list")
    public ResponseEntity<List<QuestionnaireQuestionDTO.Info>> list() {
        return new ResponseEntity<>(questionnaireQuestionValueService.list(), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/iscList")
    public ResponseEntity<TotalResponse<QuestionnaireQuestionDTO.Info>> iscList(@RequestParam MultiValueMap<String, String> criteria) {
        final NICICOCriteria nicicoCriteria = NICICOCriteria.of(criteria);
        return new ResponseEntity<>(questionnaireQuestionValueService.search(nicicoCriteria), HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/iscList/{questionnaireQuestionId}")
    public ResponseEntity<TotalResponse<QuestionnaireQuestionDTO.Info>> getParametersValueList(@RequestParam MultiValueMap<String, String> criteria, @PathVariable Long questionnaireQuestionId) {
        return iscList(CriteriaUtil.addCriteria(criteria, "questionnaireQuestionId", "equals", questionnaireQuestionId.toString()));
    }

    @Loggable
    @PostMapping
    public ResponseEntity<QuestionnaireQuestionDTO.Info> create(@RequestBody Object rq) {
        QuestionnaireQuestionDTO.Create create = modelMapper.map(rq, QuestionnaireQuestionDTO.Create.class);
//        return new ResponseEntity<>(questionnaireQuestionValueService.checkAndCreate(create), HttpStatus.OK);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @Loggable
    @PutMapping("/{id}")
    public ResponseEntity<QuestionnaireQuestionDTO.Info> update(@PathVariable Long id, @RequestBody Object rq) {
        QuestionnaireQuestionDTO.Update update = modelMapper.map(rq, QuestionnaireQuestionDTO.Update.class);
        return new ResponseEntity<>(questionnaireQuestionValueService.update(id, update), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping("/{id}")
    public ResponseEntity<QuestionnaireQuestionDTO.Info> delete(@PathVariable Long id) {
        return new ResponseEntity<>(questionnaireQuestionValueService.delete(id), null, HttpStatus.OK);
    }
}
