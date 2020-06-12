package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.env.Environment;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

@Slf4j
@RequiredArgsConstructor
@RestController
@RequestMapping(value = "/api/main/")
public class TrainingMainController {

    private final Environment environment;

    @Loggable
    @GetMapping(value = "/getMainData")
    public void getMainData(HttpServletRequest request) throws Exception {
        HttpSession session = request.getSession();

        //**********variables**********
        String version = "1.0.0";
        //*****************************

        //**********get training version**********
        if (environment.getProperty("nicico.training.version") != null) {
            version = environment.getProperty("nicico.training.version").toString();
        }
        session.setAttribute("trainingVersion", version);
        //****************************************
    }

}
