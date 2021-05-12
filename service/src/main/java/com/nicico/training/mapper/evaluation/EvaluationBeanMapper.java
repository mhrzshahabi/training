package com.nicico.training.mapper.evaluation;


import com.nicico.training.dto.TestQuestionDTO;
import com.nicico.training.dto.question.ElsExamRequestResponse;
import com.nicico.training.dto.question.ElsResendExamRequestResponse;
import com.nicico.training.dto.question.ExamQuestionsObject;
import com.nicico.training.iservice.IAttachmentService;
import com.nicico.training.model.*;
import com.nicico.training.service.AttachmentService;
import com.nicico.training.service.QuestionBankService;
import com.nicico.training.utility.persianDate.PersianDate;
import dto.Question.QuestionData;
import dto.Question.QuestionScores;
import dto.evaluuation.EvalCourse;
import dto.evaluuation.EvalCourseProtocol;
import dto.evaluuation.EvalQuestionDto;
import dto.evaluuation.EvalTargetUser;
import dto.exam.*;
import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.ReportingPolicy;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import request.evaluation.ElsEvalRequest;
import request.exam.*;
import response.BaseResponse;
import response.exam.ExamListResponse;
import response.exam.ExamQuestionsDto;
import response.exam.ExamResultDto;
import response.question.QuestionsDto;


import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

import static com.nicico.training.utility.persianDate.PersianDate.getEndDateFromDuration;
import static dto.exam.EQuestionType.DESCRIPTIVE;
import static dto.exam.EQuestionType.MULTI_CHOICES;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN, uses = QuestionBankService.class)
public abstract class EvaluationBeanMapper {

    @Autowired
    protected QuestionBankService questionBankService;
    @Autowired
    protected IAttachmentService attachmentService;

    private final Boolean hasDuplicateQuestion = true;

    @Mapping(source = "firstName", target = "surname")
    @Mapping(source = "lastName", target = "lastName")
    @Mapping(source = "nationalCode", target = "nationalCode")
    @Mapping(source = "gender", target = "gender")
    @Mapping(source = "mobile", target = "cellNumber")
    public abstract EvalTargetUser toTargetUser(Student student);

