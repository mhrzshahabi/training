package com.nicico.training.mapper.evaluation;


import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.ParameterValueDTO;
import com.nicico.training.dto.QuestionBankDTO;
import com.nicico.training.dto.TclassDTO;
import com.nicico.training.dto.TeacherDTO;
import com.nicico.training.dto.question.ElsExamRequestResponse;
import com.nicico.training.dto.question.ElsResendExamRequestResponse;
import com.nicico.training.dto.question.ExamQuestionsObject;
import com.nicico.training.dto.question.QuestionAttachments;
import com.nicico.training.iservice.*;
import com.nicico.training.model.*;
import com.nicico.training.repository.*;
import com.nicico.training.service.QuestionBankService;
import com.nicico.training.service.QuestionnaireService;
import com.nicico.training.service.TeacherService;
import com.nicico.training.utility.persianDate.MyUtils;
import dto.Question.QuestionData;
import dto.Question.QuestionScores;
import dto.evaluuation.EvalCourse;
import dto.evaluuation.EvalCourseProtocol;
import dto.evaluuation.EvalQuestionDto;
import dto.evaluuation.EvalTargetUser;
import dto.exam.*;
import org.joda.time.DateTime;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Named;
import org.mapstruct.ReportingPolicy;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import request.evaluation.ElsEvalRequest;
import request.evaluation.ElsUserEvaluationListResponseDto;
import request.exam.*;
import response.BaseResponse;
import response.evaluation.dto.ElsContactEvaluationDto;
import response.exam.ExamListResponse;
import response.exam.ExamQuestionsDto;
import response.exam.ExamResultDto;
import response.question.QuestionsDto;
import response.question.dto.ElsQuestionTargetDto;

import java.math.BigDecimal;
import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

import static com.nicico.training.utility.persianDate.PersianDate.*;
import static dto.exam.EQuestionType.*;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN, uses = QuestionBankService.class)
public abstract class EvaluationBeanMapper {


    @Autowired
    protected IParameterValueService iParameterValueService;
    @Autowired
    protected IParameterService iParameterService;

    @Autowired
    protected IQuestionBankService questionBankService;
    @Autowired
    protected QuestionnaireService questionnaireService;
    @Autowired
    protected IAttachmentService attachmentService;
    @Autowired
    protected ITclassService iTclassService;
    @Autowired
    protected ITeacherService iTeacherService;
    @Autowired
    protected IClassStudentService iClassStudentService;
    @Autowired
    protected ModelMapper modelMapper;
    @Autowired
    protected IPersonalInfoService iPersonalInfoService;
    @Autowired
    protected TeacherService teacherService;
    @Autowired
    protected IQuestionProtocolService iQuestionProtocolService;
    @Autowired
    protected ITestQuestionService iTestQuestionService;

    @Autowired
    protected QuestionBankTestQuestionDAO questionBankTestQuestionDAO;

    @Autowired
    protected IEvaluationService evaluationService;

    @Autowired
    protected TeacherDAO teacherDAO;

    @Autowired
    protected PersonalInfoDAO personalInfoDAO;

    @Autowired
    protected ClassStudentDAO classStudentDAO;
    @Autowired
    protected ViewActivePersonnelDAO viewActivePersonnelDAO;

    private final Boolean hasDuplicateQuestion = true;

    @Mapping(source = "firstName", target = "surname")
    @Mapping(source = "lastName", target = "lastName")
    @Mapping(source = "nationalCode", target = "nationalCode")
    @Mapping(source = "gender", target = "gender")
    @Mapping(source = "id", target = "studentId")
    @Mapping(source = "contactInfo", target = "cellNumber", qualifiedByName = "getLiveCellNumber")
    public abstract EvalTargetUser toTargetUser(Student student);

    @Named("getLiveCellNumber")
    String getLiveCellNumber(ContactInfo contactInfo) {
        if (contactInfo == null)
            return "";
        if (contactInfo.getEMobileForSMS() == null)
            return contactInfo.getMobile();
        return switch (contactInfo.getEMobileForSMS()) {
            case hrMobile -> contactInfo.getHrMobile();
            case mdmsMobile -> contactInfo.getMdmsMobile();
            case trainingSecondMobile -> contactInfo.getMobile2();
            default -> contactInfo.getMobile();
        };

    }

    public ElsEvalRequest toElsEvalRequest(Evaluation evaluation, Questionnaire questionnaire, List<ClassStudent> classStudents,
                                           List<EvalQuestionDto> questionDtos, PersonalInfo teacher) {
        ElsEvalRequest request = new ElsEvalRequest();


        EvalCourse evalCourse = new EvalCourse();
        EvalCourseProtocol evalCourseProtocol = new EvalCourseProtocol();
        request.setId(evaluation.getId());
        request.setClassId(evaluation.getTclass().getId());
        request.setQuestionnaireId(evaluation.getQuestionnaireId());
        request.setTitle(questionnaire.getTitle());
        try {
            request.setOrganizer(evaluation.getTclass().getOrganizer().getTitleFa());
            request.setPlanner(evaluation.getTclass().getPlanner() != null ? (evaluation.getTclass().getPlanner().getFirstName() + " " +
                    evaluation.getTclass().getPlanner().getLastName()) : "");
        } catch (NullPointerException ignored) {
        }
        request.setTargetUsers(classStudents.stream()
                .map(classStudent -> toTargetUser(classStudent.getStudent())).collect(Collectors.toList()));
        request.setQuestions(questionDtos);


        evalCourse.setTitle(evaluation.getTclass().getCourse().getTitleFa());
        evalCourse.setCode(evaluation.getTclass().getCourse().getCode());
        //
        evalCourseProtocol.setCode(evaluation.getTclass().getCode());

        if (evaluation.getTclass().getDDuration() != null) {
            evalCourseProtocol.setDuration(evaluation.getTclass().getDDuration() + "/d");
        } else
            evalCourseProtocol.setDuration(evaluation.getTclass().getHDuration() + "/h");

        evalCourseProtocol.setFinishDate(evaluation.getTclass().getEndDate());
        evalCourseProtocol.setStartDate(evaluation.getTclass().getStartDate());
        evalCourseProtocol.setTitle(evaluation.getTclass().getTitleClass());


        request.setTeacher(toTeacher(teacher));
        request.setCourse(evalCourse);
        request.setCourseProtocol(evalCourseProtocol);
        return request;
    }


    public ElsUserEvaluationListResponseDto toElsEvalResponseDto(Evaluation evaluation, Questionnaire questionnaire,
                                                                 List<EvalQuestionDto> questionDtos, PersonalInfo teacher) {
        ElsUserEvaluationListResponseDto responseDto = new ElsUserEvaluationListResponseDto();

        EvalCourse evalCourse = new EvalCourse();
        EvalCourseProtocol evalCourseProtocol = new EvalCourseProtocol();
        responseDto.setId(evaluation.getId());
        responseDto.setClassId(evaluation.getTclass().getId());
        responseDto.setQuestionnaireId(evaluation.getQuestionnaireId());
        responseDto.setTitle(questionnaire.getTitle());
        try {
            responseDto.setOrganizer(evaluation.getTclass().getOrganizer().getTitleFa());
            responseDto.setPlanner(evaluation.getTclass().getPlanner() != null ? (evaluation.getTclass().getPlanner().getFirstName() + " " +
                    evaluation.getTclass().getPlanner().getLastName()) : "");
        } catch (NullPointerException ignored) {
        }
        responseDto.setQuestions(questionDtos);

        evalCourse.setTitle(evaluation.getTclass().getCourse().getTitleFa());
        evalCourse.setCode(evaluation.getTclass().getCourse().getCode());

        evalCourseProtocol.setCode(evaluation.getTclass().getCode());

        if (evaluation.getTclass().getDDuration() != null) {
            evalCourseProtocol.setDuration(evaluation.getTclass().getDDuration() + "/d");
        } else
            evalCourseProtocol.setDuration(evaluation.getTclass().getHDuration() + "/h");

        evalCourseProtocol.setFinishDate(evaluation.getTclass().getEndDate());
        evalCourseProtocol.setStartDate(evaluation.getTclass().getStartDate());
        evalCourseProtocol.setTitle(evaluation.getTclass().getTitleClass());


        responseDto.setTeacher(toTeacher(teacher));
        responseDto.setCourse(evalCourse);
        responseDto.setCourseProtocol(evalCourseProtocol);
        return responseDto;
    }

    public List<ElsContactEvaluationDto> toElsContactEvaluationDTOList(List<Evaluation> evaluations) {
        List<ElsContactEvaluationDto> elsContactEvaluationDtos = new ArrayList<>();
        for (Evaluation evaluation : evaluations) {
            ElsContactEvaluationDto dto = new ElsContactEvaluationDto();
            EvalCourseProtocol evalCourseProtocol = new EvalCourseProtocol();
            dto.setId(evaluation.getId());
            Questionnaire questionnaire = questionnaireService.get(evaluation.getQuestionnaireId());
            dto.setTitle(questionnaire.getTitle());
            if (evaluation.getEvaluationLevelId().equals(156L)) {
                Optional<ClassStudent> classStudent = classStudentDAO.findById(evaluation.getEvaluatedId());
                classStudent.ifPresent(student -> dto.setTitle(questionnaire.getTitle() + "(" + student.getStudent().getFirstName() + " " + student.getStudent().getLastName() + ")"));
            }
            dto.setQuestionnaireId(evaluation.getQuestionnaireId());
            if (evaluation.getEvaluatorTypeId() == 187L) {
                Optional<Teacher> teacher = teacherDAO.findById(evaluation.getEvaluatorId());
                if (teacher.isPresent()) {
                    Optional<PersonalInfo> personalInfo = personalInfoDAO.findById(teacher.get().getPersonalityId());
                    personalInfo.ifPresent(info -> dto.setEvaluated(info.getFirstNameFa() + " " + info.getLastNameFa()));

                }
            } else if (evaluation.getEvaluatorTypeId() == 188L) {
                Optional<ClassStudent> classStudent = classStudentDAO.findById(evaluation.getEvaluatorId());
                if (classStudent.isPresent() && classStudent.get().getStudent() != null)
                    dto.setEvaluated(classStudent.get().getStudent().getFirstName() + " " + classStudent.get().getStudent().getLastName());
            } else {
                Optional<ViewActivePersonnel> activePersonnel = viewActivePersonnelDAO.findById(evaluation.getEvaluatorId());
                activePersonnel.ifPresent(viewActivePersonnel -> dto.setEvaluated(viewActivePersonnel.getFirstName() + " " + viewActivePersonnel.getLastName()));
            }
            dto.setClassId(evaluation.getClassId());
            dto.setOrganizer(evaluation.getTclass().getOrganizer().getTitleFa());
            dto.setPlanner(evaluation.getTclass().getPlanner() != null ? (evaluation.getTclass().getPlanner().getFirstName() + " " +
                    evaluation.getTclass().getPlanner().getLastName()) : "");
            PersonalInfo teacher = iPersonalInfoService.getPersonalInfo(teacherService.getTeacher(evaluation.getTclass().getTeacherId()).getPersonalityId());
            dto.setTeacherFullName(teacher.getFirstNameFa() + " " +
                    teacher.getLastNameFa());

            evalCourseProtocol.setCode(evaluation.getTclass().getCode());
            if (evaluation.getTclass().getDDuration() != null) {
                evalCourseProtocol.setDuration(evaluation.getTclass().getDDuration() + "/d");
            } else
                evalCourseProtocol.setDuration(evaluation.getTclass().getHDuration() + "/h");

            evalCourseProtocol.setFinishDate(evaluation.getTclass().getEndDate());
            evalCourseProtocol.setStartDate(evaluation.getTclass().getStartDate());
            evalCourseProtocol.setTitle(evaluation.getTclass().getTitleClass());
            dto.setCourseProtocol(evalCourseProtocol);
            String type = iParameterValueService.getInfo(evaluation.getEvaluationLevelId()).getCode();
            TotalResponse<ParameterValueDTO.Info> parameterValues = iParameterService.getByCode("ClassConfig");
            int deadLineDaysValue = Integer.parseInt(iParameterValueService.getInfoByCode("reactiveEvaluationDeadline").getValue());
            boolean checkClassBasisDate=MyUtils.checkClassBasisDate(evaluation.getTclass().getEndDate(),parameterValues);
            dto.setEvaluationExpired(MyUtils.isEvaluationExpired(evaluation.getTclass().getEndDate(), type,deadLineDaysValue) && checkClassBasisDate);

            elsContactEvaluationDtos.add(dto);


        }
        return elsContactEvaluationDtos;
    }

