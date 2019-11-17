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
@RequestMapping("/post-group")
public class PostGroupFormController {
    @RequestMapping("/show-form")
    public String showForm() {
        return "base/post-group";
    }

    @RequestMapping("/print/{type}/{token}")
    public ResponseEntity<?> print(final HttpServletRequest request, @PathVariable String type, @PathVariable String token) {
        RestTemplate restTemplate = new RestTemplate();
        restTemplate.getMessageConverters().add(new ByteArrayHttpMessageConverter());
        final HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + token);
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
        String restApiUrl = request.getRequestURL().toString().replace(request.getServletPath(), "");
        HttpEntity<String> entity = new HttpEntity<String>(headers);
        if (type.equals("pdf"))
            return restTemplate.exchange(restApiUrl + "/api/post-group/print/pdf", HttpMethod.GET, entity, byte[].class);
        else if (type.equals("excel"))
            return restTemplate.exchange(restApiUrl + "/api/post-group/print/excel", HttpMethod.GET, entity, byte[].class);
        else if (type.equals("html"))
            return restTemplate.exchange(restApiUrl + "/api/post-group/print/html", HttpMethod.GET, entity, byte[].class);
        else
            return null;
    }


    @RequestMapping("/printDetail/{type}/{token}/{id}")
    public ResponseEntity<?> printDetail(final HttpServletRequest request, @PathVariable String type, @PathVariable String token, @PathVariable Long id) {
        RestTemplate restTemplate = new RestTemplate();
        restTemplate.getMessageConverters().add(new ByteArrayHttpMessageConverter());
        final HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + token);
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
        String restApiUrl = request.getRequestURL().toString().replace(request.getServletPath(), "");
        HttpEntity<String> entity = new HttpEntity<String>(headers);
        if (id == null) {
            if (type.equals("pdf"))
                return restTemplate.exchange(restApiUrl + "/api/post-group/print/pdf", HttpMethod.GET, entity, byte[].class);
            else if (type.equals("excel"))
                return restTemplate.exchange(restApiUrl + "/api/post-group/print/excel", HttpMethod.GET, entity, byte[].class);
            else if (type.equals("html"))
                return restTemplate.exchange(restApiUrl + "/api/post-group/print/html", HttpMethod.GET, entity, byte[].class);
            else
                return null;
        } else {
            if (type.equals("pdf"))
                return restTemplate.exchange(restApiUrl + "/api/post-group/printDetail/pdf/"+id, HttpMethod.GET, entity, byte[].class);
            else if (type.equals("excel"))
                return restTemplate.exchange(restApiUrl + "/api/post-group/printDetail/excel/"+id, HttpMethod.GET, entity, byte[].class);
            else if (type.equals("html"))
                return restTemplate.exchange(restApiUrl + "/api/post-group/printDetail/html/"+id, HttpMethod.GET, entity, byte[].class);
            else
                return null;
        }
    }


    @RequestMapping("/printSelected/{type}/{postGroupIds}")
    public ResponseEntity<?> printWithSelectedPostGroup(final HttpServletRequest request, @PathVariable String type, @PathVariable String postGroupIds) {


        String token = (String) request.getSession().getAttribute("AccessToken");

        RestTemplate restTemplate = new RestTemplate();
        restTemplate.getMessageConverters().add(new ByteArrayHttpMessageConverter());

        final HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + token);

        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        String restApiUrl = request.getRequestURL().toString().replace(request.getServletPath(), "");


        HttpEntity<String> entity = new HttpEntity<String>(headers);

        if (type.equals("pdf"))
            return restTemplate.exchange(restApiUrl + "/api/post-group/printSelected/pdf/" + postGroupIds, HttpMethod.GET, entity, byte[].class);
        else if (type.equals("excel"))
            return restTemplate.exchange(restApiUrl + "/api/post-group/printSelected/excel/" + postGroupIds, HttpMethod.GET, entity, byte[].class);
        else if (type.equals("html"))
            return restTemplate.exchange(restApiUrl + "/api/post-group/printSelected/html/" + postGroupIds, HttpMethod.GET, entity, byte[].class);
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
            return restTemplate.exchange(restApiUrl + "/api/post-group/printAll/pdf", HttpMethod.GET, entity, byte[].class);
        else if (type.equals("excel"))
            return restTemplate.exchange(restApiUrl + "/api/post-group/printAll/excel", HttpMethod.GET, entity, byte[].class);
        else if (type.equals("html"))
            return restTemplate.exchange(restApiUrl + "/api/post-group/printAll/html", HttpMethod.GET, entity, byte[].class);
        else
            return null;
    }
}
