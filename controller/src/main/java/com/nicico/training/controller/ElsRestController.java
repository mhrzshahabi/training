package com.nicico.training.controller;


import com.nicico.copper.common.Loggable;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.Loggable;
import com.nicico.training.TrainingException;
import com.nicico.training.controller.client.els.ElsClient;
import com.nicico.training.controller.minio.MinIoClient;
import com.nicico.training.controller.util.GeneratePdfReport;
import com.nicico.training.dto.*;
import com.nicico.training.dto.enums.ExamsType;
import com.nicico.training.dto.question.ElsExamRequestResponse;
import com.nicico.training.dto.question.ElsResendExamRequestResponse;
import com.nicico.training.dto.question.ExamQuestionsObject;
import com.nicico.training.iservice.*;
import com.nicico.training.mapper.QuestionBank.QuestionBankBeanMapper;
import com.nicico.training.mapper.attendance.AttendanceBeanMapper;
import com.nicico.training.mapper.evaluation.EvaluationBeanMapper;
import com.nicico.training.mapper.person.PersonBeanMapper;
import com.nicico.training.model.*;
import com.nicico.training.model.enums.EGender;
import com.nicico.training.service.*;
import dto.evaluuation.EvalTargetUser;
import io.swagger.models.auth.In;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.core.env.Environment;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.InputStreamResource;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;
import request.attendance.ElsTeacherAttendanceListSaveDto;
import request.evaluation.ElsEvalRequest;
import request.evaluation.ElsUserEvaluationListResponseDto;
import request.evaluation.StudentEvaluationAnswerDto;
import request.evaluation.TeacherEvaluationAnswerDto;
import request.exam.*;
import response.BaseResponse;
import response.PaginationDto;
import response.attendance.AttendanceListSaveResponse;
import response.evaluation.EvalListResponse;
import response.evaluation.ElsEvaluationsListResponse;
import response.evaluation.SendEvalToElsResponse;
import response.evaluation.dto.ElsContactEvaluationDto;
import response.evaluation.dto.EvalAverageResult;
import response.evaluation.dto.EvaluationAnswerObject;
import response.event.EventListDto;
import response.exam.ExamListResponse;
import response.exam.ExamQuestionsDto;
import response.exam.ResendExamTimes;
import response.question.dto.*;
import response.tclass.ElsSessionAttendanceResponse;
import response.tclass.ElsSessionResponse;
import response.tclass.ElsStudentAttendanceListResponse;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.stream.Collectors;

