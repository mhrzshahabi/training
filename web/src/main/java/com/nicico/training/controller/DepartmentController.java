package com.nicico.training.controller;

import com.nicico.copper.common.dto.search.SearchDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

@Controller
@RequiredArgsConstructor
@RequestMapping("/department")
public class DepartmentController {

    @RequestMapping(value = "/show-form")
    public String showForm() {
        return "base/department";
    }

}
