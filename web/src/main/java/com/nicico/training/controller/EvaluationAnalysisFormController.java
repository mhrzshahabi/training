package com.nicico.training.controller;


import jdk.nashorn.internal.parser.JSONParser;
import lombok.RequiredArgsConstructor;
import org.activiti.engine.impl.util.json.JSONObject;
import org.springframework.http.*;
import org.springframework.http.converter.ByteArrayHttpMessageConverter;
import org.springframework.stereotype.Controller;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.client.RestTemplate;

import javax.servlet.http.HttpServletRequest;
import java.util.LinkedHashMap;

@RequiredArgsConstructor
@Controller
@RequestMapping("/evaluationAnalysis")
public class EvaluationAnalysisFormController {

    @RequestMapping("/show-form")
    public String showForm() {
        return "base/evaluationAnalysis";
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

        MultiValueMap<String, String> map = new LinkedMultiValueMap<>();

        HttpEntity<MultiValueMap<String, String>> entity = new HttpEntity<>(map, headers);

        String restApiUrl = request.getRequestURL().toString().replace(request.getServletPath(), "");
        return restTemplate.exchange(restApiUrl + "/api/evaluationAnalysis/printReactionEvaluation" , HttpMethod.POST, entity, byte[].class);
    }

}
