package com.nicico.training.mapper.evaluation;


import com.nicico.training.model.*;
import com.nicico.training.service.QuestionBankService;
import com.nicico.training.utility.persianDate.PersianDate;
import dto.Question.QuestionData;
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
import request.evaluation.ElsEvalRequest;
import request.exam.ElsExamRequest;
import request.exam.ExamImportedRequest;


import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

import static dto.exam.EQuestionType.MULTI_CHOICES;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN, uses = QuestionBankService.class)
public abstract class EvaluationBeanMapper {

    @Autowired
    protected QuestionBankService questionBankService;


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
    public abstract EvalTargetUser toTeacher(PersonalInfo teacher);


    public ElsExamRequest toGetExamRequest(PersonalInfo teacherInfo, ExamImportedRequest object, List<ClassStudent> classStudents) {
        ElsExamRequest request = new ElsExamRequest();


        int time = Math.toIntExact(object.getExamItem().getDuration());

        int timeQues = 0;
        if (object.getQuestions() != null && object.getQuestions().size() > 0)
            timeQues = (time * 60) / object.getQuestions().size();

        ExamCreateDTO exam = getExamData(object);
        ImportedCourseCategory courseCategory = getCourseCategoryData(object);
        ImportedCourseDto courseDto = getCourseData(object);
        CourseProtocolImportDTO courseProtocol = getCourseProtocolData(object);

        List<ImportedQuestionProtocol> questionProtocols = getQuestions(object, timeQues);
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

        return request;
    }

    private ImportedUser getTeacherData(PersonalInfo teacherInfo) {
    ImportedUser teacher=new ImportedUser();
        if (null != teacherInfo.getContactInfo() && null != teacherInfo.getContactInfo().getMobile()) {

            teacher.setCellNumber(teacherInfo.getContactInfo().getMobile());
            teacher.setNationalCode(teacherInfo.getNationalCode());
            teacher.setGender(teacherInfo.getGender().getTitleFa());
            teacher.setLastName(teacherInfo.getLastNameFa());
            teacher.setSurname(teacherInfo.getFirstNameFa());
        } else {
            teacher.setCellNumber("09189996626");
            teacher.setNationalCode("3240939177");
            teacher.setGender("زن");
            teacher.setLastName("اردلانی");
            teacher.setSurname("الناز");
        }
        return teacher;
    }

    private List<ImportedQuestionProtocol> getQuestions(ExamImportedRequest object, int timeQues) {

        List<ImportedQuestionProtocol> questionProtocols = new ArrayList<>();

        Double questionScore = (double) (20 / object.getQuestions().size());

        for (QuestionData questionData : object.getQuestions()) {
            ImportedQuestionProtocol questionProtocol = new ImportedQuestionProtocol();

            ImportedQuestion question = new ImportedQuestion();


            question.setTitle(questionData.getQuestionBank().getQuestion());
            question.setType(convertQuestionType(questionData.getQuestionBank().getQuestionType().getTitle()));

            if (question.getType().equals(MULTI_CHOICES)) {


                List<ImportedQuestionOption> options = new ArrayList<>();

                QuestionBank questionBank = questionBankService.getById(questionData.getQuestionBank().getId());

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
                question.setQuestionOption(options);
                questionProtocol.setCorrectAnswerTitle(convertCorrectAnswer(questionBank.getMultipleChoiceAnswer(), questionBank));

            }

            questionProtocol.setMark(questionScore);
            questionProtocol.setTime(timeQues);
            questionProtocol.setQuestion(question);
            questionProtocols.add(questionProtocol);
        }
        return questionProtocols;
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

    private ExamCreateDTO getExamData(ExamImportedRequest object) {
        int time = Math.toIntExact(object.getExamItem().getDuration());

//        String newTime = convertToTimeZone(object.getExamItem().getTime());
        String newTime = object.getExamItem().getTime();

        Date startDate = getDate(object.getExamItem().getDate(), newTime);

        Date endDate = getEndDateFromDuration(getStringGeoDate(object.getExamItem().getDate(), newTime)
                , object.getExamItem().getDuration());
        ExamCreateDTO exam = new ExamCreateDTO();
        exam.setCode(object.getExamItem().getTclass().getCode());
        exam.setName(object.getExamItem().getTclass().getTitleClass());
        exam.setStartDate(startDate.getTime());
        exam.setEndDate(endDate.getTime());
        exam.setQuestionCount(object.getQuestions().size());
        exam.setMinimumAcceptScore(10D);
        exam.setSourceExamId(object.getExamItem().getId());

        exam.setDuration(time);


        exam.setScore(20D);
        //todo
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

    private Date getEndDateFromDuration(String dateString, Long duration) {

// parse the string
        DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyy-MM-dd HH:mm:ss");
        DateTime dateTime = formatter.parseDateTime(dateString);


        int hours = (int) (duration / 60); //since both are ints, you get an int
        int minutes = (int) (duration % 60);
        dateTime = dateTime.plusMinutes(minutes);
        dateTime = dateTime.plusHours(hours);


        java.sql.Timestamp ts = new java.sql.Timestamp(dateTime.getMillis());


        return new Date(ts.getTime() / 1000);


    }

    private String convertToTimeZone(String dateString) {

// parse the string
        DateTimeFormatter formatter = DateTimeFormat.forPattern("HH:mm");
        DateTime dateTime = formatter.parseDateTime(dateString);
        int hours = (int) (-3); //since both are ints, you get an int
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


    public Boolean hasDuplicateQuestions(List<ImportedQuestionProtocol> questionProtocols) {

        Set<String> set = new HashSet<>();
        return !questionProtocols.stream().allMatch(t -> set.add(t.getQuestion().getTitle().trim()));
    }

    public Boolean hasWrongCorrectAnswer(List<ImportedQuestionProtocol> questionProtocols) {
        List<ImportedQuestionProtocol> filteredTeams =
                questionProtocols
                        .stream().filter(p -> p.getQuestion().getType().getValue().equals(MULTI_CHOICES.getValue()))

                        .collect(Collectors.toList());

        return filteredTeams.stream().anyMatch(x -> x.getCorrectAnswerTitle() == null);
    }
}
