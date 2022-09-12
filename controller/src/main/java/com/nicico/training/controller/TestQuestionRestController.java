package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.TestQuestionDTO;
import com.nicico.training.iservice.IQuestionBankTestQuestionService;
import com.nicico.training.iservice.ITestQuestionService;
import com.nicico.training.model.QuestionBank;
import com.nicico.training.model.QuestionBankTestQuestion;
import com.nicico.training.model.TestQuestion;
import com.nicico.training.repository.QuestionBankTestQuestionDAO;
import com.nicico.training.service.QuestionBankTestQuestionService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.modelmapper.ModelMapper;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/test-question")
public class TestQuestionRestController {
    private final ModelMapper modelMapper;
    private final ObjectMapper objectMapper;
    private final ITestQuestionService testQuestionService;
    private final IQuestionBankTestQuestionService iQuestionBankTestQuestionService;
    // ------------------------------

    @Loggable
    @GetMapping(value = "/{id}")
    public ResponseEntity<TestQuestionDTO.fullInfo> get(@PathVariable Long id) throws IOException {
        return new ResponseEntity<>(testQuestionService.get(id), HttpStatus.OK);
    }

    @GetMapping(value = "/spec-list")
    public ResponseEntity<TestQuestionDTO.TestQuestionSpecRs> list(@RequestParam(value = "_startRow", defaultValue = "0") Integer startRow,
                                                                   @RequestParam(value = "_endRow", defaultValue = "50") Integer endRow,
                                                                   @RequestParam(value = "_constructor", required = false) String constructor,
                                                                   @RequestParam(value = "operator", required = false) String operator,
                                                                   @RequestParam(value = "criteria", required = false) String criteria,
                                                                   @RequestParam(value = "_sortBy", required = false) String sortBy) throws IOException {
        SearchDTO.SearchRq request = new SearchDTO.SearchRq();

        SearchDTO.CriteriaRq criteriaRq;
        if (StringUtils.isNotEmpty(constructor) && constructor.equals("AdvancedCriteria")) {
            criteria=criteria.replaceAll("\\s","");
            criteria = "[" + criteria + "]";
            criteriaRq = new SearchDTO.CriteriaRq();
            criteriaRq.setOperator(EOperator.valueOf(operator))
                    .setCriteria(objectMapper.readValue(criteria, new TypeReference<List<SearchDTO.CriteriaRq>>() {
                    }));
            request.setCriteria(criteriaRq);
        }
        if (StringUtils.isNotEmpty(sortBy)) {
            request.setSortBy(sortBy);
        }

        request.setStartIndex(startRow)
                .setCount(endRow - startRow);

        SearchDTO.SearchRs<TestQuestionDTO.Info> response = testQuestionService.search(request);
        LocalDateTime nowDateTime = LocalDateTime.now();
        LocalDateTime examDateTime ;

        for (TestQuestionDTO.Info testQuestion: response.getList()) {
            if (testQuestion.getTime() != null && !testQuestion.getTime().equals("")
                    && testQuestion.getDate() != null && !testQuestion.getDate().equals("")){
                String dateStr = DateUtil.convertKhToMi1(testQuestion.getDate());
                String timeStr = testQuestion.getTime();
                if (timeStr.trim().length()<=5 && timeStr.contains(":"))
                {
                    String[] str = timeStr.split(":");
                    LocalDate examDate = LocalDate.parse(dateStr);
                    LocalTime examTime = LocalTime.of(Integer.parseInt(str[0]),Integer.parseInt(str[1]));
                    examDateTime = LocalDateTime.of(examDate,examTime);
                    int diff = nowDateTime.minusMinutes(5).compareTo(examDateTime);
                    testQuestion.setOnlineExamDeadLineStatus(diff > 0);
                }
                else
                {
                    testQuestion.setOnlineExamDeadLineStatus(false);

                }

            } else {
                testQuestion.setOnlineExamDeadLineStatus(false);
            }
            if (testQuestion.getOnlineFinalExamStatus()  == null){
                testQuestion.setOnlineFinalExamStatus(false);
            }
        }
        final TestQuestionDTO.SpecRs specResponse = new TestQuestionDTO.SpecRs();
        specResponse.setData(response.getList())
                .setStartRow(startRow)
                .setEndRow(startRow + response.getList().size())
                .setTotalRows(response.getTotalCount().intValue());

        final TestQuestionDTO.TestQuestionSpecRs specRs = new TestQuestionDTO.TestQuestionSpecRs();
        specRs.setResponse(specResponse);

        return new ResponseEntity<>(specRs, HttpStatus.OK);
    }

