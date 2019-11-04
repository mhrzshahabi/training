package com.nicico.training.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.*;
import org.springframework.http.converter.ByteArrayHttpMessageConverter;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClientService;
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
@RequestMapping("/tclass")
public class ClassFormController {
    private final OAuth2AuthorizedClientService authorizedClientService;

    @RequestMapping("/show-form")
    public String showForm() {
        return "base/class";
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
			return restTemplate.exchange(restApiUrl + "/api/tclass/printWithCriteria/PDF", HttpMethod.POST, entity, byte[].class);
		else if(type.equals("excel"))
			return restTemplate.exchange(restApiUrl + "/api/tclass/printWithCriteria/EXCEL", HttpMethod.POST, entity, byte[].class);
		else if(type.equals("html"))
			return restTemplate.exchange(restApiUrl + "/api/tclass/printWithCriteria/HTML", HttpMethod.POST, entity, byte[].class);
		else
			return null;
	}

	@RequestMapping("/sessions-tab")
	public String sessionsTab() {
		return "classTabs/sessions";
	}

	@RequestMapping("/alarms-tab")
	public String alarmsTab() {
		return "classTabs/alarms";
	}

	@RequestMapping("/licenses-tab")
	public String licensesTab() {
		return "classTabs/licenses";
	}

	@RequestMapping("/attendance-tab")
	public String attendanceTab() {
		return "classTabs/attendance";
	}

	@RequestMapping("/exam-tab")
	public String examTab() {
		return "classTabs/exam";
	}

	@RequestMapping("/teachers-tab")
	public String teachersTab() {
		return "classTabs/teachers";
	}

	@RequestMapping("/assessment-tab")
	public String assessmentTab() {
		return "classTabs/assessment";
	}

	@RequestMapping("/checkList-tab")
	public String checkListTab() {
		return "classTabs/check-list";
	}

	@RequestMapping("/attachments-tab")
	public String attachmentsTab() {
		return "classTabs/attachments";
	}
}