    public ElsExamRequest toElsExamRequest(Long classId) {

        ElsExamRequest elsExamRequest = new ElsExamRequest();

        ImportedCourseCategory importedCourseCategory = new ImportedCourseCategory();
        ImportedCourseDto importedCourseDto = new ImportedCourseDto();
        CourseProtocolImportDTO courseProtocolImportDTO = new CourseProtocolImportDTO();
        ImportedUser instructor = new ImportedUser();
        List<EvalTargetUser> users = new ArrayList<>();

        if (classId == null)
            throw new TrainingException(TrainingException.ErrorType.NotFound);

        try {

            TclassDTO.Info info = iTclassService.get(classId);
            TeacherDTO.Info teacherDTO = iTeacherService.get(info.getTeacherId());
            List<ClassStudent> classStudents = iClassStudentService.getClassStudents(classId);
            ExamClassData examClassData = modelMapper.map(info, ExamClassData.class);

            importedCourseCategory.setName(info.getCourse().getCategory().getTitleFa());
            importedCourseCategory.setCode(info.getCourse().getCategory().getCode());

            importedCourseDto.setName(info.getCourse().getTitleFa());
            importedCourseDto.setCode(info.getCourse().getCode());

            instructor.setSurname(teacherDTO.getPersonality().getFirstNameFa());
            instructor.setLastName(teacherDTO.getPersonality().getLastNameFa());
            instructor.setCellNumber(teacherDTO.getPersonality().getContactInfo().getMobile());
            instructor.setNationalCode(teacherDTO.getPersonality().getNationalCode());
            instructor.setGender(teacherDTO.getPersonality().getEGender() != null ? teacherDTO.getPersonality().getEGender().getTitleFa() : null);

            users.addAll(getClassUsers(classStudents));

            courseProtocolImportDTO.setName(info.getTitleClass());
            courseProtocolImportDTO.setCode(info.getCode());
            courseProtocolImportDTO.setCapacity(Math.toIntExact(info.getMaxCapacity()));
            courseProtocolImportDTO.setDuration(Math.toIntExact(info.getHDuration()));
            courseProtocolImportDTO.setCourseStatus(CourseStatus.ACTIVE);
            courseProtocolImportDTO.setClassType(ClassType.ATTENDANCE);
            courseProtocolImportDTO.setCourseType(CourseType.IMPERETIVE);
            courseProtocolImportDTO.setStartDate(getDateFromStringDate(info.getStartDate()).getTime());
            courseProtocolImportDTO.setFinishDate(getDateFromStringDate(info.getEndDate()).getTime());

            elsExamRequest.setCategory(importedCourseCategory);
            elsExamRequest.setCourse(importedCourseDto);
            elsExamRequest.setProtocol(courseProtocolImportDTO);
            elsExamRequest.setPrograms(getPrograms(examClassData));
            elsExamRequest.setInstructor(instructor);
            elsExamRequest.setUsers(users);
        } catch (Exception e) {
            throw new TrainingException(TrainingException.ErrorType.NotFound);
        }
        return elsExamRequest;
    }

    @Mapping(source = "firstNameFa", target = "surname")
    @Mapping(source = "lastNameFa", target = "lastName")
    @Mapping(source = "nationalCode", target = "nationalCode")
    @Mapping(source = "gender", target = "gender")
    @Mapping(source = "contactInfo", target = "cellNumber", qualifiedByName = "getLiveCellNumber")
    public abstract EvalTargetUser toTeacher(PersonalInfo teacher);


    public ElsExamRequestResponse toGetExamRequest(Tclass tClass, PersonalInfo teacherInfo, ExamImportedRequest object, List<ClassStudent> classStudents) {
        ElsExamRequest request = new ElsExamRequest();
        ElsExamRequestResponse elsExamRequestResponse = new ElsExamRequestResponse();
        ExamQuestionsObject examQuestionsObject;

        //        if (object.getQuestions() != null && object.getQuestions().size() > 0)
//            timeQues = (time * 60) / object.getQuestions().size();

        ExamCreateDTO exam = getExamData(object, tClass);
        ImportedCourseCategory courseCategory = getCourseCategoryData(object);
        ImportedCourseDto courseDto = getCourseData(object);
        CourseProtocolImportDTO courseProtocol = getCourseProtocolData(object);

        examQuestionsObject = getQuestionsForFinalTest(object);
        List<ImportedQuestionProtocol> questionProtocols = examQuestionsObject.getProtocols();

        ImportedUser teacher = getTeacherData(teacherInfo);
//ToDo
        request.setUsers(classStudents.stream()
                .map(classStudent -> toTargetUser(classStudent.getStudent())).collect(Collectors.toList()));


        ////////////////////
        //todo
        exam.setType(getExamType(questionProtocols));
        if (exam.getType() != ExamType.MULTI_CHOICES)
            exam.setResultDate(1638036038L);


        request.setExam(exam);
        request.setCategory(courseCategory);
        request.setCourse(courseDto);
        request.setInstructor(teacher);
        request.setQuestionProtocols(questionProtocols);
        request.setPrograms(getPrograms(object.getExamItem().getTclass()));
        request.setProtocol(courseProtocol);

        elsExamRequestResponse.setElsExamRequest(request);
        if (examQuestionsObject.getStatus() != 200) {
            elsExamRequestResponse.setStatus(examQuestionsObject.getStatus());
            elsExamRequestResponse.setMessage(examQuestionsObject.getMessage());
        } else
            elsExamRequestResponse.setStatus(200);
        return elsExamRequestResponse;
    }

    public ElsExamRequestResponse toGetExamRequest2(Tclass tClass, PersonalInfo teacherInfo, TestQuestion exam, List<ClassStudent> classStudents) {
        ElsExamRequest request = new ElsExamRequest();
        ElsExamRequestResponse elsExamRequestResponse = new ElsExamRequestResponse();
        ExamQuestionsObject examQuestionsObject;

        int time = Math.toIntExact(exam.getDuration());

        int timeQues = 0;
        List<QuestionBankTestQuestion> QuestionBankTestQuestionList = questionBankTestQuestionDAO.findAllByTestQuestionId(exam.getId());
        if (QuestionBankTestQuestionList != null && QuestionBankTestQuestionList.size() > 0)
            timeQues = (time * 60) / QuestionBankTestQuestionList.size();

        ExamCreateDTO examData = getExamData2(exam, tClass, exam.getId());
        ImportedCourseCategory courseCategory = getCourseCategoryData2(exam);
        ImportedCourseDto courseDto = getCourseData2(exam);
        CourseProtocolImportDTO courseProtocol = getCourseProtocolData2(exam);

        examQuestionsObject = getQuestionsForPreTest(exam, timeQues, QuestionBankTestQuestionList);
        List<ImportedQuestionProtocol> questionProtocols = examQuestionsObject.getProtocols();

        ImportedUser teacher = getTeacherData(teacherInfo);
//ToDo
        request.setUsers(classStudents.stream()
                .map(classStudent -> toTargetUser(classStudent.getStudent())).collect(Collectors.toList()));


        ////////////////////
        //todo
        examData.setType(getExamType(questionProtocols));
        if (examData.getType() != ExamType.MULTI_CHOICES)
            examData.setResultDate(1638036038L);


        request.setExam(examData);
        request.setCategory(courseCategory);
        request.setCourse(courseDto);
        request.setInstructor(teacher);
        request.setQuestionProtocols(questionProtocols);
        request.setPrograms(getPrograms2(exam.getTclass()));
        request.setProtocol(courseProtocol);

        elsExamRequestResponse.setElsExamRequest(request);
        if (examQuestionsObject.getStatus() != 200) {
            elsExamRequestResponse.setStatus(examQuestionsObject.getStatus());
            elsExamRequestResponse.setMessage(examQuestionsObject.getMessage());
        } else
            elsExamRequestResponse.setStatus(200);
        return elsExamRequestResponse;
    }

    public ElsExamRequestResponse toGetPreExamRequest(Tclass tClass, PersonalInfo teacherInfo, ExamImportedRequest object, List<ClassStudent> classStudents, String type) {

        ElsExamRequest request = new ElsExamRequest();
        ElsExamRequestResponse elsExamRequestResponse = new ElsExamRequestResponse();
        ExamQuestionsObject examQuestionsObject;

        ExamCreateDTO exam = getPreExamData(object, tClass, type);
        ImportedCourseCategory courseCategory = getCourseCategoryData(object);
        ImportedCourseDto courseDto = getCourseData(object);
        CourseProtocolImportDTO courseProtocol = getCourseProtocolData(object);

        examQuestionsObject = getQuestionsForFinalTest(object);
        examQuestionsObject.getProtocols().forEach(question -> question.setTime(null));
        List<ImportedQuestionProtocol> questionProtocols = examQuestionsObject.getProtocols();

        ImportedUser teacher = getTeacherData(teacherInfo);

        request.setUsers(classStudents.stream()
                .map(classStudent -> toTargetUser(classStudent.getStudent())).collect(Collectors.toList()));

        ////////////////////
        //todo
        exam.setType(getExamType(questionProtocols));
        if (exam.getType() != ExamType.MULTI_CHOICES)
            exam.setResultDate(1638036038L);

        request.setExam(exam);
        request.setCategory(courseCategory);
        request.setCourse(courseDto);
        request.setInstructor(teacher);
        request.setQuestionProtocols(questionProtocols);
        request.setPrograms(getPrograms(object.getExamItem().getTclass()));
        request.setProtocol(courseProtocol);

        elsExamRequestResponse.setElsExamRequest(request);
        if (examQuestionsObject.getStatus() != 200) {
            elsExamRequestResponse.setStatus(examQuestionsObject.getStatus());
            elsExamRequestResponse.setMessage(examQuestionsObject.getMessage());
        } else
            elsExamRequestResponse.setStatus(200);
        return elsExamRequestResponse;
    }

    public ElsExamRequestResponse toGetPreExamRequest2(Tclass tClass, PersonalInfo teacherInfo, TestQuestion exam, List<ClassStudent> classStudents) {

        ElsExamRequest request = new ElsExamRequest();
        ElsExamRequestResponse elsExamRequestResponse = new ElsExamRequestResponse();
        ExamQuestionsObject examQuestionsObject;

        List<QuestionBankTestQuestion> QuestionBankTestQuestionList = questionBankTestQuestionDAO.findAllByTestQuestionId(exam.getId());

        ExamCreateDTO exam2 = getPreExamData2(exam, tClass, exam.getId());
        ImportedCourseCategory courseCategory = getCourseCategoryData2(exam);
        ImportedCourseDto courseDto = getCourseData2(exam);
        CourseProtocolImportDTO courseProtocol = getCourseProtocolData2(exam);

        ///todo mohamad... complete this
        examQuestionsObject = getQuestionsForPreTest(exam, 0, QuestionBankTestQuestionList);
        examQuestionsObject.getProtocols().forEach(question -> question.setTime(null));
        List<ImportedQuestionProtocol> questionProtocols = examQuestionsObject.getProtocols();

        ImportedUser teacher = getTeacherData(teacherInfo);

        request.setUsers(classStudents.stream()
                .map(classStudent -> toTargetUser(classStudent.getStudent())).collect(Collectors.toList()));

        exam2.setType(getExamType(questionProtocols));
        if (exam2.getType() != ExamType.MULTI_CHOICES)
            exam2.setResultDate(1638036038L);

        request.setExam(exam2);
        request.setCategory(courseCategory);
        request.setCourse(courseDto);
        //todo mohamad... complete this
        request.setInstructor(teacher);
        request.setQuestionProtocols(questionProtocols);
        request.setPrograms(getPrograms2(tClass));
        request.setProtocol(courseProtocol);

        elsExamRequestResponse.setElsExamRequest(request);
        if (examQuestionsObject.getStatus() != 200) {
            elsExamRequestResponse.setStatus(examQuestionsObject.getStatus());
            elsExamRequestResponse.setMessage(examQuestionsObject.getMessage());
        } else
            elsExamRequestResponse.setStatus(200);
        return elsExamRequestResponse;
    }

    public ElsResendExamRequestResponse toGetResendExamRequest(ResendExamImportedRequest object) {
        ElsExtendedExamRequest request = new ElsExtendedExamRequest();
        ElsResendExamRequestResponse elsResendExamRequestResponse = new ElsResendExamRequestResponse();
        int time = Math.toIntExact(object.getDuration());
        int zone = iParameterValueService.getZone("gmtTime");

        String newTime = convertToTimeZone(object.getTime(), zone);

        Date startDate = getEpochDate(object.getStartDate(), newTime);
        Date endDate = getEndDateFromDuration(getStringGeoDate(object.getStartDate(), newTime)
                , object.getDuration());

        request.setStartDate(startDate.getTime());
        request.setEndDate(endDate.getTime());
        request.setUsers(object.getUsers());
        request.setDuration(time);
        request.setSourceExamId(object.getSourceExamId());
        elsResendExamRequestResponse.setElsResendExamRequest(request);
        elsResendExamRequestResponse.setStatus(200);
        return elsResendExamRequestResponse;
    }

