package com.nicico.training.controller.client.els;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;
import request.evaluation.ElsEvalRequest;
import response.BaseResponse;
import response.evaluation.EvalListResponse;

@FeignClient(value = "elsClient", url = "http://172.16.6.131:8080/els/api/training")
public interface ElsClient {
    @RequestMapping(method = RequestMethod.POST, value = "/evaluation")
    BaseResponse sendEvaluation(@RequestBody ElsEvalRequest request);

    @GetMapping("/evaluation/{id}")
    EvalListResponse getEvalResults(@PathVariable long id);

}
