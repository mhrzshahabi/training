package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.training.dto.QuestionnaireDTO;
import com.nicico.training.service.QuestionnaireService;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/questionnaire")
public class QuestionnaireRestController {

    private final QuestionnaireService questionnaireService;
    private final ModelMapper modelMapper;

    @Loggable
    @GetMapping("/isLocked/{id}")
    public ResponseEntity<Boolean> isLocked(@PathVariable Long id) {
        return new ResponseEntity<>(questionnaireService.isLocked(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/list")
    public ResponseEntity<List<QuestionnaireDTO.Info>> list() {
        return new ResponseEntity<>(questionnaireService.list(), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/iscList")
    public ResponseEntity<TotalResponse<QuestionnaireDTO.Info>> iscList(@RequestParam MultiValueMap<String, String> criteria) {
        final NICICOCriteria nicicoCriteria = NICICOCriteria.of(criteria);
        return new ResponseEntity<>(questionnaireService.search(nicicoCriteria), HttpStatus.OK);
    }

    @Loggable
    @PostMapping
    public ResponseEntity<QuestionnaireDTO.Info> create(@RequestBody Object rq) {
        QuestionnaireDTO.Create create = modelMapper.map(rq, QuestionnaireDTO.Create.class);
        return new ResponseEntity<>(questionnaireService.create(create), HttpStatus.OK);
    }

    @Loggable
    @PutMapping("/{id}")
    public ResponseEntity<QuestionnaireDTO.Info> update(@PathVariable Long id, @RequestBody Object rq) {
        QuestionnaireDTO.Update update = modelMapper.map(rq, QuestionnaireDTO.Update.class);
        return new ResponseEntity<>(questionnaireService.update(id, update), HttpStatus.OK);
    }

    @Loggable
    @PutMapping("/enable/{id}")
    public ResponseEntity<QuestionnaireDTO.Info> updateStatus(@PathVariable Long id) {
        return new ResponseEntity<>(questionnaireService.updateEnable(id), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping("/{id}")
    public ResponseEntity delete(@PathVariable Long id) {
        try {
            return new ResponseEntity<>(questionnaireService.deleteWithChildren(id), HttpStatus.OK);
        } catch (Exception ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.CONFLICT);
        }
    }


    @GetMapping("/getLastQuestionnarieId")
    public ResponseEntity<Long> getLastQuestionnarieId(@RequestParam MultiValueMap<String, String> criteria) {
        final NICICOCriteria nicicoCriteria = NICICOCriteria.of(criteria);
        List<QuestionnaireDTO.Info> result = questionnaireService.search(nicicoCriteria).getResponse().getData();
        Long res = null;
        if(result.size() > 0)
            res = result.get(0).getId();
        return new ResponseEntity<>(res,HttpStatus.OK);
    }
}
