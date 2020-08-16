package com.nicico.training.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.QuestionBankDTO;
import com.nicico.training.model.QuestionBank;
import com.nicico.training.model.QuestionBankTestQuestion;
import com.nicico.training.model.TestQuestion;
import com.nicico.training.repository.QuestionBankDAO;
import com.nicico.training.repository.QuestionBankTestQuestionDAO;
import com.nicico.training.repository.TestQuestionDAO;
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
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
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

    @PostMapping(value = {"/print/{type}"})
    public void print(HttpServletResponse response,
                      @PathVariable String type,
                      @RequestParam(value = "fileName") String fileName,
                      @RequestParam(value = "TestQuestionId") String TestQuestionId,
                      @RequestParam(value = "params") String receiveParams
    ) throws Exception {
        //-------------------------------------
        final Gson gson = new Gson();
        Type resultType = new TypeToken<HashMap<String, Object>>() {
        }.getType();
        final HashMap<String, Object> params = gson.fromJson(receiveParams, resultType);
//        data = "{" + "\"content\": " + data + "}";
        List<Long> questionBankIds = questionBankTestQuestionDAO.findQuestionBankIdsByTestQuestionId(new Long(23));
        List<QuestionBank> questionBanks = questionBankDAO.findByIds(questionBankIds);
        List<QuestionBankDTO.Exam> examList = modelMapper.map(questionBanks, new TypeToken<List<QuestionBankDTO.Exam>>() {}.getType());
        String data = mapper.writeValueAsString(examList);
        params.put("today", DateUtil.todayDate());
        params.put(ConstantVARs.REPORT_TYPE, type);
        JsonDataSource jsonDataSource = null;
        jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));
        reportUtil.export("/reports/" + fileName, params, jsonDataSource, response);
    }
}
