package com.nicico.training.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@RequiredArgsConstructor
@Controller
@RequestMapping("/evaluation-final-test")
public class EvaluationFinalTestFormController {
    @RequestMapping("/show-form")
    public String showForm() {
        return "base/finalTest";
    }

    @RequestMapping("/questions/show-form")
    public String questionsShowForm() {
        return "base/questionsfinalTest";
    }

    @RequestMapping("/resend-final-exam-form")
    public String resendFinalExamForm() {
        return "base/resendFinalExam";
    }
}
