package com.nicico.training.controller.client.els;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.*;
import request.evaluation.ElsEvalRequest;
import request.exam.ElsExamRequest;
import request.exam.ElsExtendedExamRequest;
import request.exam.UpdateRequest;
import response.BaseResponse;
import response.evaluation.EvalListResponse;
import response.evaluation.PdfResponse;
import response.evaluation.dto.EvaluationDoneOnlineDto;
import response.exam.DoneOnlineExamDto;
import response.exam.ExamListResponse;

import java.util.List;



@FeignClient(value = "elsClient", url = "http://devapp01.icico.net.ir/els/api/training")
public interface ElsClient {
    @RequestMapping(method = RequestMethod.POST, value = "/evaluation")
    BaseResponse sendEvaluation(@RequestBody ElsEvalRequest request);

    @RequestMapping(method = RequestMethod.POST, value = "/importExam")
    BaseResponse sendExam(@RequestBody ElsExamRequest request);

    @GetMapping("/evaluation/{id}")
    EvalListResponse getEvalResults(@PathVariable("id") long id);

    @GetMapping("/exam/{id}")
    ExamListResponse getExamResults(@PathVariable("id") long id);

    @GetMapping("/exam/pdfReport/{id}")
    PdfResponse getExamReport(@PathVariable("id") long id);

    @GetMapping("/evaluation/pdfData/{id}")
    EvalListResponse getEvalReport(@PathVariable("id") long id);

    @RequestMapping(method = RequestMethod.POST, value = "/evaluationToTeacher")
    BaseResponse sendEvaluationToTeacher(@RequestBody ElsEvalRequest request);

    @GetMapping("/report/importedEvaluations/{fromDate}/{toDate}")
    List<EvaluationDoneOnlineDto> getDoneEvaluations(@PathVariable("fromDate") String fromDate, @PathVariable("toDate") String toDate);

    @GetMapping("/report/importedExams/{startDate}/{endDate}")
    List<DoneOnlineExamDto> getDoneOnlineExams(@PathVariable("startDate") String startDate, @PathVariable("endDate") String endDate);

    @RequestMapping(method = RequestMethod.POST, value = "/exam/extend")
    BaseResponse resendExam(@RequestBody ElsExtendedExamRequest request);

    @RequestMapping(method = RequestMethod.PUT, value = "/updateResult")
    BaseResponse sendScoresToEls(@RequestBody UpdateRequest requestDto);
}
