package com.nicico.training.controller;


import lombok.RequiredArgsConstructor;
import org.activiti.engine.impl.util.json.JSONObject;
import org.springframework.http.*;
import org.springframework.http.converter.ByteArrayHttpMessageConverter;
import org.springframework.stereotype.Controller;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.client.RestTemplate;

import javax.servlet.http.HttpServletRequest;
import java.util.Arrays;

@RequiredArgsConstructor
@Controller
@RequestMapping("/evaluationAnalysis")
public class EvaluationAnalysisFormController {

    @RequestMapping("/show-form")
    public String showForm() {
        return "base/evaluationAnalysis";
    }

    @RequestMapping("/evaluationAnalysis-behavioralTab/show-form")
    public String behavioralTab() {
        return "evaluationAnalysis/evaluationAnalysist_behavioral";
    }

    @PostMapping("/printReactionEvaluation")
    public ResponseEntity<?> printWithDetail(final HttpServletRequest request) {
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
        params.add("classStatus", object.get("classStatus").toString());
        params.add("teacher", object.get("teacher").toString());

        params.add("numberOfExportedReactionEvaluationForms", object.get("numberOfExportedReactionEvaluationForms").toString());
        params.add("numberOfFilledReactionEvaluationForms", object.get("numberOfFilledReactionEvaluationForms").toString());
        params.add("numberOfInCompletedReactionEvaluationForms", object.get("numberOfInCompletedReactionEvaluationForms").toString());
        params.add("percenetOfFilledReactionEvaluationForms", object.get("percenetOfFilledReactionEvaluationForms").toString());

        params.add("FERGrade", object.get("FERGrade").toString());
        params.add("FETGrade", object.get("FETGrade").toString());
        params.add("FECRGrade", object.get("FECRGrade").toString());

        params.add("FERPass", object.get("FERPass").toString());
        params.add("FETPass", object.get("FETPass").toString());
        params.add("FECRPass", object.get("FECRPass").toString());

        params.add("minScore_ER", object.get("minScore_ER").toString());
        params.add("minScore_ET", object.get("minScore_ET").toString());

        params.add("differFER", "" + (Double.parseDouble(object.get("minScore_ER").toString())-Double.parseDouble(object.get("FERGrade").toString())) + "");
        params.add("differFET", "" + (Double.parseDouble(object.get("minScore_ET").toString())-Double.parseDouble(object.get("FETGrade").toString())) + "");

        params.add("teacherGradeToClass", object.get("teacherGradeToClass").toString());
        params.add("studentsGradeToTeacher", object.get("studentsGradeToTeacher").toString());
        params.add("studentsGradeToFacility", object.get("studentsGradeToFacility").toString());
        params.add("studentsGradeToGoals", object.get("studentsGradeToGoals").toString());
        params.add("trainingGradeToTeacher", object.get("trainingGradeToTeacher").toString());

        HttpEntity<MultiValueMap<String, String>> entity = new HttpEntity<>(params, headers);

        String restApiUrl = request.getRequestURL().toString().replace(request.getServletPath(), "");

        return restTemplate.exchange(restApiUrl + "/api/evaluationAnalysis/printReactionEvaluation" , HttpMethod.POST, entity, byte[].class);
    }
}
