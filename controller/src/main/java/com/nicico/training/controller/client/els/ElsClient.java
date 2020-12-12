package com.nicico.training.controller.client.els;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import request.evaluation.ElsEvalRequest;
import request.exam.ElsExamRequest;
import response.BaseResponse;
import response.evaluation.EvalListResponse;
import response.evaluation.PdfResponse;
import response.evaluation.dto.PdfEvalResponse;
import response.exam.ExamListResponse;

import java.io.ByteArrayInputStream;

@FeignClient(value = "elsClient", url = "http://localhost:8080/els/api/training")
public interface ElsClient {
    @RequestMapping(method = RequestMethod.POST, value = "/evaluation")
    BaseResponse sendEvaluation(@RequestBody ElsEvalRequest request);

    @RequestMapping(method = RequestMethod.POST, value = "/importExam")
    BaseResponse sendExam(@RequestBody ElsExamRequest request);

    @GetMapping("/evaluation/{id}")
    EvalListResponse getEvalResults(@PathVariable long id);


    @GetMapping("/exam/{id}")
    ExamListResponse getExamResults(@PathVariable long id);

    @GetMapping("/exam/pdfReport//{id}")
    PdfResponse getExamReport(@PathVariable long id);
    @GetMapping("/evaluation/pdfData/{id}")
    EvalListResponse getEvalReport(@PathVariable long id);

    @RequestMapping(method = RequestMethod.POST, value = "/evaluationToTeacher")
    BaseResponse sendEvaluationToTeacher(ElsEvalRequest request);
}
