package com.nicico.training.controller;

import com.nicico.copper.activiti.domain.iservice.IBusinessWorkflowEngine;
import com.nicico.copper.oauth.common.model.OAUser;
import com.nicico.copper.oauth.common.repository.OAUserDAO;
import com.nicico.training.model.LoginLog;
import com.nicico.training.model.enums.LoginState;
import com.nicico.training.repository.LoginLogDAO;
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
    private final LoginLogDAO loginLogDAO;
    private final OAUserDAO userDAO;

    @Value("${nicico.rest-api.url}")
    private String restApiUrl;


    @GetMapping(value = {"/", "/home"})
    public String showHomePage(HttpSession session) {
        String currentUsername = SecurityContextHolder.getContext().getAuthentication().getName();
        OAUser user = userDAO.findByUsername(currentUsername).orElse(new OAUser());
        if (user.getUsername() != null) {
            LoginLog loginLog = new LoginLog();
            loginLog.setNationalCode(user.getNationalCode());
            loginLog.setFirstName(user.getFirstName());
            loginLog.setLastName(user.getLastName());
            loginLog.setState(LoginState.LOGIN);
            loginLog.setUsername(currentUsername);
            loginLogDAO.save(loginLog);
        }
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
