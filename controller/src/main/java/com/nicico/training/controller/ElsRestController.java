package com.nicico.training.controller;


import com.google.gson.Gson;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.nicico.training.controller.client.els.ElsClient;
import com.nicico.training.mapper.evaluation.EvaluationBeanMapper;
import com.nicico.training.model.Evaluation;
import com.nicico.training.service.*;
import jdk.nashorn.internal.parser.JSONParser;
import lombok.RequiredArgsConstructor;
import net.minidev.json.JSONObject;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import request.evaluation.ElsEvalRequest;
import request.exam.ElsExamRequest;
import request.exam.SampleRequest;
import response.BaseResponse;
import response.evaluation.EvalListResponse;
import response.evaluation.SendEvalToElsResponse;

@RestController
@RequestMapping("/anonymous/els")
@RequiredArgsConstructor
public class ElsRestController {

    private final EvaluationBeanMapper evaluationBeanMapper;
    private final EvaluationAnswerService answerService;
    private final QuestionnaireService questionnaireService;
    private final EvaluationService evaluationService;
    private final ClassStudentService classStudentService;
    private final TeacherService teacherService;
    private final PersonalInfoService personalInfoService;
    private final ElsClient client;

    @GetMapping("/eval/{id}")
    public ResponseEntity<SendEvalToElsResponse> sendEvalToEls(@PathVariable long id) {
        Evaluation evaluation = evaluationService.getById(id);
        ElsEvalRequest request = evaluationBeanMapper.toElsEvalRequest(evaluation, questionnaireService.get(evaluation.getQuestionnaireId()),
                classStudentService.getClassStudents(evaluation.getClassId()),
                evaluationService.getEvaluationQuestions(answerService.getAllByEvaluationId(evaluation.getId())),
                personalInfoService.getPersonalInfo(teacherService.getTeacher(evaluation.getTclass().getTeacherId()).getPersonalityId()));
        BaseResponse baseResponse = client.sendEvaluation(request);
        SendEvalToElsResponse response = new SendEvalToElsResponse();
        response.setMessage(baseResponse.getMessage());
        response.setStatus(baseResponse.getStatus());

        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    @GetMapping("/evalResult/{id}")
    public ResponseEntity<EvalListResponse> getEvalResults(@PathVariable long id) {
        EvalListResponse response = client.getEvalResults(id);
        //TODO SAVE EVALUATION RESULTS TO DB OR ANYTHING THAT YOU WANT TO DO
        return new ResponseEntity(response, HttpStatus.OK);
    }

    @PostMapping("/examToEls")
    public ResponseEntity<EvalListResponse> sendExam(@RequestBody SampleRequest object) {
        ElsExamRequest request =new ElsExamRequest();

        BaseResponse response = client.sendExam(object);
        //TODO SAVE EVALUATION RESULTS TO DB OR ANYTHING THAT YOU WANT TO DO
        return new ResponseEntity(response, HttpStatus.OK);
    }
}