    private ImportedUser getTeacherData(PersonalInfo teacherInfo) {
        ImportedUser teacher = new ImportedUser();
        if (/*null !=teacherInfo.getGender() && */ null != teacherInfo.getContactInfo() && null != teacherInfo.getContactInfo().getMobile()) {

            teacher.setCellNumber(teacherInfo.getContactInfo().getMobile());
            teacher.setNationalCode(teacherInfo.getNationalCode());
            teacher.setGender(teacher.getGender() != null ? teacherInfo.getGender().getTitleFa() : null);
            teacher.setLastName(teacherInfo.getLastNameFa());
            teacher.setSurname(teacherInfo.getFirstNameFa());
        }
        return teacher;
    }

    private ExamQuestionsObject getQuestionsForFinalTest(ExamImportedRequest object) {
        ExamQuestionsObject examQuestionsObject = new ExamQuestionsObject();
        List<ImportedQuestionProtocol> questionProtocols = new ArrayList<>();
        Boolean findDuplicate = false;
        int examTime = Math.toIntExact(object.getExamItem().getDuration() != null ? object.getExamItem().getDuration() : 0);
        if (object.getQuestions().size() > 0) {
//            Double questionScore = (double) (20 / object.getQuestions().size());
            long totalQuestionsTime = 0;
            int questionsSize = 0;
            if (object.getQuestionData() != null) {
                totalQuestionsTime += object.getQuestionData().stream().mapToLong(questionScore -> {
                    String time = questionScore.getTime();
                    if (time == null)
                        return 0;
                    else
                        return Long.parseLong(questionScore.getTime());
                }).sum();
                questionsSize = object.getQuestionData().size();
            }
            for (QuestionData questionData : object.getQuestions()) {
                QuestionBank questionBank = questionBankService.getById(questionData.getQuestionBank().getId());

                EQuestionType type = convertQuestionType(questionData.getQuestionBank().getQuestionType().getTitle());

                if (type != null && type.equals(GROUPQUESTION)) {
                    Set<QuestionBank> gropQuestions = questionBank.getGroupQuestions();
                    for (QuestionBank groupQuestionBank : gropQuestions) {
                        ImportedQuestionProtocol protocol = GetGroupQuestionProtocolForFinalTest(groupQuestionBank, object, totalQuestionsTime, questionsSize, examTime);
                        protocol.setHasParent(true);
                        ImportedQuestion parent = GetGroupQuestionProtocolForFinalTest(questionBank, object, totalQuestionsTime, questionsSize, examTime).getQuestion();
                        protocol.setParent(parent);
                        questionProtocols.add(protocol);
                    }

                } else {

                    ImportedQuestionProtocol questionProtocol = new ImportedQuestionProtocol();

                    ImportedQuestion question = new ImportedQuestion();

                    QuestionAttachments attachments = getFilesForQuestion(questionBank.getId());
                    question.setId(questionData.getQuestionBank().getId());
                    question.setTitle(questionData.getQuestionBank().getQuestion());
                    question.setProposedPointValue(questionData.getQuestionBank().getProposedPointValue());
                    questionProtocol.setProposedPointValue(questionData.getQuestionBank().getProposedPointValue());
                    questionProtocol.setProposedTimeValue(questionData.getQuestionBank().getProposedTimeValue());
                    if (attachments != null && attachments.getFiles() != null)
                        question.setFiles(attachments.getFiles());
                    question.setType(convertQuestionType(questionData.getQuestionBank().getQuestionType().getTitle()));

                    if (question.getType().equals(MULTI_CHOICES)) {


                        List<ImportedQuestionOption> options = new ArrayList<>();


                        ImportedQuestionOption option1 = new ImportedQuestionOption();
                        ImportedQuestionOption option2 = new ImportedQuestionOption();
                        ImportedQuestionOption option3 = new ImportedQuestionOption();
                        ImportedQuestionOption option4 = new ImportedQuestionOption();
                        if (questionBank.getOption1() != null) {
                            option1.setTitle(questionBank.getOption1());
                            option1.setLabel("الف");
                            options.add(option1);
                            if (attachments != null && attachments.getOption1Files() != null)
                                option1.setMapFiles(attachments.getOption1Files());


                        }
                        if (questionBank.getOption2() != null) {
                            option2.setTitle(questionBank.getOption2());
                            option2.setLabel("ب");
                            options.add(option2);
                            if (attachments != null && attachments.getOption2Files() != null)
                                option2.setMapFiles(attachments.getOption2Files());

                        }
                        if (questionBank.getOption3() != null) {
                            option3.setTitle(questionBank.getOption3());
                            option3.setLabel("ج");
                            options.add(option3);
                            if (attachments != null && attachments.getOption3Files() != null)
                                option3.setMapFiles(attachments.getOption3Files());

                        }
                        if (questionBank.getOption4() != null) {
                            option4.setTitle(questionBank.getOption4());
                            option4.setLabel("د");
                            options.add(option4);
                            if (attachments != null && attachments.getOption4Files() != null)
                                option4.setMapFiles(attachments.getOption4Files());

                        }
                        if (!findDuplicate) {
                            String title = question.getTitle().toUpperCase().replaceAll("[\\s]", "");
                            findDuplicate = checkDuplicateQuestion(options, questionProtocols, title, question.getType());
                            if (findDuplicate) {
                                examQuestionsObject.setStatus(HttpStatus.CONFLICT.value());
                                examQuestionsObject.setMessage("در آزمون سوال تکراری وجود دارد");
                            }
                        }
                        if (options.size() == 0) {
                            examQuestionsObject.setStatus(HttpStatus.NOT_ACCEPTABLE.value());
                            examQuestionsObject.setMessage(String.format("گزینه های سوال «%s» تعیین نشده است.", question.getTitle()));
                            return examQuestionsObject;
                        }
                        question.setQuestionOption(options);
                        questionProtocol.setCorrectAnswerTitle(convertCorrectAnswer(questionBank.getMultipleChoiceAnswer(), questionBank));

                    } else if (question.getType().equals(DESCRIPTIVE)) {
                        if (!findDuplicate) {
                            String title = question.getTitle().toUpperCase().replaceAll("[\\s]", "");
                            findDuplicate = checkDuplicateDescriptiveQuestions(questionProtocols, title, question.getType());
                            if (findDuplicate) {
                                examQuestionsObject.setStatus(HttpStatus.CONFLICT.value());
                                examQuestionsObject.setMessage("در آزمون سوال تکراری وجود دارد");
                            }
                        }
                        questionProtocol.setCorrectAnswerTitle(questionBank.getDescriptiveAnswer());
                        question.setHasAttachment(questionBank.getHasAttachment());
                    }


                    if (object.getQuestionData() != null) {


                        QuestionScores questionScore = object.getQuestionData().stream()
                                .filter(x -> x.getId().equals(question.getId()))
                                .findFirst()
                                .get();

                        questionProtocol.setMark(Double.valueOf(questionScore.getScore()));
                        int t = 0;
                        if (questionScore.getTime() == null) {
                            t = 0;
                        } else {
                            t = Integer.parseInt(questionScore.getTime());
                        }

                        if (totalQuestionsTime != 0) {

                            questionProtocol.setTime(t * 60);
                        } else {
                            questionProtocol.setTime((examTime * 60) / questionsSize);

                        }


                    }


                    questionProtocol.setQuestion(question);
                    questionProtocol.setIsChild(questionData.getQuestionBank().getIsChild());
                    questionProtocol.setChildPriority(questionData.getQuestionBank().getChildPriority());
                    questionProtocols.add(questionProtocol);
                }

            }
        }
        examQuestionsObject.setProtocols(questionProtocols);
        if (!findDuplicate)
            examQuestionsObject.setStatus(HttpStatus.OK.value());
        return examQuestionsObject;
        /*return questionProtocols;*/
    }


    private ExamQuestionsObject getQuestionsForPreTest(TestQuestion exam, Integer timeQues, List<QuestionBankTestQuestion> questionBankTestQuestions) {
        ExamQuestionsObject examQuestionsObject = new ExamQuestionsObject();
        List<ImportedQuestionProtocol> questionProtocols = new ArrayList<>();
        Boolean findDuplicate = false;

        if (questionBankTestQuestions.size() > 0) {

            List<QuestionProtocol> questionProtocolList = iQuestionProtocolService.findAllByExamId(exam.getId());
            Map<Long, QuestionProtocol> protocolsMap = convertProtocolListToMap(questionProtocolList);

            for (QuestionBankTestQuestion questionData : questionBankTestQuestions) {

                QuestionBank questionBank = questionData.getQuestionBank();

                EQuestionType type = convertQuestionType(questionData.getQuestionBank().getQuestionType().getTitle());

                if (type != null && type.equals(GROUPQUESTION)) {
                    Set<QuestionBank> gropQuestions = questionBank.getGroupQuestions();
                    for (QuestionBank groupQuestionBank : gropQuestions) {
                        ImportedQuestionProtocol protocol = GetGroupQuestionProtocolForPreTest(groupQuestionBank, timeQues, protocolsMap);
                        protocol.setHasParent(true);
                        ImportedQuestion parent = GetGroupQuestionProtocolForPreTest(questionBank, timeQues, protocolsMap).getQuestion();
                        protocol.setParent(parent);
                        questionProtocols.add(protocol);
                    }

                } else {

                    ImportedQuestionProtocol questionProtocol = new ImportedQuestionProtocol();

                    ImportedQuestion question = new ImportedQuestion();

                    QuestionAttachments attachments = getFilesForQuestion(questionBank.getId());
                    question.setId(questionData.getQuestionBank().getId());
                    question.setTitle(questionData.getQuestionBank().getQuestion());
                    if (attachments != null && attachments.getFiles() != null)
                        question.setFiles(attachments.getFiles());
                    question.setType(convertQuestionType(questionData.getQuestionBank().getQuestionType().getTitle()));

                    if (question.getType().equals(MULTI_CHOICES)) {


                        List<ImportedQuestionOption> options = new ArrayList<>();


                        ImportedQuestionOption option1 = new ImportedQuestionOption();
                        ImportedQuestionOption option2 = new ImportedQuestionOption();
                        ImportedQuestionOption option3 = new ImportedQuestionOption();
                        ImportedQuestionOption option4 = new ImportedQuestionOption();
                        if (questionBank.getOption1() != null) {
                            option1.setTitle(questionBank.getOption1());
                            option1.setLabel("الف");
                            options.add(option1);
                            if (attachments != null && attachments.getOption1Files() != null)
                                option1.setMapFiles(attachments.getOption1Files());


                        }
                        if (questionBank.getOption2() != null) {
                            option2.setTitle(questionBank.getOption2());
                            option2.setLabel("ب");
                            options.add(option2);
                            if (attachments != null && attachments.getOption2Files() != null)
                                option2.setMapFiles(attachments.getOption2Files());

                        }
                        if (questionBank.getOption3() != null) {
                            option3.setTitle(questionBank.getOption3());
                            option3.setLabel("ج");
                            options.add(option3);
                            if (attachments != null && attachments.getOption3Files() != null)
                                option3.setMapFiles(attachments.getOption3Files());

                        }
                        if (questionBank.getOption4() != null) {
                            option4.setTitle(questionBank.getOption4());
                            option4.setLabel("د");
                            options.add(option4);
                            if (attachments != null && attachments.getOption4Files() != null)
                                option4.setMapFiles(attachments.getOption4Files());

                        }
                        if (!findDuplicate) {
                            String title = question.getTitle().toUpperCase().replaceAll("[\\s]", "");
                            findDuplicate = checkDuplicateQuestion(options, questionProtocols, title, question.getType());
                            if (findDuplicate) {
                                examQuestionsObject.setStatus(HttpStatus.CONFLICT.value());
                                examQuestionsObject.setMessage("در آزمون سوال تکراری وجود دارد");
                            }
                        }
                        question.setQuestionOption(options);
                        questionProtocol.setCorrectAnswerTitle(convertCorrectAnswer(questionBank.getMultipleChoiceAnswer(), questionBank));

                    } else if (question.getType().equals(DESCRIPTIVE)) {
                        if (!findDuplicate) {
                            String title = question.getTitle().toUpperCase().replaceAll("[\\s]", "");
                            findDuplicate = checkDuplicateDescriptiveQuestions(questionProtocols, title, question.getType());
                            if (findDuplicate) {
                                examQuestionsObject.setStatus(HttpStatus.CONFLICT.value());
                                examQuestionsObject.setMessage("در آزمون سوال تکراری وجود دارد");
                            }
                        }
                        questionProtocol.setCorrectAnswerTitle(questionBank.getDescriptiveAnswer());
                        question.setHasAttachment(questionBank.getHasAttachment());
                    }
                    QuestionProtocol protocol = protocolsMap.get(question.getId());
                    if (protocol != null) {
                        if (protocol.getQuestionMark() != null)
                            questionProtocol.setMark(Double.valueOf(protocol.getQuestionMark()));


                        questionProtocol.setTime(timeQues);
                        questionProtocol.setQuestion(question);
                        questionProtocol.setIsChild(questionData.getQuestionBank().getIsChild());
                        questionProtocol.setChildPriority(questionData.getQuestionBank().getChildPriority());
                        questionProtocols.add(questionProtocol);
                    }


                }


            }
        }
        examQuestionsObject.setProtocols(questionProtocols);
        if (!findDuplicate)
            examQuestionsObject.setStatus(HttpStatus.OK.value());
        return examQuestionsObject;
        /*return questionProtocols;*/
    }


