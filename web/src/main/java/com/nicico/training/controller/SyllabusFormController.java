package com.nicico.training.controller;

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

@RequiredArgsConstructor
@Controller
@RequestMapping("/syllabus")
public class SyllabusFormController {
	private final OAuth2AuthorizedClientService authorizedClientService;
	@Value("${nicico.rest-api.url}")
	private String restApiUrl;

	@RequestMapping(value = "/show-form")
	public String showForm() {
		return "base/syllabus";
	}

	@RequestMapping("/print/{type}")
	public ResponseEntity<?> print(Authentication authentication, @PathVariable String type) {
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
			return restTemplate.exchange(restApiUrl + "/api/syllabus/print/pdf", HttpMethod.GET, entity, byte[].class);
		else if(type.equals("excel"))
			return restTemplate.exchange(restApiUrl + "/api/syllabus/print/excel", HttpMethod.GET, entity, byte[].class);
		else if(type.equals("html"))
			return restTemplate.exchange(restApiUrl + "/api/syllabus/print/html", HttpMethod.GET, entity, byte[].class);
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
            return restTemplate.exchange(restApiUrl + "/api/syllabus/print-one-course/"+courseId+"/pdf", HttpMethod.GET, entity, byte[].class);
        else if(type.equals("excel"))
            return restTemplate.exchange(restApiUrl + "/api/syllabus/print-one-course/"+courseId+"/excel", HttpMethod.GET, entity, byte[].class);
        else if(type.equals("html"))
            return restTemplate.exchange(restApiUrl + "/api/syllabus/print-one-course/"+courseId+"/html", HttpMethod.GET, entity, byte[].class);
        else
            return null;
    }
    //------------------------------------------------

	@RequestMapping("/print-one-goal/{goalId}/{type}")
	public ResponseEntity<?> printOneGoal(Authentication authentication, @PathVariable String type, @PathVariable Long goalId) {
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
			return restTemplate.exchange(restApiUrl + "/api/syllabus/print-one-goal/"+goalId+"/pdf", HttpMethod.GET, entity, byte[].class);
		else if(type.equals("excel"))
			return restTemplate.exchange(restApiUrl + "/api/syllabus/print-one-goal/"+goalId+"/excel", HttpMethod.GET, entity, byte[].class);
		else if(type.equals("html"))
			return restTemplate.exchange(restApiUrl + "/api/syllabus/print-one-goal/"+goalId+"/html", HttpMethod.GET, entity, byte[].class);
		else
			return null;
	}
}
