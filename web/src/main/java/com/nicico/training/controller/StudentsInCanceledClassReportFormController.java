/*
 * Author: Mehran Golrokhi
 * Created Date: 2020/09/13
 * Last Modified: 2020/07/26
 */

package com.nicico.training.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.*;
import org.springframework.http.converter.ByteArrayHttpMessageConverter;
import org.springframework.stereotype.Controller;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.client.RestTemplate;

import javax.servlet.http.HttpServletRequest;

@RequiredArgsConstructor
@Controller
@RequestMapping("/students-in-canceled-class-report")
public class StudentsInCanceledClassReportFormController {

    @RequestMapping("/show-form")
    public String showForm() {
        return "report/studentsInCanceledClassReport";
    }
}
