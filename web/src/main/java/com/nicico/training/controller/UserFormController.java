package com.nicico.training.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClientService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@RequiredArgsConstructor
@Controller
@RequestMapping("/user")
public class UserFormController {
private final OAuth2AuthorizedClientService authorizedClientService;

	@RequestMapping("/show-form")
	public String showForm() {
		return "base/user";
	}
}
