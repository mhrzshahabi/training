package com.nicico.training.controller;


import com.nicico.copper.common.Loggable;
import com.nicico.training.TrainingException;
import com.nicico.training.controller.client.els.ElsClient;
import com.nicico.training.controller.util.GeneratePdfReport;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.*;
import com.nicico.training.mapper.evaluation.EvaluationBeanMapper;
import com.nicico.training.model.*;
import com.nicico.training.model.enums.EGender;
import com.nicico.training.service.*;
import lombok.RequiredArgsConstructor;
import org.apache.commons.lang3.StringUtils;
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
import java.util.regex.Matcher;
import java.util.regex.Pattern;


@RestController
@RequestMapping("/anonymous/els")
@RequiredArgsConstructor
public class ElsRestController {
    private final ModelMapper modelMapper;
    private final EvaluationBeanMapper evaluationBeanMapper;
    private final EvaluationAnswerService answerService;
    private final QuestionnaireService questionnaireService;
    private final EvaluationService evaluationService;
    private final ClassStudentService classStudentService;
    private final TclassService tclassService;
    private final TeacherService teacherService;
    private final ITclassService iTclassService;
    private final ElsClient client;
    private final TestQuestionService testQuestionService;
    private final IEvaluationAnalysisService evaluationAnalysisService;
    private final IPersonnelService personnelService;
    private final IPersonnelRegisteredService personnelRegisteredService;
    private final IPersonalInfoService personalInfoService;

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
            iTclassService.changeOnlineEvalStudentStatus(evaluation.getClassId(), true);

