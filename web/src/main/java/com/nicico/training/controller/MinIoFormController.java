package com.nicico.training.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.client.RestTemplate;

import javax.servlet.http.HttpServletRequest;

@RequiredArgsConstructor
@Controller
@RequestMapping("/minIo")
public class MinIoFormController {

    @GetMapping(value = {"/downloadFile/{groupId}/{key}/{fileName}"})
    public ResponseEntity<byte[]> downloadFile(HttpServletRequest request, @PathVariable String groupId, @PathVariable String key, @PathVariable String fileName) {
        String token = request.getParameter("token");

        String restApiUrl = request.getRequestURL().toString().replace(request.getServletPath(), "");

        HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + token);

        RestTemplate restTemplate = new RestTemplate();
        MultiValueMap<String, String> map = new LinkedMultiValueMap<>();
        HttpEntity<MultiValueMap<String, String>> entity = new HttpEntity<>(map, headers);
        return restTemplate.exchange(restApiUrl + "/api/minIo/downloadFile/" + groupId + "/" + key + "/" + fileName, HttpMethod.GET, entity, byte[].class);
    }

}
