package com.nicico.training.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.QuestionBankDTO;
import com.nicico.training.model.ParameterValue;
import com.nicico.training.model.QuestionBank;
import com.nicico.training.model.QuestionBankTestQuestion;
import com.nicico.training.model.TestQuestion;
import com.nicico.training.repository.QuestionBankDAO;
import com.nicico.training.repository.QuestionBankTestQuestionDAO;
import com.nicico.training.repository.TestQuestionDAO;
import com.nicico.training.service.ParameterValueService;
import com.nicico.training.service.QuestionBankService;
import com.nicico.training.service.QuestionBankTestQuestionService;
import com.nicico.training.service.TestQuestionService;
import lombok.RequiredArgsConstructor;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import springfox.documentation.spring.web.json.Json;

import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.lang.reflect.Type;
import java.nio.charset.Charset;
import java.util.*;
import java.util.stream.Collectors;

@RequiredArgsConstructor
@Controller
@RequestMapping("/question-bank-test-question-form")
public class QuestionBankTestQuestionFormController {

    private final ReportUtil reportUtil;
    private final QuestionBankTestQuestionDAO questionBankTestQuestionDAO;
    private final QuestionBankDAO questionBankDAO;
    private final ModelMapper modelMapper;
    private final ObjectMapper mapper;
    private final ParameterValueService parameterValueService;

    @PostMapping(value = {"/print/{type}"})
    public void print(HttpServletResponse response,
                      @PathVariable String type,
                      @RequestParam(value = "fileName") String fileName,
                      @RequestParam(value = "TestQuestionId") Long TestQuestionId,
                      @RequestParam(value = "params") String receiveParams
    ) throws Exception {
        //-------------------------------------
        final Gson gson = new Gson();
        Type resultType = new TypeToken<HashMap<String, Object>>() {
        }.getType();
        final HashMap<String, Object> params = gson.fromJson(receiveParams, resultType);
//        data = "{" + "\"content\": " + data + "}";
        List<Long> questionBankIds = questionBankTestQuestionDAO.findQuestionBankIdsByTestQuestionId(TestQuestionId);
        List<QuestionBank> questionBanks = questionBankDAO.findByIds(questionBankIds);
        List<QuestionBankDTO.Exam> examList = new ArrayList<>();
        for(QuestionBank question : questionBanks){
            QuestionBankDTO.Exam exam = new QuestionBankDTO.Exam();
            if(question.getQuestionTypeId().equals(parameterValueService.getId("MultipleChoiceAnswer"))){
                if(question.getDisplayTypeId().equals(parameterValueService.getId("Block"))){
                    exam.setVOption1(question.getOption1());exam.setVOption2(question.getOption2());exam.setVOption3(question.getOption3());exam.setVOption4(question.getOption4());
                }else{
                    exam.setHOption1(question.getOption1());exam.setHOption2(question.getOption2());exam.setHOption3(question.getOption3());exam.setHOption4(question.getOption4());
                }
            }
            exam.setQuestion(question.getQuestion());
            examList.add(exam);
        }
//                modelMapper.map(questionBanks, new TypeToken<List<QuestionBankDTO.Exam>>() {}.getType());
        String data = mapper.writeValueAsString(examList);
        params.put("today", DateUtil.todayDate());
        params.put(ConstantVARs.REPORT_TYPE, type);
        JsonDataSource jsonDataSource = null;
        jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));
        reportUtil.export("/reports/" + fileName, params, jsonDataSource, response);
    }
}
