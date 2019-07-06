package com.nicico.training.controller;

/* com.nicico.training.controller.masterData
@Author:jafari-h
@Date:6/9/2019
@Time:7:58 AM
*/
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@Controller
@RequestMapping("/goal")
public class GoalFormController {
    @RequestMapping("/show-form")
    public String showForm(HttpServletRequest req, HttpServletResponse rsp) {
        String courseId = req.getParameter("courseId");
        req.setAttribute("courseId",courseId);
        return "base/goal";
    }
}