    public Map<Long, QuestionProtocol> convertProtocolListToMap(List<QuestionProtocol> list) {
        return list.stream()
                .collect(Collectors.toMap(QuestionProtocol::getQuestionId, Function.identity()));
    }

//    @Mapping(source = "id", target = "id")
//    @Mapping(source = "questionMark", target = "mark")
//    @Mapping(source = "correctAnswerTitle", target = "correctAnswerTitle")
//    @Mapping(source = "exam", target = "question")
//    public abstract List<ImportedQuestionProtocol> toQuestionProtocolDtos(List<QuestionProtocol> questionProtocolList);

    private QuestionAttachments getFilesForQuestion(Long id) {
        return attachmentService.getFiles("QuestionBank", id);
    }

    private Boolean checkDuplicateDescriptiveQuestions(List<ImportedQuestionProtocol> protocols, String title, EQuestionType type) {
        if (protocols.size() > 0) {
            final List<ImportedQuestion> questions = protocols.stream().map(ImportedQuestionProtocol::getQuestion).collect(Collectors.toList());
            List<String> questionsTitle = questions.stream().filter(t -> t.getType().equals(type)).map(ImportedQuestion::getTitle)
                    .map(str -> str.toUpperCase().replaceAll("[\\s]", ""))
                    .collect(Collectors.toList());
            final boolean matchedTitle = questionsTitle.stream().anyMatch(t -> t.equals(title));
            if (matchedTitle) {
                return hasDuplicateQuestion;
            }

        }
        return !hasDuplicateQuestion;
    }

    private Boolean checkDuplicateQuestion(List<ImportedQuestionOption> newOptions, List<ImportedQuestionProtocol> protocols, String title, EQuestionType type) {
        if (protocols.size() > 0) {
            final List<String> newOptionsList = newOptions.stream().map(ImportedQuestionOption::getTitle)
                    .map(str -> str.toUpperCase().replaceAll("[\\s]", ""))
                    .collect(Collectors.toList());
            List<String> targetOptionsList;
            final List<ImportedQuestion> questions = protocols.stream().map(ImportedQuestionProtocol::getQuestion).collect(Collectors.toList());
            List<String> questionsTitle = questions.stream().map(ImportedQuestion::getTitle)
                    .map(str -> str.toUpperCase().replaceAll("[\\s]", ""))
                    .collect(Collectors.toList());
            final boolean matchedTitle = questionsTitle.stream().anyMatch(t -> t.equals(title));
            List<String> duplicateOptions = new ArrayList<>();
            if (matchedTitle) {
                for (ImportedQuestion question : questions) {
                    String questionTitle = question.getTitle().toUpperCase().replaceAll("[\\s]", "");
                    if (questionTitle.equals(title) && question.getType().equals(type)) {
                        targetOptionsList = question.getQuestionOption().stream().map(ImportedQuestionOption::getTitle)
                                .map(str -> str.toUpperCase().replaceAll("[\\s]", ""))
                                .collect(Collectors.toList());
                        duplicateOptions = targetOptionsList.stream().filter(newOptionsList::contains)
                                .collect(Collectors.toList());
                    }
                }
                if (duplicateOptions.size() == newOptions.size())
                    return hasDuplicateQuestion;
            }
        }
        return !hasDuplicateQuestion;
    }


    private CourseProtocolImportDTO getCourseProtocolData(ExamImportedRequest object) {
        CourseProtocolImportDTO courseProtocol = new CourseProtocolImportDTO();
        if (null != object.getExamItem().getTclass().getMaxCapacity())
            courseProtocol.setCapacity(Math.toIntExact(object.getExamItem().getTclass().getMaxCapacity()));
        courseProtocol.setCode(object.getExamItem().getTclass().getCode());
        courseProtocol.setName(object.getExamItem().getTclass().getTitleClass());
        courseProtocol.setStartDate(getDateFromStringDate(object.getExamItem().getTclass().getStartDate()).getTime());
        courseProtocol.setFinishDate(getDateFromStringDate(object.getExamItem().getTclass().getEndDate()).getTime());
//todo
        courseProtocol.setClassType(ClassType.ATTENDANCE);
        courseProtocol.setDuration(100);
        courseProtocol.setCourseStatus(CourseStatus.ACTIVE);
        courseProtocol.setCourseType(CourseType.IMPERETIVE);

        return courseProtocol;
    }

    private CourseProtocolImportDTO getCourseProtocolData2(TestQuestion exam) {
        CourseProtocolImportDTO courseProtocol = new CourseProtocolImportDTO();
        if (null != exam.getTclass().getMaxCapacity())
            courseProtocol.setCapacity(Math.toIntExact(exam.getTclass().getMaxCapacity()));
        courseProtocol.setCode(exam.getTclass().getCode());
        courseProtocol.setName(exam.getTclass().getTitleClass());
        courseProtocol.setStartDate(getDateFromStringDate(exam.getTclass().getStartDate()).getTime());
        courseProtocol.setFinishDate(getDateFromStringDate(exam.getTclass().getEndDate()).getTime());
//todo
        courseProtocol.setClassType(ClassType.ATTENDANCE);
        courseProtocol.setDuration(100);
        courseProtocol.setCourseStatus(CourseStatus.ACTIVE);
        courseProtocol.setCourseType(CourseType.IMPERETIVE);

        return courseProtocol;
    }

    private ImportedCourseDto getCourseData(ExamImportedRequest object) {
        ImportedCourseDto courseDto = new ImportedCourseDto();
        courseDto.setCode(object.getExamItem().getTclass().getCourse().getCode());
        courseDto.setName(object.getExamItem().getTclass().getCourse().getTitleFa());
        return courseDto;
    }


    private ImportedCourseDto getCourseData2(TestQuestion exam) {
        ImportedCourseDto courseDto = new ImportedCourseDto();
        courseDto.setCode(exam.getTclass().getCourse().getCode());
        courseDto.setName(exam.getTclass().getCourse().getTitleFa());
        return courseDto;
    }


    private ImportedCourseCategory getCourseCategoryData(ExamImportedRequest object) {
        ImportedCourseCategory courseCategory = new ImportedCourseCategory();
        courseCategory.setCode(object.getExamItem().getTclass().getCourse().getCategory().getCode());
        courseCategory.setName(object.getExamItem().getTclass().getCourse().getCategory().getTitleFa());
        return courseCategory;
    }

    private ImportedCourseCategory getCourseCategoryData2(TestQuestion exam) {
        ImportedCourseCategory courseCategory = new ImportedCourseCategory();
        courseCategory.setCode(exam.getTclass().getCourse().getCategory().getCode());
        courseCategory.setName(exam.getTclass().getCourse().getCategory().getTitleFa());
        return courseCategory;
    }

    private ExamCreateDTO getExamData(ExamImportedRequest object, Tclass tClass) {
        int time = Math.toIntExact(object.getExamItem().getDuration());
        int zone = iParameterValueService.getZone("gmtTime");

        String newTime = convertToTimeZone(object.getExamItem().getTime(), zone);
        String newEndTime = convertToTimeZone(object.getExamItem().getEndTime(), zone);
//        String newTime = object.getExamItem().getTime();

        Date startDate = getEpochDate(object.getExamItem().getDate(), newTime);

        Date endDate = getEpochDate(object.getExamItem().getEndDate(), newEndTime);
//        Date endDate = getEndDateFromDuration(getStringGeoDate(object.getExamItem().getDate(), newTime)
//                , object.getExamItem().getDuration());
        ExamCreateDTO exam = new ExamCreateDTO();
        exam.setCode(object.getExamItem().getTclass().getCode());
        exam.setName(object.getExamItem().getTclass().getTitleClass());
        exam.setStartDate(startDate.getTime());
        exam.setEndDate(endDate.getTime());
        Set<QuestionBankDTO.Exam> testQuestionBanks = iTestQuestionService.getAllQuestionsByTestQuestionId(object.getExamItem().getId());
        exam.setQuestionCount(getSizeOfQuestions(testQuestionBanks));
        exam.setSourceExamId(object.getExamItem().getId());
        exam.setMethod("FinalTest");

        exam.setDuration(time);

        if (tClass.getScoringMethod().equals("3")) {
            exam.setMinimumAcceptScore(Double.valueOf(tClass.getAcceptancelimit()));
            double classScore = (object.getExamItem().getClassScore() != null) ? Double.parseDouble(object.getExamItem().getClassScore()) : 0;
            double practicalScore = (object.getExamItem().getPracticalScore() != null) ? Double.parseDouble(object.getExamItem().getPracticalScore()) : 0;
            exam.setScore(20D - (classScore + practicalScore));
            exam.setFinalScore(20D);
            exam.setPracticalScore(practicalScore);
            exam.setClassScore(classScore);
        } else if (tClass.getScoringMethod().equals("2")) {
            if (null != tClass.getAcceptancelimit())
                exam.setMinimumAcceptScore(Double.valueOf(tClass.getAcceptancelimit()));
            else
                exam.setMinimumAcceptScore(50D);

            double classScore = (object.getExamItem().getClassScore() != null) ? Double.parseDouble(object.getExamItem().getClassScore()) : 0;
            double practicalScore = (object.getExamItem().getPracticalScore() != null) ? Double.parseDouble(object.getExamItem().getPracticalScore()) : 0;
            exam.setScore(100D - (classScore + practicalScore));
            exam.setFinalScore(100D);
            exam.setPracticalScore(practicalScore);
            exam.setClassScore(classScore);

        } else {
            exam.setMinimumAcceptScore(0D);

            exam.setScore(0D);
            exam.setFinalScore(0D);

        }


        if (dayIsTomorrow(startDate.getTime()))
            exam.setStatus(ExamStatus.UPCOMING);
        else
            exam.setStatus(ExamStatus.ACTIVE);

        return exam;
    }

    private Integer getSizeOfQuestions(Set<QuestionBankDTO.Exam> testQuestionBanks) {
        int childSize = 0;

        List<QuestionBankDTO.Exam> parents = testQuestionBanks.stream().filter(a -> a.getQuestionType().getTitle().equals(EQuestionType.GROUPQUESTION.getValue())).toList();
        for (QuestionBankDTO.Exam parent : parents) {
            childSize = parent.getChilds().size() + childSize;
        }
        return testQuestionBanks.size() + childSize - parents.size();
    }

    private ExamCreateDTO getExamData2(TestQuestion exam, Tclass tClass, Long examId) {
        Set<QuestionBankDTO.Exam> testQuestionBanks = iTestQuestionService.getAllQuestionsByTestQuestionId(examId);
        int time = Math.toIntExact(exam.getDuration());
        int zone = iParameterValueService.getZone("gmtTime");

        String newTime = convertToTimeZone(exam.getTime(), zone);
        String newEndTime = convertToTimeZone(exam.getEndTime(), zone);
//        String newTime = exam.getTime();

        Date startDate = getEpochDate(exam.getDate(), newTime);

        Date endDate = getEpochDate(exam.getEndDate(), newEndTime);
//        Date endDate = getEndDateFromDuration(getStringGeoDate(exam.getDate(), newTime)
//                , exam.getDuration());
        ExamCreateDTO examCreateDTO = new ExamCreateDTO();
        examCreateDTO.setCode(exam.getTclass().getCode());
        examCreateDTO.setName(exam.getTclass().getTitleClass());
        examCreateDTO.setStartDate(startDate.getTime());
        examCreateDTO.setEndDate(endDate.getTime());
        examCreateDTO.setQuestionCount(getSizeOfQuestions(testQuestionBanks));
        examCreateDTO.setSourceExamId(exam.getId());

        examCreateDTO.setDuration(time);

        if (tClass.getScoringMethod().equals("3")) {
            examCreateDTO.setMinimumAcceptScore(Double.valueOf(tClass.getAcceptancelimit()));
            double classScore = (exam.getClassScore() != null) ? Double.parseDouble(exam.getClassScore()) : 0;
            double practicalScore = (exam.getPracticalScore() != null) ? Double.parseDouble(exam.getPracticalScore()) : 0;
            examCreateDTO.setScore(20D - (classScore + practicalScore));
            examCreateDTO.setFinalScore(20D);
            examCreateDTO.setPracticalScore(practicalScore);
            examCreateDTO.setClassScore(classScore);

        } else if (tClass.getScoringMethod().equals("2")) {
            if (null != tClass.getAcceptancelimit())
                examCreateDTO.setMinimumAcceptScore(Double.valueOf(tClass.getAcceptancelimit()));
            else
                examCreateDTO.setMinimumAcceptScore(50D);

            double classScore = (exam.getClassScore() != null) ? Double.parseDouble(exam.getClassScore()) : 0;
            double practicalScore = (exam.getPracticalScore() != null) ? Double.parseDouble(exam.getPracticalScore()) : 0;
            examCreateDTO.setScore(100D - (classScore + practicalScore));
            examCreateDTO.setFinalScore(100D);

            examCreateDTO.setPracticalScore(practicalScore);
            examCreateDTO.setClassScore(classScore);

        } else {
            examCreateDTO.setMinimumAcceptScore(0D);

            examCreateDTO.setScore(0D);
            examCreateDTO.setFinalScore(0D);

        }


        if (dayIsTomorrow(startDate.getTime()))
            examCreateDTO.setStatus(ExamStatus.UPCOMING);
        else
            examCreateDTO.setStatus(ExamStatus.ACTIVE);

        return examCreateDTO;
    }

