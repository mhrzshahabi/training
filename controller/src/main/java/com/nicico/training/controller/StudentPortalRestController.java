package com.nicico.training.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.domain.ConstantVARs;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.common.util.date.DateUtil;
import com.nicico.copper.core.SecurityUtil;
import com.nicico.copper.core.util.report.ReportUtil;
import com.nicico.training.dto.ClassStudentDTO;
import com.nicico.training.iservice.IClassStudentService;
import com.nicico.training.service.ClassStudentService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jasperreports.engine.data.JsonDataSource;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.lang.reflect.Type;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.HashMap;

import static com.nicico.training.service.BaseService.makeNewCriteria;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/student-portal")
public class StudentPortalRestController {

    private final ObjectMapper objectMapper;
    private final ReportUtil reportUtil;
    private final IClassStudentService iClassStudentService;
    private final ModelMapper modelMapper;

    /////////////////////////////////////class-student//////////////////////////////////////////////////////////

    @Loggable
    @GetMapping(value = "/class-student/classes-of-student/{nationalCode}")
    public void classesOfStudentList(HttpServletRequest iscRq, HttpServletResponse response, @PathVariable String nationalCode) throws IOException {
        String restApiUrl = iscRq.getRequestURL().toString().replace(iscRq.getServletPath(), "");
        response.sendRedirect(restApiUrl + "/api/class-student/classes-of-student/" + SecurityUtil.getNationalCode() + "?" + iscRq.getQueryString());
    }

    @Loggable
    @GetMapping(value = "/class-student/class-list-of-student/{nationalCode}")
    public void classesOfStudentJustClassList(HttpServletRequest iscRq, HttpServletResponse response, @PathVariable String nationalCode) throws IOException {
        String restApiUrl = iscRq.getRequestURL().toString().replace(iscRq.getServletPath(), "");
        response.sendRedirect(restApiUrl + "/api/class-student/class-list-of-student/" + SecurityUtil.getNationalCode() + "?" + iscRq.getQueryString());
    }

    @Loggable
    @PostMapping(value = {"/print/{type}"})
    public void printWithCriteria(HttpServletResponse response,
                                  @PathVariable String type,
//                                  @RequestParam(value = "formData") String formData,
                                  @RequestParam(value = "params") String receiveParams,
                                  @RequestParam(value = "CriteriaStr") String criteriaStr) throws Exception {

        Gson gson = new Gson();
        Type resultType = new TypeToken<HashMap<String, Object>>() {
        }.getType();
        HashMap<String, Object> params = gson.fromJson(receiveParams, resultType);
        params.put("todayDate", DateUtil.todayDate());
        params.put(ConstantVARs.REPORT_TYPE, type);

//        String nationalCode = gson.fromJson(formData, String.class);
        final SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, new ArrayList<>());
        criteriaRq.getCriteria().add(makeNewCriteria("student.nationalCode", SecurityUtil.getNationalCode(), EOperator.equals, null));

        if (!criteriaStr.equalsIgnoreCase("{}")) {
            criteriaRq.getCriteria().add(objectMapper.readValue(criteriaStr, SearchDTO.CriteriaRq.class));
        }

        final SearchDTO.SearchRs<ClassStudentDTO.CoursesOfStudent> searchRs = iClassStudentService.search(new SearchDTO.SearchRq().setCriteria(criteriaRq), c -> modelMapper.map(c, ClassStudentDTO.CoursesOfStudent.class));

        String data = "{" + "\"content\": " + objectMapper.writeValueAsString(searchRs.getList()) + "}";
        JsonDataSource jsonDataSource = new JsonDataSource(new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8"))));

        reportUtil.export("/reports/trainingFile.jasper", params, jsonDataSource, response);
    }

    /////////////////////////////////////session//////////////////////////////////////////////////////////

    @Loggable
    @GetMapping(value = "/sessionService/specListWeeklyTrainingSchedule/{nationalCode}")
    public void getWeeklyTrainingSchedule(HttpServletRequest iscRq, HttpServletResponse response, @PathVariable String nationalCode) throws IOException {
        String restApiUrl = iscRq.getRequestURL().toString().replace(iscRq.getServletPath(), "");
        response.sendRedirect(restApiUrl + "/api/sessionService/specListWeeklyTrainingSchedule/" + SecurityUtil.getNationalCode() + "?" + iscRq.getQueryString());
    }

    /////////////////////////////////////personnel//////////////////////////////////////////////////////////

    @Loggable
    @GetMapping(value = "/personnel/getOneByNationalCode")
    public void getPersonnelInfo(HttpServletRequest iscRq, HttpServletResponse response) throws IOException {
        String restApiUrl = iscRq.getRequestURL().toString().replace(iscRq.getServletPath(), "");
        response.sendRedirect(restApiUrl + "/api/personnel/getOneByNationalCode/" + SecurityUtil.getNationalCode() + "?" + iscRq.getQueryString());
    }

    /////////////////////////////////////student//////////////////////////////////////////////////////////

    @Loggable
    @GetMapping(value = "/student/getOneByNationalCode")
    public void getStudentInfo(HttpServletRequest iscRq, HttpServletResponse response) throws IOException {
        String restApiUrl = iscRq.getRequestURL().toString().replace(iscRq.getServletPath(), "");
        response.sendRedirect(restApiUrl + "/api/student/getOneByNationalCode/" + SecurityUtil.getNationalCode() + "?" + iscRq.getQueryString());
    }


    @Loggable
    @GetMapping(value = "/evaluation/getStudentEvaluationForms/{nationalCode}/{personnelId}")
    public void getEvaluationForms(HttpServletRequest iscRq, HttpServletResponse response,@PathVariable String nationalCode, @PathVariable Long personnelId) throws IOException {
        String restApiUrl = iscRq.getRequestURL().toString().replace(iscRq.getServletPath(), "");
        response.sendRedirect(restApiUrl + "/api/evaluation/personnelEvaluationForms/" + nationalCode + "/" + personnelId + "?" + iscRq.getQueryString());


    }
}