package com.nicico.training.controller;

import com.nicico.copper.common.Loggable;
import com.nicico.training.controller.client.els.ElsClient;
import com.nicico.training.dto.question.ElsExamRequestResponse;
import com.nicico.training.iservice.*;
import com.nicico.training.mapper.evaluation.EvaluationBeanMapper;
import com.nicico.training.model.*;
import com.nicico.training.service.PersonalInfoService;
import dto.Question.QuestionBankData;
import dto.Question.QuestionData;
import dto.Question.QuestionScores;
import dto.Question.QuestionTypeData;
import dto.evaluuation.EvalTargetUser;
import dto.exam.ExamClassData;
import dto.exam.ExamData;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import request.exam.ElsExamRequest;
import request.exam.ExamImportedRequest;
import response.BaseResponse;
import response.exam.ElsExamMonitoringRespDto;
import response.exam.ElsExamStudentsStateDto;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;


@RequiredArgsConstructor
@RestController
@RequestMapping("/api/exam-monitoring")
public class ExamMonitoringRestController {

    private final ElsClient elsClient;
    private final ModelMapper modelMapper;
    private final ITclassService classService;
    private final IStudentService studentService;
    private final ITeacherService teacherService;
    private final PersonalInfoService personalInfoService;
    private final ITestQuestionService testQuestionService;
    private final IClassStudentService classStudentService;
    private final IQuestionBankService questionBankService;
    private final EvaluationBeanMapper evaluationBeanMapper;
    private final IExamMonitoringService examMonitoringService;
    private final IParameterValueService parameterValueService;
    private final IQuestionProtocolService questionProtocolService;
    private final IQuestionBankTestQuestionService questionBankTestQuestionService;

