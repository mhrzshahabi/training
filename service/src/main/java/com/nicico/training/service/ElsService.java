package com.nicico.training.service;


import com.nicico.training.dto.TestQuestionDTO;
import com.nicico.training.iservice.*;
import com.nicico.training.mapper.testQuestion.TestQuestionMapper;
import com.nicico.training.model.QuestionBank;
import com.nicico.training.model.QuestionBankTestQuestion;
import com.nicico.training.model.QuestionProtocol;
import com.nicico.training.model.TestQuestion;
import com.nicico.training.utility.persianDate.MyUtils;
import dto.exam.ElsExamCreateDTO;
import dto.exam.ElsImportedExam;
import dto.exam.ElsImportedQuestionProtocol;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import request.exam.ElsSendExamToTrainingResponse;
import request.exam.ExamResult;
import response.BaseResponse;

import java.util.*;

@Service
@RequiredArgsConstructor
public class ElsService implements IElsService {
    private final ITestQuestionService testQuestionService;
    private final IQuestionBankService questionBankService;
    private final IQuestionBankTestQuestionService questionBankTestQuestionService;
    private final IQuestionProtocolService questionProtocolService;
    private final ITclassService tclassService;
    private final IParameterValueService parameterValueService;
    private final TestQuestionMapper testQuestionMapper;

  @Override
    public BaseResponse checkValidScores(Long id, List<ExamResult> examResults) {
        BaseResponse baseResponse =new BaseResponse();



        return baseResponse;
    }

    @Override
    public ElsSendExamToTrainingResponse submitExamFromEls(ElsImportedExam importedExam) {
        ElsSendExamToTrainingResponse response = new ElsSendExamToTrainingResponse();
        ElsExamCreateDTO.Info info;

        try {
            // map the imported exam to testQuestion
            TestQuestionDTO.Import testQuestionDTO = testQuestionMapper.toTestQuestionDto(importedExam);
            long tclassId = tclassService.getClassByCode(testQuestionDTO.getClassCode()).getId();
            testQuestionDTO.setTclassId(tclassId);

            // save the exam without questions
            info = saveExam(testQuestionDTO);

            // compare and filter received questions from els with training questions
            // base on question title and question type
            Set<QuestionBank> filteredQuestions = compareAndFilterQuestions(testQuestionDTO, tclassId);

            // assign questions to the exam
            assignQuestionsToExam(info, testQuestionDTO, filteredQuestions);

            response.setStatus(HttpStatus.OK.value());
            response.setMessage("Exam successfully created");
            response.setInfo(info);

        } catch (Exception e) {
            response.setStatus(HttpStatus.CONFLICT.value());
            response.setMessage("بروز خطا در سیستم: " + e.getMessage());
        }

        return response;
    }

    private ElsExamCreateDTO.Info saveExam(TestQuestionDTO.Import testQuestionDTO) {
        if (testQuestionDTO.getTestQuestionType().equals("FinalTest")) {
            TestQuestionDTO.Info createdTestQuestion = testQuestionService.create(testQuestionMapper.toCreate(testQuestionDTO));
            return testQuestionMapper.toInfo(createdTestQuestion);
        } else {
            TestQuestion testQuestion = testQuestionService.createPreTest(testQuestionDTO.getTclassId());
            return testQuestionMapper.toInfo(testQuestion);
        }
    }

    private Set<QuestionBank> compareAndFilterQuestions(TestQuestionDTO.Import testQuestionDTO, long classId) {
        Set<QuestionBank> filteredQuestions = new HashSet<>();

        List<ElsImportedQuestionProtocol> receivedQuestionProtocols = testQuestionDTO.getQuestionProtocols();

        Long teacherId = tclassService.get(classId).getTeacherId();
        List<QuestionBank> allByTeacherId = questionBankService.findAllTeacherId(teacherId);

        if (receivedQuestionProtocols != null && !receivedQuestionProtocols.isEmpty()) {
            for (ElsImportedQuestionProtocol qp : receivedQuestionProtocols) {
                Optional<QuestionBank> questionBank = allByTeacherId.stream()
                        .filter(q -> q.getQuestion().equals(qp.getQuestion().getTitle()) && MyUtils.convertQuestionType(q.getQuestionTypeId(), parameterValueService).equals(qp.getQuestion().getType()))
                        .findFirst();

                questionBank.ifPresent(filteredQuestions::add);
            }
        }
        return filteredQuestions;
    }

    private void assignQuestionsToExam(ElsExamCreateDTO.Info info, TestQuestionDTO.Import testQuestionDTO, Set<QuestionBank> filteredQuestions) {
        List<QuestionBankTestQuestion> questionBankTestQuestions = new ArrayList<>();
        List<QuestionProtocol> questionProtocols = new ArrayList<>();

        filteredQuestions.forEach(question -> {
            ElsImportedQuestionProtocol qp = testQuestionDTO.getQuestionProtocols().stream()
                    .filter(questionProtocol -> questionProtocol.getQuestion().getTitle().equals(question.getQuestion()) && questionProtocol.getQuestion().getType().getValue().equals(MyUtils.convertQuestionType(question.getQuestionTypeId(), parameterValueService).getValue()))
                    .findFirst()
                    .orElse(null);

            if (qp != null) {
                QuestionBankTestQuestion questionBankTestQuestion = new QuestionBankTestQuestion();
                QuestionProtocol questionProtocol = new QuestionProtocol();

                questionBankTestQuestion.setQuestionBankId(question.getId());
                questionBankTestQuestion.setTestQuestionId(info.getId());
                questionBankTestQuestions.add(questionBankTestQuestion);
                questionProtocol.setQuestionId(question.getId());
                questionProtocol.setExamId(info.getId());
                questionProtocol.setTime(qp.getTime());
                questionProtocol.setCorrectAnswerTitle(question.getDescriptiveAnswer());
                questionProtocol.setQuestionMark(Float.valueOf(qp.getMark().toString()));
                questionProtocols.add(questionProtocol);
            }

        });
        if (!questionBankTestQuestions.isEmpty()) {
            try {
                questionBankTestQuestionService.saveAll(questionBankTestQuestions);
                questionProtocolService.saveAll(questionProtocols);
            } catch (Exception e) {
                testQuestionService.delete(info.getId());
            }
        } else {
            testQuestionService.delete(info.getId());
        }
    }

}