import static com.nicico.training.controller.util.AppUtils.getTotalPages;


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
    private final IEvaluationService iEvaluationService;
    private final IClassStudentService classStudentService;
    private final ITclassService tclassService;
    private final TeacherService teacherService;
    private final CategoryService categoryService;
    private final SubcategoryService subcategoryService;
    private final ITclassService iTclassService;
    private final PersonalInfoService personalInfoService;
    private final ElsClient client;
    private final MinIoClient client2;
    private final TestQuestionService testQuestionService;
    private final IPersonnelService personnelService;
    private final IPersonnelRegisteredService personnelRegisteredService;
    private final EvaluationAnalysisService evaluationAnalysisService;
    private final Environment environment;
    private final AttendanceBeanMapper attendanceMapper;
    private final IAttendanceService attendanceService;
    private final ClassSessionService classSessionService;
    private final IClassSession iClassSessionService;
    private final IAttachmentService iAttachmentService;
    private final QuestionBankService questionBankService;
    private final QuestionBankBeanMapper questionBankBeanMapper;
    private final ParameterValueService parameterValueService;
    private final IStudentService iStudentService;
    private final QuestionBankTestQuestionService questionBankTestQuestionService;
    private final ViewTrainingFileService viewTrainingFileService;
    private final ParameterService parameterService;
    private final ITeacherRoleService iTeacherRoleService;
    private final IMobileVerifyService iMobileVerifyService;
    private final IRoleService iRoleService;


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
                    if (baseResponse.getStatus() == 200)
                        iTclassService.changeOnlineEvalStudentStatus(evaluation.getClassId(), true);

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

                } else {
                    response.setMessage("اطلاعات به سیستم ارزشیابی آنلاین ارسال نشد");
                    response.setStatus(HttpStatus.NOT_ACCEPTABLE.value());
                    return new ResponseEntity<>(response, HttpStatus.NOT_ACCEPTABLE);
                }
            }
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
            if (baseResponse.getStatus() == 200)
                iTclassService.changeOnlineEvalTeacherStatus(evaluation.getClassId(), true);
            else
                return new ResponseEntity(response, HttpStatus.valueOf(response.getStatus()));

        } catch (Exception r) {

            if (r.getCause() != null && r.getCause().getMessage() != null && r.getCause().getMessage().equals("Read timed out")) {
                response.setMessage("اطلاعات به سیستم ارزشیابی آنلاین ارسال نشد");
                response.setStatus(HttpStatus.REQUEST_TIMEOUT.value());
                return new ResponseEntity(response, HttpStatus.valueOf(response.getStatus()));

            } else {
                response.setMessage("اطلاعات به سیستم ارزشیابی آنلاین ارسال نشد");
                response.setStatus(HttpStatus.NOT_ACCEPTABLE.value());
                return new ResponseEntity(response, HttpStatus.valueOf(response.getStatus()));
            }
        }
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    @GetMapping("/evaluations/userEval/{evalId}")
    public ElsUserEvaluationListResponseDto sendUserEvalToElsById(HttpServletRequest header, @PathVariable long evalId) {
        ElsUserEvaluationListResponseDto response = new ElsUserEvaluationListResponseDto();
        if (Objects.requireNonNull(environment.getProperty("nicico.training.pass")).trim().equals(header.getHeader("X-Auth-Token"))) {
            try {
                Evaluation evaluation = iEvaluationService.getById(evalId);
                response = evaluationBeanMapper.toElsEvalResponseDto(evaluation,
                        questionnaireService.get(evaluation.getQuestionnaireId()),
                        evaluationService.getEvaluationQuestions(
                                answerService.getAllByEvaluationId(evaluation.getId())),
                        personalInfoService.getPersonalInfo(teacherService.getTeacher(evaluation.getTclass().getTeacherId()).getPersonalityId()));
                response.setStatus(HttpStatus.OK.value());

        } catch (Exception ex) {
            if (ex.getMessage().equals("No value present")) {
                response.setMessage("ارزیابی با این اطلاعات وجود ندارد");
                response.setStatus(HttpStatus.NO_CONTENT.value());
            } else {
                response.setMessage("اطلاعات به سیستم ارزشیابی آنلاین ارسال نشد");
                response.setStatus(HttpStatus.NOT_ACCEPTABLE.value());
            }
        }
        } else {
            response.setStatus(HttpStatus.UNAUTHORIZED.value());
            response.setMessage("خطای شناسایی");
        }
        return response;
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
                        if (object.isDeleteAbsentUsers()) {
                            request = evaluationBeanMapper.removeAbsentUsersForExam(request, object.getAbsentUsers());
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

//        //ToDo mock for test answer files
//        Map<String,String> answerFiles=new HashMap<>();
//        answerFiles.put("61625136-4eff-41fc-99bc-e22e7aceef16","608fa5263cee3d76470c3d30");
//        answerFiles.put("61625136-4eff-41fc-99bc-e22e7aceef162","608fa5263cee3d76470c3d30");
//        answerFiles.put("61625136-4eff-41fc-99bc-e22e7aceef163","608fa5263cee3d76470c3d30");
//        answerFiles.put("61625136-4eff-41fc-99bc-e22e7aceef164","608fa5263cee3d76470c3d30");
//        answerFiles.put("61625136-4eff-41fc-99bc-e22e7aceef165","608fa5263cee3d76470c3d30");
//        answerFiles.put("61625136-4eff-41fc-99bc-e22e7aceef166","608fa5263cee3d76470c3d30");
//        answerFiles.put("61625136-4eff-41fc-99bc-e22e7aceef167","608fa5263cee3d76470c3d30");
//        response.getData().get(0).getAnswers().get(0).setOption1Files(answerFiles);
//        response.getData().get(0).getAnswers().get(0).setOption3Files(answerFiles);
//        response.getData().get(0).getAnswers().get(0).setOption4Files(answerFiles);
//        response.getData().get(0).getAnswers().get(0).setFiles(answerFiles);
//        response.getData().get(0).getAnswers().get(0).setAnswerFiles(answerFiles);

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
        if (Objects.requireNonNull(environment.getProperty("nicico.training.pass")).trim().equals(header.getHeader("X-Auth-Token"))) {

        try {
                EvaluationAnswerObject answerObject = tclassService.classStudentEvaluations(dto);
                EvaluationDTO.Update update = modelMapper.map(answerObject, EvaluationDTO.Update.class);
                EvaluationDTO.Info info = evaluationService.update(answerObject.getId(), update);
                evaluationAnalysisService.updateReactionEvaluation(info.getClassId());
                response.setStatus(200);

            return response;
        } catch (Exception e) {
            response.setStatus(HttpStatus.NOT_FOUND.value());
            response.setMessage("ارزیابی مورد نظر در سیستم آموزش حذف شده است");

            return response;
        }             } else {
                response.setStatus(HttpStatus.UNAUTHORIZED.value());
            return response;

            }

    }


    @PostMapping("/teacher/addAnswer/evaluation")
    public BaseResponse addTeacherEvaluationAnswer(HttpServletRequest header, @RequestBody TeacherEvaluationAnswerDto dto) {
        BaseResponse response = new BaseResponse();
        if (Objects.requireNonNull(environment.getProperty("nicico.training.pass")).trim().equals(header.getHeader("X-Auth-Token"))) {

            try {
                EvaluationAnswerObject answerObject = tclassService.classTeacherEvaluations(dto);
                EvaluationDTO.Update update = modelMapper.map(answerObject, EvaluationDTO.Update.class);
                EvaluationDTO.Info info = evaluationService.update(answerObject.getId(), update);
                evaluationAnalysisService.updateReactionEvaluation(info.getClassId());
                response.setStatus(200);

            return response;
        } catch (Exception e) {
            response.setStatus(HttpStatus.NOT_FOUND.value());
            response.setMessage("ارزیابی مورد نظر در سیستم آموزش حذف شده است");
            return response;
        }    } else {
            response.setStatus(HttpStatus.UNAUTHORIZED.value());
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
    public ResponseEntity<ResendExamTimes> getResendExamTimes(@PathVariable long sourceExamId) {
        ResendExamTimes resendExamTimes = client.getResendExamTimes(sourceExamId);

        if (resendExamTimes.getStatus() == HttpStatus.OK.value()) {
            return new ResponseEntity<>(resendExamTimes, HttpStatus.OK);

        } else
            return new ResponseEntity<>(resendExamTimes, HttpStatus.NOT_ACCEPTABLE);


    }


    @RequestMapping(value = {"/download/{group}/{key}/{token}"}, method = RequestMethod.GET)
    @Transactional
    public ResponseEntity<ByteArrayResource> downloadWithKey(HttpServletRequest request, HttpServletResponse response, @PathVariable String group
            , @PathVariable String key
            , @PathVariable String token
    ) throws IOException {

        ByteArrayResource file = client2.downloadFile("Bearer " + token,"Training", group, key);
        try {
            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + file.getFilename() + "\"")
                    .body(file);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }

    }

    /**
     * the attendance from els which done by teacher
     * the teacher can do attendance for a session when he has the permission
     */
    @PostMapping(value = {"/attendance/byTeacher"})
    public ResponseEntity<AttendanceListSaveResponse> attendanceByTeacher(HttpServletRequest header, @RequestBody ElsTeacherAttendanceListSaveDto tAttendanceDtoRequest) {
        AttendanceListSaveResponse response = new AttendanceListSaveResponse();
        if (Objects.requireNonNull(environment.getProperty("nicico.training.pass")).trim().equals(header.getHeader("X-Auth-Token"))) {
            if (tAttendanceDtoRequest != null) {

                List<Attendance> attendances = attendanceMapper.elsToAttendanceList(tAttendanceDtoRequest.getAttendanceDtos());
                if (attendances.size() > 0) {
                    if (attendances.get(0).getSessionId() != null && attendances.get(0).getStudentId() != null) {
                        ClassSession currentClassSession = classSessionService.getClassSession(attendances.get(0).getSessionId());
                        if (currentClassSession.getTeacherAttendancePermission()) {
                            for (int i = 0; i < attendances.size(); i++) {
                                Optional<Attendance> optionalAttendance = attendanceService.getAttendanceBySessionIdAndStudentId(
                                        attendances.get(i).getSessionId(), attendances.get(i).getStudentId());
                                if (attendances.get(i).getState() != null
                                        && attendances.get(i).getState().length() == 1
                                        && "01234".contains(attendances.get(i).getState())) {
                                    if (optionalAttendance.isPresent()) {
                                        Attendance mainAttendance = optionalAttendance.get();
                                        switch (attendances.get(i).getState()) {
                                            case "1": {
                                                if (mainAttendance.getState().equals("2")) {
                                                    attendances.get(i).setState("2");
                                                }
                                                break;
                                            }
                                            case "3": {
                                                if (mainAttendance.getState().equals("4")) {
                                                    attendances.get(i).setState("4");
                                                }
                                                break;
                                            }
                                        }
                                    }
                                } else {
                                    response.setStatus(HttpStatus.BAD_REQUEST.value());
                                    response.setMessage("اطلاعات حضور غیاب معتبر نیست");
                                    return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
                                }
                            }

                            boolean status = attendanceService.saveOrUpdateList(attendances);
                            if (status) {
                                response.setStatus(HttpStatus.CREATED.value());
                                response.setMessage("ثبت با موفقیت انجام شد");
                            } else {
                                response.setStatus(HttpStatus.NOT_ACCEPTABLE.value());
                                response.setMessage("اطلاعات ثبت نشد");
                            }
                        } else {
                            response.setStatus(HttpStatus.FORBIDDEN.value());
                            response.setMessage("امکان تغییر در حضور غیاب برای استاد وجود ندارد");
                        }
                    } else {
                        response.setStatus(HttpStatus.NO_CONTENT.value());
                        response.setMessage("اطلاعات ارسالی معتبر نیست");
                    }
                } else {
                    response.setStatus(HttpStatus.NO_CONTENT.value());
                    response.setMessage("لیست حضور غیاب خالی است");
                }
            } else {
                response.setStatus(HttpStatus.NO_CONTENT.value());
                response.setMessage("اطلاعات ارسالی فاقد محتوا است");
            }
        } else {
            response.setStatus(HttpStatus.UNAUTHORIZED.value());
            response.setMessage("خطای شناسایی");
        }
        return new ResponseEntity<>(response, HttpStatus.valueOf(response.getStatus()));
    }

    /**
     * An Api for Els to return a student's attendances list by the class code and national code
     *
     * @param header
     * @param classCode
     * @param nationalCode
     * @return List of student's attendances [ElsStudentAttendanceListResponse]
     */
    @GetMapping("/attendance/studentAttendanceList/{classCode}/{nationalCode}/")
    public ElsStudentAttendanceListResponse getStudentAttendanceListByClassCode(HttpServletRequest header,
                                                                                @PathVariable String classCode,
                                                                                @PathVariable String nationalCode) {
        ElsStudentAttendanceListResponse elsStudentAttendanceListResponse = new ElsStudentAttendanceListResponse();
        if (Objects.requireNonNull(environment.getProperty("nicico.training.pass")).trim().equals(header.getHeader("X-Auth-Token"))) {

            try {
                if (classCode != null && nationalCode != null && nationalCode.matches("\\d+")) {
                    elsStudentAttendanceListResponse = iStudentService.getStudentAttendanceList(classCode, nationalCode);
                } else {
                    elsStudentAttendanceListResponse.setMessage("اطلاعات ارسالی فاقد محتوای صحیح ست");
                    elsStudentAttendanceListResponse.setStatus(HttpStatus.BAD_REQUEST.value());
                }

        } catch (Exception ex) {
            elsStudentAttendanceListResponse.setStatus(HttpStatus.INTERNAL_SERVER_ERROR.value());
            elsStudentAttendanceListResponse.setMessage("عملیات با خطا مواجه شد");
        }   } else {
            elsStudentAttendanceListResponse.setStatus(HttpStatus.UNAUTHORIZED.value());
            elsStudentAttendanceListResponse.setMessage("دسترسی موردنظر یافت نشد");
        }

        return elsStudentAttendanceListResponse;
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

    @GetMapping("/sessions/{classCode}")
    public ElsSessionResponse getClassSessions(HttpServletRequest header, @PathVariable String classCode) {

        ElsSessionResponse elsSessionResponse = new ElsSessionResponse();
        if (Objects.requireNonNull(environment.getProperty("nicico.training.pass")).trim().equals(header.getHeader("X-Auth-Token"))) {

            try {

                elsSessionResponse = tclassService.getClassSessionsByCode(classCode);
                elsSessionResponse.setStatus(200);
                return elsSessionResponse;

        } catch (Exception e) {

            elsSessionResponse.setStatus(HttpStatus.NOT_FOUND.value());
            elsSessionResponse.setMessage("کلاس موردنظر یافت نشد");
            return elsSessionResponse;
        }    } else {
            elsSessionResponse.setStatus(HttpStatus.UNAUTHORIZED.value());
            elsSessionResponse.setMessage("دسترسی موردنظر یافت نشد");
            return elsSessionResponse;
        }
    }

    /**
     * @param header
     * @param sessionId
     * @return a response with a list of students of a session with their attendance information
     */
    @GetMapping("/sessionAttendancesInfo/bySessionId/{sessionId}")
    public ElsSessionAttendanceResponse getAttendanceListPerSession(HttpServletRequest header, @PathVariable Long sessionId) {
        ElsSessionAttendanceResponse elsSessionAttendanceResponse = new ElsSessionAttendanceResponse();
        if (Objects.requireNonNull(environment.getProperty("nicico.training.pass")).trim().equals(header.getHeader("X-Auth-Token"))) {

            try {
                elsSessionAttendanceResponse = iClassSessionService.sessionStudentsBySessionId(sessionId);
                if (elsSessionAttendanceResponse.getStudentAttendanceInfos() != null &&
                        elsSessionAttendanceResponse.getStudentAttendanceInfos().size() != 0) {
                    elsSessionAttendanceResponse.setStatus(HttpStatus.OK.value());
                } else {
                    elsSessionAttendanceResponse.setStatus(HttpStatus.NO_CONTENT.value());
                    elsSessionAttendanceResponse.setMessage("لیست حضور غیاب خالی است");
                }
                return elsSessionAttendanceResponse;

        } catch (Exception ex) {
            elsSessionAttendanceResponse.setStatus(HttpStatus.NOT_FOUND.value());
            elsSessionAttendanceResponse.setMessage("جلسه ی موردنظر یافت نشد");
            return elsSessionAttendanceResponse;
        }       } else {
            elsSessionAttendanceResponse.setStatus(HttpStatus.UNAUTHORIZED.value());
            elsSessionAttendanceResponse.setMessage("دسترسی موردنظر یافت نشد");
            return elsSessionAttendanceResponse;
        }
    }

    @GetMapping("/evaluations/listByNationalCode/{nationalCode}/{evaluatorType}")
    public ElsEvaluationsListResponse getEvaluationListByNationalCode(HttpServletRequest header,
                                                                      @PathVariable String nationalCode,
                                                                      @PathVariable String evaluatorType) {
        ElsEvaluationsListResponse elsEvaluationsListResponse = new ElsEvaluationsListResponse();
        if (Objects.requireNonNull(environment.getProperty("nicico.training.pass")).trim().equals(header.getHeader("X-Auth-Token"))) {

            try {
                Long evaluatorTypeId = null;
                switch (evaluatorType) {
                    case "student": {
                        evaluatorTypeId = parameterValueService.getId("32");
                        break;
                    }
                    case "teacher": {
                        evaluatorTypeId = parameterValueService.getId("11");
                    }
                }
                List<Evaluation> evaluationList = iEvaluationService.getEvaluationsByEvaluatorNationalCode(nationalCode, evaluatorTypeId, evaluatorType);
                List<ElsContactEvaluationDto> ElsContactEvaluationDtos = evaluationBeanMapper.toElsContactEvaluationDTOList(evaluationList);
                elsEvaluationsListResponse.setNationalCode(nationalCode);
                elsEvaluationsListResponse.setElsContactEvaluationDtos(ElsContactEvaluationDtos);
                elsEvaluationsListResponse.setStatus(HttpStatus.OK.value());

                return elsEvaluationsListResponse;

        } catch (Exception ex) {
            elsEvaluationsListResponse.setStatus(HttpStatus.NOT_FOUND.value());
            elsEvaluationsListResponse.setMessage("اطلاعات موردنظر یافت نشد");
            return elsEvaluationsListResponse;
        }
        } else {
            elsEvaluationsListResponse.setStatus(HttpStatus.UNAUTHORIZED.value());
            elsEvaluationsListResponse.setMessage("دسترسی موردنظر یافت نشد");
            return elsEvaluationsListResponse;
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

    @PostMapping("/sessionAttachment/{sessionId}/{fileName}")
    public BaseResponse saveSessionAttachment(@PathVariable long sessionId, @PathVariable String fileName, @RequestBody Map<String, String> file) {

        BaseResponse response = new BaseResponse();
        try {

            iAttachmentService.saveSessionAttachment(sessionId, file, fileName);
            response.setMessage("ذخیره محتوای جلسه با موفقیت انجام شد");
            response.setStatus(HttpStatus.OK.value());

        } catch (Exception e) {

            response.setMessage("مشکلی در ذخیره محتوای جلسه رخ داده است");
            response.setStatus(HttpStatus.NOT_ACCEPTABLE.value());
        }
        return response;
    }

    @GetMapping("/questionBank/{nationalCode}/{page}/{size}")
    public ElsQuestionBankDto getQuestionBankByNationalCode(HttpServletRequest header, @PathVariable String nationalCode
            , @PathVariable Integer page, @PathVariable Integer size) {

        if (Objects.requireNonNull(environment.getProperty("nicico.training.pass")).trim().equals(header.getHeader("X-Auth-Token"))) {
            try {
                Long teacherId = teacherService.getTeacherIdByNationalCode(nationalCode);
                if (teacherId!=null){
                    Page<QuestionBank> questionBankList = questionBankService.getQuestionBankByTeacherId(teacherId,page,size);
                    ElsQuestionBankDto questionBankDto = questionBankBeanMapper.toElsQuestionBank(questionBankList.getContent(), nationalCode);
                    PaginationDto paginationDto=new PaginationDto();
                    paginationDto.setCurrent(page);
                    paginationDto.setSize(size);
                    paginationDto.setTotal(questionBankList.getTotalPages());
                    paginationDto.setLast(questionBankList.getTotalPages()-1);
                    paginationDto.setTotalItems(questionBankList.get().count());
                    questionBankDto.setPagination(paginationDto);
                    return questionBankDto;
                }else {
                     ElsQuestionBankDto dto=new ElsQuestionBankDto();
                    ElsQuestionDto elsQuestionDto=new ElsQuestionDto();
                    elsQuestionDto.setStatus(406);
                    elsQuestionDto.setMessage("این استاد در آموزش وجود ندارد");
                    dto.setQuestions(Collections.singletonList(elsQuestionDto));
                     return dto;
                }

            } catch (Exception e) {
                ElsQuestionBankDto dto=new ElsQuestionBankDto();
                ElsQuestionDto elsQuestionDto=new ElsQuestionDto();
                elsQuestionDto.setStatus(500);
                dto.setQuestions(Collections.singletonList(elsQuestionDto));
                return dto;
            }
        } else {
            throw new TrainingException(TrainingException.ErrorType.Unauthorized);
        }
    }

    @PostMapping("/sendQuestions")
    public BaseResponse addQuestions(HttpServletRequest header, @RequestBody ElsQuestionBankDto elsQuestionBankDto) {

        BaseResponse response = new BaseResponse();
        if (Objects.requireNonNull(environment.getProperty("nicico.training.pass")).trim().equals(header.getHeader("X-Auth-Token"))) {
            try {
                questionBankBeanMapper.toQuestionBankCreate(elsQuestionBankDto);
                response.setMessage("ذخیره سوالات با موفقیت انجام شد");
                response.setStatus(HttpStatus.OK.value());
                return response;
            } catch (Exception e) {
                response.setMessage("مشکلی در ذخیره سوالات رخ داده است");
                response.setStatus(HttpStatus.NOT_ACCEPTABLE.value());
            }
        } else {
            throw new TrainingException(TrainingException.ErrorType.Unauthorized);
        }
        return response;
    }

    @GetMapping("/categoryList")
    public List<ElsCategoryDto> getCategories(HttpServletRequest header) {

        if (Objects.requireNonNull(environment.getProperty("nicico.training.pass")).trim().equals(header.getHeader("X-Auth-Token"))) {
            try {
                return categoryService.getCategoriesForEls();
            } catch (Exception e) {
                throw new TrainingException(TrainingException.ErrorType.NotFound);
            }
        } else {
            throw new TrainingException(TrainingException.ErrorType.Unauthorized);
        }
    }

    @GetMapping("/subCategoryList/{categoryId}")
    public List<ElsSubCategoryDto> getSubCategories(HttpServletRequest header, @PathVariable Long categoryId) {

        if (Objects.requireNonNull(environment.getProperty("nicico.training.pass")).trim().equals(header.getHeader("X-Auth-Token"))) {
            try {
                return subcategoryService.getSubCategoriesForEls(categoryId);
            } catch (Exception e) {
                throw new TrainingException(TrainingException.ErrorType.NotFound);
            }
        } else {
            throw new TrainingException(TrainingException.ErrorType.Unauthorized);
        }
    }

    @GetMapping("/questionBankById/{id}")
    public ElsQuestionDto getQuestionBankById(HttpServletRequest header, @PathVariable long id) {
        ElsQuestionDto response = new ElsQuestionDto();
        if (Objects.requireNonNull(environment.getProperty("nicico.training.pass")).trim().equals(header.getHeader("X-Auth-Token"))) {
            try {
                QuestionBank questionBank = questionBankService.getById(id);
                ElsQuestionBankDto questionBankDto = questionBankBeanMapper.toElsQuestionBank(Collections.singletonList(questionBank), null);
                ElsQuestionDto questionDto = questionBankDto.getQuestions().get(0);
                questionDto.setStatus(200);
                return questionDto;
            } catch (Exception e) {
                response.setStatus(HttpStatus.NOT_FOUND.value());
                response.setMessage("سوال یافت نشد");
            }
        } else {
            response.setStatus(HttpStatus.UNAUTHORIZED.value());
            response.setMessage("خطای دسترسی");
        }
        return response;

    }

    @DeleteMapping("/delete/questionBank/{nationalCode}/{id}")
    public BaseResponse deleteQuestionBank(HttpServletRequest header, @PathVariable String nationalCode, @PathVariable long id) {
        BaseResponse response = new BaseResponse();
        if (Objects.requireNonNull(environment.getProperty("nicico.training.pass")).trim().equals(header.getHeader("X-Auth-Token"))) {
            try {
                QuestionBankDTO.FullInfo questionBankDto = questionBankService.get(id);
                if (questionBankDto.getTeacherId() == null || teacherService.getTeacher(questionBankDto.getTeacherId()).getTeacherCode().equals(nationalCode)) {
                    if (!questionBankTestQuestionService.usedQuestion(id)) {
                        questionBankService.delete(id);
                        response.setStatus(HttpStatus.OK.value());
                    } else {
                        response.setStatus(HttpStatus.NOT_ACCEPTABLE.value());
                        response.setMessage("سوال قابل حذف نیست");
                    }
                    return response;

                } else {
                    response.setStatus(HttpStatus.UNAUTHORIZED.value());
                    response.setMessage("این استاد دسترسی حذف این سوال را ندارد");
                }

                return response;
            } catch (Exception e) {
                response.setStatus(HttpStatus.NOT_ACCEPTABLE.value());
                response.setMessage("خطا در حذف سوال");
            }
        } else {
            response.setStatus(HttpStatus.UNAUTHORIZED.value());
            response.setMessage("خطای دسترسی");
        }
        return response;
    }

    @PostMapping("/edit/questionBank/{nationalCode}/{id}")
    public ElsQuestionDto editQuestionBank(HttpServletRequest header, @PathVariable String nationalCode, @PathVariable long id,
                                           @RequestBody ElsQuestionDto elsQuestionDto) {
        ElsQuestionDto response = new ElsQuestionDto();

        if (Objects.requireNonNull(environment.getProperty("nicico.training.pass")).trim().equals(header.getHeader("X-Auth-Token"))) {
            try {
                QuestionBankDTO.FullInfo questionBankDto = questionBankService.get(id);
                if (questionBankDto.getTeacherId() == null || teacherService.getTeacher(questionBankDto.getTeacherId()).getTeacherCode().equals(nationalCode)) {
                    if (!questionBankTestQuestionService.usedQuestion(id)) {

                        response = questionBankBeanMapper.toQuestionBankEdit(elsQuestionDto, id, questionBankDto.getTeacherId());
                        response.setStatus(HttpStatus.OK.value());

                    } else {
                        response.setStatus(HttpStatus.NOT_ACCEPTABLE.value());
                        response.setMessage("سوال قابل ویرایش نیست");
                    }
                    return response;

                } else {
                    response.setStatus(HttpStatus.UNAUTHORIZED.value());
                    response.setMessage("این استاد دسترسی ویرایش این سوال را ندارد");
                }

                return response;
            } catch (Exception e) {
                response.setStatus(HttpStatus.NOT_ACCEPTABLE.value());
                response.setMessage("خطا در ویرایش سوال");
            }
        } else {
            response.setStatus(HttpStatus.UNAUTHORIZED.value());
            response.setMessage("خطای دسترسی");
        }
        return response;
    }


    @GetMapping("/exam/findByType")
    public List<Map<String,Object>> findAllExamsByNationalCode(@RequestParam String nationalCode, @RequestParam ExamsType type){
        return iStudentService.findAllExamsByNationalCode(nationalCode,type);
    }

    @GetMapping(value = "/trainingFileByNationalCode/{nationalCode}")
    public ResponseEntity trainingFileByNationalCode(HttpServletRequest header, @PathVariable String nationalCode) {
        if (Objects.requireNonNull(environment.getProperty("nicico.training.pass")).trim().equals(header.getHeader("X-Auth-Token"))) {
            return new ResponseEntity(new ViewTrainingFileDTO
                    .ViewTrainingFileSpecRs()
                    .setResponse(viewTrainingFileService.getByNationalCode(nationalCode)), HttpStatus.OK);
        } else {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("خطای دسترسی");
        }
    }

    @Loggable
    @GetMapping("/parameter/listByCode/{parameterCode}")
    public ResponseEntity<ElsQuestionTargetsDto> getParametersValueListByCode(HttpServletRequest header, @PathVariable String parameterCode) {
        ElsQuestionTargetsDto dto = new ElsQuestionTargetsDto();

        if (Objects.requireNonNull(environment.getProperty("nicico.training.pass")).trim().equals(header.getHeader("X-Auth-Token"))) {
            try {
                //for see all question target the parameterCode must be :=questionTarget
                List<ElsQuestionTargetDto> data;
                data = evaluationBeanMapper.toQuestionTargets(parameterService.getByCode(parameterCode).getResponse().getData());
                dto.setStatus(200);
                dto.setQuestionTargetDtoList(data);
                return new ResponseEntity<>(dto, HttpStatus.OK);
            } catch (Exception e) {
                dto.setStatus(TrainingException.ErrorType.NotFound.getHttpStatusCode());
                dto.setMessage("کد مورد نظر شما یافت نشد");
                return new ResponseEntity<>(dto, HttpStatus.NOT_FOUND);

            }
        } else {
            dto.setStatus(TrainingException.ErrorType.Unauthorized.getHttpStatusCode());
            dto.setMessage("شما دسترسی ندارید");
            return new ResponseEntity<>(dto, HttpStatus.UNAUTHORIZED);
        }

    }

    @GetMapping("/role/findBy-nationalCode")
    public ResponseEntity<Set<String>> findAllRoleByNationalCode(@RequestParam String nationalCode) {
        return ResponseEntity.ok(iStudentService.findAllRoleByNationalCode(nationalCode));
    }

    @GetMapping("/role/")
    public ResponseEntity<List<Role>> findAllRole() {
        return ResponseEntity.ok(iRoleService.findAll());
    }

    @DeleteMapping("/role/")
    public ResponseEntity<Boolean> removeRoleByNationalCode(@RequestParam String nationalCode, @RequestParam String role) {
        return ResponseEntity.ok(iTeacherRoleService.removeTeacherRole(nationalCode, role));
    }

    @PostMapping("/role/")
    public ResponseEntity<Boolean> addRoleByNationalCode(@RequestParam String nationalCode, @RequestParam String role) {
        return ResponseEntity.ok(iTeacherRoleService.addRoleByNationalCode(nationalCode, role));
    }



    @GetMapping("/anonymous-number/status")
    public ResponseEntity<Boolean> mobileNumberVerifyStatus(@RequestParam String nationalCode, @RequestParam String number) {
        return ResponseEntity.ok(iMobileVerifyService.checkVerificationIfNotPresentAdd(nationalCode, number));
    }

    @PostMapping("/set-score")
    public ResponseEntity<BaseResponse> setScore(HttpServletRequest header,@RequestBody ElsExamScore elsExamScore) {
        BaseResponse response =new BaseResponse();
        if (Objects.requireNonNull(environment.getProperty("nicico.training.pass")).trim().equals(header.getHeader("X-Auth-Token"))) {
            try {
                response  = classStudentService.updateScore(elsExamScore);
            } catch (Exception e) {
                response.setStatus(HttpStatus.NOT_ACCEPTABLE.value());
                response.setMessage(((TrainingException) e).getMsg());
            }
        } else {
            response.setStatus(HttpStatus.UNAUTHORIZED.value());
            response.setMessage("خطای دسترسی");
        }
        return new ResponseEntity<>(response, HttpStatus.valueOf(response.getStatus()));
    }

    @GetMapping("/event")
    public ResponseEntity<EventListDto> getEventByNationalCode(HttpServletRequest header
            , @RequestParam String type
            , @RequestParam String nationalCode
            , @RequestParam String startDate
            , @RequestParam String endDate
    ) {
        EventListDto response =new EventListDto();
        if (Objects.requireNonNull(environment.getProperty("nicico.training.pass")).trim().equals(header.getHeader("X-Auth-Token"))) {
            try {
                switch (type) {
                    case "student": {
                        response  = iClassSessionService.getStudentEvent(nationalCode,startDate,endDate);
                        break;
                    }
                    case "teacher": {
                        response  = iClassSessionService.getTeacherEvent(nationalCode,startDate,endDate);
                    }
                }
                response.setStatus(200);
            } catch (Exception e) {
                response.setStatus(HttpStatus.NOT_ACCEPTABLE.value());
                response.setMessage(((TrainingException) e).getMsg());
            }
        } else {
            response.setStatus(HttpStatus.UNAUTHORIZED.value());
            response.setMessage("خطای دسترسی");
        }
        return new ResponseEntity<>(response, HttpStatus.OK);
    }







}