    private ExamCreateDTO getPreExamData(ExamImportedRequest object, Tclass tClass, String type) {

        ExamCreateDTO exam = new ExamCreateDTO();
        exam.setCode(object.getExamItem().getTclass().getCode());
        exam.setName(object.getExamItem().getTclass().getTitleClass());
        exam.setStartDate(null);
        exam.setEndDate(null);
        Set<QuestionBankDTO.Exam> testQuestionBanks = iTestQuestionService.getAllQuestionsByTestQuestionId(object.getExamItem().getId());
        exam.setQuestionCount(getSizeOfQuestions(testQuestionBanks));
        exam.setSourceExamId(object.getExamItem().getId());
        exam.setDuration(0);
        if (type.equalsIgnoreCase("preTest"))
            exam.setMethod("PreTest");
        else
            exam.setMethod("Preparation");

        if (tClass.getScoringMethod().equals("3")) {
            exam.setMinimumAcceptScore(Double.valueOf(tClass.getAcceptancelimit()));
            if (type.equalsIgnoreCase("preTest")) {
                exam.setScore(20D);
                exam.setFinalScore(20D);
            } else {
                double classScore = (object.getExamItem().getClassScore() != null) ? Double.parseDouble(object.getExamItem().getClassScore()) : 0;
                double practicalScore = (object.getExamItem().getPracticalScore() != null) ? Double.parseDouble(object.getExamItem().getPracticalScore()) : 0;
                exam.setScore(20D - (classScore + practicalScore));
                exam.setFinalScore(20D);
                exam.setPracticalScore(practicalScore);
                exam.setClassScore(classScore);
            }
        } else if (tClass.getScoringMethod().equals("2")) {
            if (null != tClass.getAcceptancelimit())
                exam.setMinimumAcceptScore(Double.valueOf(tClass.getAcceptancelimit()));
            else
                exam.setMinimumAcceptScore(50D);

            if (type.equalsIgnoreCase("preTest")) {
                exam.setScore(100D);
                exam.setFinalScore(100D);


            } else {
                double classScore = (object.getExamItem().getClassScore() != null) ? Double.parseDouble(object.getExamItem().getClassScore()) : 0;
                double practicalScore = (object.getExamItem().getPracticalScore() != null) ? Double.parseDouble(object.getExamItem().getPracticalScore()) : 0;
                exam.setScore(100D - (classScore + practicalScore));
                exam.setFinalScore(100D);
                exam.setPracticalScore(practicalScore);
                exam.setClassScore(classScore);
            }
        } else {
            exam.setMinimumAcceptScore(0D);
            exam.setScore(0D);
            exam.setFinalScore(0D);

        }

        exam.setStatus(ExamStatus.ACTIVE);
        return exam;
    }

    private ExamCreateDTO getPreExamData2(TestQuestion exam, Tclass tClass, Long examId) {

        ExamCreateDTO examDto = new ExamCreateDTO();
        examDto.setCode(exam.getTclass().getCode());
        examDto.setName(exam.getTclass().getTitleClass());
        examDto.setStartDate(null);
        examDto.setEndDate(null);
        Set<QuestionBankDTO.Exam> testQuestionBanks = iTestQuestionService.getAllQuestionsByTestQuestionId(examId);
        examDto.setQuestionCount(getSizeOfQuestions(testQuestionBanks));
        examDto.setSourceExamId(exam.getId());
        examDto.setDuration(0);

        if (tClass.getScoringMethod().equals("3")) {
            examDto.setMinimumAcceptScore(Double.valueOf(tClass.getAcceptancelimit()));
            examDto.setScore(20D);
            examDto.setFinalScore(20D);

        } else if (tClass.getScoringMethod().equals("2")) {
            if (null != tClass.getAcceptancelimit())
                examDto.setMinimumAcceptScore(Double.valueOf(tClass.getAcceptancelimit()));
            else
                examDto.setMinimumAcceptScore(50D);
            examDto.setScore(100D);
            examDto.setFinalScore(100D);

        } else {
            examDto.setMinimumAcceptScore(0D);
            examDto.setScore(0D);
            examDto.setFinalScore(0D);

        }

        examDto.setStatus(ExamStatus.ACTIVE);
        return examDto;
    }

    private List<ImportedCourseProgram> getPrograms(ExamClassData tclass) {
        List<ImportedCourseProgram> programs = new ArrayList<>();
        ////////////////////////////////////


        if (null != (tclass.getSaturday()) && tclass.getSaturday()) {


            if (null != (tclass.getFirst()) && tclass.getFirst()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("SATURDAY");
                program.setStartTime("8");
                program.setEndTime("10");
                programs.add(program);

            }
            if (null != (tclass.getSecond()) && tclass.getSecond()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("SATURDAY");
                program.setStartTime("10");
                program.setEndTime("12");
                programs.add(program);
            }
            if (null != (tclass.getThird()) && tclass.getThird()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("SATURDAY");
                program.setStartTime("12");
                program.setEndTime("14");
                programs.add(program);
            }
            if (null != (tclass.getFourth()) && tclass.getFourth()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("SATURDAY");
                program.setStartTime("14");
                program.setEndTime("16");
                programs.add(program);
            }
            if (null != (tclass.getFifth()) && tclass.getFifth()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("SATURDAY");
                program.setStartTime("16");
                program.setEndTime("18");
                programs.add(program);
            }


        }
        if (null != (tclass.getSunday()) && tclass.getSunday()) {


            if (null != (tclass.getFirst()) && tclass.getFirst()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("SUNDAY");
                program.setStartTime("8");
                program.setEndTime("10");
                programs.add(program);

            }
            if (null != (tclass.getSecond()) && tclass.getSecond()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("SUNDAY");
                program.setStartTime("10");
                program.setEndTime("12");
                programs.add(program);
            }
            if (null != (tclass.getThird()) && tclass.getThird()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("SUNDAY");
                program.setStartTime("12");
                program.setEndTime("14");
                programs.add(program);
            }
            if (null != (tclass.getFourth()) && tclass.getFourth()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("SUNDAY");
                program.setStartTime("14");
                program.setEndTime("16");
                programs.add(program);
            }
            if (null != (tclass.getFifth()) && tclass.getFifth()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("SUNDAY");
                program.setStartTime("16");
                program.setEndTime("18");
                programs.add(program);
            }


        }
        if (null != (tclass.getMonday()) && tclass.getMonday()) {


            if (null != (tclass.getFirst()) && tclass.getFirst()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("MONDAY");
                program.setStartTime("8");
                program.setEndTime("10");
                programs.add(program);

            }
            if (null != (tclass.getSecond()) && tclass.getSecond()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("MONDAY");
                program.setStartTime("10");
                program.setEndTime("12");
                programs.add(program);
            }
            if (null != (tclass.getThird()) && tclass.getThird()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("MONDAY");
                program.setStartTime("12");
                program.setEndTime("14");
                programs.add(program);
            }
            if (null != (tclass.getFourth()) && tclass.getFourth()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("MONDAY");
                program.setStartTime("14");
                program.setEndTime("16");
                programs.add(program);
            }
            if (null != (tclass.getFifth()) && tclass.getFifth()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("MONDAY");
                program.setStartTime("16");
                program.setEndTime("18");
                programs.add(program);
            }


        }
        if (null != (tclass.getTuesday()) && tclass.getTuesday()) {


            if (null != (tclass.getFirst()) && tclass.getFirst()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("TUESDAY");
                program.setStartTime("8");
                program.setEndTime("10");
                programs.add(program);

            }
            if (null != (tclass.getSecond()) && tclass.getSecond()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("TUESDAY");
                program.setStartTime("10");
                program.setEndTime("12");
                programs.add(program);
            }
            if (null != (tclass.getThird()) && tclass.getThird()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("TUESDAY");
                program.setStartTime("12");
                program.setEndTime("14");
                programs.add(program);
            }
            if (null != (tclass.getFourth()) && tclass.getFourth()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("TUESDAY");
                program.setStartTime("14");
                program.setEndTime("16");
                programs.add(program);
            }
            if (null != (tclass.getFifth()) && tclass.getFifth()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("TUESDAY");
                program.setStartTime("16");
                program.setEndTime("18");
                programs.add(program);
            }


        }
        if (null != (tclass.getWednesday()) && tclass.getWednesday()) {


            if (null != (tclass.getFirst()) && tclass.getFirst()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("WEDNESDAY");
                program.setStartTime("8");
                program.setEndTime("10");
                programs.add(program);

            }
            if (null != (tclass.getSecond()) && tclass.getSecond()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("WEDNESDAY");
                program.setStartTime("10");
                program.setEndTime("12");
                programs.add(program);
            }
            if (null != (tclass.getThird()) && tclass.getThird()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("WEDNESDAY");
                program.setStartTime("12");
                program.setEndTime("14");
                programs.add(program);
            }
            if (null != (tclass.getFourth()) && tclass.getFourth()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("WEDNESDAY");
                program.setStartTime("14");
                program.setEndTime("16");
                programs.add(program);
            }
            if (null != (tclass.getFifth()) && tclass.getFifth()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("WEDNESDAY");
                program.setStartTime("16");
                program.setEndTime("18");
                programs.add(program);
            }


        }
        if (null != (tclass.getThursday()) && tclass.getThursday()) {


            if (null != (tclass.getFirst()) && tclass.getFirst()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("THURSDAY");
                program.setStartTime("8");
                program.setEndTime("10");
                programs.add(program);

            }
            if (null != (tclass.getSecond()) && tclass.getSecond()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("THURSDAY");
                program.setStartTime("10");
                program.setEndTime("12");
                programs.add(program);
            }
            if (null != (tclass.getThird()) && tclass.getThird()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("THURSDAY");
                program.setStartTime("12");
                program.setEndTime("14");
                programs.add(program);
            }
            if (null != (tclass.getFourth()) && tclass.getFourth()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("THURSDAY");
                program.setStartTime("14");
                program.setEndTime("16");
                programs.add(program);
            }
            if (null != (tclass.getFifth()) && tclass.getFifth()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("THURSDAY");
                program.setStartTime("16");
                program.setEndTime("18");
                programs.add(program);
            }


        }
        if (null != (tclass.getFriday()) && tclass.getFriday()) {


            if (null != (tclass.getFirst()) && tclass.getFirst()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("FRIDAY");
                program.setStartTime("8");
                program.setEndTime("10");
                programs.add(program);

            }
            if (null != (tclass.getSecond()) && tclass.getSecond()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("FRIDAY");
                program.setStartTime("10");
                program.setEndTime("12");
                programs.add(program);
            }
            if (null != (tclass.getThird()) && tclass.getThird()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("FRIDAY");
                program.setStartTime("12");
                program.setEndTime("14");
                programs.add(program);
            }
            if (null != (tclass.getFourth()) && tclass.getFourth()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("FRIDAY");
                program.setStartTime("14");
                program.setEndTime("16");
                programs.add(program);
            }
            if (null != (tclass.getFifth()) && tclass.getFifth()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("FRIDAY");
                program.setStartTime("16");
                program.setEndTime("18");
                programs.add(program);
            }


        }

        return programs;
    }

