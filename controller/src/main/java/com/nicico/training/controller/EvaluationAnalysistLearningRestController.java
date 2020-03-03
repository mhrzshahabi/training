package com.nicico.training.controller;

import com.nicico.copper.core.util.report.ReportUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.apache.xmlbeans.impl.xb.xsdschema.Public;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.nio.charset.Charset;
import java.sql.RowId;
import java.util.HashMap;
import java.util.Map;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/evaluationAnalysist-learning-Rest")
public class EvaluationAnalysistLearningRestController {
    private final ReportUtil reportUtil;
    @PostMapping(value = "/print")
    public void print(HttpServletResponse response, @RequestParam(value = "recordId") String recordId)throws Exception
    {
       Map<String,Object> params=new HashMap();
        JsonDataSource jsonDataSource = null;
        String data=null;
        jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));
        reportUtil.export("/reports/printPreTestScore.jasper", params, jsonDataSource, response);
    }
}
