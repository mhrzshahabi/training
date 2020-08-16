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
@RequestMapping("/polis_and_province")
public class PolisAndProvinceFormController {

    @RequestMapping(value = "/show-form")
    public String showForm(){
        return "base/polis_and_province";
    }

    @PostMapping(value = {"/{region}/printWithCriteria/{type}"})
    public ResponseEntity<?> printWithCriteria(final HttpServletRequest request,
                                               @PathVariable("region") String region,
                                               @PathVariable("type") String type){
        String token = request.getParameter("token");

        final RestTemplate restTemplate = new RestTemplate();
        restTemplate.getMessageConverters().add(new ByteArrayHttpMessageConverter());

        final HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + token);

        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        MultiValueMap<String,String> map = new LinkedMultiValueMap<>();
        map.add("CriteriaStr", request.getParameter("CriteriaStr"));

        HttpEntity<MultiValueMap<String, String>> entity = new HttpEntity<>(map, headers);

        String restApiUrl = request.getRequestURL().toString().replace(request.getServletPath(), "");
        type = type.toUpperCase();
        return restTemplate.exchange(restApiUrl + "/api/" + region + "/printWithCriteria/" + type,
                HttpMethod.POST,
                entity,
                byte[].class);
    }
}
