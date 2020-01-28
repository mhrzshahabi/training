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
@RequestMapping("/committee")
public class CommitteeFormController {

    @RequestMapping("/show-form")
    public String showForm() {
        return "base/committee";
    }


//	@PostMapping("/printCommitteeWithMember/{type}")
//	public ResponseEntity<?> printAll(final HttpServletRequest request, @PathVariable String type) {
//		//String token = (String) request.getSession().getAttribute("AccessToken");
//		String token=(String) request.getParameter("token");
//		final RestTemplate restTemplate = new RestTemplate();
//		restTemplate.getMessageConverters().add(new ByteArrayHttpMessageConverter());
//	    final HttpHeaders headers = new HttpHeaders();
//		headers.add("Authorization", "Bearer " + token);
//
//		headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
//
//		MultiValueMap<String, String> map = new LinkedMultiValueMap<String, String>();
//		map.add("CriteriaStr", request.getParameter("CriteriaStr"));
//
//		HttpEntity<MultiValueMap<String, String>> entity = new HttpEntity<MultiValueMap<String, String>>(map, headers);
//
//		String restApiUrl = request.getRequestURL().toString().replace(request.getServletPath(),"");
//
//		 if (type.equals("pdf"))
//            return restTemplate.exchange(restApiUrl + "/api/committee/printCommitteeWithMember/PDF",HttpMethod.POST, entity, byte[].class);
//        else if (type.equals("excel"))
//            return restTemplate.exchange(restApiUrl + "/api/committee/printCommitteeWithMember/EXCEL",HttpMethod.POST, entity, byte[].class);
//        else if (type.equals("html"))
//            return restTemplate.exchange(restApiUrl + "/api/committee/printCommitteeWithMember/HTML",HttpMethod.POST, entity, byte[].class);
//        else
//            return null;
//	}

    @RequestMapping("/printCommitteeWithMember/{type}")
    public ResponseEntity<?> print(final HttpServletRequest request, @PathVariable String type) {

        String token = (String) request.getSession().getAttribute("accessToken");
        //   	String token=(String) request.getParameter("token");
        RestTemplate restTemplate = new RestTemplate();
        restTemplate.getMessageConverters().add(new ByteArrayHttpMessageConverter());

        final HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + token);

        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        String restApiUrl = request.getRequestURL().toString().replace(request.getServletPath(), "");

        HttpEntity<String> entity = new HttpEntity<String>(headers);

        if (type.equals("pdf"))
            return restTemplate.exchange(restApiUrl + "/api/committee/printCommitteeWithMember/PDF", HttpMethod.GET, entity, byte[].class);
        else if (type.equals("excel"))
            return restTemplate.exchange(restApiUrl + "/api/committee/printCommitteeWithMember/EXCEL", HttpMethod.GET, entity, byte[].class);
        else if (type.equals("html"))
            return restTemplate.exchange(restApiUrl + "/api/committee/printCommitteeWithMember/HTML", HttpMethod.GET, entity, byte[].class);
        else
            return null;
    }
}
