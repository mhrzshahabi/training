package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.training.dto.EvaluationQuestionDTO;
import com.nicico.training.service.EvaluationQuestionService;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/config-questionnaire")
public class EvaluationQuestionRestController {

    private final EvaluationQuestionService evaluationQuestionService;
    private final ModelMapper modelMapper;

    @Loggable
    @GetMapping("/list")
    public ResponseEntity<List<EvaluationQuestionDTO.Info>> list() {
        return new ResponseEntity<>(evaluationQuestionService.list(), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/iscList")
    public ResponseEntity<TotalResponse<EvaluationQuestionDTO.Info>> iscList(@RequestParam MultiValueMap<String, String> criteria) {
        final NICICOCriteria nicicoCriteria = NICICOCriteria.of(criteria);
        return new ResponseEntity<>(evaluationQuestionService.search(nicicoCriteria), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
    public ResponseEntity<EvaluationQuestionDTO.Info> create(@RequestBody Object rq) {
        EvaluationQuestionDTO.Create create = modelMapper.map(rq, EvaluationQuestionDTO.Create.class);
        return new ResponseEntity<>(evaluationQuestionService.create(create), HttpStatus.OK);
    }

    @Loggable
    @PutMapping("/{id}")
    public ResponseEntity<EvaluationQuestionDTO.Info> update(@PathVariable Long id, @RequestBody Object rq) {
        EvaluationQuestionDTO.Update update = modelMapper.map(rq, EvaluationQuestionDTO.Update.class);
        return new ResponseEntity<>(evaluationQuestionService.update(id, update), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping("/{id}")
    public ResponseEntity delete(@PathVariable Long id) {
        try {
            return new ResponseEntity<>(evaluationQuestionService.delete(id), HttpStatus.OK);
        } catch (Exception ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

}
