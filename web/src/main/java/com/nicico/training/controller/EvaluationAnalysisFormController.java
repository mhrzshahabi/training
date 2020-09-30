package com.nicico.training.controller;


import com.fasterxml.jackson.core.type.TypeReference;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewClassDetailDTO;
import com.nicico.training.model.EvaluationAnalysis;
import com.nicico.training.service.EvaluationAnalysisService;
import com.nicico.training.service.ViewClassDetailService;
import lombok.RequiredArgsConstructor;
import org.activiti.engine.impl.util.json.JSONObject;
import org.apache.commons.lang3.StringUtils;
import org.springframework.http.*;
import org.springframework.http.converter.ByteArrayHttpMessageConverter;
import org.springframework.stereotype.Controller;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Arrays;
import java.util.List;

@RequiredArgsConstructor
@Controller
@RequestMapping("/evaluationAnalysis")
public class EvaluationAnalysisFormController {

    private final EvaluationAnalysisService evaluationAnalysisService;

    @RequestMapping("/show-form")
    public String showForm() {
        return "base/evaluationAnalysis";
    }

    @RequestMapping("/evaluationAnalysis-behavioralTab/show-form")
    public String behavioralTab() {
        return "evaluationAnalysis/evaluationAnalysist_behavioral";
    }

    @RequestMapping("/evaluationAnalysis-reactionTab/show-form")
    public String reactionTab() {
        return "evaluationAnalysis/evaluationAnalysist_reaction";
    }

    @RequestMapping("/evaluationAnalysis-learningTab")
    public String learningTab() {
        return "evaluationAnalysis/evaluationAnalysist_learning";
    }

    @PostMapping("/printReactionEvaluation")
    public ResponseEntity<?> printReactionEvaluation(final HttpServletRequest request) {
        String token = request.getParameter("token");
        JSONObject object = new JSONObject(request.getParameter("data"));
        final RestTemplate restTemplate = new RestTemplate();
        restTemplate.getMessageConverters().add(new ByteArrayHttpMessageConverter());

        final HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + token);

        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
        headers.setAccept(Arrays.asList(MediaType.APPLICATION_JSON));

        MultiValueMap<String, String> params = new LinkedMultiValueMap();
        params.add("code",object.get("tclassCode").toString());
        params.add("titleClass",object.get("courseTitleFa").toString());
        params.add("term",object.get("termTitleFa").toString());
        params.add("studentCount", object.get("tclassStudentsCount").toString());
        params.add("classStatus", object.get("tclassStatus").toString());
        params.add("teacher", object.get("teacherFullName").toString());

        params.add("numberOfExportedReactionEvaluationForms", object.get("numberOfExportedReactionEvaluationForms").toString());
        params.add("numberOfFilledReactionEvaluationForms", object.get("numberOfFilledReactionEvaluationForms").toString());
        params.add("numberOfInCompletedReactionEvaluationForms", object.get("numberOfInCompletedReactionEvaluationForms").toString());
        params.add("percenetOfFilledReactionEvaluationForms", object.get("percenetOfFilledReactionEvaluationForms").toString());

        if(!object.isNull("FERGrade"))
            params.add("FERGrade", object.get("FERGrade").toString());
        else
            params.add("FERGrade", "");
        if(!object.isNull("FETGrade"))
            params.add("FETGrade", object.get("FETGrade").toString());
        else
            params.add("FETGrade", "");
        if(!object.isNull("FECRGrade"))
            params.add("FECRGrade", object.get("FECRGrade").toString());
        else
            params.add("FECRGrade", "");
        if(!object.isNull("FERPass"))
            params.add("FERPass", object.get("FERPass").toString());
        else
            params.add("FERPass", "");
        if(!object.isNull("FETPass"))
            params.add("FETPass", object.get("FETPass").toString());
        else
            params.add("FETPass", "");
        if(!object.isNull("FECRPass"))
            params.add("FECRPass", object.get("FECRPass").toString());
        else
            params.add("FECRPass", "");
        if(!object.isNull("minScore_ER"))
            params.add("minScore_ER", object.get("minScore_ER").toString());
        else
            params.add("minScore_ER", "");
        if(!object.isNull("minScore_ET"))
            params.add("minScore_ET", object.get("minScore_ET").toString());
        else
            params.add("minScore_ET", "");
        if(!object.isNull("FERGrade"))
            params.add("differFER", "" + (Double.parseDouble(object.get("minScore_ER").toString())-Double.parseDouble(object.get("FERGrade").toString())) + "");
        else
            params.add("differFER", "");
        if(!object.isNull("FETGrade"))
            params.add("differFET", "" + (Double.parseDouble(object.get("minScore_ET").toString())-Double.parseDouble(object.get("FETGrade").toString())) + "");
        else
            params.add("differFET",  "");
        if(!object.isNull("teacherGradeToClass"))
            params.add("teacherGradeToClass", object.get("teacherGradeToClass").toString());
        else
            params.add("teacherGradeToClass", "");
        if(!object.isNull("studentsGradeToTeacher"))
            params.add("studentsGradeToTeacher", object.get("studentsGradeToTeacher").toString());
        else
            params.add("studentsGradeToTeacher", "");
        if(!object.isNull("studentsGradeToFacility"))
            params.add("studentsGradeToFacility", object.get("studentsGradeToFacility").toString());
        else
            params.add("studentsGradeToFacility", "");
        if(!object.isNull("studentsGradeToGoals"))
            params.add("studentsGradeToGoals", object.get("studentsGradeToGoals").toString());
        else
            params.add("studentsGradeToGoals","");
        if(!object.isNull("trainingGradeToTeacher"))
            params.add("trainingGradeToTeacher", object.get("trainingGradeToTeacher").toString());
        else
            params.add("trainingGradeToTeacher", "");
        HttpEntity<MultiValueMap<String, String>> entity = new HttpEntity<>(params, headers);

