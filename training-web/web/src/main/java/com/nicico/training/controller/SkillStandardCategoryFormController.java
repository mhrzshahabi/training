package com.nicico.training.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@RequiredArgsConstructor
@Controller
@RequestMapping("/skill-standard-category")
public class SkillStandardCategoryFormController {

	@RequestMapping("/show-form")
	public String showSkillCategory() {
		return "base/skill-standard-category";
	}
}
