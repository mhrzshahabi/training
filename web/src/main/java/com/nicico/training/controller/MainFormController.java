package com.nicico.training.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/web")
@RequiredArgsConstructor
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

    @RequestMapping("/post-group")
    public String showPostGroupForm() {
        return "base/post-group";
    }

    @RequestMapping("/competence")
    public String showCompetenceForm() {
        return "base/competence";
    }

    @RequestMapping("/needAssessment")
    public String showNeedAssessmentForm() {
        return "base/needAssessmentNew1";
    }

    @RequestMapping("/postGradeGroup")
    public String showPostGradeGroupForm() {
        return "base/postGradeGroup";
    }

    @RequestMapping("/needAssessmentSkillBased")
    public String showNeedAssessmentSkillBasedForm() {
        return "base/needAssessmentSkillBased";
    }

}
