package com.nicico.training.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/course")
public class CourseFormController {

	@RequestMapping("/show-form")
	public String showForm() {
		return "base/course";
	}
}