    @Loggable
    @DeleteMapping(value = "/{id}")
//    @PreAuthorize("hasAuthority('d_personalInfo')")
    public ResponseEntity delete(@PathVariable Long id) {
        try {
            TestQuestionDTO.fullInfo testQuestion= testQuestionService.get(id);
            if(testQuestion.getOnlineFinalExamStatus()==null||!testQuestion.getOnlineFinalExamStatus())
            {
                testQuestionService.delete(id);
                return  new ResponseEntity<>(HttpStatus.OK);
            }
            else
                return new ResponseEntity<>(
                        new TrainingException(TrainingException.ErrorType.NotDeletable).getMessage(), HttpStatus.NOT_FOUND);

        } catch (TrainingException | DataIntegrityViolationException e) {
            return new ResponseEntity<>(
                    new TrainingException(TrainingException.ErrorType.TestQuestionBadRequest).getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @Loggable
    @PostMapping
    public ResponseEntity<TestQuestionDTO.Info> create(@Validated @RequestBody TestQuestionDTO.Create request) {

        HttpStatus httpStatus = HttpStatus.CREATED;
        TestQuestionDTO.Info info = null;
        try {
            info = testQuestionService.create(request);

        } catch (Exception e) {
            httpStatus = HttpStatus.NO_CONTENT;
            info = null;
        }
        return new ResponseEntity<>(info, httpStatus);
    }

    @Loggable
    @PostMapping(value = "/create-copy/{testId}")
    public ResponseEntity<TestQuestionDTO.Info> createCopy(@PathVariable Long testId, @Validated @RequestBody TestQuestionDTO.Create request) {

        HttpStatus httpStatus = HttpStatus.CREATED;
        TestQuestionDTO.Info testQuestionInfo = null;

        try {
            testQuestionInfo = testQuestionService.create(request);
            TestQuestion testQuestion = modelMapper.map(testQuestionInfo, TestQuestion.class);
            List<QuestionBankTestQuestion> questionTests = iQuestionBankTestQuestionService.findByTestQuestionId(testId);
            List<QuestionBank> questionBanks = questionTests.stream().map(QuestionBankTestQuestion::getQuestionBank).collect(Collectors.toList());

            questionBanks.stream().forEach(qb -> {
                QuestionBankTestQuestion questionBankTestQuestion = new QuestionBankTestQuestion();
                questionBankTestQuestion.setQuestionBank(qb);
                questionBankTestQuestion.setQuestionBankId(qb.getId());
                questionBankTestQuestion.setTestQuestion(testQuestion);
                questionBankTestQuestion.setTestQuestionId(testQuestion.getId());
                iQuestionBankTestQuestionService.save(questionBankTestQuestion);
            });
        } catch (Exception e) {
            httpStatus = HttpStatus.NO_CONTENT;
            testQuestionInfo = null;
        }

        return new ResponseEntity<>(testQuestionInfo, httpStatus);
    }

    @Loggable
    @PutMapping(value = "/{id}")
    public ResponseEntity<TestQuestionDTO.Info> update(@PathVariable Long id, @Validated @RequestBody TestQuestionDTO.Update request, HttpServletResponse response) {
        return new ResponseEntity<>(testQuestionService.update(id, request,response), HttpStatus.OK);
    }

    @Loggable
    @PostMapping(value = "/pre-test/{classId}")
    public ResponseEntity<TestQuestionDTO.Info> createPreTest(@PathVariable Long classId) {
        TestQuestion preTest = testQuestionService.createPreTest(classId);
        TestQuestionDTO.Info testQuestionInfo = modelMapper.map(preTest, TestQuestionDTO.Info.class);
        return new ResponseEntity<>(testQuestionInfo, HttpStatus.CREATED);
    }

}
