package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.training.dto.QuestionnaireDTO;
import com.nicico.training.iservice.IEvaluationService;
import com.nicico.training.iservice.IQuestionnaireService;
import com.nicico.training.model.Evaluation;
import com.nicico.training.repository.EvaluationDAO;
import com.nicico.training.service.EvaluationService;
import com.nicico.training.service.QuestionnaireService;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/questionnaire")
public class QuestionnaireRestController {

    private final IQuestionnaireService iQuestionnaireService;
    private final ModelMapper modelMapper;
    private final IEvaluationService iEvaluationService;

    @Loggable
    @GetMapping("/isLocked/{id}")
    public ResponseEntity<Boolean> isLocked(@PathVariable Long id) {
        return new ResponseEntity<>(iQuestionnaireService.isLocked(id), HttpStatus.OK);
    }

    @Loggable
    @GetMapping("/list")
    public ResponseEntity<List<QuestionnaireDTO.Info>> list() {
        return new ResponseEntity<>(iQuestionnaireService.list(), HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/iscList")
    public ResponseEntity<TotalResponse<QuestionnaireDTO.Info>> iscList(@RequestParam MultiValueMap<String, String> criteria) {
        final NICICOCriteria nicicoCriteria = NICICOCriteria.of(criteria);
        return new ResponseEntity<>(iQuestionnaireService.search(nicicoCriteria), HttpStatus.OK);
    }



    @Loggable
    @GetMapping(value = "/iscList/validQestionnaries/{classId}")
    public ResponseEntity<TotalResponse<QuestionnaireDTO.Info>> iscListValidQuestionnarie(@RequestParam MultiValueMap<String, String> criteria,
                                                                                            @PathVariable Long classId) {
        Long questionnarieId = null;
        Long questionnarieType = null;
        final NICICOCriteria nicicoCriteria = NICICOCriteria.of(criteria);
        TotalResponse<QuestionnaireDTO.Info> result = iQuestionnaireService.search(nicicoCriteria);
        if(result != null && result.getResponse().getData() != null && result.getResponse().getData().size() != 0){
            questionnarieType = result.getResponse().getData().get(0).getQuestionnaireType().getId();
        }
        if(questionnarieType != null && questionnarieType.equals(139L)){
            List<Evaluation> evaluationList =  iEvaluationService.findByClassIdAndEvaluationLevelIdAndQuestionnaireTypeId(classId, 154L, 139L);
            if(evaluationList != null && evaluationList.size() != 0){
                questionnarieId = evaluationList.get(0).getQuestionnaireId();
            }
        }
        //Todo need to refactor
        List<Object> removedObject = new ArrayList();
        for (QuestionnaireDTO.Info info : result.getResponse().getData()) {
            if(info.getQuestionnaireQuestionList() == null || info.getQuestionnaireQuestionList().size() == 0)
                removedObject.add(info);
          else if(questionnarieId != null && !info.getId().equals(questionnarieId))
                removedObject.add(info);

        }

        for (Object o : removedObject) {
            result.getResponse().getData().remove(o);
            result.getResponse().setTotalRows(result.getResponse().getTotalRows() -1);
            result.getResponse().setEndRow(result.getResponse().getEndRow() -1);
        }

        return new ResponseEntity<>(result, HttpStatus.OK);
    }

    @Loggable
    @PostMapping
    public ResponseEntity<QuestionnaireDTO.Info> create(@RequestBody Object rq) {
        QuestionnaireDTO.Create create = modelMapper.map(rq, QuestionnaireDTO.Create.class);
        return new ResponseEntity<>(iQuestionnaireService.create(create), HttpStatus.OK);
    }

    @Loggable
    @PutMapping("/{id}")
    public ResponseEntity<QuestionnaireDTO.Info> update(@PathVariable Long id, @RequestBody Object rq) {
        QuestionnaireDTO.Update update = modelMapper.map(rq, QuestionnaireDTO.Update.class);
        return new ResponseEntity<>(iQuestionnaireService.update(id, update), HttpStatus.OK);
    }

    @Loggable
    @PutMapping("/enable/{id}")
    public ResponseEntity<QuestionnaireDTO.Info> updateStatus(@PathVariable Long id) {
        return new ResponseEntity<>(iQuestionnaireService.updateEnable(id), HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping("/{id}")
    public ResponseEntity delete(@PathVariable Long id) {
        try {
            return new ResponseEntity<>(iQuestionnaireService.deleteWithChildren(id), HttpStatus.OK);
        } catch (Exception ex) {
            return new ResponseEntity<>(ex.getMessage(), HttpStatus.CONFLICT);
        }
    }


    @GetMapping("/getLastQuestionnarieId")
    public ResponseEntity<Long> getLastQuestionnarieId(@RequestParam MultiValueMap<String, String> criteria) {
        final NICICOCriteria nicicoCriteria = NICICOCriteria.of(criteria);
        List<QuestionnaireDTO.Info> result = iQuestionnaireService.search(nicicoCriteria).getResponse().getData();
        Long res = null;
        if(result.size() > 0)
            res = result.get(0).getId();
        return new ResponseEntity<>(res,HttpStatus.OK);
    }
}
