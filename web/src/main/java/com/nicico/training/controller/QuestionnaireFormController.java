package com.nicico.training.controller;

import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import lombok.RequiredArgsConstructor;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.activiti.engine.impl.util.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.nio.charset.Charset;
import java.util.HashMap;
import java.util.Map;


@RequiredArgsConstructor
@Controller
@RequestMapping("/questionnaireReport")
public class QuestionnaireFormController {
    private final DateUtil dateUtil;
    private final ReportUtil reportUtil;
    @PostMapping("/questionnaire/{type}")
    public void printWithCriteria(HttpServletResponse response,@PathVariable String type,@RequestParam(value = "questionnaire") String questions,@RequestParam(value = "title") String title) throws Exception {
        //-------------------------------------
        final Map<String, Object> params = new HashMap<>();
        String data = "{" + "\"content\": " + questions + "}";
        JSONObject json = new JSONObject(title);
        params.put("todayDate", dateUtil.todayDate());
        params.put("code",json.getString("code"));
        params.put("teacher",json.getString("teacher"));
        params.put("startDate",json.getString("startDate") );
        params.put("titleClass",json.getString("titleClass"));
        params.put("institute",json.getJSONObject("institute").get("titleFa"));
        params.put("evaluator",json.getString("evaluator"));
        JsonDataSource jsonDataSource = null;
        jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));
        params.put(ConstantVARs.REPORT_TYPE,type);
        reportUtil.export("/reports/questionnaireReport.jasper", params, jsonDataSource,response);
    }
}
