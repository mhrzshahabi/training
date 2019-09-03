/*
ghazanfari_f, 8/29/2019, 10:42 AM
*/
package com.nicico.training.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@RequiredArgsConstructor
@Controller
@RequestMapping("/postGrade")
public class PostGradeFormController {

    @RequestMapping("/show-form")
    public String showForm() {
        return "base/postGrade";
    }
}