    private List<ImportedCourseProgram> getPrograms2(Tclass tclass) {
        List<ImportedCourseProgram> programs = new ArrayList<>();
        ////////////////////////////////////


        if (null != (tclass.getSaturday()) && tclass.getSaturday()) {


            if (null != (tclass.getFirst()) && tclass.getFirst()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("SATURDAY");
                program.setStartTime("8");
                program.setEndTime("10");
                programs.add(program);

            }
            if (null != (tclass.getSecond()) && tclass.getSecond()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("SATURDAY");
                program.setStartTime("10");
                program.setEndTime("12");
                programs.add(program);
            }
            if (null != (tclass.getThird()) && tclass.getThird()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("SATURDAY");
                program.setStartTime("12");
                program.setEndTime("14");
                programs.add(program);
            }
            if (null != (tclass.getFourth()) && tclass.getFourth()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("SATURDAY");
                program.setStartTime("14");
                program.setEndTime("16");
                programs.add(program);
            }
            if (null != (tclass.getFifth()) && tclass.getFifth()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("SATURDAY");
                program.setStartTime("16");
                program.setEndTime("18");
                programs.add(program);
            }


        }
        if (null != (tclass.getSunday()) && tclass.getSunday()) {


            if (null != (tclass.getFirst()) && tclass.getFirst()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("SUNDAY");
                program.setStartTime("8");
                program.setEndTime("10");
                programs.add(program);

            }
            if (null != (tclass.getSecond()) && tclass.getSecond()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("SUNDAY");
                program.setStartTime("10");
                program.setEndTime("12");
                programs.add(program);
            }
            if (null != (tclass.getThird()) && tclass.getThird()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("SUNDAY");
                program.setStartTime("12");
                program.setEndTime("14");
                programs.add(program);
            }
            if (null != (tclass.getFourth()) && tclass.getFourth()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("SUNDAY");
                program.setStartTime("14");
                program.setEndTime("16");
                programs.add(program);
            }
            if (null != (tclass.getFifth()) && tclass.getFifth()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("SUNDAY");
                program.setStartTime("16");
                program.setEndTime("18");
                programs.add(program);
            }


        }
        if (null != (tclass.getMonday()) && tclass.getMonday()) {


            if (null != (tclass.getFirst()) && tclass.getFirst()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("MONDAY");
                program.setStartTime("8");
                program.setEndTime("10");
                programs.add(program);

            }
            if (null != (tclass.getSecond()) && tclass.getSecond()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("MONDAY");
                program.setStartTime("10");
                program.setEndTime("12");
                programs.add(program);
            }
            if (null != (tclass.getThird()) && tclass.getThird()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("MONDAY");
                program.setStartTime("12");
                program.setEndTime("14");
                programs.add(program);
            }
            if (null != (tclass.getFourth()) && tclass.getFourth()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("MONDAY");
                program.setStartTime("14");
                program.setEndTime("16");
                programs.add(program);
            }
            if (null != (tclass.getFifth()) && tclass.getFifth()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("MONDAY");
                program.setStartTime("16");
                program.setEndTime("18");
                programs.add(program);
            }


        }
        if (null != (tclass.getTuesday()) && tclass.getTuesday()) {


            if (null != (tclass.getFirst()) && tclass.getFirst()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("TUESDAY");
                program.setStartTime("8");
                program.setEndTime("10");
                programs.add(program);

            }
            if (null != (tclass.getSecond()) && tclass.getSecond()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("TUESDAY");
                program.setStartTime("10");
                program.setEndTime("12");
                programs.add(program);
            }
            if (null != (tclass.getThird()) && tclass.getThird()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("TUESDAY");
                program.setStartTime("12");
                program.setEndTime("14");
                programs.add(program);
            }
            if (null != (tclass.getFourth()) && tclass.getFourth()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("TUESDAY");
                program.setStartTime("14");
                program.setEndTime("16");
                programs.add(program);
            }
            if (null != (tclass.getFifth()) && tclass.getFifth()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("TUESDAY");
                program.setStartTime("16");
                program.setEndTime("18");
                programs.add(program);
            }


        }
        if (null != (tclass.getWednesday()) && tclass.getWednesday()) {


            if (null != (tclass.getFirst()) && tclass.getFirst()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("WEDNESDAY");
                program.setStartTime("8");
                program.setEndTime("10");
                programs.add(program);

            }
            if (null != (tclass.getSecond()) && tclass.getSecond()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("WEDNESDAY");
                program.setStartTime("10");
                program.setEndTime("12");
                programs.add(program);
            }
            if (null != (tclass.getThird()) && tclass.getThird()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("WEDNESDAY");
                program.setStartTime("12");
                program.setEndTime("14");
                programs.add(program);
            }
            if (null != (tclass.getFourth()) && tclass.getFourth()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("WEDNESDAY");
                program.setStartTime("14");
                program.setEndTime("16");
                programs.add(program);
            }
            if (null != (tclass.getFifth()) && tclass.getFifth()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("WEDNESDAY");
                program.setStartTime("16");
                program.setEndTime("18");
                programs.add(program);
            }


        }
        if (null != (tclass.getThursday()) && tclass.getThursday()) {


            if (null != (tclass.getFirst()) && tclass.getFirst()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("THURSDAY");
                program.setStartTime("8");
                program.setEndTime("10");
                programs.add(program);

            }
            if (null != (tclass.getSecond()) && tclass.getSecond()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("THURSDAY");
                program.setStartTime("10");
                program.setEndTime("12");
                programs.add(program);
            }
            if (null != (tclass.getThird()) && tclass.getThird()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("THURSDAY");
                program.setStartTime("12");
                program.setEndTime("14");
                programs.add(program);
            }
            if (null != (tclass.getFourth()) && tclass.getFourth()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("THURSDAY");
                program.setStartTime("14");
                program.setEndTime("16");
                programs.add(program);
            }
            if (null != (tclass.getFifth()) && tclass.getFifth()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("THURSDAY");
                program.setStartTime("16");
                program.setEndTime("18");
                programs.add(program);
            }


        }
        if (null != (tclass.getFriday()) && tclass.getFriday()) {


            if (null != (tclass.getFirst()) && tclass.getFirst()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("FRIDAY");
                program.setStartTime("8");
                program.setEndTime("10");
                programs.add(program);

            }
            if (null != (tclass.getSecond()) && tclass.getSecond()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("FRIDAY");
                program.setStartTime("10");
                program.setEndTime("12");
                programs.add(program);
            }
            if (null != (tclass.getThird()) && tclass.getThird()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("FRIDAY");
                program.setStartTime("12");
                program.setEndTime("14");
                programs.add(program);
            }
            if (null != (tclass.getFourth()) && tclass.getFourth()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("FRIDAY");
                program.setStartTime("14");
                program.setEndTime("16");
                programs.add(program);
            }
            if (null != (tclass.getFifth()) && tclass.getFifth()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("FRIDAY");
                program.setStartTime("16");
                program.setEndTime("18");
                programs.add(program);
            }


        }

        return programs;
    }

//    private Date getDate(String date, String time) {
//        if (!time.contains(":")) {
//            StringBuilder sb = new StringBuilder(time);
//            sb.insert(2, ':');
//            time = sb.toString();
//        }
//        long longDate = Date.from(java.sql.Timestamp
//                .valueOf(                           // Class-method parses SQL-style formatted date-time strings.
//                        getStringGeoDate(date, time)
//                )                                   // Returns a `Timestamp` object.
//                .toInstant()).getTime();
//
//        return new Date(longDate / 1000);
//    }
//
//    private String getStringGeoDate(String date, String time) {
//        if (null != time) {
//            if (!time.contains(":")) {
//                StringBuilder sb = new StringBuilder(time);
//                sb.insert(2, ':');
//                time = sb.toString();
//            }
//            String[] arr = date.split("/");
//
//            PersianDate persianDate = PersianDate.of(Integer.parseInt(arr[0]), Integer.parseInt(arr[1]), Integer.parseInt(arr[2]));
//            LocalDate gregDate = persianDate.toGregorian();
//            return gregDate.toString() + " " + time + ":00";
//        } else {
//            String[] arr = date.split("/");
//
//            PersianDate persianDate = PersianDate.of(Integer.parseInt(arr[0]), Integer.parseInt(arr[1]), Integer.parseInt(arr[2]));
//            LocalDate gregDate = persianDate.toGregorian();
//            return gregDate.toString();
//        }
//
//    }
//

    private String convertCorrectAnswer(Integer multipleChoiceAnswer, QuestionBank questionBank) {
        return switch (multipleChoiceAnswer) {
            case 1 -> questionBank.getOption1();
            case 2 -> questionBank.getOption2();
            case 3 -> questionBank.getOption3();
            case 4 -> questionBank.getOption4();
            default -> null;
        };
    }

    private EQuestionType convertQuestionType(String title) {

        return switch (title) {
            case "چند گزینه ای" -> MULTI_CHOICES;
            case "تشریحی" -> DESCRIPTIVE;
            case "سوالات گروهی" -> GROUPQUESTION;
            default -> null;
        };
    }

    private Date getDateFromStringDate(String date) {
        getStringGeoDate(date, null);
        long longDate = Date.from(java.sql.Timestamp
                .valueOf(                           // Class-method parses SQL-style formatted date-time strings.
                        getStringGeoDate(date, "08:00")
                )                                   // Returns a `Timestamp` object.
                .toInstant()).getTime();
        long time = longDate / 1000;

        return new Date(time);

    }

    private ExamType getExamType(List<ImportedQuestionProtocol> questionProtocols) {
        int multies = 0;
        int descriptive = 0;

        for (ImportedQuestionProtocol question : questionProtocols) {
            if (question.getQuestion().getType().getKey() == 1)
                descriptive++;
            else
                multies++;


        }
        if (multies > 0 && descriptive > 0)
            return ExamType.MIX;
        else if (multies > 0 && descriptive == 0)
            return ExamType.MULTI_CHOICES;
        else
            return ExamType.DESCRIPTIVE;


    }


    public Boolean hasWrongCorrectAnswer(List<ImportedQuestionProtocol> questionProtocols) {
        List<ImportedQuestionProtocol> filteredTeams =
                questionProtocols
                        .stream().filter(p -> p.getQuestion().getType().getValue().equals(MULTI_CHOICES.getValue()))

                        .collect(Collectors.toList());

        return filteredTeams.stream().anyMatch(x -> x.getCorrectAnswerTitle() == null);
    }

    public static boolean dayIsTomorrow(long time) {
        DateTime tomorrow = new DateTime().withTimeAtStartOfDay().plusDays(1);
        return time > (tomorrow.getMillis() / 1000);

    }

    public ExamQuestionsObject toGetExamQuestions(ExamImportedRequest object) {
        ExamQuestionsDto examQuestionsDto = new ExamQuestionsDto();
        final ExamQuestionsObject examQuestionsObject = getQuestionsForFinalTest(object);
        if (examQuestionsObject.getStatus() == 200) {
            List<ImportedQuestionProtocol> questionProtocols = examQuestionsObject.getProtocols();
            List<QuestionsDto> questionsDtos = new ArrayList<>();
            for (ImportedQuestionProtocol question : questionProtocols) {
                QuestionsDto questionsDto = new QuestionsDto();
                questionsDto.setQuestion(question.getQuestion().getTitle());
                questionsDto.setType(question.getQuestion().getType().getValue());
                Optional<QuestionProtocol> q=iQuestionProtocolService.findOneByExamIdAndQuestionId(object.getExamItem().getId(),question.getQuestion().getId());
                String score =(q.isPresent()) ? String.valueOf(q.get().getQuestionMark()==null ? "" : q.get().getQuestionMark()) : "";
                String time =(q.isPresent()) ? String.valueOf(q.get().getTime()==null ? "" : q.get().getTime()/60) : "";
                questionsDto.setScore(score);
                questionsDto.setTime(time);
                questionsDto.setId(question.getQuestion().getId());
                questionsDto.setProposedPointValue(question.getProposedPointValue());
                questionsDto.setProposedTimeValue(question.getProposedTimeValue());
                StringBuilder listString = new StringBuilder();

                if (questionsDto.getType().equals(MULTI_CHOICES.getValue())) {
                    for (int i = 0; i < question.getQuestion().getQuestionOption().size(); i++) {
                        listString.append(i + 1).append(" - ").append(question.getQuestion().getQuestionOption().get(i).getTitle()).append("\t").append(System.lineSeparator());
                    }
                    questionsDto.setOptions(listString.toString());
                }
//                else  if (questionsDto.getType().equals(GROUPQUESTION.getValue())){
//                }
                else {
                    questionsDto.setOptions("-");

                }


                questionsDtos.add(questionsDto);
            }
            examQuestionsDto.setData(questionsDtos);

            examQuestionsObject.setDto(examQuestionsDto);
            return examQuestionsObject;
        } else {

            return examQuestionsObject;
        }
    }


    public List<EvalTargetUser> getClassUsers(List<ClassStudent> classStudents) {
        return classStudents.stream().map(classStudent -> toTargetUser(classStudent.getStudent())).collect(Collectors.toList());
    }

    public ElsExamRequest removeInvalidUsersForExam(ElsExamRequest request) {
        request.getUsers().removeIf(user -> !validateTargetUser(user));
        return request;
    }

