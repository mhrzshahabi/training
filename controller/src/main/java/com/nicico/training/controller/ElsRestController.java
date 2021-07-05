package com.nicico.training.controller;


import com.nicico.training.TrainingException;
import com.nicico.training.controller.client.els.ElsClient;
import com.nicico.training.controller.minio.MinIoClient;
import com.nicico.training.controller.util.GeneratePdfReport;
import com.nicico.training.dto.*;
import com.nicico.training.dto.question.ElsExamRequestResponse;
import com.nicico.training.dto.question.ElsResendExamRequestResponse;
import com.nicico.training.dto.question.ExamQuestionsObject;
import com.nicico.training.iservice.IPersonnelRegisteredService;
import com.nicico.training.iservice.IPersonnelService;
import com.nicico.training.iservice.ITclassService;
import com.nicico.training.mapper.evaluation.EvaluationBeanMapper;
import com.nicico.training.mapper.person.PersonBeanMapper;
import com.nicico.training.model.Evaluation;
import com.nicico.training.model.PersonalInfo;
import com.nicico.training.model.enums.EGender;
import com.nicico.training.service.*;
import dto.evaluuation.EvalTargetUser;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.core.env.Environment;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import request.evaluation.ElsEvalRequest;
import request.evaluation.StudentEvaluationAnswerDto;
import request.evaluation.TeacherEvaluationAnswerDto;
import request.exam.*;
import response.BaseResponse;
import response.evaluation.EvalListResponse;
import response.evaluation.SendEvalToElsResponse;
import response.evaluation.dto.EvalAverageResult;
import response.evaluation.dto.EvaluationAnswerObject;
import response.exam.ExamListResponse;
import response.exam.ExamQuestionsDto;
import response.exam.ResendExamTimes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;


@RestController
@RequestMapping("/anonymous/els")
@RequiredArgsConstructor
public class ElsRestController {

    private final ModelMapper modelMapper;
    private final EvaluationBeanMapper evaluationBeanMapper;
    private final PersonBeanMapper personBeanMapper;
    private final EvaluationAnswerService answerService;
    private final QuestionnaireService questionnaireService;
    private final EvaluationService evaluationService;
    private final ClassStudentService classStudentService;
    private final TclassService tclassService;
    private final TeacherService teacherService;
    private final ITclassService iTclassService;
    private final PersonalInfoService personalInfoService;
    private final ElsClient client;
    private final MinIoClient client2;
    private final TestQuestionService testQuestionService;
    private final IPersonnelService personnelService;
    private final IPersonnelRegisteredService personnelRegisteredService;
    private final EvaluationAnalysisService evaluationAnalysisService;
    private final Environment environment;
    private final ElsService elsService;


    @GetMapping("/eval/{id}")
    public ResponseEntity<SendEvalToElsResponse> sendEvalToEls(@PathVariable long id) {
        SendEvalToElsResponse response = new SendEvalToElsResponse();
        Evaluation evaluation = evaluationService.getById(id);
        ElsEvalRequest request = evaluationBeanMapper.toElsEvalRequest(evaluation, questionnaireService.get(evaluation.getQuestionnaireId()), classStudentService.getClassStudents(evaluation.getClassId()), evaluationService.getEvaluationQuestions(answerService.getAllByEvaluationId(evaluation.getId())), personalInfoService.getPersonalInfo(teacherService.getTeacher(evaluation.getTclass().getTeacherId()).getPersonalityId()));

        if (!evaluationBeanMapper.validateTargetUser(request.getTeacher())) {
            response.setMessage("اطلاعات استاد تکمیل نیست");
            response.setStatus(HttpStatus.NOT_ACCEPTABLE.value());

            return new ResponseEntity<>(response, HttpStatus.NOT_ACCEPTABLE);
        } else {
            try {
                request = evaluationBeanMapper.removeInvalidUsers(request);
                if (!request.getTargetUsers().isEmpty()) {
                    BaseResponse baseResponse = client.sendEvaluation(request);
                    response.setMessage(baseResponse.getMessage());
                    response.setStatus(baseResponse.getStatus());
                } else {
                    response.setMessage("دوره فراگیری با اطلاعات کامل ندارد.");
                    response.setStatus(HttpStatus.NOT_FOUND.value());
                    return new ResponseEntity<>(response, HttpStatus.NOT_FOUND);
                }

            } catch (Exception r) {

                if (r.getCause() != null && r.getCause().getMessage() != null && r.getCause().getMessage().equals("Read timed out")) {
                    response.setMessage("اطلاعات به سیستم ارزشیابی آنلاین ارسال نشد");
                    response.setStatus(HttpStatus.REQUEST_TIMEOUT.value());
                    return new ResponseEntity<>(response, HttpStatus.REQUEST_TIMEOUT);

                }

            }
            iTclassService.changeOnlineEvalStudentStatus(evaluation.getClassId(), true);
            return new ResponseEntity<>(response, HttpStatus.valueOf(response.getStatus()));
        }
    }

