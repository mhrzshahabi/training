package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.QuestionBankTestQuestionDTO;
import com.nicico.training.iservice.IQuestionBankTestQuestionService;
import com.nicico.training.repository.TclassDAO;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/question-bank-test-question")
public class QuestionBankTestQuestionRestController {

    private final IQuestionBankTestQuestionService questionBankTestQuestionService;
    private final TclassDAO tclassDAO;
    private final ObjectMapper objectMapper;

    // ------------------------------

    @GetMapping(value = "/spec-list")
    public ResponseEntity<QuestionBankTestQuestionDTO.QuestionBankTestQuestionSpecRs> list(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow, @RequestParam(value = "_endRow", defaultValue = "50") Integer endRow, @RequestParam(value = "_constructor", required = false) String constructor, @RequestParam(value = "operator", required = false) String operator, @RequestParam(value = "criteria", required = false) String criteria, @RequestParam(value = "_sortBy", required = false) String sortBy) throws IOException {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();

        SearchDTO.CriteriaRq criteriaRq;
        if (StringUtils.isNotEmpty(constructor) && constructor.equals("AdvancedCriteria")) {
            criteria = "[" + criteria + "]";
            criteriaRq = new SearchDTO.CriteriaRq();
            criteriaRq.setOperator(EOperator.valueOf(operator)).setCriteria(objectMapper.readValue(criteria, new TypeReference<List<SearchDTO.CriteriaRq>>() {
            }));
            request.setCriteria(criteriaRq);
        }
        if (StringUtils.isNotEmpty(sortBy)) {
            request.setSortBy(sortBy);
        }

        request.setStartIndex(startRow).setCount(endRow - startRow);

        SearchDTO.SearchRs<QuestionBankTestQuestionDTO.Info> response = questionBankTestQuestionService.search(request);

        final QuestionBankTestQuestionDTO.SpecRs specResponse = new QuestionBankTestQuestionDTO.SpecRs();
        specResponse.setData(response.getList()).setStartRow(startRow).setEndRow(startRow + response.getList().size()).setTotalRows(response.getTotalCount().intValue());

        final QuestionBankTestQuestionDTO.QuestionBankTestQuestionSpecRs specRs = new QuestionBankTestQuestionDTO.QuestionBankTestQuestionSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @GetMapping(value = "{type}/{classId}/spec-list")
    public ResponseEntity<QuestionBankTestQuestionDTO.QuestionBankTestQuestionSpecRs> listForClass(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow, @RequestParam(value = "_endRow", defaultValue = "50") Integer endRow, @RequestParam(value = "_constructor", required = false) String constructor, @RequestParam(value = "operator", required = false) String operator, @RequestParam(value = "criteria", required = false) String criteria, @RequestParam(value = "_sortBy", required = false) String sortBy, @PathVariable Long classId, @PathVariable String type) throws IOException {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();

        SearchDTO.CriteriaRq criteriaRq;
        if (StringUtils.isNotEmpty(constructor) && constructor.equals("AdvancedCriteria")) {
            criteria = "[" + criteria + "]";
            criteriaRq = new SearchDTO.CriteriaRq();
            criteriaRq.setOperator(EOperator.valueOf(operator)).setCriteria(objectMapper.readValue(criteria, new TypeReference<List<SearchDTO.CriteriaRq>>() {
            }));
            request.setCriteria(criteriaRq);
        }

        if (StringUtils.isNotEmpty(sortBy)) {
            request.setSortBy(sortBy);
        }

        request.setStartIndex(startRow).setCount(endRow - startRow);


        SearchDTO.CriteriaRq tmpCriteria = null;
        List<SearchDTO.CriteriaRq> listCriteria = new ArrayList<>();

        SearchDTO.CriteriaRq result = new SearchDTO.CriteriaRq();
        result.setOperator(EOperator.and);

        if (request.getCriteria() != null) {
            listCriteria.add(request.getCriteria());
        }

        tmpCriteria = new SearchDTO.CriteriaRq();

        SearchDTO.CriteriaRq criteriaRq1 = new SearchDTO.CriteriaRq();
        criteriaRq1.setOperator(EOperator.equals);
        criteriaRq1.setFieldName("testQuestion.tclassId");
        criteriaRq1.setValue(classId);

        ArrayList<SearchDTO.CriteriaRq> criteriaRqs = new ArrayList<>();
        criteriaRqs.add(criteriaRq1);

        criteriaRq1 = new SearchDTO.CriteriaRq();
        criteriaRq1.setOperator(EOperator.equals);
        criteriaRq1.setFieldName("testQuestion.isPreTestQuestion");

        if (type.equals("preTest")) {
            criteriaRq1.setValue(1);
        } else {
            criteriaRq1.setValue(0);
        }


        criteriaRqs.add(criteriaRq1);

        tmpCriteria.setCriteria(criteriaRqs);
        tmpCriteria.setOperator(EOperator.and);

        listCriteria.add(tmpCriteria);

        result.setCriteria(listCriteria);

        request.setCriteria(result);


        SearchDTO.SearchRs<QuestionBankTestQuestionDTO.Info> response = questionBankTestQuestionService.search(request);

        final QuestionBankTestQuestionDTO.SpecRs specResponse = new QuestionBankTestQuestionDTO.SpecRs();
        specResponse.setData(response.getList()).setStartRow(startRow).setEndRow(startRow + response.getList().size()).setTotalRows(response.getTotalCount().intValue());

        final QuestionBankTestQuestionDTO.QuestionBankTestQuestionSpecRs specRs = new QuestionBankTestQuestionDTO.QuestionBankTestQuestionSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @GetMapping(value = "{type}/{classId}/spec-list-final-test")
    public ResponseEntity<List<QuestionBankTestQuestionDTO.QuestionBankTestQuestionFinalTest>> listForFinalTest(@PathVariable Long classId, @PathVariable String type) {

        try {

            List<QuestionBankTestQuestionDTO.QuestionBankTestQuestionFinalTest> questionBankTestQuestionFinalTests = questionBankTestQuestionService.finalTestList(type, classId);
            if (questionBankTestQuestionFinalTests.size() == 0) {
                return new ResponseEntity<>(questionBankTestQuestionFinalTests, HttpStatus.OK);
            } else {
                try {

                    questionBankTestQuestionService.validateQuestions(type, questionBankTestQuestionFinalTests);
                    return new ResponseEntity<>(questionBankTestQuestionFinalTests, HttpStatus.OK);
                } catch (Exception ex) {
                    return new ResponseEntity("", HttpStatus.METHOD_NOT_ALLOWED);
                }
            }
        } catch (Exception e) {
            return new ResponseEntity("", HttpStatus.NOT_FOUND);
        }
    }


    @GetMapping(value = "/byCourse/{type}/{classId}/spec-list")
    public ResponseEntity<QuestionBankTestQuestionDTO.QuestionBankTestQuestionSpecRsUsed> questionForCourse(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow, @RequestParam(value = "_endRow", defaultValue = "50") Integer endRow, @RequestParam(value = "_constructor", required = false) String constructor, @RequestParam(value = "operator", required = false) String operator, @RequestParam(value = "criteria", required = false) String criteria, @RequestParam(value = "_sortBy", required = false) String sortBy, @PathVariable Long classId, @PathVariable String type) throws IOException {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();

        SearchDTO.CriteriaRq criteriaRq;
        if (StringUtils.isNotEmpty(constructor) && constructor.equals("AdvancedCriteria")) {
            criteria = "[" + criteria + "]";
            criteriaRq = new SearchDTO.CriteriaRq();
            criteriaRq.setOperator(EOperator.valueOf(operator)).setCriteria(objectMapper.readValue(criteria, new TypeReference<List<SearchDTO.CriteriaRq>>() {
            }));
            request.setCriteria(criteriaRq);
        }

        if (StringUtils.isNotEmpty(sortBy)) {
            request.setSortBy(sortBy);
        }

        request.setStartIndex(startRow).setCount(endRow - startRow);


        SearchDTO.CriteriaRq tmpCriteria = null;
        List<SearchDTO.CriteriaRq> listCriteria = new ArrayList<>();

        SearchDTO.CriteriaRq result = new SearchDTO.CriteriaRq();
        result.setOperator(EOperator.and);

        if (request.getCriteria() != null) {
            listCriteria.add(request.getCriteria());
        }

        tmpCriteria = new SearchDTO.CriteriaRq();

        ArrayList<SearchDTO.CriteriaRq> criteriaRqs = new ArrayList<>();

        SearchDTO.CriteriaRq criteriaRq1 = new SearchDTO.CriteriaRq();
        criteriaRq1.setOperator(EOperator.notEqual);
        criteriaRq1.setFieldName("testQuestion.tclassId");
        criteriaRq1.setValue(classId);

        criteriaRqs.add(criteriaRq1);

        criteriaRq1 = new SearchDTO.CriteriaRq();
        criteriaRq1.setOperator(EOperator.equals);
        criteriaRq1.setFieldName("testQuestion.tclass.courseId");
        criteriaRq1.setValue(tclassDAO.findById(classId).orElse(null).getCourseId());

        criteriaRqs.add(criteriaRq1);

        criteriaRq1 = new SearchDTO.CriteriaRq();
        criteriaRq1.setOperator(EOperator.equals);
        criteriaRq1.setFieldName("testQuestion.isPreTestQuestion");

        if (type.equals("preTest")) {
            criteriaRq1.setValue(1);
        } else {
            criteriaRq1.setValue(0);
        }

        criteriaRqs.add(criteriaRq1);

        tmpCriteria.setCriteria(criteriaRqs);
        tmpCriteria.setOperator(EOperator.and);

        listCriteria.add(tmpCriteria);

        result.setCriteria(listCriteria);

        request.setCriteria(result);

        SearchDTO.SearchRs<QuestionBankTestQuestionDTO.InfoUsed> response = questionBankTestQuestionService.search1(request);

        final QuestionBankTestQuestionDTO.SpecRsUsed specResponse = new QuestionBankTestQuestionDTO.SpecRsUsed();
        specResponse.setData(response.getList()).setStartRow(startRow).setEndRow(startRow + response.getList().size()).setTotalRows(response.getTotalCount().intValue());

        final QuestionBankTestQuestionDTO.QuestionBankTestQuestionSpecRsUsed specRs = new QuestionBankTestQuestionDTO.QuestionBankTestQuestionSpecRsUsed();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/add-questions/{type}/{classId}/{questionId}")
    public ResponseEntity<Void> addQuestions(@PathVariable String type, @PathVariable Long classId, @PathVariable List<Long> questionId) {
        questionBankTestQuestionService.addQuestions(type, classId, questionId);
        return new ResponseEntity(HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/delete-questions/{type}/{classId}/{questionId}")
    public ResponseEntity<Void> deleteQuestions(@PathVariable String type, @PathVariable Long classId, @PathVariable List<Long> questionId) {
        questionBankTestQuestionService.deleteQuestions(type, classId, questionId);
        return new ResponseEntity(HttpStatus.OK);
    }

}