    public ElsExtendedExamRequest removeInvalidUsersForResendExam(ElsExtendedExamRequest request) {
        request.getUsers().removeIf(user -> !validateTargetUser(user));
        return request;
    }

    public boolean validateTeacherExam(ImportedUser teacher) {

        boolean isValid = true;
        if (null == teacher.getNationalCode() || null == teacher.getCellNumber())
            isValid = false;
        else {
            if (teacher.getNationalCode().length() != 10 || !teacher.getNationalCode().matches("\\d+")) isValid = false;
            if ((teacher.getCellNumber().length() != 10 && teacher.getCellNumber().length() != 11) || !teacher.getCellNumber().matches("\\d+"))
                isValid = false;
            if (teacher.getCellNumber().length() == 10 && !(teacher.getCellNumber().startsWith("9"))) isValid = false;
            if (teacher.getCellNumber().length() == 11 && !(teacher.getCellNumber().startsWith("09"))) isValid = false;

        }

        return isValid;
    }

    public boolean validateTargetUser(EvalTargetUser teacher) {

        boolean isValid = true;
        if (null == teacher.getNationalCode() || null == teacher.getCellNumber())
            isValid = false;
        else {
            if (teacher.getNationalCode().length() != 10 || !teacher.getNationalCode().matches("\\d+")) isValid = false;
            if ((teacher.getCellNumber().length() != 10 && teacher.getCellNumber().length() != 11) || !teacher.getCellNumber().matches("\\d+"))
                isValid = false;
            if (teacher.getCellNumber().length() == 10 && !(teacher.getCellNumber().startsWith("9"))) isValid = false;
            if (teacher.getCellNumber().length() == 11 && !(teacher.getCellNumber().startsWith("09"))) isValid = false;

        }

        return isValid;
    }

    public ExamListResponse toExamResult(ExamListResponse response) {
        for (ExamResultDto examResultDto : response.getData()) {

            switch (examResultDto.getResultStatus()) {
                case "1": {
                    examResultDto.setResultStatus("قبول");
                    break;
                }
                case "2": {
                    examResultDto.setResultStatus("مردود");
                    break;
                }
                case "3": {
                    examResultDto.setScore("-");
                    examResultDto.setResultStatus("منتظر اعلام نتیجه");
                    break;
                }
                case "4": {
                    examResultDto.setScore("-");
                    examResultDto.setResultStatus("بدون پاسخ");
                    break;
                }
                case "5": {
                    examResultDto.setScore(examResultDto.getScore());
                    examResultDto.setResultStatus("نمره نهایی");
                    break;
                }
            }
            if (null == examResultDto.getTestResult())
                examResultDto.setTestResult("-");

            if (null == examResultDto.getDescriptiveResult())
                examResultDto.setDescriptiveResult("-");

            if (null == examResultDto.getFinalResult())
                examResultDto.setFinalResult("-");

        }

        return response;
    }

    public BaseResponse checkValidScores(List<ExamResult> examResult) {
        BaseResponse response = new BaseResponse();
        for (ExamResult data : examResult) {
            try {
                double descriptiveResult = 0D;
                double finalResult = 0D;
                if (data.getDescriptiveResult() != null && !data.getDescriptiveResult().equals("-")) {
                    String englishDescriptiveResult = new BigDecimal(data.getDescriptiveResult()).toString();
                    descriptiveResult = Double.parseDouble(englishDescriptiveResult);
                    String[] splitter = Double.toString(descriptiveResult).split("\\.");
                    int dec = splitter[1].length();
                    if (dec > 2) {
                        response.setMessage("نمره اعشاری نمره ی تشریحی تا دو رقم باید باشد");
                        response.setStatus(406);
                        return response;

                    }

                }

                if (data.getFinalResult() != null && !data.getFinalResult().equals("-")) {
                    String englishFinalResult = new BigDecimal(data.getFinalResult()).toString();
                    finalResult = Double.parseDouble(englishFinalResult);
                    String[] splitter = Double.toString(finalResult).split("\\.");
                    int dec = splitter[1].length();
                    if (dec > 2) {
                        response.setMessage("نمره اعشاری نمره ی نهایی تا دو رقم باید باشد");
                        response.setStatus(406);
                        return response;

                    }
                }
                if (finalResult < descriptiveResult && (data.getFinalResult() != null && !data.getFinalResult().equals("-"))) {
                    response.setMessage("مقدار های وارد شده صحیح نمی باشد");
                    response.setStatus(406);
                    return response;

                }

            } catch (NumberFormatException e) {
                response.setMessage("مقدار های وارد شده صحیح نمی باشد");
                response.setStatus(406);
                return response;
            }
        }
        response.setStatus(200);
        return response;
    }

    public boolean checkScoreInRange(String scoringMethod, List<ExamResult> examResult) {
        if (scoringMethod.equals("3") || scoringMethod.equals("2")) {

            if (scoringMethod.equals("3")) {
                for (ExamResult data : examResult) {
                    double finalResult = 0D;

                    if (data.getFinalResult() != null && !data.getFinalResult().equals("-")) {
                        String englishFinalResult = new BigDecimal(data.getFinalResult()).toString();
                        finalResult = Double.parseDouble(englishFinalResult);
                        if (finalResult > 20D)
                            return false;
                    }

                }
                return true;
            } else {
                for (ExamResult data : examResult) {
                    double finalResult = 0D;

                    if (data.getFinalResult() != null && !data.getFinalResult().equals("-")) {
                        String englishFinalResult = new BigDecimal(data.getFinalResult()).toString();
                        finalResult = Double.parseDouble(englishFinalResult);
                        if (finalResult > 100D)
                            return false;
                    }

                }
                return true;
            }
        } else
            return false;
    }

    public UpdateRequest convertScoresToDto(List<ExamResult> examResult, long id, String user) {
        UpdateRequest request = new UpdateRequest();
        request.setSourceExamId(id);
        request.setModifiedBy(user);
        List<UpdatedResultDto> resultDtoList = new ArrayList<>();
        for (ExamResult data : examResult) {
            UpdatedResultDto updatedResultDto = new UpdatedResultDto();
            double descriptiveResult;
            double finalResult;
            double score;
            if (data.getDescriptiveResult() != null && !data.getDescriptiveResult().equals("-")) {
                String englishDescriptiveResult = new BigDecimal(data.getDescriptiveResult()).toString();
                descriptiveResult = Double.parseDouble(englishDescriptiveResult);
                updatedResultDto.setDescriptiveResult(descriptiveResult);
            } else {
                updatedResultDto.setDescriptiveResult(null);

            }
            if (data.getFinalResult() != null && !data.getFinalResult().equals("-")) {
                String englishFinalResult = new BigDecimal(data.getFinalResult()).toString();
                finalResult = Double.parseDouble(englishFinalResult);
                updatedResultDto.setFinalResult(finalResult);
            } else {
                updatedResultDto.setFinalResult(null);
            }

            if (data.getTestResult() != null && !data.getTestResult().equals("-")) {
                String englishScore = new BigDecimal(data.getTestResult()).toString();
                score = Double.parseDouble(englishScore);
                updatedResultDto.setTestResult(score);
            } else {
                updatedResultDto.setTestResult(null);
            }

            updatedResultDto.setMobileNumber(data.getCellNumber());
            updatedResultDto.setNationalCode(data.getNationalCode());
            if (data.getClassScore() != null && !Objects.equals(data.getClassScore(), "-"))
                updatedResultDto.setClassScore(Double.parseDouble(data.getClassScore()));
            else
                updatedResultDto.setClassScore(null);

            if (data.getPracticalScore() != null && !Objects.equals(data.getPracticalScore(), "-"))
                updatedResultDto.setPracticalScore(Double.parseDouble(data.getPracticalScore()));
            else
                updatedResultDto.setPracticalScore(null);

            resultDtoList.add(updatedResultDto);
        }
        request.setResults(resultDtoList);
        return request;
    }

    public List<String> getUsersWithAnswer(List<ExamResultDto> answers, List<EvalTargetUser> newUsers) {
        List<ExamResultDto> userListWithoutNotAnswered = answers.stream().filter(item -> !item.getResultStatus().equals("4")).collect(Collectors.toList());

        List<String> userNames = new ArrayList<>();
        for (ExamResultDto examResultDto : userListWithoutNotAnswered) {
            String nationalCode = examResultDto.getNationalCode();
            boolean hasUser = newUsers.stream().anyMatch(item -> item.getNationalCode().equals(nationalCode));

            if (hasUser)
                userNames.add(examResultDto.getSurname() + " " + examResultDto.getLastName());
        }
        return userNames;


    }

    public ElsExamRequest removeAbsentUsersForExam(ElsExamRequest request, List<EvalTargetUser> absentUsers) {
        request.getUsers().removeIf(p -> absentUsers.stream().anyMatch(x -> (p.getNationalCode().equals(x.getNationalCode()))));
        return request;
    }


    public abstract ElsQuestionTargetDto toQuestionTarget(ParameterValueDTO.Info question);


    public abstract List<ElsQuestionTargetDto> toQuestionTargets(List<ParameterValueDTO.Info> questions);

    private ImportedQuestionProtocol GetGroupQuestionProtocolForFinalTest(QuestionBank groupQuestionBank, ExamImportedRequest object, long totalQuestionsTime, int questionsSize, int examTime) {
        ImportedQuestion groupQuestion = new ImportedQuestion();
        ImportedQuestionProtocol groupQuestionProtocol = new ImportedQuestionProtocol();
        QuestionAttachments groupAttachments = getFilesForQuestion(groupQuestionBank.getId());
        groupQuestion.setId(groupQuestionBank.getId());
//        groupQuestion.setTitle(" سوال گروهی : "+question+ "- سوال زیر مجموعه  : "+groupQuestionBank.getQuestion());
        groupQuestion.setTitle(groupQuestionBank.getQuestion());
        groupQuestion.setProposedPointValue(groupQuestionBank.getProposedPointValue());
        groupQuestionProtocol.setProposedPointValue(groupQuestionBank.getProposedPointValue());
        groupQuestionProtocol.setProposedTimeValue(groupQuestionBank.getProposedTimeValue());
        if (groupAttachments != null && groupAttachments.getFiles() != null)
            groupQuestion.setFiles(groupAttachments.getFiles());

        groupQuestion.setType(convertQuestionType(groupQuestionBank.getQuestionTypeId()));

        if (groupQuestion.getType().equals(MULTI_CHOICES)) {


            List<ImportedQuestionOption> options = new ArrayList<>();


            ImportedQuestionOption option1 = new ImportedQuestionOption();
            ImportedQuestionOption option2 = new ImportedQuestionOption();
            ImportedQuestionOption option3 = new ImportedQuestionOption();
            ImportedQuestionOption option4 = new ImportedQuestionOption();
            if (groupQuestionBank.getOption1() != null) {
                option1.setTitle(groupQuestionBank.getOption1());
                option1.setLabel("الف");
                options.add(option1);
                if (groupAttachments != null && groupAttachments.getOption1Files() != null)
                    option1.setMapFiles(groupAttachments.getOption1Files());


            }
            if (groupQuestionBank.getOption2() != null) {
                option2.setTitle(groupQuestionBank.getOption2());
                option2.setLabel("ب");
                options.add(option2);
                if (groupAttachments != null && groupAttachments.getOption2Files() != null)
                    option2.setMapFiles(groupAttachments.getOption2Files());

            }
            if (groupQuestionBank.getOption3() != null) {
                option3.setTitle(groupQuestionBank.getOption3());
                option3.setLabel("ج");
                options.add(option3);
                if (groupAttachments != null && groupAttachments.getOption3Files() != null)
                    option3.setMapFiles(groupAttachments.getOption3Files());

            }
            if (groupQuestionBank.getOption4() != null) {
                option4.setTitle(groupQuestionBank.getOption4());
                option4.setLabel("د");
                options.add(option4);
                if (groupAttachments != null && groupAttachments.getOption4Files() != null)
                    option4.setMapFiles(groupAttachments.getOption4Files());

            }
//            if (!findDuplicate) {
//                String title = groupQuestion.getTitle().toUpperCase().replaceAll("[\\s]", "");
//                findDuplicate = checkDuplicateQuestion(options, questionProtocols, title, groupQuestion.getType());
//                if (findDuplicate) {
//                    examQuestionsObject.setStatus(HttpStatus.CONFLICT.value());
//                    examQuestionsObject.setMessage("در آزمون سوال تکراری وجود دارد");
//                }
//            }
//            if (options.size() == 0) {
//                examQuestionsObject.setStatus(HttpStatus.NOT_ACCEPTABLE.value());
//                examQuestionsObject.setMessage(String.format("گزینه های سوال «%s» تعیین نشده است.", groupQuestion.getTitle()));
//                return examQuestionsObject;
//            }
            groupQuestion.setQuestionOption(options);
            groupQuestionProtocol.setCorrectAnswerTitle(convertCorrectAnswer(groupQuestionBank.getMultipleChoiceAnswer(), groupQuestionBank));

        } else if (groupQuestion.getType().equals(DESCRIPTIVE)) {
//            if (!findDuplicate) {
//                String title = groupQuestion.getTitle().toUpperCase().replaceAll("[\\s]", "");
//                findDuplicate = checkDuplicateDescriptiveQuestions(questionProtocols, title, groupQuestion.getType());
//                if (findDuplicate) {
//                    examQuestionsObject.setStatus(HttpStatus.CONFLICT.value());
//                    examQuestionsObject.setMessage("در آزمون سوال تکراری وجود دارد");
//                }
//            }
            groupQuestionProtocol.setCorrectAnswerTitle(groupQuestionBank.getDescriptiveAnswer());
            groupQuestion.setHasAttachment(groupQuestionBank.getHasAttachment());
        }


        if (object.getQuestionData() != null && !groupQuestion.getType().equals(GROUPQUESTION)) {


            QuestionScores questionScore = object.getQuestionData().stream()
                    .filter(x -> x.getId().equals(groupQuestion.getId()))
                    .findFirst()
                    .get();

            groupQuestionProtocol.setMark(Double.valueOf(questionScore.getScore()));
            int t = 0;
            if (questionScore.getTime() == null) {
                t = 0;
            } else {
                t = Integer.parseInt(questionScore.getTime());
            }

            if (totalQuestionsTime != 0) {

                groupQuestionProtocol.setTime(t * 60);
            } else {
                groupQuestionProtocol.setTime((examTime * 60) / questionsSize);

            }


        }
        groupQuestionProtocol.setIsChild(groupQuestionBank.getIsChild());
        groupQuestionProtocol.setChildPriority(groupQuestionBank.getChildPriority());
        groupQuestionProtocol.setQuestion(groupQuestion);
        return groupQuestionProtocol;
    }

