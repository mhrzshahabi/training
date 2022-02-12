package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.training.controller.util.CriteriaUtil;
import com.nicico.training.dto.QuestionnaireQuestionDTO;
import com.nicico.training.dto.SkillDTO;
import com.nicico.training.iservice.IQuestionnaireQuestionService;
import com.nicico.training.iservice.ISkillService;
import com.nicico.training.model.QuestionnaireQuestion;
import com.nicico.training.model.Skill;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/questionnaireQuestion")
public class QuestionnaireQuestionRestController {

    private final IQuestionnaireQuestionService questionnaireQuestionValueService;
    private final ModelMapper modelMapper;
    private final ISkillService iSkillService;

    @Loggable
    @GetMapping("/list")
    public ResponseEntity<List<QuestionnaireQuestionDTO.Info>> list() {
        return new ResponseEntity<>(questionnaireQuestionValueService.list(), HttpStatus.OK);
    }



    @Loggable
    @GetMapping("/iscList/{questionnaireId}")
    public ResponseEntity<TotalResponse<QuestionnaireQuestionDTO.Info>> getParametersValueList(@RequestParam MultiValueMap<String, String> criteria, @PathVariable Long questionnaireId) {
        return iscList(CriteriaUtil.addCriteria(criteria, "questionnaireId", "equals", questionnaireId.toString()));
    }

    @Loggable
    @PostMapping
    public ResponseEntity<QuestionnaireQuestionDTO.Info> create(@RequestBody Object rq) {
        QuestionnaireQuestionDTO.Create create = modelMapper.map(rq, QuestionnaireQuestionDTO.Create.class);
        return new ResponseEntity<>(questionnaireQuestionValueService.checkAndCreate(create), HttpStatus.OK);
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

//    @Loggable
//    @GetMapping(value = "/teacherQuestionnaire")
//    public ResponseEntity<TotalResponse<QuestionnaireQuestionDTO.Info>> teacherQuestionnaire() {
//        final NICICOCriteria nicicoCriteria = NICICOCriteria.of(criteria);
//        return new ResponseEntity<>(questionnaireQuestionValueService.search(nicicoCriteria), HttpStatus.OK);
//    }

    @Loggable
    @GetMapping(value = "/iscList")
    public ResponseEntity<TotalResponse<QuestionnaireQuestionDTO.Info>> iscList(@RequestParam MultiValueMap<String, String> criteria) {
        final NICICOCriteria nicicoCriteria = NICICOCriteria.of(criteria);
        return new ResponseEntity<>(questionnaireQuestionValueService.search(nicicoCriteria), HttpStatus.OK);
    }


    @Loggable
    @GetMapping(value = "/equipmentQuestionnaire")
    public ResponseEntity<QuestionnaireQuestionDTO.QuestionnaireQuestionSpecRs> equipmentQuestionnaire() {

        List<QuestionnaireQuestion> equipmentQuestionnaireQuestion = questionnaireQuestionValueService.getEvaluationQuestion(54L);

        List<QuestionnaireQuestionDTO.Info> questionnaireQuestionInfo = modelMapper.map(equipmentQuestionnaireQuestion,
                new TypeToken<List<QuestionnaireQuestionDTO.Info>>() {
        }.getType());
        final QuestionnaireQuestionDTO.SpecRs specResponse = new QuestionnaireQuestionDTO.SpecRs();
        specResponse.setData(questionnaireQuestionInfo)
                .setStartRow(0)
                .setEndRow(questionnaireQuestionInfo.size())
                .setTotalRows(questionnaireQuestionInfo.size());
        final QuestionnaireQuestionDTO.QuestionnaireQuestionSpecRs specRs = new QuestionnaireQuestionDTO.QuestionnaireQuestionSpecRs();
        specRs.setResponse(specResponse);
        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }


    @Loggable
    @GetMapping(value = "/teacherQuestionnaire")
    public ResponseEntity<QuestionnaireQuestionDTO.QuestionnaireQuestionSpecRs> teacherQuestionnaire() {

        List<QuestionnaireQuestion> teacherQuestionnaireQuestion = questionnaireQuestionValueService.getEvaluationQuestion(53L);

        List<QuestionnaireQuestionDTO.Info> questionnaireQuestionInfo = modelMapper.map(teacherQuestionnaireQuestion,
                new TypeToken<List<QuestionnaireQuestionDTO.Info>>() {}.getType());
        final QuestionnaireQuestionDTO.SpecRs specResponse = new QuestionnaireQuestionDTO.SpecRs();
        specResponse.setData(questionnaireQuestionInfo)
                .setStartRow(0)
                .setEndRow(questionnaireQuestionInfo.size())
                .setTotalRows(questionnaireQuestionInfo.size());
        final QuestionnaireQuestionDTO.QuestionnaireQuestionSpecRs specRs = new QuestionnaireQuestionDTO.QuestionnaireQuestionSpecRs();
        specRs.setResponse(specResponse);
        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @GetMapping(value = "/skillQuestionnaire/{courseId}")
    public ResponseEntity<SkillDTO.SkillSpecRs> skillQuestionnaire(@PathVariable Long courseId) {

        List<Skill> skillList = iSkillService.skillList(courseId);

        List<SkillDTO.Info> skillInfo = modelMapper.map(skillList,
                new TypeToken<List<QuestionnaireQuestionDTO.Info>>() {}.getType());
        final SkillDTO.SpecRs specResponse = new SkillDTO.SpecRs();
        specResponse.setData(skillInfo)
                .setStartRow(0)
                .setEndRow(skillInfo.size())
                .setTotalRows(skillInfo.size());
        final SkillDTO.SkillSpecRs specRs = new SkillDTO.SkillSpecRs();
        specRs.setResponse(specResponse);
        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

}