    @GetMapping(value = "/list/{classCode}")
    public ResponseEntity<ISC<ElsExamStudentsStateDto>> getExamMonitoring(@RequestParam(value = "_startRow", required = false) Integer startRow,
                                                                          @RequestParam(value = "_endRow", required = false) Integer endRow,
                                                                          @PathVariable String classCode) {

        ISC.Response<ElsExamStudentsStateDto> response = new ISC.Response<>();
        try {
            ElsExamMonitoringRespDto respDto = elsClient.getExamMonitoring(classCode, "FinalTest");
            if (respDto.getExamParticipants() != null) {
                List<ElsExamStudentsStateDto> studentList = examMonitoringService.getExamMonitoringData(respDto.getExamParticipants());

                response.setStartRow(startRow);
                response.setEndRow(startRow + studentList.size());
                response.setTotalRows(studentList.size());
                response.setData(studentList);
            }

            ISC<ElsExamStudentsStateDto> infoISC = new ISC<>(response);
            return new ResponseEntity<>(infoISC, HttpStatus.OK);
        } catch (Exception e) {
            ISC<ElsExamStudentsStateDto> infoISC = new ISC<>(response);
            return new ResponseEntity<>(infoISC, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @Loggable
    @PostMapping(value = "/send-preparation-test/{classId}")
    public ResponseEntity sendPreparationTest(@PathVariable Long classId) {
        ElsExamRequest request;
        BaseResponse response = new BaseResponse();
        final ElsExamRequestResponse elsExamRequestResponse;

        try {

            List<QuestionBank> questionBankList = questionBankService.findAllByCreateBy("preparation_test");
            List<Long> questionIds = questionBankList.stream().map(QuestionBank::getId).collect(Collectors.toList());
            questionBankTestQuestionService.addQuestions("Preparation", classId, questionIds);
            TestQuestion testQuestion = testQuestionService.findByTestQuestionTypeAndTclassId("Preparation", classId);

            ExamImportedRequest examImportedRequest = new ExamImportedRequest();

            Tclass tClass = classService.getTClass(classId);
            ExamClassData examClassData = modelMapper.map(tClass, ExamClassData.class);

            ExamData examData = new ExamData();
            examData.setTclassId(classId);
            examData.setTclass(examClassData);
            examData.setId(testQuestion.getId());
            examImportedRequest.setExamItem(examData);

            List<QuestionData> questionDataList = new ArrayList<>();
            questionBankList.forEach(questionBank -> {
                QuestionData questionData = new QuestionData();
                QuestionBankData questionBankData = new QuestionBankData();
                QuestionTypeData questionTypeData = new QuestionTypeData();

                questionTypeData.setTitle(parameterValueService.getInfo(questionBank.getQuestionTypeId()).getTitle());

                questionBankData.setQuestion(questionBank.getQuestion());
                questionBankData.setIsChild(questionBank.getIsChild());
                questionBankData.setChildPriority(questionBank.getChildPriority());
                questionBankData.setQuestionType(questionTypeData);
                questionBankData.setId(questionBank.getId());

                QuestionBankTestQuestion questionBankTestQuestion = questionBankTestQuestionService.findByTestQuestionIdAndQuestionBankId(testQuestion.getId(), questionBank.getId());
                questionData.setId(questionBankTestQuestion != null ? questionBankTestQuestion.getId() : null);
                questionData.setTestQuestionId(testQuestion.getId());
                questionData.setQuestionBankId(questionBank.getId());
                questionData.setQuestionBank(questionBankData);

                questionDataList.add(questionData);
            });
            examImportedRequest.setQuestions(questionDataList);

            List<QuestionScores> questionScoresList = new ArrayList<>();
            questionBankList.forEach(questionBank -> {
                QuestionScores questionScores = new QuestionScores();
                questionScores.setId(questionBank.getId());
                questionScores.setQuestion(questionBank.getQuestion());
                questionScores.setScore("4");
                questionScoresList.add(questionScores);
            });
            examImportedRequest.setQuestionData(questionScoresList);

            PersonalInfo teacherInfo = personalInfoService.getPersonalInfo(teacherService.getTeacher(examImportedRequest.getExamItem().getTclass().getTeacherId()).getPersonalityId());
            elsExamRequestResponse = evaluationBeanMapper.toGetPreExamRequest(classService.getTClass(examImportedRequest.getExamItem().getTclassId()), teacherInfo, examImportedRequest, classStudentService.getClassStudents(examImportedRequest.getExamItem().getTclassId()), "Preparation");


            if (elsExamRequestResponse.getStatus() == 200) {
                request = elsExamRequestResponse.getElsExamRequest();
                if (request.getInstructor() != null && request.getInstructor().getNationalCode() != null &&
                        evaluationBeanMapper.validateTeacherExam(request.getInstructor())) {
                    try {
                        request = evaluationBeanMapper.removeInvalidUsersForExam(request);
                        if (examImportedRequest.isDeleteAbsentUsers()) {
                            request = evaluationBeanMapper.removeAbsentUsersForExam(request, examImportedRequest.getAbsentUsers());
                        }
                        if (request.getUsers() != null && !request.getUsers().isEmpty()) {
                            questionProtocolService.saveQuestionProtocol(request.getExam().getSourceExamId(), request.getQuestionProtocols());
                            response = elsClient.sendExam(request);
                        } else {
                            response.setStatus(HttpStatus.NOT_FOUND.value());
                            response.setMessage("دوره فراگیر ندارد .");
                            return new ResponseEntity<>(response, HttpStatus.NOT_FOUND);
                        }
                    } catch (Exception e) {
                        if (e.getCause() != null && e.getCause().getMessage() != null && e.getCause().getMessage().equals("Read timed out")) {
                            response.setMessage("اطلاعات به سیستم ارزشیابی آنلاین ارسال نشد");
                            response.setStatus(HttpStatus.REQUEST_TIMEOUT.value());
                            return new ResponseEntity<>(response, HttpStatus.REQUEST_TIMEOUT);

                        }
                    }

                } else {
                    response.setStatus(HttpStatus.NOT_ACCEPTABLE.value());
                    response.setMessage("اطلاعات استاد تکمیل نیست");
                    return new ResponseEntity<>(response, HttpStatus.NOT_ACCEPTABLE);
                }
                if (response.getStatus() == HttpStatus.OK.value()) {
                    testQuestionService.changeOnlineFinalExamStatus(request.getExam().getSourceExamId(), true);
                    studentService.updateHasPreparationTestByNationalCodes(request.getUsers().stream().map(EvalTargetUser::getNationalCode).collect(Collectors.toList()), true);
                    return new ResponseEntity<>(response, HttpStatus.OK);
                } else
                    return new ResponseEntity<>(response, HttpStatus.valueOf(response.getStatus()));
            } else {
                response.setStatus(elsExamRequestResponse.getStatus());
                response.setMessage(elsExamRequestResponse.getMessage());
                return new ResponseEntity<>(response, HttpStatus.NOT_ACCEPTABLE);
            }

        } catch (Exception e) {
            response.setStatus(HttpStatus.BAD_REQUEST.value());
            response.setMessage("عملیات انجام نشد");
            return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
        }

    }

}
