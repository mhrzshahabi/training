package com.nicico.training.controller;

/*
AUTHOR: ghazanfari_f
DATE: 6/10/2019
TIME: 8:53 AM
*/

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@RequiredArgsConstructor
@Controller
@RequestMapping("/competence")
public class CompetenceFormController {

    @RequestMapping("/show-form")
    public String showForm() {
        return "base/competence";
    }
}
