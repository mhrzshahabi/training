package com.nicico.training.controller;


import com.nicico.training.TrainingException;
import com.nicico.training.controller.client.els.ElsClient;
import com.nicico.training.mapper.evaluation.EvaluationBeanMapper;
import com.nicico.training.model.ClassStudent;
import com.nicico.training.model.Evaluation;
import com.nicico.training.model.QuestionBank;
import com.nicico.training.service.*;
import dto.Question.QuestionData;
import dto.exam.*;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import request.evaluation.ElsEvalRequest;
import request.exam.ElsExamRequest;
import request.exam.ExamImportedRequest;
import response.BaseResponse;
import response.evaluation.EvalListResponse;
import response.evaluation.SendEvalToElsResponse;
import response.exam.ExamListResponse;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

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
    private final QuestionBankService questionBankService;
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

    @GetMapping("/examResult/{id}")
    public ResponseEntity<ExamListResponse> examResult(@PathVariable long id) {
        ExamListResponse response = client.getExamResults(id);
        //TODO SAVE EVALUATION RESULTS TO DB OR ANYTHING THAT YOU WANT TO DO
        return new ResponseEntity(response, HttpStatus.OK);
    }

    @PostMapping("/examToEls")
    public ResponseEntity sendExam(@RequestBody ExamImportedRequest object) {
        BaseResponse response = new BaseResponse();
        try {
            ElsExamRequest request;
            request = evaluationBeanMapper.toGetExamRequest(object, classStudentService.getClassStudents(object.getExamItem().getTclassId()));
            boolean hasDuplicateQuestions = evaluationBeanMapper.hasDuplicateQuestions(request.getQuestionProtocols());
            boolean hasWrongCorrectAnswer = evaluationBeanMapper.hasWrongCorrectAnswer(request.getQuestionProtocols());
            if (hasDuplicateQuestions || hasWrongCorrectAnswer) {

                response.setStatus(HttpStatus.NOT_ACCEPTABLE.value());
                if (hasDuplicateQuestions)
                    response.setMessage("سوال با عنوان تکراری در آزمون موجود است!");
                else
                    response.setMessage("سوال چهار گزینه ای بدون جواب صحیح موجود است!");

                return new ResponseEntity<>(response, HttpStatus.NOT_ACCEPTABLE);
            } else {

                response = client.sendExam(request);
                return new ResponseEntity<>(response, HttpStatus.OK);
            }

        } catch (TrainingException ex) {
            response.setStatus(HttpStatus.NOT_ACCEPTABLE.value());
            response.setMessage("بروز خطا در سیستم");
            return new ResponseEntity<>(response, HttpStatus.NOT_ACCEPTABLE);
        }
    }


}
