package com.nicico.training.controller;

import lombok.RequiredArgsConstructor;
import org.activiti.engine.impl.util.json.JSONObject;
import org.springframework.http.*;
import org.springframework.http.converter.ByteArrayHttpMessageConverter;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClientService;
import org.springframework.stereotype.Controller;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.client.RestTemplate;

import javax.servlet.http.HttpServletRequest;
import java.util.Arrays;

@RequiredArgsConstructor
@Controller
@RequestMapping("/tclass")
public class ClassFormController {
    private final OAuth2AuthorizedClientService authorizedClientService;

    @RequestMapping("/show-form")
    public String showForm() {
        return "base/class";
    }

    @GetMapping("/printWithCriteria/{type}")
    public ResponseEntity<?> printWithCriteria(final HttpServletRequest request, @PathVariable String type) {
        String token = (String) request.getSession().getAttribute("AccessToken");

        final RestTemplate restTemplate = new RestTemplate();
        restTemplate.getMessageConverters().add(new ByteArrayHttpMessageConverter());

        final HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + token);

        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        MultiValueMap<String, String> map = new LinkedMultiValueMap<String, String>();
        map.add("CriteriaStr", request.getParameter("CriteriaStr"));

        HttpEntity<MultiValueMap<String, String>> entity = new HttpEntity<MultiValueMap<String, String>>(map, headers);

        String restApiUrl = request.getRequestURL().toString().replace(request.getServletPath(), "");

        if (type.equals("pdf"))
            return restTemplate.exchange(restApiUrl + "/api/tclass/printWithCriteria/PDF", HttpMethod.POST, entity, byte[].class);
        else if (type.equals("excel"))
            return restTemplate.exchange(restApiUrl + "/api/tclass/printWithCriteria/EXCEL", HttpMethod.POST, entity, byte[].class);
        else if (type.equals("html"))
            return restTemplate.exchange(restApiUrl + "/api/tclass/printWithCriteria/HTML", HttpMethod.POST, entity, byte[].class);
        else
            return null;
    }

    @RequestMapping("/sessions-tab")
    public String sessionsTab() {
        return "classTabs/sessions";
    }

    @RequestMapping("/alarms-tab")
    public String alarmsTab() {
        return "classTabs/alarms";
    }

    @RequestMapping("/licenses-tab")
    public String licensesTab() {
        return "classTabs/licenses";
    }

    @RequestMapping("/attendance-tab")
    public String attendanceTab() {
        return "classTabs/attendance";
    }

    @RequestMapping("/exam-tab")
    public String examTab() {
        return "classTabs/exam";
    }

    @RequestMapping("/teachers-tab")
    public String teachersTab() {
        return "classTabs/teachers";
    }

    @RequestMapping("/assessment-tab")
    public String assessmentTab() {
        return "classTabs/assessment";
    }

    @RequestMapping("/checkList-tab")
    public String checkListTab() {
        return "classTabs/checkList";
    }

    @RequestMapping("/attachments-tab")
    public String attachmentsTab() {
        return "base/attachments";
    }

    @RequestMapping("/student")
    public String showStudentsForm() {
        return "classTabs/student";
    }

    @RequestMapping("/scores-tab")
    public String scoresTab() {
        return "classTabs/scores";
    }

    @RequestMapping("/cost-class-tab")
    public String costclasstabTab() {
        return "classTabs/costClass";
    }

    @RequestMapping("/classDocuments-tab")
    public String classDocumentsTab() {
        return "classTabs/classDocuments";
    }

    @RequestMapping("/pre-course-test-questions-tab")
    public String preCourseQuestionsTab() {
        return "classTabs/preCourseTestQuestions";
    }

    @RequestMapping("/teacher-information-tab")
    public String techerInformationTab() {
        return "classTabs/teacherInformation";
    }

    @RequestMapping("/evaluation-info-tab")
    public String evaluationInfoTab() {
        return "classTabs/classEvaluationInfo";
    }

    @PostMapping("/reportPrint/{type}")
    public ResponseEntity<?> reportPrint(final HttpServletRequest request, @PathVariable String type) {
        String token = request.getParameter("token");

        final RestTemplate restTemplate = new RestTemplate();
        restTemplate.getMessageConverters().add(new ByteArrayHttpMessageConverter());
        JSONObject dataParams = new JSONObject(request.getParameter("data"));

        MultiValueMap<String, String> params = new LinkedMultiValueMap();
        params.add("courseInfo",dataParams.get("courseInfo").toString());
        params.add("classTimeInfo",dataParams.get("classTimeInfo").toString());
        params.add("executionInfo",dataParams.get("executionInfo").toString());;
        params.add("evaluationInfo",dataParams.get("evaluationInfo").toString());
        params.add("CriteriaStr", request.getParameter("CriteriaStr").toString());

        final HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + token);
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
        headers.setAccept(Arrays.asList(MediaType.APPLICATION_JSON));

        HttpEntity<MultiValueMap<String, String>> entity = new HttpEntity<>(params, headers);

        String restApiUrl = request.getRequestURL().toString().replace(request.getServletPath(), "");

        switch (type) {
            case "pdf":
                return restTemplate.exchange(restApiUrl + "/api/tclass/reportPrint/PDF", HttpMethod.POST, entity, byte[].class);
            case "excel":
                return restTemplate.exchange(restApiUrl + "/api/tclass/reportPrint/EXCEL", HttpMethod.POST, entity, byte[].class);
            case "html":
                return restTemplate.exchange(restApiUrl + "/api/tclass/reportPrint/HTML", HttpMethod.POST, entity, byte[].class);
            default:
                return null;
        }
    }
}
