package com.nicico.training.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequiredArgsConstructor
@RequestMapping("/evaluationIndex")
public class EvaluationIndexController {

    @RequestMapping(value = "/show-form")
    public String showForm() {
        return "base/evaluationIndex";
    }
}
