package com.nicico.training.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.http.*;
import org.springframework.http.converter.ByteArrayHttpMessageConverter;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.client.RestTemplate;
import javax.servlet.http.HttpServletRequest;
@RequiredArgsConstructor
@Controller
@RequestMapping("/unjustifiedAbsenceReport")
public class unjustifiedAbsenceReportFormController {

    @RequestMapping("/show-form")
    public String showForm() {
        return "base/unjustifiedAbsenceReport";
    }

    @PostMapping("/unjustifiedAbsence/{startDate}/{endDate}")
    public ResponseEntity<?> printWithCriteria(final HttpServletRequest request, @PathVariable String startDate, @PathVariable String endDate) {
        String token = (String) request.getParameter("token");
        final RestTemplate restTemplate = new RestTemplate();
        restTemplate.getMessageConverters().add(new ByteArrayHttpMessageConverter());
        final HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + token);
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
        MultiValueMap<String, String> map = new LinkedMultiValueMap<String, String>();
        map.add("startDate",startDate);
        map.add("endDate",endDate);
        HttpEntity<MultiValueMap<String, String>> entity = new HttpEntity<MultiValueMap<String, String>>(map, headers);
        String restApiUrl = request.getRequestURL().toString().replace(request.getServletPath(), "");
        return restTemplate.exchange(restApiUrl + "/api/unjustifiedAbsenceReport/print", HttpMethod.POST, entity, byte[].class);

    }
}
