package com.nicico.training.controller;/*
com.nicico.training.controller.client.masterData
@author : banifatemi
@Date : 6/11/2019
@Time :10:47 AM
    */

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.http.converter.ByteArrayHttpMessageConverter;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClientService;
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
@RequestMapping("/skill")

public class SkillFormController {

    private final OAuth2AuthorizedClientService authorizedClientService;

    @Value("${nicico.rest-api.url}")
    private String restApiUrl;

    @RequestMapping("/show-form")
    public String showForm() {
        return "base/skill";
    }


   // @RequestMapping("/print-all/{type}")
    public ResponseEntity<?> print(final HttpServletRequest request, @PathVariable String type) {


        String token = (String) request.getSession().getAttribute("AccessToken");

        RestTemplate restTemplate = new RestTemplate();
        restTemplate.getMessageConverters().add(new ByteArrayHttpMessageConverter());

        final HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + token);

        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        String restApiUrl = request.getRequestURL().toString().replace(request.getServletPath(), "");


        HttpEntity<String> entity = new HttpEntity<String>(headers);

        if (type.equals("pdf"))
            return restTemplate.exchange(restApiUrl + "/api/skill/print-all/pdf", HttpMethod.GET, entity, byte[].class);
        else if (type.equals("excel"))
            return restTemplate.exchange(restApiUrl + "/api/skill/print-all/excel", HttpMethod.GET, entity, byte[].class);
        else if (type.equals("html"))
            return restTemplate.exchange(restApiUrl + "/api/skill/print-all/html", HttpMethod.GET, entity, byte[].class);
        else
            return null;
    }

    @PostMapping("/print-all/{type}")
    public ResponseEntity<?> printWithCriteria(final HttpServletRequest request, @PathVariable String type) {
        String token = (String) request.getParameter("token");
        final RestTemplate restTemplate = new RestTemplate();
        restTemplate.getMessageConverters().add(new ByteArrayHttpMessageConverter());
        final HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + token);
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
        MultiValueMap<String, String> map = new LinkedMultiValueMap<String, String>();
        map.add("CriteriaStr", request.getParameter("CriteriaStr"));
        map.add("_sortBy", request.getParameter("sortBy"));
        HttpEntity<MultiValueMap<String, String>> entity = new HttpEntity<MultiValueMap<String, String>>(map, headers);
        String restApiUrl = request.getRequestURL().toString().replace(request.getServletPath(), "");
        if (type.equals("pdf"))
            return restTemplate.exchange(restApiUrl + "/api/skill/print-all/pdf",HttpMethod.POST, entity, byte[].class);
        else if (type.equals("excel"))
            return restTemplate.exchange(restApiUrl + "/api/skill/print-all/excel",HttpMethod.POST, entity, byte[].class);
        else if (type.equals("html"))
            return restTemplate.exchange(restApiUrl + "/api/skill/print-all/html",HttpMethod.POST, entity, byte[].class);
        else
            return null;
    }
}
