package com.nicico.training.controller;


import lombok.RequiredArgsConstructor;
import org.springframework.http.*;
import org.springframework.http.converter.ByteArrayHttpMessageConverter;
import org.springframework.stereotype.Controller;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.client.RestTemplate;

import javax.servlet.http.HttpServletRequest;

@RequiredArgsConstructor
@Controller
@RequestMapping("/evaluation")
public class EvaluationFormController {

    @RequestMapping("/show-form")
    public String showForm() {
        return "base/evaluation";
    }

    @PostMapping("/printWithCriteria/{type}/{classId}/{courseId}/{studentId}")
    public ResponseEntity<?> printWithCriteria(final HttpServletRequest request, @PathVariable String type, @PathVariable Long classId, @PathVariable Long courseId, @PathVariable Long studentId) {
        //String token = (String) request.getSession().getAttribute(ConstantVARs.ACCESS_TOKEN);
        String token = request.getParameter("myToken");

        final RestTemplate restTemplate = new RestTemplate();
        restTemplate.getMessageConverters().add(new ByteArrayHttpMessageConverter());

        final HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + token);

        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        MultiValueMap<String, String> map = new LinkedMultiValueMap<String, String>();
        map.add("CriteriaStr", request.getParameter("CriteriaStr"));

        HttpEntity<MultiValueMap<String, String>> entity = new HttpEntity<>(map, headers);

        String restApiUrl = request.getRequestURL().toString().replace(request.getServletPath(), "");

        if (type.equals("pdf"))
            return restTemplate.exchange(restApiUrl + "/api/evaluation/PDF/" + classId + "/" + courseId + "/" + studentId, HttpMethod.POST, entity, byte[].class);
        else if (type.equals("excel"))
            return restTemplate.exchange(restApiUrl + "/api/evaluation/printWithCriteria/EXCEL", HttpMethod.POST, entity, byte[].class);
        else if (type.equals("html"))
            return restTemplate.exchange(restApiUrl + "/api/evaluation/printWithCriteria/HTML", HttpMethod.POST, entity, byte[].class);
        else
            return null;
    }

    @RequestMapping("/reaction-form")
    public String loadPageReaction() {
        return "evaluation/reaction";
    }

    @RequestMapping("/learning-form")
    public String loadPageLearning() {
        return "evaluation/learning";
    }

    @RequestMapping("/behavioral-form")
    public String loadPageBehavioral() {
        return "evaluation/behavioral";
    }

    @RequestMapping("/results-form")
    public String loadPageResults() {
        return "evaluation/results";
    }

}
