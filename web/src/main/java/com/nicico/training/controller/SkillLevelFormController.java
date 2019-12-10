package com.nicico.training.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;


@RequiredArgsConstructor
@Controller
@RequestMapping("/skill-level")
public class SkillLevelFormController {

    @RequestMapping("/show-form")
    public String showFiscalYear() {
        return "base/skill-level";
    }

}
