package com.nicico.training.controller;

import com.nicico.copper.activiti.domain.iservice.IBusinessWorkflowEngine;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpSession;

@Slf4j
@RequiredArgsConstructor
@Controller
@RequestMapping("/")
public class HomeController {

	private final IBusinessWorkflowEngine businessWorkflowEngine;

	@Value("${nicico.rest-api.url}")
	private String restApiUrl;

	@GetMapping(value = {"/", "/home"})
	public String showHomePage(HttpSession session) {
		final String username = SecurityContextHolder.getContext().getAuthentication().getName();
		session.setAttribute("cartableCount", businessWorkflowEngine.getUserTasks(username).size());

		return "trainingMainDesktop";
	}

	@GetMapping(value = {"/login"})
	public String showLoginPage() {
		return "security/login";
	}

	@GetMapping("/oauth_login")
	public String getLoginPage(Model model) {
		if (!(SecurityContextHolder.getContext().getAuthentication() instanceof AnonymousAuthenticationToken) && SecurityContextHolder.getContext().getAuthentication().isAuthenticated()) {
			return "redirect:/";
		} else {
			return "redirect:/oauth2/authorization/sso-login";
		}
	}
}
