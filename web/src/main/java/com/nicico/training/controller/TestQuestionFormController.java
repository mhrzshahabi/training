package com.nicico.training.controller;

import com.nicico.training.service.TestQuestionService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletResponse;

@RequiredArgsConstructor
@Controller
@RequestMapping("/test-question-form")
public class TestQuestionFormController {

    private final TestQuestionService testQuestionService;

    @PostMapping(value = {"/print/{type}"})
    public void print(HttpServletResponse response,
                      @PathVariable String type,
                      @RequestParam(value = "fileName") String fileName,
                      @RequestParam(value = "TestQuestionId") Long testQuestionId,
                      @RequestParam(value = "params") String Params
    ) throws Exception {
        testQuestionService.print(response, type, fileName, testQuestionId, Params);
    }

}
