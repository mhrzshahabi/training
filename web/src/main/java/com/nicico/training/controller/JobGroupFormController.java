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
@RequestMapping("/job-group")
public class JobGroupFormController {
	@RequestMapping("/show-form")
	public String showForm() {
		return "base/job-group";
	}

	@RequestMapping("/print/{type}")
	public ResponseEntity<?> print(final HttpServletRequest request,@PathVariable String type) {


		String token = (String) request.getSession().getAttribute("AccessToken");

		RestTemplate restTemplate = new RestTemplate();
		restTemplate.getMessageConverters().add(new ByteArrayHttpMessageConverter());

		final HttpHeaders headers = new HttpHeaders();
		headers.add("Authorization", "Bearer " + token);

		headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

		String restApiUrl = request.getRequestURL().toString().replace(request.getServletPath(),"");


		HttpEntity<String> entity = new HttpEntity<String>(headers);

		if(type.equals("pdf"))
			return restTemplate.exchange(restApiUrl + "/api/job-group/print/pdf", HttpMethod.GET, entity, byte[].class);
		else if(type.equals("excel"))
			return restTemplate.exchange(restApiUrl + "/api/job-group/print/excel", HttpMethod.GET, entity, byte[].class);
		else if(type.equals("html"))
			return restTemplate.exchange(restApiUrl + "/api/job-group/print/html", HttpMethod.GET, entity, byte[].class);
		else
			return null;
	}



	@RequestMapping("/printSelected/{type}/{jobGroupIds}")
	public ResponseEntity<?> printWithSelectedJobGroup(final HttpServletRequest request,@PathVariable String type,@PathVariable String jobGroupIds) {


		String token = (String) request.getSession().getAttribute("AccessToken");

		RestTemplate restTemplate = new RestTemplate();
		restTemplate.getMessageConverters().add(new ByteArrayHttpMessageConverter());

		final HttpHeaders headers = new HttpHeaders();
		headers.add("Authorization", "Bearer " + token);

		headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

		String restApiUrl = request.getRequestURL().toString().replace(request.getServletPath(),"");


		HttpEntity<String> entity = new HttpEntity<String>(headers);

		if(type.equals("pdf"))
			return restTemplate.exchange(restApiUrl + "/api/job-group/printSelected/pdf/"+jobGroupIds, HttpMethod.GET, entity, byte[].class);
		else if(type.equals("excel"))
			return restTemplate.exchange(restApiUrl + "/api/job-group/printSelected/excel/"+jobGroupIds, HttpMethod.GET, entity, byte[].class);
		else if(type.equals("html"))
			return restTemplate.exchange(restApiUrl + "/api/job-group/printSelected/html/"+jobGroupIds, HttpMethod.GET, entity, byte[].class);
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

		String restApiUrl = request.getRequestURL().toString().replace(request.getServletPath(),"");


		HttpEntity<String> entity = new HttpEntity<String>(headers);

		if(type.equals("pdf"))
			return restTemplate.exchange(restApiUrl + "/api/job-group/printAll/pdf", HttpMethod.GET, entity, byte[].class);
		else if(type.equals("excel"))
			return restTemplate.exchange(restApiUrl + "/api/job-group/printAll/excel", HttpMethod.GET, entity, byte[].class);
		else if(type.equals("html"))
			return restTemplate.exchange(restApiUrl + "/api/job-group/printAll/html", HttpMethod.GET, entity, byte[].class);
		else
			return null;
	}
}
