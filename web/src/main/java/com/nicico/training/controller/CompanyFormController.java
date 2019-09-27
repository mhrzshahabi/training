package com.nicico.training.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@RequiredArgsConstructor
@Controller
@RequestMapping("/company")
public class CompanyFormController {
@RequestMapping("/show-form")
	public String showForm() {
		return "base/company";
	}
}
