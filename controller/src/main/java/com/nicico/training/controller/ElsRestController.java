package com.nicico.training.controller;


import com.nicico.training.TrainingException;
import com.nicico.training.controller.client.els.ElsClient;
import com.nicico.training.controller.util.GeneratePdfReport;
import com.nicico.training.dto.*;
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
import dto.exam.ImportedUser;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.core.env.Environment;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import request.evaluation.ElsEvalRequest;
import request.evaluation.StudentEvaluationAnswerDto;
import request.evaluation.TeacherEvaluationAnswerDto;
import request.exam.ElsExamRequest;
import request.exam.ExamImportedRequest;
import response.BaseResponse;
import response.evaluation.EvalListResponse;
import response.evaluation.SendEvalToElsResponse;
import response.evaluation.dto.EvaluationAnswerObject;
import response.exam.ExamListResponse;
import response.exam.ExamQuestionsDto;
import response.exam.ExamResultDto;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
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
    private final TestQuestionService testQuestionService;
    private final IPersonnelService personnelService;
    private final IPersonnelRegisteredService personnelRegisteredService;
    private final EvaluationAnalysisService evaluationAnalysisService;

    private final Environment environment;


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
                request =evaluationBeanMapper.removeInvalidUsers(request);
                BaseResponse baseResponse = client.sendEvaluation(request);
                response.setMessage(baseResponse.getMessage());
                response.setStatus(baseResponse.getStatus());
            } catch (Exception r) {

                if (r.getCause().getMessage().equals("Read timed out")) {
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
            request =evaluationBeanMapper.removeInvalidUsers(request);
            BaseResponse baseResponse = client.sendEvaluationToTeacher(request);
            response.setMessage(baseResponse.getMessage());
            response.setStatus(baseResponse.getStatus());
        } catch (Exception r) {

            if (r.getCause().getMessage().equals("Read timed out")) {
                response.setMessage("اطلاعات به سیستم ارزشیابی آنلاین ارسال نشد");
                response.setStatus(HttpStatus.REQUEST_TIMEOUT.value());
                return new ResponseEntity(response, HttpStatus.valueOf(response.getStatus()));

            }

        }
        iTclassService.changeOnlineEvalTeacherStatus(evaluation.getClassId(), true);
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    @GetMapping("/evalResult/{id}")
    public ResponseEntity<EvalListResponse> getEvalResults(@PathVariable long id) {
        ;
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
            PersonalInfo teacherInfo = personalInfoService.getPersonalInfo(teacherService.getTeacher(object.getExamItem().getTclass().getTeacherId()).getPersonalityId());
            request = evaluationBeanMapper.toGetExamRequest(tclassService.getTClass(object.getExamItem().getTclassId()), teacherInfo, object, classStudentService.getClassStudents(object.getExamItem().getTclassId()));

            if (request.getInstructor() != null && request.getInstructor().getNationalCode() != null && evaluationBeanMapper.validateTeacherExam(request.getInstructor())) {
                if (request.getUsers() != null && !request.getUsers().isEmpty())
                {
                    try {
                        request =evaluationBeanMapper.removeInvalidUsersForExam(request);
                        response = client.sendExam(request);
                    }
                    catch (Exception e)
                    {
                        if (e.getCause().getMessage().equals("Read timed out")) {
                            response.setMessage("اطلاعات به سیستم ارزشیابی آنلاین ارسال نشد");
                            response.setStatus(HttpStatus.REQUEST_TIMEOUT.value());
                            return new ResponseEntity<>(response, HttpStatus.REQUEST_TIMEOUT);

                        }
                    }

                }
                else {
                    response.setStatus(HttpStatus.NOT_FOUND.value());
                    response.setMessage("دوره فراگیر ندارد");
                    return new ResponseEntity<>(response, HttpStatus.NOT_FOUND);
                }
            } else {
                response.setStatus(HttpStatus.NOT_ACCEPTABLE.value());
                response.setMessage("اطلاعات استاد تکمیل نیست");
                return new ResponseEntity<>(response, HttpStatus.NOT_ACCEPTABLE);
            }
            if (response.getStatus() == HttpStatus.OK.value()) {

                testQuestionService.changeOnlineFinalExamStatus(request.getExam().getSourceExamId(), true);
                return new ResponseEntity<>(response, HttpStatus.OK);
            } else return new ResponseEntity<>(response, HttpStatus.valueOf(response.getStatus()));

        } catch (TrainingException ex) {
                response.setStatus(HttpStatus.NOT_ACCEPTABLE.value());
                response.setMessage("بروز خطا در سیستم");
                return new ResponseEntity<>(response, HttpStatus.NOT_ACCEPTABLE);

        }
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
    public void printPdf(HttpServletResponse response, @PathVariable long id, @PathVariable String national, @PathVariable String name, @PathVariable String last, @PathVariable String fullName

    ) throws Exception {

        ExamListResponse pdfData = client.getExamResults(id);
        ExamResultDto data;

        data = pdfData.getData().stream().filter(x -> x.getNationalCode().trim().equals(national.trim())).findFirst().get();
        String params = "{\"student\":\"" + name + "" + last + "\"}";

        testQuestionService.printElsPdf(response, "pdf", "ElsExam.jasper", id, params, data);
    }


    @PostMapping("/examQuestions")
    public ResponseEntity<ExamQuestionsDto> examQuestions(@RequestBody ExamImportedRequest object) {

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");

        try {
            if (sdf.parse(object.getExamItem().getTclass().getStartDate()).compareTo(sdf.parse(object.getExamItem().getTclass().getEndDate())) != 0) {

                if (sdf.parse(object.getExamItem().getDate()).after(sdf.parse(object.getExamItem().getTclass().getStartDate()))) {
                    ExamQuestionsDto response = evaluationBeanMapper.toGetExamQuestions(object);
                    return new ResponseEntity(response, HttpStatus.OK);
                } else {
                    return new ResponseEntity("زمان برگذاری آزمون در بازه زمانی درست نمی باشد", HttpStatus.NOT_ACCEPTABLE);
                }
            } else {
                if (sdf.parse(object.getExamItem().getTclass().getStartDate()).compareTo(sdf.parse(object.getExamItem().getDate())) != 0) {
                    return new ResponseEntity("زمان برگذاری آزمون در بازه زمانی درست نمی باشد", HttpStatus.NOT_ACCEPTABLE);
                } else {
                    ExamQuestionsDto response = evaluationBeanMapper.toGetExamQuestions(object);
                    return new ResponseEntity(response, HttpStatus.OK);
                }
            }

        } catch (ParseException e) {

            return new ResponseEntity(new TrainingException(TrainingException.ErrorType.NotDeletable).getMessage(), HttpStatus.NOT_ACCEPTABLE);
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

        PersonnelDTO.PersonalityInfo personalInfoDTO = personnelService.getByNationalCode(nationalCode);
        return new ResponseEntity<>(personDTO, HttpStatus.OK);
    }

    @PostMapping("/student/addAnswer/evaluation")
    public BaseResponse addStudentEvaluationAnswer(HttpServletRequest header, @RequestBody StudentEvaluationAnswerDto dto) {
        BaseResponse response = new BaseResponse();

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

    }


    @PostMapping("/teacher/addAnswer/evaluation")
    public BaseResponse addTeacherEvaluationAnswer(HttpServletRequest header, @RequestBody TeacherEvaluationAnswerDto dto) {
        BaseResponse response = new BaseResponse();

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

    }

}
