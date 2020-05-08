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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;
import javax.servlet.http.HttpServletRequest;
@RequiredArgsConstructor
@Controller
@RequestMapping("/evaluationAnalysist-learning")
public class EvaluationAnalysistLearningFormController {

    @RequestMapping("/evaluationAnalysis-learningTab")
    public String learningTab() {
        return "evaluationAnalysis/evaluationAnalysist_learning";
    }

    @PostMapping(value = "/evaluaationAnalysist-learningReport")
    public ResponseEntity<?> printWithCriteri(final HttpServletRequest request) {
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
        return restTemplate.exchange(restApiUrl + "/api/evaluationAnalysist-learning-Rest/print", HttpMethod.POST, entity, byte[].class);

    }
}
