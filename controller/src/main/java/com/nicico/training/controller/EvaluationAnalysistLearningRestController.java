package com.nicico.training.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.service.EvaluationAnalysistLearningService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.activiti.engine.impl.util.json.JSONObject;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.nio.charset.Charset;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/evaluationAnalysist-learning-Rest")
public class EvaluationAnalysistLearningRestController {
    private final EvaluationAnalysistLearningService evaluationAnalysistLearningService;
    private final ReportUtil reportUtil;
    private final ObjectMapper objectMapper;

    @PostMapping(value = "/print")
    public void print(HttpServletResponse response, @RequestParam(value = "recordId") String recordId,@RequestParam(value = "minScoreLearning") String minScoreLearning, @RequestParam(value = "Record") String Record) throws Exception {
        Map<String, Object> params = new HashMap();
        Map<String, String> map = new HashMap<>();
        map.put("1", "ارزشی");
        map.put("2", "نمره از صد");
        map.put("3", "نمره از بیست");
        map.put("4", "بدون نمره");
        JSONObject json = new JSONObject(Record);
        params.put("code", json.getString("tclassCode"));
        params.put("studentCount", json.getString("tclassStudentsCount"));
        params.put("endDate", json.getString("tclassEndDate"));
        params.put("startDate", json.getString("tclassStartDate"));
        params.put("teacher", json.getString("teacherFullName"));
        params.put("courseCode", json.getString("courseCode"));
        params.put("coursetitleFa", json.getString("courseTitleFa"));
        if(json.has("classScoringMethod"))
            params.put("scoringMethod", map.get(json.getString("classScoringMethod")));
        else
            params.put("scoringMethod", "");
        params.put("minScoreLearning",minScoreLearning);
        String scoringMethod = "3";
        if(json.has("classScoringMethod"))
            scoringMethod = json.getString("classScoringMethod");
        Float[] classStudent = evaluationAnalysistLearningService.getStudents(Long.parseLong(recordId),scoringMethod);

        params.put("score", classStudent[0]);
        params.put("preTestScore",classStudent[1]);
        params.put("ScoreEvaluation",classStudent[3]);
        if(classStudent[3]>=Float.valueOf(minScoreLearning))
        {
            params.put("resault","تایید");
        }
        else
        {
            params.put("resault","عدم تایید");
        }
        List<?> list=evaluationAnalysistLearningService.getStudentWithOutPreTest(Long.parseLong(recordId));
        String data = "{" + "\"studentWithOutPreTest\": " + objectMapper.writeValueAsString(list) + "}";
        params.put(ConstantVARs.REPORT_TYPE, "pdf");
        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));
        reportUtil.export("/reports/evaluationAnalysistLearning.jasper", params, jsonDataSource, response);
    }
}
