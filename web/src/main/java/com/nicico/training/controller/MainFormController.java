package com.nicico.training.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class MainFormController {

    @RequestMapping("/job")
    public String showJobForm() {
        return "base/job";
    }

    @RequestMapping("/postGrade")
    public String showPostGradeForm() {
        return "base/postGrade";
    }

    @RequestMapping("/post")
    public String showPostForm() {
        return "base/post";
    }

    @RequestMapping("/competence")
    public String showCompetenceForm() {
        return "base/competence";
    }

    @RequestMapping("/needAssessment")
    public String showNeedAssessmentForm() {
        return "base/needAssessment";
    }
}
