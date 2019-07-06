package com.nicico.training.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClient;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClientService;
import org.springframework.security.oauth2.client.authentication.OAuth2AuthenticationToken;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.client.RestTemplate;

import javax.servlet.http.HttpSession;

@Slf4j
@RequiredArgsConstructor
@Controller
@RequestMapping("/")
public class HomeController {
    private final OAuth2AuthorizedClientService authorizedClientService;

    @Value("${nicico.oauth2.server.url}")
    private String oauth2ServerUrl;

	@Value("${nicico.rest-api.url}")
	private String restApiUrl;

    @GetMapping(value = {"/", "/home"})
    public String showHomePage(Authentication authentication, HttpSession session) {
        if (authentication instanceof OAuth2AuthenticationToken) {
            OAuth2AuthorizedClient client = authorizedClientService
                    .loadAuthorizedClient(
                            ((OAuth2AuthenticationToken) authentication).getAuthorizedClientRegistrationId(),
                            authentication.getName());
            try {
                String token = client.getAccessToken().getTokenValue();
                session.setAttribute("token",token);
                HttpHeaders headers = new HttpHeaders();
                headers.add("Authorization", "Bearer " + token);
                HttpEntity<String> request = new HttpEntity<String>(headers);

                RestTemplate restTemplate = new RestTemplate();

                ResponseEntity<String> processDiagram = restTemplate.exchange(restApiUrl + "/api/workflow/userTask/count/" + session.getAttribute("username"), HttpMethod.GET, request, String.class);
                session.setAttribute("cartableCount", processDiagram.getBody());
            } catch (Exception e) {
                return "underConstruction";
            }
        }

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

    @GetMapping("/oauth_logout")
    public String logout() {
        return "redirect:" + oauth2ServerUrl;
    }
}