            return new ResponseEntity<>(response, HttpStatus.OK);
        }


    }

    @GetMapping("/teacherEval/{id}")
    public ResponseEntity<BaseResponse> sendEvalToElsForTeacher(@PathVariable long id) {
        BaseResponse response = new BaseResponse();

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
            iTclassService.changeOnlineEvalTeacherStatus(evaluation.getClassId(), true);

            return new ResponseEntity<>(response, HttpStatus.OK);
        }


    }

    @GetMapping("/evalResult/{id}")
    public ResponseEntity<EvalListResponse> getEvalResults(@PathVariable long id) {
       ;
        EvalListResponse response = client.getEvalResults(evaluationService.getTclass(id));
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

                if (object.getExamItem().getTclass().getTeacherId() != null) {
                    if (evaluationBeanMapper.checkExamScore(object, tclassService.getTClass(object.getExamItem().getTclassId()))) {
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
                            request = evaluationBeanMapper.toGetExamRequest(tclassService.getTClass(object.getExamItem().getTclassId()), teacherInfo,
                                    object, classStudentService.getClassStudents(object.getExamItem().getTclassId()));
//                            boolean hasDuplicateQuestions = evaluationBeanMapper.hasDuplicateQuestions(request.getQuestionProtocols());
                            boolean hasWrongCorrectAnswer = evaluationBeanMapper.hasWrongCorrectAnswer(request.getQuestionProtocols());
                            if (hasWrongCorrectAnswer || request.getQuestionProtocols().size() == 0) {

                                response.setStatus(HttpStatus.NOT_ACCEPTABLE.value());
//                                if (hasDuplicateQuestions)
//                                    response.setMessage("سوال با عنوان تکراری در آزمون موجود است!");
                                if (hasWrongCorrectAnswer)
                                    response.setMessage("سوال چهار گزینه ای بدون جواب صحیح موجود است!");
                                else
                                    response.setMessage("آزمون سوال ندارد!");


                                return new ResponseEntity<>(response, HttpStatus.NOT_ACCEPTABLE);
                            } else {

                                response = client.sendExam(request);
                                if (response.getStatus() == HttpStatus.OK.value()) {
                                    testQuestionService.changeOnlineFinalExamStatus(request.getExam().getSourceExamId(), true);
                                    return new ResponseEntity<>(response, HttpStatus.OK);
                                } else
                                    return new ResponseEntity<>(response, HttpStatus.NOT_ACCEPTABLE);

                            }
                        }

                    } else {
                        response.setMessage("بارم بندی آزمون صحیح نمی باشد");
                        return new ResponseEntity<>(response, HttpStatus.NOT_ACCEPTABLE);
                    }

                } else {
                    response.setMessage("کلاس استاد ندارد");
                    return new ResponseEntity<>(response, HttpStatus.NOT_ACCEPTABLE);
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


        EvalListResponse pdfResponse = client.getEvalResults(evaluationService.getTclass(id));

        ByteArrayInputStream bis = GeneratePdfReport.ReportEvaluation(pdfResponse);
        HttpHeaders headers = new HttpHeaders();
        headers.add("Content-Disposition", "inline; filename=evaluation-" + System.currentTimeMillis() + ".pdf");

        return ResponseEntity
                .ok()
                .headers(headers)
                .contentType(MediaType.APPLICATION_PDF)
                .body(new InputStreamResource(bis));
    }


    @PostMapping("/printPdf/{id}/{national}/{name}/{last}/{fullName}")
    public void printPdf(HttpServletResponse response,
                         @PathVariable long id,
                         @PathVariable String national,
                         @PathVariable String name,
                         @PathVariable String last,
                         @PathVariable String fullName

    ) throws Exception {

        ExamListResponse pdfData = client.getExamResults(id);
        ExamResultDto data;


        data = pdfData.getData().stream()
                .filter(x -> x.getNationalCode().trim().equals(national.trim()))
                .findFirst()
                .get();

        String params = "{\"student\":\"" + name + "" + last + "\"}";

        testQuestionService.printElsPdf(response, "pdf", "ElsExam.jasper", id, params, data);


    }


    @PostMapping("/examQuestions")
    public ResponseEntity<ExamQuestionsDto> examQuestions(@RequestBody ExamImportedRequest object) {

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");

        try {
            if (sdf.parse(object.getExamItem().getTclass().getStartDate()).compareTo(sdf.parse(object.getExamItem().getTclass().getEndDate())) != 0) {

                if (sdf.parse(object.getExamItem().getDate()).after(sdf.parse(object.getExamItem().getTclass().getStartDate()))
                ) {
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

    @Loggable
    @GetMapping(value = "/peopleByNationalCode/{nationalCode}")
    public ResponseEntity<PersonDTO> findPeopleByNationalCode(@PathVariable String nationalCode) {
        PersonDTO personDTO = new PersonDTO();
        PersonnelDTO.PersonalityInfo personnel = personnelService.getByNationalCode(nationalCode);
        PersonnelRegisteredDTO.Info personnelRegistered = null;
        PersonalInfoDTO.Info personalInfo = personalInfoService.getOneByNationalCode(nationalCode);
        List<String> roles = new ArrayList<>();
        if (personnel != null ) {
            personDTO.setFirstName(personnel.getFirstName());
            personDTO.setLastName(personnel.getLastName());
            personDTO.setFatherName(personnel.getFatherName());
            personDTO.setBirthDate(personnel.getBirthDate());
            if (personnel.getGender() != null) {
                if (personnel.getGender().equals(EGender.Male.getTitleFa())) {
                    personDTO.setGender(0);
                } else if (personnel.getGender().equals(EGender.Female.getTitleFa())){
                    personDTO.setGender(1);
                }
            }
            personDTO.setNationalCode(personnel.getNationalCode());
            personDTO.setMobile(checkMobileFormat(personnel.getMobile()));
            personDTO.setEducationLevelTitle(personnel.getEducationLevelTitle());
            personDTO.setEducationMajorTitle(personnel.getEducationMajorTitle());
            personDTO.setPhone(personnel.getPhone());
            personDTO.setEmail(personnel.getEmail());
            String role = "User";
            roles.add(role);
            personDTO.setRoles(roles);
        } else {
            personnelRegistered = personnelRegisteredService.getOneByNationalCode(nationalCode);
            if (personnelRegistered != null){
                personDTO.setFirstName(personnelRegistered.getFirstName());
                personDTO.setLastName(personnelRegistered.getLastName());
                personDTO.setFatherName(personnelRegistered.getFatherName());
                personDTO.setBirthDate(personnelRegistered.getBirthDate());
                if (personnelRegistered.getGender() != null) {
                    if (personnelRegistered.getGender().equals(EGender.Male.getTitleFa())) {
                        personDTO.setGender(0);
                    } else if (personnelRegistered.getGender().equals(EGender.Female.getTitleFa())){
                        personDTO.setGender(1);
                    }
                }
                personDTO.setNationalCode(personnelRegistered.getNationalCode());
                personDTO.setMobile(checkMobileFormat(personnelRegistered.getMobile()));
                personDTO.setEducationLevelTitle(personnelRegistered.getEducationLevel());
                personDTO.setEducationMajorTitle(personnelRegistered.getEducationMajor());
                personDTO.setPhone(personnelRegistered.getPhone());
                personDTO.setEmail(personnelRegistered.getEmail());
                String role = "User";
                roles.add(role);
            }
        }
        if (personalInfo != null){
            String role = "Instructor";
            roles.add(role);
            if (personnel == null && personnelRegistered == null){
                personDTO.setFirstName(personalInfo.getFirstNameFa());
                personDTO.setLastName(personalInfo.getLastNameFa());
                personDTO.setFatherName(personalInfo.getFatherName());
                personDTO.setBirthDate(personalInfo.getBirthDate());
                if (personalInfo.getGenderId() != null) {
                    if (personalInfo.getGenderId().equals(EGender.Male.getId())) {
                        personDTO.setGender(0);
                    } else {
                        personDTO.setGender(1);
                    }
                }
                personDTO.setNationalCode(personalInfo.getNationalCode());
                if (personalInfo.getContactInfo() != null) {
                    personDTO.setEmail(personalInfo.getContactInfo().getEmail());
                    personDTO.setMobile(checkMobileFormat(personalInfo.getContactInfo().getMobile()));
                    if (personalInfo.getContactInfo().getHomeAddress() != null) {
                        personDTO.setPhone(personalInfo.getContactInfo().getHomeAddress().getPhone());
                        personDTO.setAddress(personalInfo.getContactInfo().getHomeAddress().getRestAddr());
                    }
                }
                if (personalInfo.getEducationLevel() != null) {
                    personDTO.setEducationLevelTitle(personalInfo.getEducationLevel().getTitleFa());
                }
                if (personalInfo.getEducationMajor() != null) {
                    personDTO.setEducationMajorTitle(personalInfo.getEducationMajor().getTitleFa());
                }
            } else {
                if(personDTO.getEmail() == null && personalInfo.getContactInfo() != null && personalInfo.getContactInfo().getEmail() != null){
                    personDTO.setEmail(personalInfo.getContactInfo().getEmail());
                }
                if(personDTO.getAddress() == null && personalInfo.getContactInfo() != null && personalInfo.getContactInfo().getHomeAddress() != null){
                    personDTO.setAddress(personalInfo.getContactInfo().getHomeAddress().getRestAddr());
                }
                if(personDTO.getMobile() == null && personalInfo.getContactInfo() != null && personalInfo.getContactInfo().getMobile() != null){
                    personDTO.setMobile(checkMobileFormat(personalInfo.getContactInfo().getMobile()));
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

    public String checkMobileFormat(String mobileNumber) {
        if (mobileNumber == null || mobileNumber.equals("")) {
            return null;
        } else {
            mobileNumber = StringUtils.leftPad(mobileNumber, 11, "0");
            String regexStr = "^09\\d{9}";
            Pattern pattern = Pattern.compile(regexStr);
            Matcher matcher = pattern.matcher(mobileNumber);
            if (!matcher.find())
                return null;
            return mobileNumber;
        }
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

}
