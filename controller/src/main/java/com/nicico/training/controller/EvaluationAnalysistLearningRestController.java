package com.nicico.training.controller;

import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.ClassStudentDTO;
import com.nicico.training.model.ClassStudent;
import com.nicico.training.service.EvaluationAnalysistLearningService;
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
    @PostMapping(value = "/print")
    public void print(HttpServletResponse response, @RequestParam(value = "recordId") String recordId)throws Exception
    {
       Float[] classStudent= evaluationAnalysistLearningService.getStudents(Long.parseLong(recordId));
        Map<String,Object> params=new HashMap();
        params.put("score",classStudent[0]);
        params.put("preTestScore",classStudent[1]);
        params.put("studentCount",classStudent[2]);
        String data=null;
        reportUtil.export("/reports/printPreTestScore.jasper", params, response);
    }
}
