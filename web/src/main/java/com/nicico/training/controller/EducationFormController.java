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
@RequestMapping("/education")
public class EducationFormController {

    @RequestMapping(value = "/show-form")
    public String showForm() {
        return "base/education";
    }

    @RequestMapping("/print-one-course/{courseId}/{type}/{token}")
    public ResponseEntity<?> printOneCourse(final HttpServletRequest request, @PathVariable String type, @PathVariable Long id, @PathVariable String token) {
//        String token = (String) request.getSession().getAttribute("AccessToken");

        RestTemplate restTemplate = new RestTemplate();
        restTemplate.getMessageConverters().add(new ByteArrayHttpMessageConverter());

        HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + token);

        HttpEntity<String> entity = new HttpEntity<String>(headers);

        String restApiUrl = request.getRequestURL().toString().replace(request.getServletPath(), "");


        if (type.equals("pdf"))
            return restTemplate.exchange(restApiUrl + "/api/goal/print-one-course/" + id + "/pdf", HttpMethod.GET, entity, byte[].class);
        else if (type.equals("excel"))
            return restTemplate.exchange(restApiUrl + "/api/goal/print-one-course/" + id + "/excel", HttpMethod.GET, entity, byte[].class);
        else if (type.equals("html"))
            return restTemplate.exchange(restApiUrl + "/api/goal/print-one-course/" + id + "/html", HttpMethod.GET, entity, byte[].class);
        else
            return null;
    }
}