        String restApiUrl = request.getRequestURL().toString().replace(request.getServletPath(), "");

        return restTemplate.exchange(restApiUrl + "/api/evaluationAnalysis/printReactionEvaluation" , HttpMethod.POST, entity, byte[].class);
    }

    @PostMapping("/printBehavioralEvaluation")
    public ResponseEntity<?> printBehavioralEvaluation(final HttpServletRequest request) {
        String token = request.getParameter("token");
        JSONObject object = new JSONObject(request.getParameter("data"));
        final RestTemplate restTemplate = new RestTemplate();
        restTemplate.getMessageConverters().add(new ByteArrayHttpMessageConverter());

        final HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + token);

        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
        headers.setAccept(Arrays.asList(MediaType.APPLICATION_JSON));

        MultiValueMap<String, String> params = new LinkedMultiValueMap();
        params.add("code",object.get("code").toString());
        params.add("titleClass",object.get("titleClass").toString());
        params.add("term",object.getJSONObject("term").get("titleFa").toString());
        params.add("studentCount", object.get("studentCount").toString());
        params.add("teacher", object.get("teacher").toString());
        params.add("classPassedTime", object.get("classPassedTime").toString());
        params.add("numberOfFilledFormsBySuperviosers", object.get("numberOfFilledFormsBySuperviosers").toString());
        params.add("numberOfFilledFormsByStudents", object.get("numberOfFilledFormsByStudents").toString());
        params.add("studentsMeanGrade", object.get("studentsMeanGrade").toString());
        params.add("supervisorsMeanGrade", object.get("supervisorsMeanGrade").toString());
        params.add("FEBGrade", object.get("FEBGrade").toString());
        params.add("FEBPass", object.get("FEBPass").toString());
        params.add("FECBGrade", object.get("FECBGrade").toString());
        params.add("FECBPass", object.get("FECBPass").toString());


        HttpEntity<MultiValueMap<String, String>> entity = new HttpEntity<>(params, headers);

        String restApiUrl = request.getRequestURL().toString().replace(request.getServletPath(), "");

        return restTemplate.exchange(restApiUrl + "/api/evaluationAnalysis/printBehavioralEvaluation" , HttpMethod.POST, entity, byte[].class);
    }

    @PostMapping(value = {"/printBehavioralReport/{type}"})
    public void print(HttpServletResponse response,
                      @PathVariable String type,
                      @RequestParam(value = "fileName") String fileName,
                      @RequestParam(value = "ClassId") Long ClassId,
                      @RequestParam(value = "params") String Params,
                      @RequestParam(value = "suggestions") String suggestions,
                      @RequestParam(value = "opinion") String opinion
    ) throws Exception {
        evaluationAnalysisService.print(response, type, fileName, ClassId, Params, suggestions, opinion);
    }

    @PostMapping(value = "/evaluaationAnalysist-learningReport")
    public ResponseEntity<?> printLearningEvaluation(final HttpServletRequest request) {
        String token = (String) request.getParameter("token");
        String recordId=(String)request.getParameter("recordId");
        MultiValueMap<String, String> map = new LinkedMultiValueMap<String, String>();
        final RestTemplate restTemplate = new RestTemplate();
        restTemplate.getMessageConverters().add(new ByteArrayHttpMessageConverter());
        final HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + token);
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        map.add("recordId",recordId);
        map.add("Record",request.getParameter("record"));
        map.add("minScoreLearning",(String)request.getParameter("minScore"));
        HttpEntity<MultiValueMap<String, String>> entity = new HttpEntity<MultiValueMap<String, String>>(map,headers);
        String restApiUrl = request.getRequestURL().toString().replace(request.getServletPath(), "");
        return restTemplate.exchange(restApiUrl + "/api/evaluationAnalysis/printLearningEvaluation", HttpMethod.POST, entity, byte[].class);
    }


    @PostMapping("/printReactionEvaluationReport")
    public ResponseEntity<?> printReactionEvaluationReport(final HttpServletRequest request) {
        String token = request.getParameter("token");
        JSONObject object = new JSONObject(request.getParameter("data"));
        MultiValueMap<String, String> params = new LinkedMultiValueMap();
        final RestTemplate restTemplate = new RestTemplate();
        restTemplate.getMessageConverters().add(new ByteArrayHttpMessageConverter());

        final HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + token);

        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
        headers.setAccept(Arrays.asList(MediaType.APPLICATION_JSON));

        params.add("CriteriaStr", request.getParameter("CriteriaStr"));
        params.add("title", "");
        params.add("description", "");

        HttpEntity<MultiValueMap<String, String>> entity = new HttpEntity<>(params, headers);

        String restApiUrl = request.getRequestURL().toString().replace(request.getServletPath(), "");


        return restTemplate.exchange(restApiUrl + "/api/evaluationAnalysis/printReactionEvaluationReport" , HttpMethod.POST, entity, byte[].class);
    }
}
