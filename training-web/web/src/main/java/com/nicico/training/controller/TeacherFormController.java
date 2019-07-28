package com.nicico.training.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.*;
import org.springframework.http.converter.ByteArrayHttpMessageConverter;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClient;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClientService;
import org.springframework.security.oauth2.client.authentication.OAuth2AuthenticationToken;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Base64;

@RequiredArgsConstructor
@Controller
@RequestMapping("/teacher")
public class TeacherFormController {
	private final OAuth2AuthorizedClientService authorizedClientService;

	@Value("${nicico.rest-api.url}")
	private String restApiUrl;

	@RequestMapping("/show-form")
	public String showForm() {
		return "base/teacher";
	}

   	@GetMapping(value = {"/getTempAttach/{fileName}"})
	public String getTempAttach(ModelMap modelMap, Authentication authentication,@PathVariable String fileName) {
		String token = "";
		if (authentication instanceof OAuth2AuthenticationToken) {
			OAuth2AuthorizedClient client = authorizedClientService
					.loadAuthorizedClient(
							((OAuth2AuthenticationToken) authentication).getAuthorizedClientRegistrationId(),
							authentication.getName());
			token = client.getAccessToken().getTokenValue();
		}
        HttpHeaders headers = new HttpHeaders();
		headers.add("Authorization", "Bearer " + token);
        HttpEntity<String> request = new HttpEntity<String>(headers);

        RestTemplate restTemplate = new RestTemplate();
		ResponseEntity<byte[]> teacherImg = restTemplate.exchange(restApiUrl + "/api/teacher/getTempAttach/"+fileName , HttpMethod.GET, request, byte[].class);
		modelMap.addAttribute("teacherImg", Base64.getEncoder().encodeToString(teacherImg.getBody()));

        return "base/teacherImage";
    }


   	@GetMapping(value = {"/getAttach/{Id}"})
	public String getAttach(ModelMap modelMap, Authentication authentication,@PathVariable Long Id) {
		String token = "";
		if (authentication instanceof OAuth2AuthenticationToken) {
			OAuth2AuthorizedClient client = authorizedClientService
					.loadAuthorizedClient(
							((OAuth2AuthenticationToken) authentication).getAuthorizedClientRegistrationId(),
							authentication.getName());
			token = client.getAccessToken().getTokenValue();
		}
        HttpHeaders headers = new HttpHeaders();
		headers.add("Authorization", "Bearer " + token);
        HttpEntity<String> request = new HttpEntity<String>(headers);

        RestTemplate restTemplate = new RestTemplate();
		ResponseEntity<byte[]> teacherImg = restTemplate.exchange(restApiUrl + "/api/teacher/getAttach/"+Id , HttpMethod.GET, request, byte[].class);
		modelMap.addAttribute("teacherImg", Base64.getEncoder().encodeToString(teacherImg.getBody()));

        return "base/teacherImage";
    }


    @PostMapping("/printWithCriteria/{type}")
	public ResponseEntity<?> printWithCriteria(final HttpServletRequest request,@PathVariable String type) {
		String token = (String) request.getSession().getAttribute("token");

		final RestTemplate restTemplate = new RestTemplate();
		restTemplate.getMessageConverters().add(new ByteArrayHttpMessageConverter());

		final HttpHeaders headers = new HttpHeaders();
		headers.add("Authorization", "Bearer " + token);

		headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

		MultiValueMap<String, String> map = new LinkedMultiValueMap<String, String>();
		map.add("CriteriaStr", request.getParameter("CriteriaStr"));

		HttpEntity<MultiValueMap<String, String>> entity = new HttpEntity<MultiValueMap<String, String>>(map, headers);

		if(type.equals("pdf"))
			return restTemplate.exchange(restApiUrl + "/api/teacher/printWithCriteria/PDF", HttpMethod.POST, entity, byte[].class);
		else if(type.equals("excel"))
			return restTemplate.exchange(restApiUrl + "/api/teacher/printWithCriteria/EXCEL", HttpMethod.POST, entity, byte[].class);
		else if(type.equals("html"))
			return restTemplate.exchange(restApiUrl + "/api/teacher/printWithCriteria/HTML", HttpMethod.POST, entity, byte[].class);
		else
			return null;
	}

}
