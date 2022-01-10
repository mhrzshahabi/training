package com.nicico.training.controller;

/* com.nicico.training.controller.client.masterData
@Author:jafari-h
@Date:6/9/2019
@Time:7:58 AM
*/

import lombok.RequiredArgsConstructor;
import org.springframework.http.*;
import org.springframework.http.converter.ByteArrayHttpMessageConverter;
import org.springframework.stereotype.Controller;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.client.RestTemplate;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@RequiredArgsConstructor
@Controller
@RequestMapping("/goal")
public class GoalFormController {
//    private final OAuth2AuthorizedClientService authorizedClientService;

    @RequestMapping("/show-form")
    public String showForm(HttpServletRequest req, HttpServletResponse rsp) {
//        String courseId = req.getParameter("courseId");
//        req.setAttribute("courseId",courseId);
        return "base/goal";
    }

    @RequestMapping("/print-all/{type}")
    public ResponseEntity<?> printAll(final HttpServletRequest request, @PathVariable String type) {
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
            return restTemplate.exchange(restApiUrl + "/api/goal/print-all/pdf", HttpMethod.GET, entity, byte[].class);
        else if (type.equals("excel"))
            return restTemplate.exchange(restApiUrl + "/api/goal/print-all/excel", HttpMethod.GET, entity, byte[].class);
        else if (type.equals("html"))
            return restTemplate.exchange(restApiUrl + "/api/goal/print-all/html", HttpMethod.GET, entity, byte[].class);
        else
            return null;
    }

    @RequestMapping("/print-one-course/{courseId}/{type}")
    public ResponseEntity<?> printOneCourse(final HttpServletRequest request, @PathVariable String type, @PathVariable Long courseId) {
        String token = request.getParameter("token");


        RestTemplate restTemplate = new RestTemplate();
        restTemplate.getMessageConverters().add(new ByteArrayHttpMessageConverter());

        HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + token);

        HttpEntity<String> entity = new HttpEntity<String>(headers);

        String restApiUrl = request.getRequestURL().toString().replace(request.getServletPath(), "");


        if (type.equals("pdf"))
            return restTemplate.exchange(restApiUrl + "/api/goal/print-one-course/" + courseId + "/pdf", HttpMethod.GET, entity, byte[].class);
        else if (type.equals("excel"))
            return restTemplate.exchange(restApiUrl + "/api/goal/print-one-course/" + courseId + "/excel", HttpMethod.GET, entity, byte[].class);
        else if (type.equals("html"))
            return restTemplate.exchange(restApiUrl + "/api/goal/print-one-course/" + courseId + "/html", HttpMethod.GET, entity, byte[].class);
        else
            return null;
    }
}
