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

    @PostMapping("/printWithCriteria")
    public ResponseEntity<?> printWithCriteria(final HttpServletRequest request) {

        String token = request.getParameter("myToken");

        final RestTemplate restTemplate = new RestTemplate();
        restTemplate.getMessageConverters().add(new ByteArrayHttpMessageConverter());

        final HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + token);

        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        MultiValueMap<String, String> map = new LinkedMultiValueMap<String, String>();
        map.add("printData", request.getParameter("printData"));

        HttpEntity<MultiValueMap<String, String>> entity = new HttpEntity<>(map, headers);

        String restApiUrl = request.getRequestURL().toString().replace(request.getServletPath(), "");

        return restTemplate.exchange(restApiUrl + "/api/evaluation/printWithCriteria", HttpMethod.POST, entity, byte[].class);
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

    @RequestMapping("/reaction-evaluation-form")
    public String loadPageReactionEvaluation() {
        return "evaluation/reactionEvaluation";
    }

    @RequestMapping("/behavioral-evaluation-form")
    public String loadPageBehavioralEvaluation() {
        return "evaluation/behavioralEvaluation";
    }

    @RequestMapping("/edit-goal-questions-form")
    public String loadPageEditGoalQuestions() {
        return "evaluation/editGoalQuestions";
    }

    @PostMapping("/printEvaluationForm")
    public ResponseEntity<?> printEvaluationForm(final HttpServletRequest request) {

        String token = request.getParameter("token");

        final RestTemplate restTemplate = new RestTemplate();
        restTemplate.getMessageConverters().add(new ByteArrayHttpMessageConverter());

        final HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + token);

        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        MultiValueMap<String, String> map = new LinkedMultiValueMap<String, String>();

        map.add("data", request.getParameter("data"));

        HttpEntity<MultiValueMap<String, String>> entity = new HttpEntity<>(map, headers);

        String restApiUrl = request.getRequestURL().toString().replace(request.getServletPath(), "");

        return restTemplate.exchange(restApiUrl + "/api/evaluation/printEvaluationForm" , HttpMethod.POST, entity, byte[].class);
    }

}
