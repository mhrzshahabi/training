package com.nicico.training.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.http.converter.ByteArrayHttpMessageConverter;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClientService;
import org.springframework.stereotype.Controller;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.client.RestTemplate;

import javax.servlet.http.HttpServletRequest;

@RequiredArgsConstructor
@Controller
@RequestMapping("/term")
public class TermFormController {

private final OAuth2AuthorizedClientService authorizedClientService;



	@RequestMapping("/show-form")
	public String showForm() {
		return "base/term";
	}

	@RequestMapping("/printWithCriteria/{type}")
	public ResponseEntity<?> printWithCriteria(final HttpServletRequest request, @PathVariable String type) {
		String token = (String) request.getSession().getAttribute("AccessToken");

		final RestTemplate restTemplate = new RestTemplate();
		restTemplate.getMessageConverters().add(new ByteArrayHttpMessageConverter());

		final HttpHeaders headers = new HttpHeaders();
		headers.add("Authorization", "Bearer " + token);

		headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

		MultiValueMap<String, String> map = new LinkedMultiValueMap<String, String>();
		map.add("CriteriaStr", request.getParameter("CriteriaStr"));

		HttpEntity<MultiValueMap<String, String>> entity = new HttpEntity<MultiValueMap<String, String>>(map, headers);

		String restApiUrl = request.getRequestURL().toString().replace(request.getServletPath(),"");

		if(type.equals("pdf"))
			return restTemplate.exchange(restApiUrl + "/api/term/printWithCriteria/pdf", HttpMethod.GET, entity, byte[].class);
		else if(type.equals("excel"))
			return restTemplate.exchange(restApiUrl + "/api/term/printWithCriteria/excel", HttpMethod.GET, entity, byte[].class);
		else if(type.equals("html"))
			return restTemplate.exchange(restApiUrl + "/api/term/printWithCriteria/html", HttpMethod.GET, entity, byte[].class);
		else
			return null;
	}

}