    public ElsEvalRequest toElsEvalRequest(Evaluation evaluation, Questionnaire questionnaire, List<ClassStudent> classStudents,
                                           List<EvalQuestionDto> questionDtos, PersonalInfo teacher) {
        ElsEvalRequest request = new ElsEvalRequest();


        EvalCourse evalCourse = new EvalCourse();
        EvalCourseProtocol evalCourseProtocol = new EvalCourseProtocol();
        request.setId(evaluation.getId());
        request.setClassId(evaluation.getTclass().getId());
        request.setTitle(questionnaire.getTitle());
        try {
            request.setOrganizer(evaluation.getTclass().getOrganizer().getTitleFa());
            request.setPlanner(evaluation.getTclass().getPlanner().getFirstName() + " " +
                    evaluation.getTclass().getPlanner().getLastName());
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

    @Mapping(source = "firstNameFa", target = "surname")
    @Mapping(source = "lastNameFa", target = "lastName")
    @Mapping(source = "nationalCode", target = "nationalCode")
    @Mapping(source = "gender", target = "gender")
    @Mapping(source = "contactInfo.mobile", target = "cellNumber")
    public abstract EvalTargetUser toTeacher(PersonalInfo teacher);


    public ElsExamRequestResponse toGetExamRequest(Tclass tClass, PersonalInfo teacherInfo, ExamImportedRequest object, List<ClassStudent> classStudents) {
        ElsExamRequest request = new ElsExamRequest();
        ElsExamRequestResponse elsExamRequestResponse = new ElsExamRequestResponse();
        ExamQuestionsObject examQuestionsObject = new ExamQuestionsObject();

        int time = Math.toIntExact(object.getExamItem().getDuration());

        int timeQues = 0;
        if (object.getQuestions() != null && object.getQuestions().size() > 0)
            timeQues = (time * 60) / object.getQuestions().size();

        ExamCreateDTO exam = getExamData(object, tClass);
        ImportedCourseCategory courseCategory = getCourseCategoryData(object);
        ImportedCourseDto courseDto = getCourseData(object);
        CourseProtocolImportDTO courseProtocol = getCourseProtocolData(object);

        examQuestionsObject = getQuestions(object, timeQues);
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

    public ElsExamRequestResponse toGetPreExamRequest(Tclass tClass, PersonalInfo teacherInfo, ExamImportedRequest object, List<ClassStudent> classStudents) {

        ElsExamRequest request = new ElsExamRequest();
        ElsExamRequestResponse elsExamRequestResponse = new ElsExamRequestResponse();
        ExamQuestionsObject examQuestionsObject = new ExamQuestionsObject();

        ExamCreateDTO exam = getPreExamData(object, tClass);
        ImportedCourseCategory courseCategory = getCourseCategoryData(object);
        ImportedCourseDto courseDto = getCourseData(object);
        CourseProtocolImportDTO courseProtocol = getCourseProtocolData(object);

        examQuestionsObject = getQuestions(object, 0);
        examQuestionsObject.getProtocols().stream().forEach(question -> question.setTime(null));
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

    public ElsResendExamRequestResponse toGetResendExamRequest(ResendExamImportedRequest object) {
        ElsExtendedExamRequest request = new ElsExtendedExamRequest();
        ElsResendExamRequestResponse elsResendExamRequestResponse = new ElsResendExamRequestResponse();
        int time = Math.toIntExact(object.getDuration());

        String newTime = convertToTimeZone(object.getTime());

        Date startDate = getDate(object.getStartDate(), newTime);
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

    private ExamQuestionsObject getQuestions(ExamImportedRequest object, Integer timeQues) {
        ExamQuestionsObject examQuestionsObject = new ExamQuestionsObject();
        List<ImportedQuestionProtocol> questionProtocols = new ArrayList<>();
        Boolean findDuplicate = false;

        if (object.getQuestions().size() > 0) {
//            Double questionScore = (double) (20 / object.getQuestions().size());

            for (QuestionData questionData : object.getQuestions()) {


                ImportedQuestionProtocol questionProtocol = new ImportedQuestionProtocol();
                QuestionBank questionBank = questionBankService.getById(questionData.getQuestionBank().getId());

                ImportedQuestion question = new ImportedQuestion();

                question.setId(questionData.getQuestionBank().getId());
                question.setTitle(questionData.getQuestionBank().getQuestion());
                question.setFiles(getFilesForQuestion(questionBank.getId()));
                question.setType(convertQuestionType(questionData.getQuestionBank().getQuestionType().getTitle()));

                if (question.getType().equals(MULTI_CHOICES)) {


                    List<ImportedQuestionOption> options = new ArrayList<>();


                    ImportedQuestionOption option1 = new ImportedQuestionOption();
                    ImportedQuestionOption option2 = new ImportedQuestionOption();
                    ImportedQuestionOption option3 = new ImportedQuestionOption();
                    ImportedQuestionOption option4 = new ImportedQuestionOption();
                    option1.setTitle(questionBank.getOption1());
                    option2.setTitle(questionBank.getOption2());
                    option3.setTitle(questionBank.getOption3());
                    option4.setTitle(questionBank.getOption4());

                    options.add(option1);
                    options.add(option2);
                    options.add(option3);
                    options.add(option4);
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

                }
                if (object.getQuestionData() != null) {
                    QuestionScores questionScore = object.getQuestionData().stream()
                            .filter(x -> x.getId().equals(question.getId()))
                            .findFirst()
                            .get();

                    questionProtocol.setMark(Double.valueOf(questionScore.getScore()));
                }

                questionProtocol.setTime(timeQues);
                questionProtocol.setQuestion(question);
                questionProtocols.add(questionProtocol);
            }
        }
        examQuestionsObject.setProtocols(questionProtocols);
        if (!findDuplicate)
            examQuestionsObject.setStatus(HttpStatus.OK.value());
        return examQuestionsObject;
        /*return questionProtocols;*/
    }

    private List<Map<String, String>> getFilesForQuestion(Long id) {
        return   attachmentService.getFiles("QuestionBank",id);
     }

    private Boolean checkDuplicateDescriptiveQuestions(List<ImportedQuestionProtocol> protocols, String title, EQuestionType type) {
        if (protocols.size() > 0) {
            final List<ImportedQuestion> questions = protocols.stream().map(ImportedQuestionProtocol::getQuestion).collect(Collectors.toList());
            List<String> questionsTitle = questions.stream().filter(t -> t.getType().equals(type)).map(ImportedQuestion::getTitle)
                    .map(str -> new String(str.toUpperCase().replaceAll("[\\s]", "")))
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
                    .map(str -> new String(str.toUpperCase().replaceAll("[\\s]", "")))
                    .collect(Collectors.toList());
            List<String> targetOptionsList = new ArrayList<>();
            final List<ImportedQuestion> questions = protocols.stream().map(ImportedQuestionProtocol::getQuestion).collect(Collectors.toList());
            List<String> questionsTitle = questions.stream().map(ImportedQuestion::getTitle)
                    .map(str -> new String(str.toUpperCase().replaceAll("[\\s]", "")))
                    .collect(Collectors.toList());
            final boolean matchedTitle = questionsTitle.stream().anyMatch(t -> t.equals(title));
            List<String> duplicateOptions = new ArrayList<>();
            if (matchedTitle) {
                for (ImportedQuestion question : questions) {
                    String questionTitle = question.getTitle().toUpperCase().replaceAll("[\\s]", "");
                    if (questionTitle.equals(title) && question.getType().equals(type)) {
                        targetOptionsList = question.getQuestionOption().stream().map(ImportedQuestionOption::getTitle)
                                .map(str -> new String(str.toUpperCase().replaceAll("[\\s]", "")))
                                .collect(Collectors.toList());
                        duplicateOptions = targetOptionsList.stream().filter(e -> newOptionsList.contains(e))
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

    private ImportedCourseDto getCourseData(ExamImportedRequest object) {
        ImportedCourseDto courseDto = new ImportedCourseDto();
        courseDto.setCode(object.getExamItem().getTclass().getCourse().getCode());
        courseDto.setName(object.getExamItem().getTclass().getCourse().getTitleFa());
        return courseDto;
    }


    private ImportedCourseCategory getCourseCategoryData(ExamImportedRequest object) {
        ImportedCourseCategory courseCategory = new ImportedCourseCategory();
        courseCategory.setCode(object.getExamItem().getTclass().getCourse().getCategory().getCode());
        courseCategory.setName(object.getExamItem().getTclass().getCourse().getCategory().getTitleFa());
        return courseCategory;
    }

    private ExamCreateDTO getExamData(ExamImportedRequest object, Tclass tClass) {
        int time = Math.toIntExact(object.getExamItem().getDuration());

        String newTime = convertToTimeZone(object.getExamItem().getTime());
//        String newTime = object.getExamItem().getTime();

        Date startDate = getDate(object.getExamItem().getDate(), newTime);

        Date endDate = getEndDateFromDuration(getStringGeoDate(object.getExamItem().getDate(), newTime)
                , object.getExamItem().getDuration());
        ExamCreateDTO exam = new ExamCreateDTO();
        exam.setCode(object.getExamItem().getTclass().getCode());
        exam.setName(object.getExamItem().getTclass().getTitleClass());
        exam.setStartDate(startDate.getTime());
        exam.setEndDate(endDate.getTime());
        exam.setQuestionCount(object.getQuestions().size());
        exam.setSourceExamId(object.getExamItem().getId());

        exam.setDuration(time);

        if (tClass.getScoringMethod().equals("3")) {
            exam.setMinimumAcceptScore(Double.valueOf(tClass.getAcceptancelimit()));
            exam.setScore(20D);

        } else if (tClass.getScoringMethod().equals("2")) {
            if (null != tClass.getAcceptancelimit())
                exam.setMinimumAcceptScore(Double.valueOf(tClass.getAcceptancelimit()));
            else
                exam.setMinimumAcceptScore(50D);

            exam.setScore(100D);

        } else {
            exam.setMinimumAcceptScore(0D);

            exam.setScore(0D);

        }


        if (dayIsTomorrow(startDate.getTime()))
            exam.setStatus(ExamStatus.UPCOMING);
        else
            exam.setStatus(ExamStatus.ACTIVE);

        return exam;
    }

    private ExamCreateDTO getPreExamData(ExamImportedRequest object, Tclass tClass) {

        ExamCreateDTO exam = new ExamCreateDTO();
        exam.setCode(object.getExamItem().getTclass().getCode());
        exam.setName(object.getExamItem().getTclass().getTitleClass());
        exam.setStartDate(null);
        exam.setEndDate(null);
        exam.setQuestionCount(object.getQuestions().size());
        exam.setSourceExamId(object.getExamItem().getId());
        exam.setDuration(0);

        if (tClass.getScoringMethod().equals("3")) {
            exam.setMinimumAcceptScore(Double.valueOf(tClass.getAcceptancelimit()));
            exam.setScore(20D);
        } else if (tClass.getScoringMethod().equals("2")) {
            if (null != tClass.getAcceptancelimit())
                exam.setMinimumAcceptScore(Double.valueOf(tClass.getAcceptancelimit()));
            else
                exam.setMinimumAcceptScore(50D);
            exam.setScore(100D);
        } else {
            exam.setMinimumAcceptScore(0D);
            exam.setScore(0D);
        }

        exam.setStatus(ExamStatus.ACTIVE);
        return exam;
    }

    private List<ImportedCourseProgram> getPrograms(ExamClassData tclass) {
        List<ImportedCourseProgram> programs = new ArrayList<>();
        ////////////////////////////////////


        if (null != (tclass.getSaturday()) && tclass.getSaturday()) {


            if (null != (tclass.getFirst()) && tclass.getFirst()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("SATURDAY");
                program.setEndTime("8");
                program.setStartTime("10");
                programs.add(program);

            }
            if (null != (tclass.getSecond()) && tclass.getSecond()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("SATURDAY");
                program.setEndTime("10");
                program.setStartTime("12");
                programs.add(program);
            }
            if (null != (tclass.getThird()) && tclass.getThird()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("SATURDAY");
                program.setEndTime("12");
                program.setStartTime("14");
                programs.add(program);
            }
            if (null != (tclass.getFourth()) && tclass.getFourth()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("SATURDAY");
                program.setEndTime("14");
                program.setStartTime("16");
                programs.add(program);
            }
            if (null != (tclass.getFifth()) && tclass.getFifth()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("SATURDAY");
                program.setEndTime("16");
                program.setStartTime("18");
                programs.add(program);
            }


        }
        if (null != (tclass.getSunday()) && tclass.getSunday()) {


            if (null != (tclass.getFirst()) && tclass.getFirst()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("SUNDAY");
                program.setEndTime("8");
                program.setStartTime("10");
                programs.add(program);

            }
            if (null != (tclass.getSecond()) && tclass.getSecond()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("SUNDAY");
                program.setEndTime("10");
                program.setStartTime("12");
                programs.add(program);
            }
            if (null != (tclass.getThird()) && tclass.getThird()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("SUNDAY");
                program.setEndTime("12");
                program.setStartTime("14");
                programs.add(program);
            }
            if (null != (tclass.getFourth()) && tclass.getFourth()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("SUNDAY");
                program.setEndTime("14");
                program.setStartTime("16");
                programs.add(program);
            }
            if (null != (tclass.getFifth()) && tclass.getFifth()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("SUNDAY");
                program.setEndTime("16");
                program.setStartTime("18");
                programs.add(program);
            }


        }
        if (null != (tclass.getMonday()) && tclass.getMonday()) {


            if (null != (tclass.getFirst()) && tclass.getFirst()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("MONDAY");
                program.setEndTime("8");
                program.setStartTime("10");
                programs.add(program);

            }
            if (null != (tclass.getSecond()) && tclass.getSecond()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("MONDAY");
                program.setEndTime("10");
                program.setStartTime("12");
                programs.add(program);
            }
            if (null != (tclass.getThird()) && tclass.getThird()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("MONDAY");
                program.setEndTime("12");
                program.setStartTime("14");
                programs.add(program);
            }
            if (null != (tclass.getFourth()) && tclass.getFourth()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("MONDAY");
                program.setEndTime("14");
                program.setStartTime("16");
                programs.add(program);
            }
            if (null != (tclass.getFifth()) && tclass.getFifth()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("MONDAY");
                program.setEndTime("16");
                program.setStartTime("18");
                programs.add(program);
            }


        }
        if (null != (tclass.getTuesday()) && tclass.getTuesday()) {


            if (null != (tclass.getFirst()) && tclass.getFirst()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("TUESDAY");
                program.setEndTime("8");
                program.setStartTime("10");
                programs.add(program);

            }
            if (null != (tclass.getSecond()) && tclass.getSecond()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("TUESDAY");
                program.setEndTime("10");
                program.setStartTime("12");
                programs.add(program);
            }
            if (null != (tclass.getThird()) && tclass.getThird()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("TUESDAY");
                program.setEndTime("12");
                program.setStartTime("14");
                programs.add(program);
            }
            if (null != (tclass.getFourth()) && tclass.getFourth()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("TUESDAY");
                program.setEndTime("14");
                program.setStartTime("16");
                programs.add(program);
            }
            if (null != (tclass.getFifth()) && tclass.getFifth()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("TUESDAY");
                program.setEndTime("16");
                program.setStartTime("18");
                programs.add(program);
            }


        }
        if (null != (tclass.getWednesday()) && tclass.getWednesday()) {


            if (null != (tclass.getFirst()) && tclass.getFirst()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("WEDNESDAY");
                program.setEndTime("8");
                program.setStartTime("10");
                programs.add(program);

            }
            if (null != (tclass.getSecond()) && tclass.getSecond()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("WEDNESDAY");
                program.setEndTime("10");
                program.setStartTime("12");
                programs.add(program);
            }
            if (null != (tclass.getThird()) && tclass.getThird()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("WEDNESDAY");
                program.setEndTime("12");
                program.setStartTime("14");
                programs.add(program);
            }
            if (null != (tclass.getFourth()) && tclass.getFourth()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("WEDNESDAY");
                program.setEndTime("14");
                program.setStartTime("16");
                programs.add(program);
            }
            if (null != (tclass.getFifth()) && tclass.getFifth()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("WEDNESDAY");
                program.setEndTime("16");
                program.setStartTime("18");
                programs.add(program);
            }


        }
        if (null != (tclass.getThursday()) && tclass.getThursday()) {


            if (null != (tclass.getFirst()) && tclass.getFirst()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("THURSDAY");
                program.setEndTime("8");
                program.setStartTime("10");
                programs.add(program);

            }
            if (null != (tclass.getSecond()) && tclass.getSecond()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("THURSDAY");
                program.setEndTime("10");
                program.setStartTime("12");
                programs.add(program);
            }
            if (null != (tclass.getThird()) && tclass.getThird()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("THURSDAY");
                program.setEndTime("12");
                program.setStartTime("14");
                programs.add(program);
            }
            if (null != (tclass.getFourth()) && tclass.getFourth()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("THURSDAY");
                program.setEndTime("14");
                program.setStartTime("16");
                programs.add(program);
            }
            if (null != (tclass.getFifth()) && tclass.getFifth()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("THURSDAY");
                program.setEndTime("16");
                program.setStartTime("18");
                programs.add(program);
            }


        }
        if (null != (tclass.getFriday()) && tclass.getFriday()) {


            if (null != (tclass.getFirst()) && tclass.getFirst()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("FRIDAY");
                program.setEndTime("8");
                program.setStartTime("10");
                programs.add(program);

            }
            if (null != (tclass.getSecond()) && tclass.getSecond()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("FRIDAY");
                program.setEndTime("10");
                program.setStartTime("12");
                programs.add(program);
            }
            if (null != (tclass.getThird()) && tclass.getThird()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("FRIDAY");
                program.setEndTime("12");
                program.setStartTime("14");
                programs.add(program);
            }
            if (null != (tclass.getFourth()) && tclass.getFourth()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("FRIDAY");
                program.setEndTime("14");
                program.setStartTime("16");
                programs.add(program);
            }
            if (null != (tclass.getFifth()) && tclass.getFifth()) {
                ImportedCourseProgram program = new ImportedCourseProgram();
                program.setDay("FRIDAY");
                program.setEndTime("16");
                program.setStartTime("18");
                programs.add(program);
            }


        }

        return programs;
    }


    private String convertToTimeZone(String dateString) {

// parse the string
        DateTimeFormatter formatter = DateTimeFormat.forPattern("HH:mm");
        DateTime dateTime = formatter.parseDateTime(dateString);
        int hours = (int) (-4); //since both are ints, you get an int
        int minutes = (int) (-30);
        dateTime = dateTime.plusMinutes(minutes);
        dateTime = dateTime.plusHours(hours);
        return dateTime.getHourOfDay() + ":" + dateTime.getMinuteOfHour();
    }

    private Date getDate(String date, String time) {
        if (!time.contains(":")) {
            StringBuilder sb = new StringBuilder(time);
            sb.insert(2, ':');
            time = sb.toString();
        }
        long longDate = Date.from(java.sql.Timestamp
                .valueOf(                           // Class-method parses SQL-style formatted date-time strings.
                        getStringGeoDate(date, time)
                )                                   // Returns a `Timestamp` object.
                .toInstant()).getTime();

        return new Date(longDate / 1000);
    }

    private String getStringGeoDate(String date, String time) {
        if (null != time) {
            if (!time.contains(":")) {
                StringBuilder sb = new StringBuilder(time);
                sb.insert(2, ':');
                time = sb.toString();
            }
            String[] arr = date.split("/");

            PersianDate persianDate = PersianDate.of(Integer.parseInt(arr[0]), Integer.parseInt(arr[1]), Integer.parseInt(arr[2]));
            LocalDate gregDate = persianDate.toGregorian();
            return gregDate.toString() + " " + time + ":00";
        } else {
            String[] arr = date.split("/");

            PersianDate persianDate = PersianDate.of(Integer.parseInt(arr[0]), Integer.parseInt(arr[1]), Integer.parseInt(arr[2]));
            LocalDate gregDate = persianDate.toGregorian();
            return gregDate.toString();
        }

    }


    private String convertCorrectAnswer(Integer multipleChoiceAnswer, QuestionBank questionBank) {
        switch (multipleChoiceAnswer) {
            case 1:
                return questionBank.getOption1();
            case 2:
                return questionBank.getOption2();
            case 3:
                return questionBank.getOption3();
            case 4:
                return questionBank.getOption4();
            default:
                return null;

        }
    }

    private EQuestionType convertQuestionType(String title) {

        switch (title) {
            case "چند گزینه ای":
                return MULTI_CHOICES;
            case "تشریحی":
                return EQuestionType.DESCRIPTIVE;

            default:
                return null;

        }
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
        final ExamQuestionsObject examQuestionsObject = getQuestions(object, null);
        if (examQuestionsObject.getStatus() == 200) {
            List<ImportedQuestionProtocol> questionProtocols = examQuestionsObject.getProtocols();
            List<QuestionsDto> questionsDtos = new ArrayList<>();
            for (ImportedQuestionProtocol question : questionProtocols) {
                QuestionsDto questionsDto = new QuestionsDto();
                questionsDto.setQuestion(question.getQuestion().getTitle());
                questionsDto.setType(question.getQuestion().getType().getValue());
                questionsDto.setId(question.getQuestion().getId());
                StringBuilder listString = new StringBuilder();

                if (questionsDto.getType().equals(MULTI_CHOICES.getValue())) {
                    for (int i = 0; i < question.getQuestion().getQuestionOption().size(); i++) {
                        listString.append(i + 1).append(" - ").append(question.getQuestion().getQuestionOption().get(i).getTitle()).append("\t").append(System.lineSeparator());
                    }
                    questionsDto.setOptions(listString.toString());
                } else {
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

    public boolean checkExamScore(ExamImportedRequest object, Tclass tclass) {

        try {
            if (tclass.getScoringMethod().equals("3") || tclass.getScoringMethod().equals("2")) {
                double totalScore = 0;
                for (QuestionScores questionScores : object.getQuestionData()) {
                    double score = Double.parseDouble(questionScores.getScore());
                    totalScore = totalScore + score;
                }
                if (tclass.getScoringMethod().equals("3")) {
                    return totalScore == 20;
                } else {
                    return totalScore == 100;
                }

            } else {
                return true;

            }
        } catch (Exception ex) {
            return false;

        }

    }


    public List<EvalTargetUser> getClassUsers(List<ClassStudent> classStudents) {
        return classStudents.stream().map(classStudent -> toTargetUser(classStudent.getStudent())).collect(Collectors.toList());
    }

    public ElsEvalRequest removeInvalidUsers(ElsEvalRequest request) {
        request.getTargetUsers().removeIf(user -> !validateTargetUser(user));
        return request;
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

    public boolean checkValidScores(List<ExamResult> examResult) {
        for (ExamResult data : examResult) {
            try
            {
                double descriptiveResult=0D;
                double finalResult=0D;
                if ( data.getDescriptiveResult()!=null && !data.getDescriptiveResult().equals("-")) {
                    String englishDescriptiveResult = new BigDecimal(data.getDescriptiveResult()).toString();
                    descriptiveResult=  Double.parseDouble(englishDescriptiveResult);

                 }

                if ( data.getFinalResult()!=null && !data.getFinalResult().equals("-")) {
                    String englishFinalResult = new BigDecimal(data.getFinalResult()).toString();
                    finalResult= Double.parseDouble(englishFinalResult);
                }
                if (finalResult<descriptiveResult && (data.getFinalResult()!=null && !data.getFinalResult().equals("-")))
                    return false;

            }
            catch(NumberFormatException e)
            {
                return false;
            }
        }
        return true;
    }

    public boolean checkScoreInRange(String scoringMethod, List<ExamResult> examResult) {
        if (scoringMethod.equals("3") || scoringMethod.equals("2")) {

           if (scoringMethod.equals("3") )
           {
               for (ExamResult data : examResult) {
                   double finalResult=0D;

                   if ( data.getFinalResult()!=null && !data.getFinalResult().equals("-")) {
                       String englishFinalResult = new BigDecimal(data.getFinalResult()).toString();
                       finalResult= Double.parseDouble(englishFinalResult);
                       if (finalResult>20D)
                           return false;
                   }

               }
               return true;
               }
           else
           {
               for (ExamResult data : examResult) {
                   double finalResult=0D;

                   if ( data.getFinalResult()!=null && !data.getFinalResult().equals("-")) {
                       String englishFinalResult = new BigDecimal(data.getFinalResult()).toString();
                       finalResult= Double.parseDouble(englishFinalResult);
                       if (finalResult>100D)
                           return false;
                   }

               }
               return true;
           }
           }
          else
        return false;
    }

    public UpdateRequest convertScoresToDto(List<ExamResult> examResult, long id) {
        UpdateRequest request=new UpdateRequest();
        request.setSourceExamId(id);
        List<UpdatedResultDto> resultDtoList=new ArrayList<>();
        for (ExamResult data:examResult)
        {
            UpdatedResultDto updatedResultDto=new UpdatedResultDto();
            double descriptiveResult;
            double finalResult;
            double score;
            if ( data.getDescriptiveResult()!=null && !data.getDescriptiveResult().equals("-"))
            {
                String englishDescriptiveResult = new BigDecimal(data.getDescriptiveResult()).toString();
                descriptiveResult=  Double.parseDouble(englishDescriptiveResult);
                updatedResultDto.setDescriptiveResult(descriptiveResult);
            }
            else
            {
                updatedResultDto.setDescriptiveResult(null);

            }
            if ( data.getFinalResult()!=null && !data.getFinalResult().equals("-"))
            {
                String englishFinalResult = new BigDecimal(data.getFinalResult()).toString();
                finalResult= Double.parseDouble(englishFinalResult);
                updatedResultDto.setFinalResult(finalResult);
            }
            else
            {
                updatedResultDto.setFinalResult(null);
            }

            if ( data.getTestResult()!=null && !data.getTestResult().equals("-"))
            {
                String englishScore = new BigDecimal(data.getTestResult()).toString();
                score= Double.parseDouble(englishScore);
                updatedResultDto.setTestResult(score);
            }
            else
            {
                updatedResultDto.setTestResult(null);
            }

            updatedResultDto.setMobileNumber(data.getCellNumber());

            resultDtoList.add(updatedResultDto);
        }
        request.setResults(resultDtoList);
        return request;
    }

    public List<String> getUsersWithAnswer(List<ExamResultDto> answers, List<EvalTargetUser> newUsers) {
        List<ExamResultDto> userListWithoutNotAnswered = answers.stream().filter(item-> !item.getResultStatus().equals("4")).collect(Collectors.toList());

        List<String> userNames=new ArrayList<>();
        for (ExamResultDto examResultDto:userListWithoutNotAnswered)
        {
            String nationalCode=examResultDto.getNationalCode();
           boolean hasUser= newUsers.stream().anyMatch(item -> item.getNationalCode().equals(nationalCode));

            if (hasUser)
                userNames.add(examResultDto.getSurname() +" "+examResultDto.getLastName() );
        }
        return userNames;


    }
}
