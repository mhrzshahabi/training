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

import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;



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

    @GetMapping("/eval/{id}")
    public ResponseEntity<SendEvalToElsResponse> sendEvalToEls(@PathVariable long id) {
        SendEvalToElsResponse response = new SendEvalToElsResponse();

        Evaluation evaluation = evaluationService.getById(id);
        ElsEvalRequest request = evaluationBeanMapper.toElsEvalRequest(evaluation, questionnaireService.get(evaluation.getQuestionnaireId()), classStudentService.getClassStudents(evaluation.getClassId()), evaluationService.getEvaluationQuestions(answerService.getAllByEvaluationId(evaluation.getId())), personalInfoService.getPersonalInfo(teacherService.getTeacher(evaluation.getTclass().getTeacherId()).getPersonalityId()));

        if (!validateTeacher(request.getTeacher())) {
            response.setMessage("اطلاعات استاد تکمیل نیست");
            response.setStatus(HttpStatus.NOT_ACCEPTABLE.value());

            return new ResponseEntity<>(response, HttpStatus.NOT_ACCEPTABLE);
        } else {

            BaseResponse baseResponse = client.sendEvaluation(request);
            response.setMessage(baseResponse.getMessage());
            response.setStatus(baseResponse.getStatus());
            iTclassService.changeOnlineEvalStudentStatus(evaluation.getClassId(), true);

            return new ResponseEntity<>(response, HttpStatus.OK);
        }
    }

    private boolean validateTeacher(EvalTargetUser teacher) {

        boolean isValid = true;

        if (teacher.getGender() == null) isValid = false;
        if (teacher.getNationalCode().length() != 10 || !teacher.getNationalCode().matches("\\d+")) isValid = false;
        if ((teacher.getCellNumber().length() != 10 && teacher.getCellNumber().length() != 11) || !teacher.getCellNumber().matches("\\d+"))
            isValid = false;
        if (teacher.getCellNumber().length() == 10 && !(teacher.getCellNumber().startsWith("9"))) isValid = false;
        if (teacher.getCellNumber().length() == 11 && !(teacher.getCellNumber().startsWith("09"))) isValid = false;

        return isValid;
    }

    @GetMapping("/teacherEval/{id}")
    public ResponseEntity<SendEvalToElsResponse> sendEvalToElsForTeacher(@PathVariable long id) {

        SendEvalToElsResponse response = new SendEvalToElsResponse();

        Evaluation evaluation = evaluationService.getById(id);
        ElsEvalRequest request = evaluationBeanMapper.toElsEvalRequest(evaluation, questionnaireService.get(evaluation.getQuestionnaireId()), classStudentService.getClassStudents(evaluation.getClassId()), evaluationService.getEvaluationQuestions(answerService.getAllByEvaluationId(evaluation.getId())), personalInfoService.getPersonalInfo(teacherService.getTeacher(evaluation.getTclass().getTeacherId()).getPersonalityId()));

        BaseResponse baseResponse = client.sendEvaluationToTeacher(request);
        response.setMessage(baseResponse.getMessage());
        response.setStatus(baseResponse.getStatus());
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

            if (request.getInstructor()!=null && request.getInstructor().getNationalCode()!=null && validateTeacherExam(request.getInstructor()))
            {
                response = client.sendExam(request);
            }
            else
            {
                response.setStatus(HttpStatus.NOT_ACCEPTABLE.value());
                response.setMessage("اطلاعات استاد تکمیل نیست");
                return new ResponseEntity<>(response, HttpStatus.NOT_ACCEPTABLE);
            }
            if (response.getStatus() == HttpStatus.OK.value()) {

                testQuestionService.changeOnlineFinalExamStatus(request.getExam().getSourceExamId(), true);
                return new ResponseEntity<>(response, HttpStatus.OK);
            } else return new ResponseEntity<>(response, HttpStatus.NOT_ACCEPTABLE);

        } catch (TrainingException ex) {

            response.setStatus(HttpStatus.NOT_ACCEPTABLE.value());
            response.setMessage("بروز خطا در سیستم");
            return new ResponseEntity<>(response, HttpStatus.NOT_ACCEPTABLE);
        }
    }

    private boolean validateTeacherExam(ImportedUser teacher) {
        boolean isValid = true;

        if (teacher.getGender() == null) isValid = false;
        if (teacher.getNationalCode().length() != 10 || !teacher.getNationalCode().matches("\\d+")) isValid = false;
        if ((teacher.getCellNumber().length() != 10 && teacher.getCellNumber().length() != 11) || !teacher.getCellNumber().matches("\\d+"))
            isValid = false;
        if (teacher.getCellNumber().length() == 10 && !(teacher.getCellNumber().startsWith("9"))) isValid = false;
        if (teacher.getCellNumber().length() == 11 && !(teacher.getCellNumber().startsWith("09"))) isValid = false;

        return isValid;
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
        if (personnel != null ) {
            personBeanMapper.setPersonnelFields(personDTO, personnel);
            String role = "User";
            roles.add(role);
        } else {
            personnelRegistered = personnelRegisteredService.getOneByNationalCode(nationalCode);
            if (personnelRegistered != null){
                personBeanMapper.setPersonnelRegisteredFields(personDTO, personnelRegistered);
                String role = "User";
                roles.add(role);
            }
        }
        //if user is a teacher or a company owner
        if (personalInfo != null){
            String role = "Instructor";
            roles.add(role);
            if (personnel == null && personnelRegistered == null){
                personBeanMapper.setPersonalInfoFields(personDTO, personalInfo);
            } else {
                // we fill fields if there are valid values in other objects
                if(personDTO.getEmail() == null && personalInfo.getContactInfo() != null && personalInfo.getContactInfo().getEmail() != null){
                    personDTO.setEmail(personalInfo.getContactInfo().getEmail());
                }
                if(personDTO.getAddress() == null && personalInfo.getContactInfo() != null && personalInfo.getContactInfo().getHomeAddress() != null){
                    personDTO.setAddress(personalInfo.getContactInfo().getHomeAddress().getRestAddr());
                }
                if(personDTO.getMobile() == null && personalInfo.getContactInfo() != null && personalInfo.getContactInfo().getMobile() != null){
                    personDTO.setMobile(personBeanMapper.checkMobileFormat(personalInfo.getContactInfo().getMobile()));
                }
                if(personDTO.getPhone() == null && personalInfo.getContactInfo() != null && personalInfo.getContactInfo().getHomeAddress() != null){
                    personDTO.setPhone(personalInfo.getContactInfo().getHomeAddress().getPhone());
                }
                if(personDTO.getBirthDate() == null && personalInfo.getBirthDate() != null){
                    personDTO.setBirthDate(personalInfo.getBirthDate());
                }
                if(personDTO.getGender() == null && personalInfo.getGenderId() != null){
                    if (personalInfo.getGenderId().equals(EGender.Male.getId())) {
                        personDTO.setGender(0);
                    } else {
                        personDTO.setGender(1);
                    }
                }
                if(personDTO.getEducationLevelTitle() == null && personalInfo.getEducationLevel() != null){
                    personDTO.setEducationLevelTitle(personalInfo.getEducationLevel().getTitleFa());
                }
                if(personDTO.getEducationMajorTitle() == null && personalInfo.getEducationMajor() != null){
                    personDTO.setEducationMajorTitle(personalInfo.getEducationMajor().getTitleFa());
                }
            }

        }
        if ( personnel != null || personnelRegistered != null || personalInfo != null){
            personDTO.setRoles(roles);
        }

        PersonnelDTO.PersonalityInfo personalInfoDTO = personnelService.getByNationalCode(nationalCode);
        return new ResponseEntity<>(personDTO, HttpStatus.OK);
    }
    @PostMapping("/student/addAnswer/evaluation")
    public BaseResponse addStudentEvaluationAnswer(@RequestBody StudentEvaluationAnswerDto dto) {
        EvaluationAnswerObject answerObject = tclassService.classStudentEvaluations(dto);
        EvaluationDTO.Update update = modelMapper.map(answerObject, EvaluationDTO.Update.class);
        EvaluationDTO.Info info = evaluationService.update(answerObject.getId(), update);
        evaluationAnalysisService.updateReactionEvaluation(info.getClassId());
        BaseResponse response=new BaseResponse();
        response.setStatus(200);
        return response;
    }



    @PostMapping("/teacher/addAnswer/evaluation")
    public BaseResponse addTeacherEvaluationAnswer(@RequestBody TeacherEvaluationAnswerDto dto) {
        EvaluationAnswerObject answerObject = tclassService.classTeacherEvaluations(dto);
        EvaluationDTO.Update update = modelMapper.map(answerObject, EvaluationDTO.Update.class);
        EvaluationDTO.Info info = evaluationService.update(answerObject.getId(), update);
        evaluationAnalysisService.updateReactionEvaluation(info.getClassId());
        BaseResponse response=new BaseResponse();
        response.setStatus(200);
        return response;
    }

}
