package com.nicico.training.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClientService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.client.RestTemplate;

import javax.servlet.http.HttpServletRequest;
import java.util.Base64;

@RequiredArgsConstructor
@Controller
@RequestMapping("/personalInfo")
public class PersonalInfoFormController {
    private final OAuth2AuthorizedClientService authorizedClientService;

    @GetMapping(value = {"/getTempAttach/{fileName}"})
    public String getTempAttach(ModelMap modelMap, final HttpServletRequest httpServletRequest, @PathVariable String fileName) {
        String token = (String) httpServletRequest.getSession().getAttribute("AccessToken");
        String restApiUrl = httpServletRequest.getRequestURL().toString().replace(httpServletRequest.getServletPath(), "");

        HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + token);

        MultiValueMap<String, String> map = new LinkedMultiValueMap<String, String>();

        HttpEntity<MultiValueMap<String, String>> entity = new HttpEntity<MultiValueMap<String, String>>(map, headers);

        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity<byte[]> personImg = restTemplate.exchange(restApiUrl + "/api/personalInfo/getTempAttach/" + fileName, HttpMethod.GET, entity, byte[].class);
        modelMap.addAttribute("personImg", Base64.getEncoder().encodeToString(personImg.getBody()));

        return "base/personImage";
    }


    @GetMapping(value = {"/getAttach/{Id}"})
    public String getAttach(ModelMap modelMap, final HttpServletRequest httpServletRequest, @PathVariable Long Id) {
        String token = (String) httpServletRequest.getSession().getAttribute("AccessToken");
        String restApiUrl = httpServletRequest.getRequestURL().toString().replace(httpServletRequest.getServletPath(), "");

        HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + token);

        RestTemplate restTemplate = new RestTemplate();
        MultiValueMap<String, String> map = new LinkedMultiValueMap<String, String>();
        HttpEntity<MultiValueMap<String, String>> entity = new HttpEntity<MultiValueMap<String, String>>(map, headers);
        ResponseEntity<byte[]> personImg = restTemplate.exchange(restApiUrl + "/api/personalInfo/getAttach/" + Id, HttpMethod.GET, entity, byte[].class);
        modelMap.addAttribute("personImg", Base64.getEncoder().encodeToString(personImg.getBody()));

        return "base/personImage";
    }

}
