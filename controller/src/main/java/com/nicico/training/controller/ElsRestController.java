package com.nicico.training.controller;


import com.nicico.training.TrainingException;
import com.nicico.training.controller.client.els.ElsClient;
import com.nicico.training.controller.util.GeneratePdfReport;
import com.nicico.training.mapper.evaluation.EvaluationBeanMapper;
import com.nicico.training.model.*;
import com.nicico.training.service.*;
import dto.Question.QuestionData;
import dto.exam.*;
import lombok.RequiredArgsConstructor;
import net.sf.jasperreports.engine.JasperCompileManager;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import request.evaluation.ElsEvalRequest;
import request.exam.ElsExamRequest;
import request.exam.ExamImportedRequest;
import response.BaseResponse;
import response.evaluation.EvalListResponse;
import response.evaluation.PdfResponse;
import response.evaluation.SendEvalToElsResponse;
import response.evaluation.dto.PdfEvalResponse;
import response.exam.ExamAnswerDto;
import response.exam.ExamListResponse;
import response.exam.ExamResultDto;

import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
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
    private final StudentService studentService;
    private final PersonalInfoService personalInfoService;
    private final ElsClient client;
    private final TestQuestionService testQuestionService;

    @GetMapping("/eval/{id}")
    public ResponseEntity<SendEvalToElsResponse> sendEvalToEls(@PathVariable long id) {
        SendEvalToElsResponse response = new SendEvalToElsResponse();

        Evaluation evaluation = evaluationService.getById(id);
        ElsEvalRequest request = evaluationBeanMapper.toElsEvalRequest(evaluation, questionnaireService.get(evaluation.getQuestionnaireId()),
                classStudentService.getClassStudents(evaluation.getClassId()),
                evaluationService.getEvaluationQuestions(answerService.getAllByEvaluationId(evaluation.getId())),
                personalInfoService.getPersonalInfo(teacherService.getTeacher(evaluation.getTclass().getTeacherId()).getPersonalityId()));


        if (null == request.getTeacher().getGender() ||
                null == request.getTeacher().getCellNumber() ||
                null == request.getTeacher().getNationalCode() ||
                10 != request.getTeacher().getNationalCode().length()
        ) {
            response.setMessage("اطلاعات استاد تکمیل نیست");
            response.setStatus(HttpStatus.NOT_ACCEPTABLE.value());

            return new ResponseEntity<>(response, HttpStatus.NOT_ACCEPTABLE);
        } else {
            BaseResponse baseResponse = client.sendEvaluation(request);
            response.setMessage(baseResponse.getMessage());
            response.setStatus(baseResponse.getStatus());
            return new ResponseEntity<>(response, HttpStatus.OK);
        }


    }

    @GetMapping("/teacherEval/{id}")
    public ResponseEntity<SendEvalToElsResponse> sendEvalToElsForTeacher(@PathVariable long id) {
        SendEvalToElsResponse response = new SendEvalToElsResponse();

        Evaluation evaluation = evaluationService.getById(id);
        ElsEvalRequest request = evaluationBeanMapper.toElsEvalRequest(evaluation, questionnaireService.get(evaluation.getQuestionnaireId()),
                classStudentService.getClassStudents(evaluation.getClassId()),
                evaluationService.getEvaluationQuestions(answerService.getAllByEvaluationId(evaluation.getId())),
                personalInfoService.getPersonalInfo(teacherService.getTeacher(evaluation.getTclass().getTeacherId()).getPersonalityId()));


        if (null == request.getTeacher().getGender() ||
                null == request.getTeacher().getCellNumber() ||
                null == request.getTeacher().getNationalCode() ||
                10 != request.getTeacher().getNationalCode().length()
        ) {
            response.setMessage("اطلاعات استاد تکمیل نیست");
            response.setStatus(HttpStatus.NOT_ACCEPTABLE.value());

            return new ResponseEntity<>(response, HttpStatus.NOT_ACCEPTABLE);
        } else {
            BaseResponse baseResponse = client.sendEvaluationToTeacher(request);
            response.setMessage(baseResponse.getMessage());
            response.setStatus(baseResponse.getStatus());
            return new ResponseEntity<>(response, HttpStatus.OK);
        }


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
            if (null == object.getQuestions() || object.getQuestions().isEmpty()) {
                response.setMessage("آزمون سوال ندارد!");
                return new ResponseEntity<>(response, HttpStatus.NOT_ACCEPTABLE);

            } else {

                PersonalInfo teacherInfo = personalInfoService.getPersonalInfo
                        (teacherService.getTeacher(object.getExamItem().getTclass().getTeacherId()).getPersonalityId());
                if (null == teacherInfo.getGender() ||
                        null == teacherInfo.getContactInfo() ||
                        null == teacherInfo.getNationalCode() ||
                        10 != teacherInfo.getNationalCode().length() ||
                        null == teacherInfo.getContactInfo().getMobile()) {
                    response.setMessage("اطلاعات استاد تکمیل نیست");
                    return new ResponseEntity<>(response, HttpStatus.NOT_ACCEPTABLE);
                } else {
                    request = evaluationBeanMapper.toGetExamRequest(teacherInfo,
                            object, classStudentService.getClassStudents(object.getExamItem().getTclassId()));
                    boolean hasDuplicateQuestions = evaluationBeanMapper.hasDuplicateQuestions(request.getQuestionProtocols());
                    boolean hasWrongCorrectAnswer = evaluationBeanMapper.hasWrongCorrectAnswer(request.getQuestionProtocols());
                    if (hasDuplicateQuestions || hasWrongCorrectAnswer || request.getQuestionProtocols().size() == 0) {

                        response.setStatus(HttpStatus.NOT_ACCEPTABLE.value());
                        if (hasDuplicateQuestions)
                            response.setMessage("سوال با عنوان تکراری در آزمون موجود است!");
                        else if (hasWrongCorrectAnswer)
                            response.setMessage("سوال چهار گزینه ای بدون جواب صحیح موجود است!");

                        else
                            response.setMessage("آزمون سوال ندارد!");


                        return new ResponseEntity<>(response, HttpStatus.NOT_ACCEPTABLE);
                    } else {

                        response = client.sendExam(request);
                        if (response.getStatus() == HttpStatus.OK.value())
                            return new ResponseEntity<>(response, HttpStatus.OK);
                        else
                            return new ResponseEntity<>(response, HttpStatus.NOT_ACCEPTABLE);

                    }
                }


            }


        } catch (TrainingException ex) {
            response.setStatus(HttpStatus.NOT_ACCEPTABLE.value());
            response.setMessage("بروز خطا در سیستم");
            return new ResponseEntity<>(response, HttpStatus.NOT_ACCEPTABLE);
        }
    }


    @GetMapping("/getEvalReport/{id}")
    public ResponseEntity<InputStreamResource> getEvalReport(@PathVariable long id) {


        EvalListResponse pdfResponse = client.getEvalResults(id);

        ByteArrayInputStream bis = GeneratePdfReport.ReportEvaluation(pdfResponse);
        HttpHeaders headers = new HttpHeaders();
        headers.add("Content-Disposition", "inline; filename=evaluation-" + System.currentTimeMillis() + ".pdf");

        return ResponseEntity
                .ok()
                .headers(headers)
                .contentType(MediaType.APPLICATION_PDF)
                .body(new InputStreamResource(bis));
    }


    @GetMapping("/printPdf/{id}/{national}/{fullName}")
    public void printPdf(HttpServletResponse response, @PathVariable long id,@PathVariable String national,@PathVariable String fullName) throws Exception {

        ExamListResponse pdfData = client.getExamResults(id);
        ExamResultDto data;


        data = pdfData.getData().stream()
                .filter(x -> x.getNationalCode().trim().equals(national.trim()))
                .findFirst()
                .get();

        String params="{\"student\":\""+fullName+"\"}";


        testQuestionService.printElsPdf(response, "pdf", "elsExam.jasper", id, params,data );


    }
}
