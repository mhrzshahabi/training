package com.nicico.training.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@RequiredArgsConstructor
@Controller
@RequestMapping("/pre-test")
public class PreTestController {
    @RequestMapping("/show-form")
    public String showForm() {
        return "evaluation/preTest";
    }

}
