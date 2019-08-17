package com.nicico.training.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClientService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@RequiredArgsConstructor
@Controller
@RequestMapping("/term")
public class TermFormController {

private final OAuth2AuthorizedClientService authorizedClientService;

	@Value("${nicico.rest-api.url}")
	private String restApiUrl;

	@RequestMapping("/show-form")
	public String showForm() {
		return "base/term";
	}

}
