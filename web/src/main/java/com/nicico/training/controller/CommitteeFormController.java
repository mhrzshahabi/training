package com.nicico.training.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@RequiredArgsConstructor
@Controller
@RequestMapping("/committee")
public class CommitteeFormController {

	@RequestMapping("/show-form")
	public String showForm() {
		return "base/committee";
	}
}
