package com.nicico.training.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.*;
import org.springframework.http.converter.ByteArrayHttpMessageConverter;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.client.RestTemplate;

import javax.servlet.http.HttpServletRequest;

@RequiredArgsConstructor
@Controller
@RequestMapping("/company")
public class CompanyFormController {
    @RequestMapping("/show-form")
    public String showForm() {
        return "base/company";
    }

    @RequestMapping("/printCompanyWithMember/{type}")
    public ResponseEntity<?> print(final HttpServletRequest request, @PathVariable String type) {
        String token = (String) request.getSession().getAttribute("accessToken");
        RestTemplate restTemplate = new RestTemplate();
        restTemplate.getMessageConverters().add(new ByteArrayHttpMessageConverter());
        final HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + token);
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
        String restApiUrl = request.getRequestURL().toString().replace(request.getServletPath(), "");
        HttpEntity<String> entity = new HttpEntity<String>(headers);
        if (type.equals("pdf"))
            return restTemplate.exchange(restApiUrl + "/api/committee/printCompanyWithMember/PDF", HttpMethod.GET, entity, byte[].class);
        else if (type.equals("excel"))
            return restTemplate.exchange(restApiUrl + "/api/committee/printCompanyWithMember/EXCEL", HttpMethod.GET, entity, byte[].class);
        else if (type.equals("html"))
            return restTemplate.exchange(restApiUrl + "/api/committee/printCompanyWithMember/HTML", HttpMethod.GET, entity, byte[].class);
        else
            return null;
    }


}
