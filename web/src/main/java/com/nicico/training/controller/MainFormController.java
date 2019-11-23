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

@Controller
@RequestMapping("/web")
@RequiredArgsConstructor
public class MainFormController {

    @RequestMapping("/job")
    public String showJobForm() {
        return "base/job";
    }

    @RequestMapping("/postGrade")
    public String showPostGradeForm() {
        return "base/postGrade";
    }

    @RequestMapping("/post")
    public String showPostForm() {
        return "base/post";
    }

    @RequestMapping("/post-group")
    public String showPostGroupForm() {
        return "base/post-group";
    }

    @RequestMapping("/competence")
    public String showCompetenceForm() {
        return "base/competence";
    }

    @RequestMapping("/needAssessment")
    public String showNeedAssessmentForm() {
        return "base/needAssessmentNew1";
    }

    @RequestMapping("/postGradeGroup")
    public String showPostGradeGroupForm() {
        return "base/postGradeGroup";
    }

    @RequestMapping("/needAssessmentSkillBased")
    public String showNeedAssessmentSkillBasedForm() {
        return "base/needAssessmentSkillBased";
    }

    @PostMapping("/post/print_list")
    public ResponseEntity<?> printList(final HttpServletRequest request, @PathVariable String type) {
        String token = request.getParameter("myToken");

        final RestTemplate restTemplate = new RestTemplate();
        restTemplate.getMessageConverters().add(new ByteArrayHttpMessageConverter());

        final HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + token);

        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        MultiValueMap<String, String> map = new LinkedMultiValueMap<String, String>();
        map.add("CriteriaStr", request.getParameter("CriteriaStr"));

        HttpEntity<MultiValueMap<String, String>> entity = new HttpEntity<>(map, headers);

        String restApiUrl = request.getRequestURL().toString().replace(request.getServletPath(),"");

        if(type.equals("pdf"))
            return restTemplate.exchange(restApiUrl + "/api/post/print_list/PDF", HttpMethod.POST, entity, byte[].class);
        else if(type.equals("excel"))
            return restTemplate.exchange(restApiUrl + "/api/post/print_list/EXCEL", HttpMethod.POST, entity, byte[].class);
        else if(type.equals("html"))
            return restTemplate.exchange(restApiUrl + "/api/post/print_list/HTML", HttpMethod.POST, entity, byte[].class);
        else
            return null;
    }

}
