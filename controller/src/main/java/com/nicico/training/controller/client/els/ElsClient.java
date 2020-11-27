package com.nicico.training.controller.client.els;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;
import request.evaluation.ElsEvalRequest;
import request.exam.ElsExamRequest;
import response.BaseResponse;
import response.evaluation.EvalListResponse;
import response.exam.ExamListResponse;

@FeignClient(value = "elsClient", url = "http://mobiles.nicico.com/els/api/training")
public interface ElsClient {
    @RequestMapping(method = RequestMethod.POST, value = "/evaluation")
    BaseResponse sendEvaluation(@RequestBody ElsEvalRequest request);

    @RequestMapping(method = RequestMethod.POST, value = "/importExam")
    BaseResponse sendExam(@RequestBody ElsExamRequest request);

    @GetMapping("/evaluation/{id}")
    EvalListResponse getEvalResults(@PathVariable long id);


    @GetMapping("/exam/{id}")
    ExamListResponse getExamResults(@PathVariable long id);

}
