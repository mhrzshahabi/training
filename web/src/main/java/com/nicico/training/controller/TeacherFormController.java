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
import org.springframework.ui.ModelMap;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.client.RestTemplate;

import javax.servlet.http.HttpServletRequest;
import java.util.Base64;

@RequiredArgsConstructor
@Controller
@RequestMapping("/teacher")
public class TeacherFormController {
	private final OAuth2AuthorizedClientService authorizedClientService;

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

		String restApiUrl="htttp:localhost:8080/training";

        RestTemplate restTemplate = new RestTemplate();
		ResponseEntity<byte[]> teacherImg = restTemplate.exchange(restApiUrl + "/api/teacher/getTempAttach/"+fileName , HttpMethod.GET, request, byte[].class);
		modelMap.addAttribute("teacherImg", Base64.getEncoder().encodeToString(teacherImg.getBody()));

        return "base/teacherImage";
    }


   	@GetMapping(value = {"/getAttach/{Id}"})
	public String getAttach(ModelMap modelMap, final HttpServletRequest request,@PathVariable Long Id) {
		String token = (String) request.getSession().getAttribute("AccessToken");

        HttpHeaders headers = new HttpHeaders();
		headers.add("Authorization", "Bearer " + token);

		String restApiUrl="htttp:localhost:8080/training";

        RestTemplate restTemplate = new RestTemplate();
        MultiValueMap<String, String> map = new LinkedMultiValueMap<String, String>();
        HttpEntity<MultiValueMap<String, String>> entity = new HttpEntity<MultiValueMap<String, String>>(map, headers);
		ResponseEntity<byte[]> teacherImg = restTemplate.exchange(restApiUrl + "/api/teacher/getAttach/"+Id , HttpMethod.GET, entity, byte[].class);
		modelMap.addAttribute("teacherImg", Base64.getEncoder().encodeToString(teacherImg.getBody()));

        return "base/teacherImage";
    }


    @PostMapping("/printWithCriteria/{type}")
	public ResponseEntity<?> printWithCriteria(final HttpServletRequest request,@PathVariable String type) {
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
			return restTemplate.exchange(restApiUrl + "/api/teacher/printWithCriteria/PDF", HttpMethod.POST, entity, byte[].class);
		else if(type.equals("excel"))
			return restTemplate.exchange(restApiUrl + "/api/teacher/printWithCriteria/EXCEL", HttpMethod.POST, entity, byte[].class);
		else if(type.equals("html"))
			return restTemplate.exchange(restApiUrl + "/api/teacher/printWithCriteria/HTML", HttpMethod.POST, entity, byte[].class);
		else
			return null;
	}

}
