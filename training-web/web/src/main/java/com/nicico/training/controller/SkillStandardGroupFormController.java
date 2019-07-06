package com.nicico.training.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/skill-group")
public class SkillStandardGroupFormController {

	@RequestMapping("/show-form")
	public String showForm() {
		return "base/skill-group";

	}
}
