package com.nicico.training.controller;

/* com.nicico.training.controller.masterData
@Author:jafari-h
@Date:6/9/2019
@Time:7:58 AM
*/
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.ByteArrayHttpMessageConverter;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClient;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClientService;
import org.springframework.security.oauth2.client.authentication.OAuth2AuthenticationToken;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.client.RestTemplate;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@RequiredArgsConstructor
@Controller
@RequestMapping("/goal")
public class GoalFormController {
    private final OAuth2AuthorizedClientService authorizedClientService;
    @Value("${nicico.rest-api.url}")
    private String restApiUrl;

    @RequestMapping("/show-form")
    public String showForm(HttpServletRequest req, HttpServletResponse rsp) {
        String courseId = req.getParameter("courseId");
        req.setAttribute("courseId",courseId);
        return "base/goal";
    }

    @RequestMapping("/print-all/{type}")
    public ResponseEntity<?> printAll(Authentication authentication, @PathVariable String type) {
        String token = "";
        if (authentication instanceof OAuth2AuthenticationToken) {
            OAuth2AuthorizedClient client = authorizedClientService
                    .loadAuthorizedClient(
                            ((OAuth2AuthenticationToken) authentication).getAuthorizedClientRegistrationId(),
                            authentication.getName());
            token = client.getAccessToken().getTokenValue();
        }

        RestTemplate restTemplate = new RestTemplate();
        restTemplate.getMessageConverters().add(new ByteArrayHttpMessageConverter());

        HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + token);

        HttpEntity<String> entity = new HttpEntity<String>(headers);

        if(type.equals("pdf"))
            return restTemplate.exchange(restApiUrl + "/api/goal/print-all/pdf", HttpMethod.GET, entity, byte[].class);
        else if(type.equals("excel"))
            return restTemplate.exchange(restApiUrl + "/api/goal/print-all/excel", HttpMethod.GET, entity, byte[].class);
        else if(type.equals("html"))
            return restTemplate.exchange(restApiUrl + "/api/goal/print-all/html", HttpMethod.GET, entity, byte[].class);
        else
            return null;
    }
    @RequestMapping("/print-one-course/{courseId}/{type}")
    public ResponseEntity<?> printOneCourse(Authentication authentication, @PathVariable String type, @PathVariable Long courseId) {
        String token = "";
        if (authentication instanceof OAuth2AuthenticationToken) {
            OAuth2AuthorizedClient client = authorizedClientService
                    .loadAuthorizedClient(
                            ((OAuth2AuthenticationToken) authentication).getAuthorizedClientRegistrationId(),
                            authentication.getName());
            token = client.getAccessToken().getTokenValue();
        }

        RestTemplate restTemplate = new RestTemplate();
        restTemplate.getMessageConverters().add(new ByteArrayHttpMessageConverter());

        HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + token);

        HttpEntity<String> entity = new HttpEntity<String>(headers);

        if(type.equals("pdf"))
            return restTemplate.exchange(restApiUrl + "/api/goal/print-one-course/"+courseId+"/pdf", HttpMethod.GET, entity, byte[].class);
        else if(type.equals("excel"))
            return restTemplate.exchange(restApiUrl + "/api/goal/print-one-course/"+courseId+"/excel", HttpMethod.GET, entity, byte[].class);
        else if(type.equals("html"))
            return restTemplate.exchange(restApiUrl + "/api/goal/print-one-course/"+courseId+"/html", HttpMethod.GET, entity, byte[].class);
        else
            return null;
    }
}
