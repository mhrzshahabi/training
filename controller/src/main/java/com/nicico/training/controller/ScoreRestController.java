package com.nicico.training.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.JsonObject;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.ClassStudentDTO;
import com.nicico.training.dto.TermDTO;
import com.nicico.training.service.ClassStudentService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.activiti.engine.impl.util.json.JSONObject;
import org.modelmapper.ModelMapper;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.nio.charset.Charset;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/score")
public class ScoreRestController {
    private final ObjectMapper objectMapper;
    private final DateUtil dateUtil;
    private final ReportUtil reportUtil;
    private final ClassStudentService classStudentService;

    @PostMapping(value = {"/printWithCriteria"})
    public void printWithCriteria(HttpServletResponse response, @RequestParam(value = "classId") String classId, @RequestParam(value = "CriteriaStr") String criteriaStr, @RequestParam(value = "class") String classRecord) throws Exception {
        final SearchDTO.CriteriaRq criteriaRq;
        final SearchDTO.SearchRq searchRq;
        Map<String, String> map = new HashMap<>();
        map.put("1001", "ضعیف");
        map.put("1002", "متوسط");
        map.put("1003", "خوب");
        map.put("1004", "خیلی خوب");
        if (criteriaStr.equalsIgnoreCase("{}")) {
            searchRq = new SearchDTO.SearchRq();
        } else {
            criteriaRq = objectMapper.readValue(criteriaStr, SearchDTO.CriteriaRq.class);
            searchRq = new SearchDTO.SearchRq().setCriteria(criteriaRq);
        }
        JSONObject json = new JSONObject(classRecord);
        final SearchDTO.SearchRs<ClassStudentDTO.ScoresInfo> searchRs = classStudentService.searchClassStudents(searchRq, Long.valueOf(classId), ClassStudentDTO.ScoresInfo.class);
        Map<String, String> map1 = new HashMap<>();
        map1.put("1001", "ضعیف");
        map1.put("1002", "متوسط");
        map1.put("1003", "خوب");
        map1.put("1004", "خیلی خوب");
        final Map<String, Object> params = new HashMap<>();
        params.put("todayDate", dateUtil.todayDate());
        params.put("code", json.getString("code"));
        params.put("teacher", json.getString("teacher"));
        params.put("course", json.getString("course"));
        params.put("endDate", json.getString("endDate"));
        params.put("startDate", json.getString("startDate"));
        params.put("scoringMethod", json.getString("scoringMethod"));
        params.put("acceptancelimit", json.getString("acceptancelimit"));
        params.put(ConstantVARs.REPORT_TYPE, "pdf");
        if (json.getString("scoringMethod").equals("ارزشی")) {
            List<ClassStudentDTO.ScoresInfo> list = searchRs.getList();
            for (ClassStudentDTO.ScoresInfo x : list) {
                x.setValence(map1.get(x.getValence()));
            }
            String data = "{" + "\"content\": " + objectMapper.writeValueAsString(list) + "}";
            JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));
            reportUtil.export("/reports/scoreValence.jasper", params, jsonDataSource, response);
        } else {
            String data = "{" + "\"content\": " + objectMapper.writeValueAsString(searchRs.getList()) + "}";
            JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));
            reportUtil.export("/reports/scoreOf20OR100.jasper", params, jsonDataSource, response);
        }
    }
}
