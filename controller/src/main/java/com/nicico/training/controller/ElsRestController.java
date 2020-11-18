package com.nicico.training.controller;


import com.nicico.training.controller.client.els.ElsClient;
import com.nicico.training.controller.util.JalaliCalendar;
import com.nicico.training.mapper.evaluation.EvaluationBeanMapper;
import com.nicico.training.model.ClassStudent;
import com.nicico.training.model.Evaluation;
import com.nicico.training.model.QuestionBank;
import com.nicico.training.service.*;
import dto.QuestionData;
import dto.exam.*;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import request.evaluation.ElsEvalRequest;
import request.exam.ElsExamRequest;
import request.exam.ExamImportedRequest;
import response.BaseResponse;
import response.evaluation.EvalListResponse;
import response.evaluation.SendEvalToElsResponse;
import response.exam.ExamListResponse;

import java.util.ArrayList;
import java.util.Date;
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
    private final PersonalInfoService personalInfoService;
    private final QuestionBankService questionBankService;
    private final ElsClient client;

    @GetMapping("/eval/{id}")
    public ResponseEntity<SendEvalToElsResponse> sendEvalToEls(@PathVariable long id) {
        Evaluation evaluation = evaluationService.getById(id);
        ElsEvalRequest request = evaluationBeanMapper.toElsEvalRequest(evaluation, questionnaireService.get(evaluation.getQuestionnaireId()),
                classStudentService.getClassStudents(evaluation.getClassId()),
                evaluationService.getEvaluationQuestions(answerService.getAllByEvaluationId(evaluation.getId())),
                personalInfoService.getPersonalInfo(teacherService.getTeacher(evaluation.getTclass().getTeacherId()).getPersonalityId()));
        BaseResponse baseResponse = client.sendEvaluation(request);
        SendEvalToElsResponse response = new SendEvalToElsResponse();
        response.setMessage(baseResponse.getMessage());
        response.setStatus(baseResponse.getStatus());

        return new ResponseEntity<>(response, HttpStatus.OK);
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
    public ResponseEntity<EvalListResponse> sendExam(@RequestBody ExamImportedRequest object) {

        ElsExamRequest request = new ElsExamRequest();
        ExamCreateDTO exam = new ExamCreateDTO();
        ImportedCourseCategory courseCategory = new ImportedCourseCategory();
        ImportedCourseDto courseDto = new ImportedCourseDto();
        CourseProtocolImportDTO courseProtocol = new CourseProtocolImportDTO();
        ImportedCourseProgram program = new ImportedCourseProgram();
        List<ImportedCourseProgram> programs = new ArrayList<>();
        List<ImportedQuestionProtocol> questionProtocols = new ArrayList<>();
        ImportedUser teacher = new ImportedUser();
        /////////////////////////////////////////////////////////

        exam.setCode(object.getExamItem().getTclass().getCode());
        exam.setName(object.getExamItem().getTclass().getTitleClass());
        exam.setStartDate(1600585781L);
        exam.setEndDate(1685585781L);
        exam.setQuestionCount(object.getQuestions().size());
        exam.setMinimumAcceptScore(10D);
        exam.setSourceExamId(object.getExamItem().getId());
        int time = Math.toIntExact(object.getExamItem().getDuration());

        exam.setDuration(time);
        int timeQues = 0;
        if (object.getQuestions() != null && object.getQuestions().size() > 0)
            timeQues = (time * 1000) / object.getQuestions().size();
        exam.setScore(20D);
        exam.setStatus(ExamStatus.ACTIVE);
//////////////////////////////////////////////////
        courseCategory.setCode(object.getExamItem().getTclass().getCourse().getCategory().getCode());
        courseCategory.setName(object.getExamItem().getTclass().getCourse().getCategory().getTitleFa());
//////////////////////
        courseDto.setCode(object.getExamItem().getTclass().getCourse().getCode());
        courseDto.setName(object.getExamItem().getTclass().getCourse().getTitleFa());
////////////////////////
        courseProtocol.setCapacity(Math.toIntExact(object.getExamItem().getTclass().getMaxCapacity()));
        courseProtocol.setClassType(ClassType.ATTENDANCE);
        courseProtocol.setCode(object.getExamItem().getTclass().getCode());
        courseProtocol.setName(object.getExamItem().getTclass().getTitleClass());
        courseProtocol.setDuration(100);
        courseProtocol.setStartDate(getDateFromStringDate(object.getExamItem().getTclass().getStartDate()).getTime());
        courseProtocol.setFinishDate(getDateFromStringDate(object.getExamItem().getTclass().getEndDate()).getTime());
        courseProtocol.setCourseStatus(CourseStatus.ACTIVE);
        courseProtocol.setCourseType(CourseType.IMPERETIVE);
        ////////////////////////////////////
        program.setDay("SATURDAY");
        program.setEndTime("12");
        program.setStartTime("10");
        programs.add(program);
        /////////////////////////////


        for (QuestionData questionData : object.getQuestions()) {
            ImportedQuestionProtocol questionProtocol = new ImportedQuestionProtocol();

            ImportedQuestion question = new ImportedQuestion();


            question.setTitle(questionData.getQuestionBank().getQuestion());
            question.setType(convertQuestionType(questionData.getQuestionBank().getQuestionType().getTitle()));

            if (question.getType().equals(EQuestionType.MULTI_CHOICES)) {


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

            questionProtocol.setMark(2D);
            questionProtocol.setTime(timeQues);
            questionProtocol.setQuestion(question);
            questionProtocols.add(questionProtocol);
        }


////////////////////////////////////////////
        teacher.setCellNumber("09189996626");
        teacher.setNationalCode("3240939177");
        teacher.setGender("زن");
        teacher.setLastName("اردلانی");
        teacher.setSurname("الناز");
        /////////////////////////////


        List<ClassStudent> classStudents = classStudentService.getClassStudents(object.getExamItem().getTclassId());

        request.setUsers(classStudents.stream()
                .map(classStudent -> evaluationBeanMapper.toTargetUser(classStudent.getStudent())).collect(Collectors.toList()));


        ////////////////////
        exam.setType(getExamType(questionProtocols));

        request.setExam(exam);
        request.setCategory(courseCategory);
        request.setCourse(courseDto);
        request.setInstructor(teacher);
        request.setQuestionProtocols(questionProtocols);
        request.setPrograms(programs);
        request.setProtocol(courseProtocol);


        BaseResponse response = client.sendExam(request);
        //TODO SAVE EVALUATION RESULTS TO DB OR ANYTHING THAT YOU WANT TO DO
        return new ResponseEntity(response, HttpStatus.OK);
    }

    private ExamType getExamType(List<ImportedQuestionProtocol> questionProtocols) {
         int multies = 0;
        int creative = 0;

        for (ImportedQuestionProtocol question : questionProtocols) {
            if (question.getQuestion().getType().getKey() == 1)
                creative++;
            else
                multies++;


        }
        if (multies>0 && creative>0)
            return ExamType.MIX;
        else if (multies>0 && creative==0)
            return ExamType.MULTI_CHOICES;
        else
            return ExamType.DESCRIPTIVE;


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
                return EQuestionType.MULTI_CHOICES;
            case "تشریحی":
                return EQuestionType.DESCRIPTIVE;

            default:
                return null;

        }
    }

    private Date getDateFromStringDate(String date) {

        long longDate = JalaliCalendar.getGregorianDate(date).getTime();
        long time = longDate / 1000;

        return new Date(time);

    }
}
