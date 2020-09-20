package com.nicico.training.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.http.converter.ByteArrayHttpMessageConverter;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClientService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.client.RestTemplate;

import javax.servlet.http.HttpServletRequest;

@RequiredArgsConstructor
@Controller
@RequestMapping("/skill-group")
public class SkillGroupFormController {


    private final OAuth2AuthorizedClientService authorizedClientService;

    //@Value("${nicico.rest-api.url}")
//	private String restApiUrl;

    @RequestMapping("/show-form")
    public String showForm() {
        return "base/skill-group";
    }

    @RequestMapping("/print/{type}")
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
            return restTemplate.exchange(restApiUrl + "/api/skill-group/print/pdf", HttpMethod.GET, entity, byte[].class);
        else if (type.equals("excel"))
            return restTemplate.exchange(restApiUrl + "/api/skill-group/print/excel", HttpMethod.GET, entity, byte[].class);
        else if (type.equals("html"))
            return restTemplate.exchange(restApiUrl + "/api/skill-group/print/html", HttpMethod.GET, entity, byte[].class);
        else
            return null;
    }


    @RequestMapping("/printSelected/{type}/{skillGroupIds}")
    public ResponseEntity<?> printWithSelectedSkillGroup(final HttpServletRequest request, @PathVariable String type, @PathVariable String skillGroupIds) {


        String token = (String) request.getSession().getAttribute("AccessToken");

        RestTemplate restTemplate = new RestTemplate();
        restTemplate.getMessageConverters().add(new ByteArrayHttpMessageConverter());

        final HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + token);

        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        String restApiUrl = request.getRequestURL().toString().replace(request.getServletPath(), "");


        HttpEntity<String> entity = new HttpEntity<String>(headers);

        if (type.equals("pdf"))
            return restTemplate.exchange(restApiUrl + "/api/skill-group/printSelected/pdf/" + skillGroupIds, HttpMethod.GET, entity, byte[].class);
        else if (type.equals("excel"))
            return restTemplate.exchange(restApiUrl + "/api/skill-group/printSelected/excel/" + skillGroupIds, HttpMethod.GET, entity, byte[].class);
        else if (type.equals("html"))
            return restTemplate.exchange(restApiUrl + "/api/skill-group/printSelected/html/" + skillGroupIds, HttpMethod.GET, entity, byte[].class);
        else
            return null;
    }


    @RequestMapping("/printAll/{type}")
    public ResponseEntity<?> printAll(final HttpServletRequest request, @PathVariable String type) {
        String token = (String) request.getSession().getAttribute("AccessToken");

        RestTemplate restTemplate = new RestTemplate();
        restTemplate.getMessageConverters().add(new ByteArrayHttpMessageConverter());

        final HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + token);

        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        String restApiUrl = request.getRequestURL().toString().replace(request.getServletPath(), "");


        HttpEntity<String> entity = new HttpEntity<String>(headers);

        if (type.equals("pdf"))
            return restTemplate.exchange(restApiUrl + "/api/skill-group/printAll/pdf", HttpMethod.GET, entity, byte[].class);
        else if (type.equals("excel"))
            return restTemplate.exchange(restApiUrl + "/api/skill-group/printAll/excel", HttpMethod.GET, entity, byte[].class);
        else if (type.equals("html"))
            return restTemplate.exchange(restApiUrl + "/api/skill-group/printAll/html", HttpMethod.GET, entity, byte[].class);
        else
            return null;
    }


//	@RequestMapping("/show-form")
//	public String showForm() {
//		return "base/skill-group";
//
//	}
}
