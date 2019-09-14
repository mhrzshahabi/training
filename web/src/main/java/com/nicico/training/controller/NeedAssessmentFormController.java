/*
ghazanfari_f, 8/29/2019, 14:42 AM
*/
package com.nicico.training.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@RequiredArgsConstructor
@Controller
@RequestMapping("/needAssessment")
public class NeedAssessmentFormController {

    @RequestMapping("/show-form")
    public String showForm() {
        return "base/needAssessment";
    }
}
