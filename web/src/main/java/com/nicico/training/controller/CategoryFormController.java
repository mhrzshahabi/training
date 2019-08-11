package com.nicico.training.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@RequiredArgsConstructor
@Controller
@RequestMapping("/category")
public class CategoryFormController {

	@RequestMapping("/show-form")
	public String showSkillCategory() {
		return "base/category";
	}
}
