package com.nicico.training.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.http.converter.ByteArrayHttpMessageConverter;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClient;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClientService;
import org.springframework.security.oauth2.client.authentication.OAuth2AuthenticationToken;
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
@RequestMapping("/institute")
public class InstituteFormController {
    private final OAuth2AuthorizedClientService authorizedClientService;

	@Value("${nicico.rest-api.url}")
	private String restApiUrl;

    @RequestMapping("/show-form")
    public String showForm() {
        return "base/institute";
    }

    @PostMapping("/printWithCriteria/{type}")
	public ResponseEntity<?> printWithCriteria(final HttpServletRequest request, @PathVariable String type) {
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
			return restTemplate.exchange(restApiUrl + "/api/institute/printWithCriteria/PDF", HttpMethod.POST, entity, byte[].class);
		else if(type.equals("excel"))
			return restTemplate.exchange(restApiUrl + "/api/institute/printWithCriteria/EXCEL", HttpMethod.POST, entity, byte[].class);
		else if(type.equals("html"))
			return restTemplate.exchange(restApiUrl + "/api/institute/printWithCriteria/HTML", HttpMethod.POST, entity, byte[].class);
		else
			return null;
	}

}
