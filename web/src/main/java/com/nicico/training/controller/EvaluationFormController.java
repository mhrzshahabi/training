package com.nicico.training.controller;


import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@RequiredArgsConstructor
@Controller
@RequestMapping("/evaluation")
public class EvaluationFormController {

    @RequestMapping("/show-form")
    public String showForm() {
        return "base/evaluation";
    }

}