    private EQuestionType convertQuestionType(Long questionTypeId) {
        ParameterValueDTO.TupleInfo info = iParameterValueService.getInfo(questionTypeId);
        return switch (info.getTitle()) {
            case "چند گزینه ای" -> MULTI_CHOICES;
            case "تشریحی" -> DESCRIPTIVE;
            case "سوالات گروهی" -> GROUPQUESTION;
            default -> null;
        };
    }

    private ImportedQuestionProtocol GetGroupQuestionProtocolForPreTest(QuestionBank groupQuestionBank, Integer timeQues, Map<Long, QuestionProtocol> protocolsMap) {

        ImportedQuestionProtocol questionProtocol = new ImportedQuestionProtocol();

        ImportedQuestion question = new ImportedQuestion();

        QuestionAttachments attachments = getFilesForQuestion(groupQuestionBank.getId());
        question.setId(groupQuestionBank.getId());
        question.setTitle(groupQuestionBank.getQuestion());
        if (attachments != null && attachments.getFiles() != null)
            question.setFiles(attachments.getFiles());
        question.setType(convertQuestionType(groupQuestionBank.getQuestionTypeId()));

        if (question.getType().equals(MULTI_CHOICES)) {


            List<ImportedQuestionOption> options = new ArrayList<>();


            ImportedQuestionOption option1 = new ImportedQuestionOption();
            ImportedQuestionOption option2 = new ImportedQuestionOption();
            ImportedQuestionOption option3 = new ImportedQuestionOption();
            ImportedQuestionOption option4 = new ImportedQuestionOption();
            if (groupQuestionBank.getOption1() != null) {
                option1.setTitle(groupQuestionBank.getOption1());
                option1.setLabel("الف");
                options.add(option1);
                if (attachments != null && attachments.getOption1Files() != null)
                    option1.setMapFiles(attachments.getOption1Files());


            }
            if (groupQuestionBank.getOption2() != null) {
                option2.setTitle(groupQuestionBank.getOption2());
                option2.setLabel("ب");
                options.add(option2);
                if (attachments != null && attachments.getOption2Files() != null)
                    option2.setMapFiles(attachments.getOption2Files());

            }
            if (groupQuestionBank.getOption3() != null) {
                option3.setTitle(groupQuestionBank.getOption3());
                option3.setLabel("ج");
                options.add(option3);
                if (attachments != null && attachments.getOption3Files() != null)
                    option3.setMapFiles(attachments.getOption3Files());

            }
            if (groupQuestionBank.getOption4() != null) {
                option4.setTitle(groupQuestionBank.getOption4());
                option4.setLabel("د");
                options.add(option4);
                if (attachments != null && attachments.getOption4Files() != null)
                    option4.setMapFiles(attachments.getOption4Files());

            }
//            if (!findDuplicate) {
//                String title = question.getTitle().toUpperCase().replaceAll("[\\s]", "");
//                findDuplicate = checkDuplicateQuestion(options, questionProtocols, title, question.getType());
//                if (findDuplicate) {
//                    examQuestionsObject.setStatus(HttpStatus.CONFLICT.value());
//                    examQuestionsObject.setMessage("در آزمون سوال تکراری وجود دارد");
//                }
//            }
            question.setQuestionOption(options);
            questionProtocol.setCorrectAnswerTitle(convertCorrectAnswer(groupQuestionBank.getMultipleChoiceAnswer(), groupQuestionBank));

        } else if (question.getType().equals(DESCRIPTIVE)) {
//            if (!findDuplicate) {
//                String title = question.getTitle().toUpperCase().replaceAll("[\\s]", "");
//                findDuplicate = checkDuplicateDescriptiveQuestions(questionProtocols, title, question.getType());
//                if (findDuplicate) {
//                    examQuestionsObject.setStatus(HttpStatus.CONFLICT.value());
//                    examQuestionsObject.setMessage("در آزمون سوال تکراری وجود دارد");
//                }
//            }
            questionProtocol.setCorrectAnswerTitle(groupQuestionBank.getDescriptiveAnswer());
            question.setHasAttachment(groupQuestionBank.getHasAttachment());
        }
        QuestionProtocol protocol = protocolsMap.get(question.getId());

        if (protocol.getQuestionMark() != null)
            questionProtocol.setMark(Double.valueOf(protocol.getQuestionMark()));


        questionProtocol.setTime(timeQues);
        questionProtocol.setQuestion(question);
        questionProtocol.setIsChild(groupQuestionBank.getIsChild());
        questionProtocol.setChildPriority(groupQuestionBank.getChildPriority());
        return questionProtocol;


    }


    public boolean checkClassScoreInRange(String allClassScore, List<ExamResult> examResult) {
        if (allClassScore != null) {


            for (ExamResult data : examResult) {
                double classScore = 0D;

                if (data.getClassScore() != null && !data.getClassScore().equals("-")) {
                    String englishFinalResult = new BigDecimal(data.getClassScore()).toString();
                    classScore = Double.parseDouble(englishFinalResult);
                    if (classScore > Double.parseDouble(allClassScore))
                        return false;
                }

            }
            return true;

        } else
            return true;

    }

    public boolean checkPracticalScoreInRange(String allPracticalScore, List<ExamResult> examResult) {
        if (allPracticalScore != null) {


            for (ExamResult data : examResult) {
                double practicalScore = 0D;

                if (data.getClassScore() != null && !data.getClassScore().equals("-")) {
                    String englishFinalResult = new BigDecimal(data.getPracticalScore()).toString();
                    practicalScore = Double.parseDouble(englishFinalResult);
                    if (practicalScore > Double.parseDouble(allPracticalScore))
                        return false;
                }

            }
            return true;

        } else
            return true;

    }

    public ElsAddQuestionToExamResponse getQuestionProtocols(List<Long> questionIds) {
        ElsAddQuestionToExamResponse response = new ElsAddQuestionToExamResponse();

        List<ImportedQuestionProtocol> questionProtocols = new ArrayList<>();
        List<QuestionBank> questionBanks = questionBankService.findAllByIds(questionIds);
        Boolean findDuplicate = false;

        for (QuestionBank questionBank : questionBanks) {
            ImportedQuestionProtocol questionProtocol = new ImportedQuestionProtocol();
            ImportedQuestion question = new ImportedQuestion();

            QuestionAttachments attachments = getFilesForQuestion(questionBank.getId());
            question.setId(questionBank.getId());
            question.setTitle(questionBank.getQuestion());
            question.setProposedPointValue(questionBank.getProposedPointValue());
            questionProtocol.setProposedPointValue(questionBank.getProposedPointValue());
            questionProtocol.setProposedTimeValue(questionBank.getProposedTimeValue());
            if (attachments != null && attachments.getFiles() != null) {
                question.setFiles(attachments.getFiles());
            }
            question.setType(convertQuestionType(questionBank.getQuestionTypeId()));

            if (question.getType().equals(MULTI_CHOICES)) {
                List<ImportedQuestionOption> options = new ArrayList<>();

                ImportedQuestionOption option1 = new ImportedQuestionOption();
                ImportedQuestionOption option2 = new ImportedQuestionOption();
                ImportedQuestionOption option3 = new ImportedQuestionOption();
                ImportedQuestionOption option4 = new ImportedQuestionOption();

                if (questionBank.getOption1() != null) {
                    option1.setTitle(questionBank.getOption1());
                    option1.setLabel("الف");
                    options.add(option1);
                    if (attachments != null && attachments.getOption1Files() != null)
                        option1.setMapFiles(attachments.getOption1Files());
                }
                if (questionBank.getOption2() != null) {
                    option2.setTitle(questionBank.getOption2());
                    option2.setLabel("ب");
                    options.add(option2);
                    if (attachments != null && attachments.getOption2Files() != null)
                        option2.setMapFiles(attachments.getOption2Files());
                }
                if (questionBank.getOption3() != null) {
                    option3.setTitle(questionBank.getOption3());
                    option3.setLabel("ج");
                    options.add(option3);
                    if (attachments != null && attachments.getOption3Files() != null)
                        option3.setMapFiles(attachments.getOption3Files());
                }
                if (questionBank.getOption4() != null) {
                    option4.setTitle(questionBank.getOption4());
                    option4.setLabel("د");
                    options.add(option4);
                    if (attachments != null && attachments.getOption4Files() != null)
                        option4.setMapFiles(attachments.getOption4Files());
                }
                if (!findDuplicate) {
                    String title = question.getTitle().toUpperCase().replaceAll("[\\s]", "");
                    findDuplicate = checkDuplicateQuestion(options, questionProtocols, title, question.getType());
                    if (findDuplicate) {
                        response.setStatus(HttpStatus.CONFLICT.value());
                        response.setMessage("در آزمون سوال تکراری وجود دارد");
                    }
                }
                if (options.size() == 0) {
                    response.setStatus(HttpStatus.NOT_ACCEPTABLE.value());
                    response.setMessage(String.format("گزینه های سوال «%s» تعیین نشده است.", question.getTitle()));
                    return response;
                }
                question.setQuestionOption(options);
                questionProtocol.setCorrectAnswerTitle(convertCorrectAnswer(questionBank.getMultipleChoiceAnswer(), questionBank));

            } else if (question.getType().equals(DESCRIPTIVE)) {
                if (!findDuplicate) {
                    String title = question.getTitle().toUpperCase().replaceAll("[\\s]", "");
                    findDuplicate = checkDuplicateDescriptiveQuestions(questionProtocols, title, question.getType());
                    if (findDuplicate) {
                        response.setStatus(HttpStatus.CONFLICT.value());
                        response.setMessage("در آزمون سوال تکراری وجود دارد");
                        return response;
                    }
                }
                questionProtocol.setCorrectAnswerTitle(questionBank.getDescriptiveAnswer());
                question.setHasAttachment(questionBank.getHasAttachment());
            }
//            if (object.getQuestionData() != null) {
//
//
//                QuestionScores questionScore = object.getQuestionData().stream()
//                        .filter(x -> x.getId().equals(question.getId()))
//                        .findFirst()
//                        .get();
//
//                questionProtocol.setMark(Double.valueOf(questionScore.getScore()));
//                int t = 0;
//                if (questionScore.getTime() == null) {
//                    t = 0;
//                } else {
//                    t = Integer.parseInt(questionScore.getTime());
//                }
//
//                if (totalQuestionsTime != 0) {
//
//                    questionProtocol.setTime(t * 60);
//                } else {
//                    questionProtocol.setTime((examTime * 60) / questionsSize);
//
//                }
//
//
//            }
            questionProtocol.setQuestion(question);
            questionProtocol.setIsChild(questionBank.getIsChild());
            questionProtocol.setChildPriority(questionBank.getChildPriority());

            questionProtocols.add(questionProtocol);
        }

        response.setImportedQuestionProtocols(questionProtocols);

        return response;
    }



}
