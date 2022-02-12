package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.EvaluationQuestionDTO;
import com.nicico.training.iservice.IEvaluationQuestionService;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;

import java.util.LinkedHashMap;
import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/config-questionnaire")
public class EvaluationQuestionRestController {

    private final IEvaluationQuestionService evaluationQuestionService;
    private final ModelMapper modelMapper;

    @Loggable
    @GetMapping("/usedCount/{id}")
    public ResponseEntity<Integer> usedCount(@PathVariable Long id) {
        return new ResponseEntity<>(evaluationQuestionService.usedCount(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/list")
    public ResponseEntity<List<EvaluationQuestionDTO.Info>> list() {
        return new ResponseEntity<>(evaluationQuestionService.list(), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/pickList")
    public ResponseEntity<TotalResponse<EvaluationQuestionDTO.InfoWithDomain>> pickList(@RequestParam MultiValueMap<String, String> criteria) {
        final NICICOCriteria nicicoCriteria = NICICOCriteria.of(criteria);
        nicicoCriteria.setDistinct(true);
        return new ResponseEntity<>(evaluationQuestionService.searchForPickList(nicicoCriteria), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/iscList")
    public ResponseEntity<TotalResponse<EvaluationQuestionDTO.Info>> iscList(@RequestParam MultiValueMap<String, String> criteria) {
        final NICICOCriteria nicicoCriteria = NICICOCriteria.of(criteria);
        nicicoCriteria.setDistinct(true);
        return new ResponseEntity<>(evaluationQuestionService.search(nicicoCriteria), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
    public ResponseEntity create(@RequestBody LinkedHashMap rq) {
        List<Long> indexIds = setIndexIds(rq);
        try {
            EvaluationQuestionDTO.Create create = modelMapper.map(rq, EvaluationQuestionDTO.Create.class);
            return new ResponseEntity<>(evaluationQuestionService.create(create, indexIds), HttpStatus.OK);
        } catch (
                TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @PutMapping("/{id}")
    public ResponseEntity update(@PathVariable Long id, @RequestBody LinkedHashMap rq) {
        List<Long> indexIds = setIndexIds(rq);
        try {
            EvaluationQuestionDTO.Update update = modelMapper.map(rq, EvaluationQuestionDTO.Update.class);
            if(evaluationQuestionService.usedCount(id)==0){
                return new ResponseEntity<>(evaluationQuestionService.update(id, update, indexIds), HttpStatus.OK);
            }else{
                return new ResponseEntity<>("این سوال در پرسشنامه استفاده شده است.", HttpStatus.FORBIDDEN);
            }

        } catch (TrainingException ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @DeleteMapping("/{id}")
    public ResponseEntity delete(@PathVariable Long id) {
        try {
            if(evaluationQuestionService.usedCount(id)==0) {
                return new ResponseEntity<>(evaluationQuestionService.delete(id), HttpStatus.OK);
            }else{
                return new ResponseEntity<>("این سوال در پرسشنامه استفاده شده است.", HttpStatus.FORBIDDEN);
            }
        } catch (Exception ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    private List<Long> setIndexIds(LinkedHashMap rq) {
        if (rq.get("evaluationIndices") == null)
            return null;
        List<Long> indexIds = modelMapper.map(rq.get("evaluationIndices"), new TypeToken<List<Long>>() {
        }.getType());
        rq.remove("evaluationIndices");
        return indexIds;
    }

}
