package com.nicico.training.controller.client.els;

import com.nicico.training.dto.MessagesAttDTO;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import request.evaluation.ElsEvalRequest;
import request.evaluation.ReviewByRunExpert;
import request.evaluation.ReviewByRunSupervisor;
import request.exam.ElsExamRequest;
import request.exam.ElsExtendedExamRequest;
import request.exam.UpdateRequest;
import response.BaseResponse;
import response.TrainingRequestDTO;
import response.evaluation.EvalListResponse;
import response.evaluation.PdfResponse;
import response.evaluation.dto.EvaluationDoneOnlineDto;
import response.exam.DoneOnlineExamDto;
import response.exam.ElsExamMonitoringRespDto;
import response.exam.ExamListResponse;
import response.exam.ResendExamTimes;

import java.util.List;

@FeignClient(value = "elsClient", url = "${nicico.elsUrl}")
public interface ElsClient {
    @RequestMapping(method = RequestMethod.POST, value = "/training/evaluation")
    BaseResponse sendEvaluation(@RequestBody ElsEvalRequest request);

    @RequestMapping(method = RequestMethod.POST, value = "/training/importExam")
    BaseResponse sendExam(@RequestBody ElsExamRequest request);

    @GetMapping("/training/evaluation/{id}")
    EvalListResponse getEvalResults(@PathVariable("id") long id);

    @GetMapping("/training/exam/{id}")
    ExamListResponse getExamResults(@PathVariable("id") long id);

    @GetMapping("/training/exam/pdfReport/{id}")
    PdfResponse getExamReport(@PathVariable("id") long id);

    @GetMapping("/training/evaluation/pdfData/{id}")
    EvalListResponse getEvalReport(@PathVariable("id") long id);

    @RequestMapping(method = RequestMethod.POST, value = "/training/evaluationToTeacher")
    BaseResponse sendEvaluationToTeacher(@RequestBody ElsEvalRequest request);

    @GetMapping("/training/report/importedEvaluations/{fromDate}/{toDate}")
    List<EvaluationDoneOnlineDto> getDoneEvaluations(@PathVariable("fromDate") String fromDate, @PathVariable("toDate") String toDate);

    @GetMapping("/training/report/importedExams/{startDate}/{endDate}")
    List<DoneOnlineExamDto> getDoneOnlineExams(@PathVariable("startDate") String startDate, @PathVariable("endDate") String endDate);

    @RequestMapping(method = RequestMethod.POST, value = "/training/exam/extend")
    BaseResponse resendExam(@RequestBody ElsExtendedExamRequest request);

    @RequestMapping(method = RequestMethod.PUT, value = "/training/updateResult")
    BaseResponse sendScoresToEls(@RequestBody UpdateRequest requestDto);

    @GetMapping("/training/extendedList/{sourceExamId}")
    ResendExamTimes getResendExamTimes(@PathVariable Long sourceExamId);

    @RequestMapping(method = RequestMethod.POST, value = "/training/importCourse")
    BaseResponse sendClass(@RequestBody ElsExamRequest request);

    @DeleteMapping(value = "/training/evaluations/remove/{sourceId}/{nationalCode}")
    BaseResponse deleteEvaluationForOnePerson(@PathVariable Long sourceId, @PathVariable String nationalCode);

    @DeleteMapping(value = "/training/evaluations/remove")
    BaseResponse deleteEvaluationForOneClass(@RequestBody List<Long> sourceIds);

    @GetMapping(value = "/training/messages/findAll")
    ResponseEntity<List<MessagesAttDTO>> findAllMessagesBySessionId(@RequestParam("sessionId") Long sessionId);

    @GetMapping(value = "/training/profilesInExam")
    ElsExamMonitoringRespDto getExamMonitoring(@RequestParam String examCode, @RequestParam String method);

    @DeleteMapping("/training/exam")
    BaseResponse deleteExamFromEls(@RequestParam Long sourceExamId, @RequestParam String method);

    @GetMapping("/training-request/run-supervisor/task-list/by-type/{objectType}")
    List<TrainingRequestDTO.Info> getRunSupervisorTaskListByType(@PathVariable String objectType);

    @PostMapping("/training-request/review/run-Supervisor")
    TrainingRequestDTO.Info reviewRunSupervisor(@RequestBody ReviewByRunSupervisor reviewByRunSupervisor);

    @GetMapping("/training-request/run-expert/task-list/by-type/{nationalCode}/{objectType}")
    List<TrainingRequestDTO.Info> getRunExpertTaskListByType(@PathVariable String nationalCode,@PathVariable String objectType);

    @GetMapping("/training-request/run-expert/all-task-list")
    List<TrainingRequestDTO.Info> getAllRunExpertTaskList();

    @PostMapping("/training-request/review/run-expert")
    TrainingRequestDTO.Info reviewByRunExpert(@RequestBody ReviewByRunExpert reviewByRunExpert);

}
