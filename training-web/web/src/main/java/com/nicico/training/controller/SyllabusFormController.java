package com.nicico.training.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/syllabus")
public class SyllabusFormController {

	@RequestMapping(value = "/show-form")
	public String showForm() {
		return "base/syllabus";
	}
}