    @GetMapping("/teacherEval/{id}")
    public ResponseEntity<SendEvalToElsResponse> sendEvalToElsForTeacher(@PathVariable long id) {
        SendEvalToElsResponse response = new SendEvalToElsResponse();
        Evaluation evaluation = evaluationService.getById(id);
        ElsEvalRequest request = evaluationBeanMapper.toElsEvalRequest(evaluation, questionnaireService.get(evaluation.getQuestionnaireId()), classStudentService.getClassStudents(evaluation.getClassId()), evaluationService.getEvaluationQuestions(answerService.getAllByEvaluationId(evaluation.getId())), personalInfoService.getPersonalInfo(teacherService.getTeacher(evaluation.getTclass().getTeacherId()).getPersonalityId()));
        try {
            request = evaluationBeanMapper.removeInvalidUsers(request);
            BaseResponse baseResponse = client.sendEvaluationToTeacher(request);
            response.setMessage(baseResponse.getMessage());
            response.setStatus(baseResponse.getStatus());
        } catch (Exception r) {

            if (r.getCause() != null && r.getCause().getMessage() != null && r.getCause().getMessage().equals("Read timed out")) {
                response.setMessage("اطلاعات به سیستم ارزشیابی آنلاین ارسال نشد");
                response.setStatus(HttpStatus.REQUEST_TIMEOUT.value());
                return new ResponseEntity(response, HttpStatus.valueOf(response.getStatus()));

            }

        }
        iTclassService.changeOnlineEvalTeacherStatus(evaluation.getClassId(), true);
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    @PostMapping("/examToEls/{type}")
    public ResponseEntity sendExam(@RequestBody ExamImportedRequest object, @PathVariable String type) {
        BaseResponse response = new BaseResponse();
        final ElsExamRequestResponse elsExamRequestResponse;

        try {
            ElsExamRequest request;
            PersonalInfo teacherInfo = personalInfoService.getPersonalInfo(teacherService.getTeacher(object.getExamItem().getTclass().getTeacherId()).getPersonalityId());

            if (type.equals("preTest"))
                elsExamRequestResponse = evaluationBeanMapper.toGetPreExamRequest(tclassService.getTClass(object.getExamItem().getTclassId()), teacherInfo, object, classStudentService.getClassStudents(object.getExamItem().getTclassId()));
            else
                elsExamRequestResponse = evaluationBeanMapper.toGetExamRequest(tclassService.getTClass(object.getExamItem().getTclassId()), teacherInfo, object, classStudentService.getClassStudents(object.getExamItem().getTclassId()));

            if (elsExamRequestResponse.getStatus() == 200) {
                request = elsExamRequestResponse.getElsExamRequest();
                if (request.getInstructor() != null && request.getInstructor().getNationalCode() != null &&
                        evaluationBeanMapper.validateTeacherExam(request.getInstructor())) {
                    try {
                        request = evaluationBeanMapper.removeInvalidUsersForExam(request);
                        if (object.isDeleteAbsentUsers())
                        {
                            request = evaluationBeanMapper.removeAbsentUsersForExam(request,object.getAbsentUsers());
                        }
                        if (request.getUsers() != null && !request.getUsers().isEmpty()) {
                            response = client.sendExam(request);
                        } else {
                            response.setStatus(HttpStatus.NOT_FOUND.value());
                            response.setMessage("دوره فراگیر ندارد");
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
                    return new ResponseEntity<>(response, HttpStatus.OK);
                } else
                    return new ResponseEntity<>(response, HttpStatus.valueOf(response.getStatus()));
            } else {
                response.setStatus(elsExamRequestResponse.getStatus());
                response.setMessage(elsExamRequestResponse.getMessage());
                return new ResponseEntity<>(response, HttpStatus.NOT_ACCEPTABLE);
            }

        } catch (TrainingException ex) {
            response.setStatus(HttpStatus.NOT_ACCEPTABLE.value());
            response.setMessage("بروز خطا در سیستم");
            return new ResponseEntity<>(response, HttpStatus.NOT_ACCEPTABLE);

        }
    }

    @PostMapping("/resendExamToEls")
    public ResponseEntity resendExam(@RequestBody ResendExamImportedRequest object) {
        BaseResponse response = new BaseResponse();
        try {
            ElsExtendedExamRequest request;

            ElsResendExamRequestResponse elsExamRequestResponse = evaluationBeanMapper.toGetResendExamRequest(object);
            if (elsExamRequestResponse.getStatus() == 200) {
                request = elsExamRequestResponse.getElsResendExamRequest();
                try {
                    request = evaluationBeanMapper.removeInvalidUsersForResendExam(request);
                    if (request.getUsers() != null && !request.getUsers().isEmpty()) {
                        response = client.resendExam(request);
                    } else {
                        response.setStatus(HttpStatus.NOT_FOUND.value());
                        response.setMessage("هیچ فراگیری انتخاب نشده است");
                        return new ResponseEntity<>(response, HttpStatus.NOT_FOUND);
                    }
                } catch (Exception e) {
                    if (e.getCause() != null && e.getCause().getMessage() != null && e.getCause().getMessage().equals("Read timed out")) {
                        response.setMessage("اطلاعات به سیستم آزمون آنلاین ارسال نشد");
                        response.setStatus(HttpStatus.REQUEST_TIMEOUT.value());
                        return new ResponseEntity<>(response, HttpStatus.REQUEST_TIMEOUT);

                    }
                }


                if (response.getStatus() == HttpStatus.OK.value()) {
                    return new ResponseEntity<>(response, HttpStatus.OK);
                } else return new ResponseEntity<>(response, HttpStatus.valueOf(response.getStatus()));
            } else {
                response.setStatus(elsExamRequestResponse.getStatus());
                response.setMessage(elsExamRequestResponse.getMessage());
                return new ResponseEntity<>(response, HttpStatus.NOT_ACCEPTABLE);
            }

        } catch (TrainingException ex) {
            response.setStatus(HttpStatus.NOT_ACCEPTABLE.value());
            response.setMessage("بروز خطا در سیستم");
            return new ResponseEntity<>(response, HttpStatus.NOT_ACCEPTABLE);

        }
    }

    @PostMapping("/checkForResendExamToEls")
    public ResponseEntity checkForResendExamToEls(@RequestBody ResendExamImportedRequest object) {
        BaseResponse response = new BaseResponse();
        try {
            ExamListResponse examListResponse = client.getExamResults(object.getSourceExamId());
            List<String> userWithAnswer = evaluationBeanMapper.getUsersWithAnswer(examListResponse.getData(), object.getUsers());
            if (userWithAnswer.isEmpty()) {
                response.setStatus(200);
                return new ResponseEntity<>(response, HttpStatus.OK);

            } else {
                String joinedNames = String.join(System.lineSeparator(), userWithAnswer);
                response.setStatus(409);
                response.setMessage("کاربران مقابل یک بار جواب این آزمون را داده اند. درصورتی که آزمون مجدد برایشان ارسال شود جواب قبلی آنها پاک خواهد شد:" + System.lineSeparator() + joinedNames);
                return new ResponseEntity<>(response, HttpStatus.CONFLICT);

            }

        } catch (Exception e) {
            response.setMessage("خطا در ارتباط با آموزش آنلاین");
            return new ResponseEntity<>(response, HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @GetMapping("/examResult/{id}")
    public ResponseEntity<ExamListResponse> examResult(@PathVariable long id) {
        ExamListResponse response = client.getExamResults(id);
        if (response.getData() != null)
            response = evaluationBeanMapper.toExamResult(response);
        return new ResponseEntity(response, HttpStatus.OK);
    }

    @GetMapping("/evalResult/{id}")
    public ResponseEntity<EvalListResponse> getEvalResults(@PathVariable long id) {
        EvalListResponse response = client.getEvalResults(id);
        return new ResponseEntity(response, HttpStatus.OK);
    }

    @GetMapping("/getClassStudent/{id}")
    public List<EvalTargetUser> getClassStudent(@PathVariable long id) {
        return evaluationBeanMapper.getClassUsers(classStudentService.getClassStudents(id));
    }

    @GetMapping("/getEvalReport/{id}")
    public ResponseEntity<InputStreamResource> getEvalReport(@PathVariable long id) {
        EvalListResponse pdfResponse = client.getEvalResults(id);
        ByteArrayInputStream bis = GeneratePdfReport.ReportEvaluation(pdfResponse);
        HttpHeaders headers = new HttpHeaders();
        headers.add("Content-Disposition", "inline; filename=evaluation-" + System.currentTimeMillis() + ".pdf");
        return ResponseEntity.ok().headers(headers).contentType(MediaType.APPLICATION_PDF).body(new InputStreamResource(bis));
    }

    @PostMapping("/printPdf/{id}/{national}/{name}/{last}/{fullName}")
    public void printPdf(HttpServletResponse response, @PathVariable long id, @PathVariable String national, @PathVariable String name, @PathVariable String last, @PathVariable String fullName) throws Exception {
        ExamListResponse pdfData = client.getExamResults(id);
        response.exam.ExamResultDto data;
        data = pdfData.getData().stream().filter(x -> x.getNationalCode().trim().equals(national.trim())).findFirst().get();
        String params = "{\"student\":\"" + name + "" + last + "\"}";
        testQuestionService.printElsPdf(response, "pdf", "ElsExam.jasper", id, params, data);
    }


    @PostMapping("/examQuestions")
    public ResponseEntity<ExamQuestionsDto> examQuestions(@RequestBody ExamImportedRequest object) {

        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd");
        ExamQuestionsObject examQuestionsObject = new ExamQuestionsObject();
        ExamQuestionsDto response = new ExamQuestionsDto();
        try {
//            if (dateFormat.parse(object.getExamItem().getTclass().getStartDate()).compareTo(dateFormat.parse(object.getExamItem().getTclass().getEndDate())) != 0) {

            if (dateFormat.parse(object.getExamItem().getDate()).after(dateFormat.parse(object.getExamItem().getTclass().getStartDate()))) {
                /*ExamQuestionsDto response*/
                examQuestionsObject = evaluationBeanMapper.toGetExamQuestions(object);
                if (examQuestionsObject.getStatus() == 200) {
                    response.setData(examQuestionsObject.getDto().getData());
                    return new ResponseEntity(response, HttpStatus.OK);
                } else {
                    return new ResponseEntity(examQuestionsObject.getMessage(), HttpStatus.NOT_ACCEPTABLE); // سوال تکراری در آزمون وجود دارد
                }
            } else {
                return new ResponseEntity("زمان برگذاری آزمون در بازه زمانی درست نمی باشد", HttpStatus.NOT_ACCEPTABLE);
            }
//            } else {
//                if (dateFormat.parse(object.getExamItem().getTclass().getStartDate()).compareTo(dateFormat.parse(object.getExamItem().getDate())) != 0) {
//                    return new ResponseEntity("زمان برگذاری آزمون در بازه زمانی درست نمی باشد", HttpStatus.NOT_ACCEPTABLE);
//                } else {
//                    examQuestionsObject = evaluationBeanMapper.toGetExamQuestions(object);
//                    if(examQuestionsObject.getStatus() == 200) {
//                        response.setData(examQuestionsObject.getDto().getData());
//                        return new ResponseEntity(response, HttpStatus.OK);
//                    }else {
//                        return new ResponseEntity(examQuestionsObject.getMessage(), HttpStatus.NOT_ACCEPTABLE); // سوال تکراری در آزمون وجود دارد
//                    }
//                }
//            }

        } catch (ParseException e) {

            return new ResponseEntity(new TrainingException(TrainingException.ErrorType.NotDeletable).getMessage(), HttpStatus.NOT_ACCEPTABLE);
        }


    }

    @PostMapping("/preExamQuestions")
    public ResponseEntity<ExamQuestionsDto> preExamQuestions(@RequestBody ExamImportedRequest object) {

        ExamQuestionsObject examQuestionsObject = new ExamQuestionsObject();
        ExamQuestionsDto response = new ExamQuestionsDto();

        /*ExamQuestionsDto response*/
        examQuestionsObject = evaluationBeanMapper.toGetExamQuestions(object);
        if (examQuestionsObject.getStatus() == 200) {
            response.setData(examQuestionsObject.getDto().getData());
            return new ResponseEntity(response, HttpStatus.OK);
        } else {
            return new ResponseEntity(examQuestionsObject.getMessage(), HttpStatus.NOT_ACCEPTABLE); // سوال تکراری در آزمون وجود دارد
        }
    }

    @GetMapping(value = "/peopleByNationalCode/{nationalCode}")
    public ResponseEntity<PersonDTO> findPeopleByNationalCode(@PathVariable String nationalCode) {
        PersonDTO personDTO = new PersonDTO();
        PersonnelDTO.PersonalityInfo personnel = personnelService.getByNationalCode(nationalCode);
        PersonnelRegisteredDTO.Info personnelRegistered = null;
        PersonalInfoDTO.Info personalInfo = personalInfoService.getOneByNationalCode(nationalCode);
        List<String> roles = new ArrayList<>();
        if (personnel != null) {
            personBeanMapper.setPersonnelFields(personDTO, personnel);
            String role = "User";
            roles.add(role);
        } else {
            personnelRegistered = personnelRegisteredService.getOneByNationalCode(nationalCode);
            if (personnelRegistered != null) {
                personBeanMapper.setPersonnelRegisteredFields(personDTO, personnelRegistered);
                String role = "User";
                roles.add(role);
            }
        }
        //if user is a teacher or a company owner
        if (personalInfo != null) {
            String role = "Instructor";
            roles.add(role);
            if (personnel == null && personnelRegistered == null) {
                personBeanMapper.setPersonalInfoFields(personDTO, personalInfo);
            } else {
                // we fill fields if there are valid values in other objects
                if (personDTO.getEmail() == null && personalInfo.getContactInfo() != null && personalInfo.getContactInfo().getEmail() != null) {
                    personDTO.setEmail(personalInfo.getContactInfo().getEmail());
                }
                if (personDTO.getAddress() == null && personalInfo.getContactInfo() != null && personalInfo.getContactInfo().getHomeAddress() != null) {
                    personDTO.setAddress(personalInfo.getContactInfo().getHomeAddress().getRestAddr());
                }
                if (personDTO.getMobile() == null && personalInfo.getContactInfo() != null && personalInfo.getContactInfo().getMobile() != null) {
                    personDTO.setMobile(personBeanMapper.checkMobileFormat(personalInfo.getContactInfo().getMobile()));
                }
                if (personDTO.getPhone() == null && personalInfo.getContactInfo() != null && personalInfo.getContactInfo().getHomeAddress() != null) {
                    personDTO.setPhone(personalInfo.getContactInfo().getHomeAddress().getPhone());
                }
                if (personDTO.getBirthDate() == null && personalInfo.getBirthDate() != null) {
                    personDTO.setBirthDate(personalInfo.getBirthDate());
                }
                if (personDTO.getGender() == null && personalInfo.getGenderId() != null) {
                    if (personalInfo.getGenderId().equals(EGender.Male.getId())) {
                        personDTO.setGender(0);
                    } else {
                        personDTO.setGender(1);
                    }
                }
                if (personDTO.getEducationLevelTitle() == null && personalInfo.getEducationLevel() != null) {
                    personDTO.setEducationLevelTitle(personalInfo.getEducationLevel().getTitleFa());
                }
                if (personDTO.getEducationMajorTitle() == null && personalInfo.getEducationMajor() != null) {
                    personDTO.setEducationMajorTitle(personalInfo.getEducationMajor().getTitleFa());
                }
            }

        }
        if (personnel != null || personnelRegistered != null || personalInfo != null) {
            personDTO.setRoles(roles);
        }
        return new ResponseEntity<>(personDTO, HttpStatus.OK);
    }

    @PostMapping("/student/addAnswer/evaluation")
    public BaseResponse addStudentEvaluationAnswer(HttpServletRequest header, @RequestBody StudentEvaluationAnswerDto dto) {
        BaseResponse response = new BaseResponse();

        try {
            if (Objects.requireNonNull(environment.getProperty("nicico.training.pass")).trim().equals(header.getHeader("X-Auth-Token"))) {
                EvaluationAnswerObject answerObject = tclassService.classStudentEvaluations(dto);
                EvaluationDTO.Update update = modelMapper.map(answerObject, EvaluationDTO.Update.class);
                EvaluationDTO.Info info = evaluationService.update(answerObject.getId(), update);
                evaluationAnalysisService.updateReactionEvaluation(info.getClassId());
                response.setStatus(200);
            } else {
                response.setStatus(HttpStatus.UNAUTHORIZED.value());

            }
            return response;
        } catch (Exception e) {
            response.setStatus(HttpStatus.NOT_FOUND.value());
            response.setMessage("ارزیابی مورد نظر در سیستم آموزش حذف شده است");

            return response;
        }

    }


    @PostMapping("/teacher/addAnswer/evaluation")
    public BaseResponse addTeacherEvaluationAnswer(HttpServletRequest header, @RequestBody TeacherEvaluationAnswerDto dto) {
        BaseResponse response = new BaseResponse();
        try {
            if (Objects.requireNonNull(environment.getProperty("nicico.training.pass")).trim().equals(header.getHeader("X-Auth-Token"))) {
                EvaluationAnswerObject answerObject = tclassService.classTeacherEvaluations(dto);
                EvaluationDTO.Update update = modelMapper.map(answerObject, EvaluationDTO.Update.class);
                EvaluationDTO.Info info = evaluationService.update(answerObject.getId(), update);
                evaluationAnalysisService.updateReactionEvaluation(info.getClassId());
                response.setStatus(200);
            } else {
                response.setStatus(HttpStatus.UNAUTHORIZED.value());
            }
            return response;
        } catch (Exception e) {
            response.setStatus(HttpStatus.NOT_FOUND.value());
            response.setMessage("ارزیابی مورد نظر در سیستم آموزش حذف شده است");
            return response;
        }

    }

    @PostMapping("/final/test/{id}")
    public BaseResponse setFinalScores(@PathVariable long id, @RequestBody List<ExamResult> examResult) {
        BaseResponse baseResponse = new BaseResponse();
        boolean checkValidScores = evaluationBeanMapper.checkValidScores(examResult);
        if (!checkValidScores) {
            baseResponse.setStatus(406);
            baseResponse.setMessage("مقدار های وارد شده صحیح نمی باشد");

        } else {
            String scoringMethod = testQuestionService.get(id).getTclass().getScoringMethod();
            boolean checkScoreInRange = evaluationBeanMapper.checkScoreInRange(scoringMethod, examResult);
            if (!checkScoreInRange) {
                baseResponse.setStatus(406);
                baseResponse.setMessage("نمرات نهایی وارد شده از بیشترین مقدار روش نمره دهی کلاس بیشتر است");

            } else {
                UpdateRequest requestDto = evaluationBeanMapper.convertScoresToDto(examResult, id);
                try {
                    baseResponse = client.sendScoresToEls(requestDto);
                    if (baseResponse.getStatus() != 200 && baseResponse.getMessage() != null)
                        return baseResponse;
                } catch (Exception e) {
                    baseResponse.setMessage("اطلاعات به سیستم ارزشیابی آنلاین ارسال نشد");
                    baseResponse.setStatus(HttpStatus.REQUEST_TIMEOUT.value());
                    return baseResponse;

                }
            }
        }
        return baseResponse;
    }

    @GetMapping(value = "/extendedList/{sourceExamId}")
    public ResponseEntity<ResendExamTimes> getResendExamTimes(@PathVariable long sourceExamId){
        ResendExamTimes resendExamTimes=client.getResendExamTimes(sourceExamId);

        if (resendExamTimes.getStatus()== HttpStatus.OK.value())
        {
            return new ResponseEntity<>(resendExamTimes, HttpStatus.OK);

        }
        else
            return new ResponseEntity<>(resendExamTimes, HttpStatus.NOT_ACCEPTABLE);




    }


    @RequestMapping(value = {"/download/{group}/{key}/{token}"}, method = RequestMethod.GET)
    @Transactional
    public ResponseEntity<ByteArrayResource> downloadWithKey(HttpServletRequest request, HttpServletResponse response, @PathVariable String group
            , @PathVariable String key
            , @PathVariable String token
    ) throws IOException {

        ByteArrayResource file= client2.downloadFile("Bearer " +token ,group,key);
        try {
            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" +file.getFilename()+  "\"")
                    .body(file);
        } catch ( Exception e) {
            e.printStackTrace();
            return null;
        }

    }

    @GetMapping("/averageResult/{classId}")
    public EvalAverageResult getEvaluationAverageResultToTeacher(HttpServletRequest header, @PathVariable Long classId) {

        EvalAverageResult evaluationAverageResultToInstructor = new EvalAverageResult();
        if (Objects.requireNonNull(environment.getProperty("nicico.training.pass")).trim().equals(header.getHeader("X-Auth-Token"))) {

            evaluationAverageResultToInstructor = tclassService.getEvaluationAverageResultToTeacher(classId);
            evaluationAverageResultToInstructor.setStatus(200);
            return evaluationAverageResultToInstructor;
        } else {
            evaluationAverageResultToInstructor.setStatus(HttpStatus.UNAUTHORIZED.value());
            return evaluationAverageResultToInstructor;
        }
    }

    @GetMapping("/classToEls/{classId}")
    public BaseResponse sendClass(@PathVariable Long classId) {

        BaseResponse response = new BaseResponse();
        try {

            ElsExamRequest elsExamRequest = evaluationBeanMapper.toElsExamRequest(classId);
            response = client.sendClass(elsExamRequest);
            if (response.getStatus() == HttpStatus.OK.value())
                tclassService.changeClassToOnlineStatus(classId, true);

        } catch (TrainingException ex) {

            response.setMessage("اطلاعات به سیستم آزمون آنلاین ارسال نشد");
            response.setStatus(HttpStatus.NOT_ACCEPTABLE.value());
        }
        return response;
    }

}
