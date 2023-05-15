package com.nicico.training.service;


import com.nicico.training.TrainingException;
import com.nicico.training.dto.TestQuestionDTO;
import com.nicico.training.iservice.*;
import com.nicico.training.mapper.testQuestion.TestQuestionMapper;
import com.nicico.training.model.*;
import com.nicico.training.utility.persianDate.MyUtils;
import dto.exam.*;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import request.exam.ElsSendExamToTrainingResponse;
import request.exam.ExamResult;
import response.BaseResponse;

import java.util.*;
import java.util.concurrent.atomic.AtomicReference;

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
    private final ITeacherService teacherService;
    private final IStudentService studentService;
    private final IClassStudentService classStudentService;

    @Override
    public BaseResponse checkValidScores(Long id, List<ExamResult> examResults) {
        BaseResponse baseResponse = new BaseResponse();


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
//                if (questionBank.isPresent() && (questionBank.get().getIsChild() == null || (questionBank.get().getIsChild() != null && !questionBank.get().getIsChild())))
                    filteredQuestions.add(questionBank.get());
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
                 if (qp.getMark()!=null)
                questionProtocol.setQuestionMark(Float.valueOf(qp.getMark().toString()));
                 else {
                     questionProtocol.setQuestionMark(getGroupQuestionMark(testQuestionDTO,question.getGroupQuestions()));
                 }
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

    private Float getGroupQuestionMark(TestQuestionDTO.Import testQuestionDTO, Set<QuestionBank> groupQuestions) {
        AtomicReference<Float> mark= new AtomicReference<>(0F);
        if (groupQuestions!=null){
            groupQuestions.forEach(questionBank -> {
                ElsImportedQuestionProtocol qp = testQuestionDTO.getQuestionProtocols().stream()
                        .filter(questionProtocol -> questionProtocol.getQuestion().getTitle().equals(questionBank.getQuestion()))
                        .findFirst()
                        .orElse(null);
                mark.set((float) (mark.get() + ((qp!=null && qp.getMark()!=null) ? qp.getMark() : 0F)));

            });
        }
        return mark.get();
    }

    @Override
    public List<ExamNotSentToElsDTO.Info> getAllExamsNotSentToElsByTeacherNationalCode(String nationalCode) {
        Teacher teacher = teacherService.getTeacherByNationalCode(nationalCode);

        if (teacher == null) {
            throw new TrainingException(TrainingException.ErrorType.TeacherNotFound);
        }

        // find all test-questions(exams) not sent to els
        List<TestQuestion> allNotSentToEls = testQuestionService.getTeacherExamsNotSentToEls(nationalCode);

        // map exams to dto
        List<ExamNotSentToElsDTO.Info> examNotSentToElsDTOS = testQuestionMapper.toExamNotSentDto(allNotSentToEls);

        return examNotSentToElsDTOS;
    }

    @Override
    public List<ExamStudentDTO.Info> getAllStudentsOfExam(Long examId) {
        TestQuestion exam = testQuestionService.getById(examId);

        if (exam == null) {
            throw new TrainingException(TrainingException.ErrorType.TestQuestionNotFound);
        }

        List<?> allStudentsOfExam = studentService.getAllStudentsOfExam(examId);
        List<ExamStudentDTO.Info> infos = new ArrayList<>();

        if (allStudentsOfExam != null) {
            for (Object o : allStudentsOfExam) {
                Object[] fields = (Object[]) o;

                ExamStudentDTO.Info dto = new ExamStudentDTO.Info();

                dto.setFirstName(fields[0] != null ? fields[0].toString() : null);
                dto.setLastName(fields[1] != null ? fields[1].toString() : null);
                dto.setNationalCode(fields[2] != null ? fields[2].toString() : null);
                dto.setScore(fields[3] != null ? Float.valueOf(fields[3].toString()) : null);
                dto.setScoreStateTitle(fields[4] != null ? fields[4].toString() : null);
                dto.setClassStudentId(fields[5] != null ? Long.valueOf(fields[5].toString()) : null);
                dto.setExamId(fields[6] != null ? Long.valueOf(fields[6].toString()) : null);
                dto.setPracticalScore(fields[7] != null ? Double.valueOf(fields[7].toString()) : null);
                dto.setClassScore(fields[8] != null ? Double.valueOf(fields[8].toString()) : null);
                dto.setDescriptiveScore(fields[9] != null ? Float.valueOf(fields[9].toString()) : null);
                dto.setTestScore(fields[10] != null ? Float.valueOf(fields[10].toString()) : null);
                dto.setMaxPracticalScore(fields[11] != null ? Double.valueOf(fields[11].toString()) : null);
                dto.setMaxClassScore(fields[12] != null ? Double.valueOf(fields[12].toString()) : null);
                dto.setMaxScore(fields[13] != null ? Double.valueOf(fields[13].toString()) : null);

                infos.add(dto);
            }
        }

        return infos;
    }

    @Override
    public Map<String, String> updateScores(List<ExamStudentDTO.Score> list) {
        Map<String, String> notUpdatedNationalCodes = new HashMap<>();

        list.forEach(item -> {
            ClassStudent classStudent = classStudentService.findById(item.getClassStudentId())
                    .orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));

            String testQuestionType = testQuestionService.getById(item.getExamId()).getTestQuestionType();

            try {
                Float score = item.getScore();
                Double classScore = item.getClassScore() != null ? item.getClassScore().doubleValue() : 0;
                Float testScore = item.getTestScore() != null ? item.getTestScore() : 0;
                Float descriptiveScore = item.getDescriptiveScore() != null ? item.getDescriptiveScore() : 0;
                Double practicalScore = item.getPracticalScore() != null ? item.getPracticalScore().doubleValue() : 0;
                String scoringMethod = tclassService.get(classStudent.getTclassId()).getScoringMethod();
                String classClassScore = testQuestionService.getById(item.getExamId()).getClassScore();
                String classPracticalScore = testQuestionService.getById(item.getExamId()).getPracticalScore();
                String acceptanceLimit = tclassService.get(classStudent.getTclassId()).getAcceptancelimit();
                boolean scoreInValidRange = isScoreInValidRange(score, scoringMethod, classScore, testScore, descriptiveScore, practicalScore);
                boolean scoresAcceptable = isScoresAcceptable(classClassScore, classPracticalScore, classScore, practicalScore);

                if (testQuestionType.equals("FinalTest")) {
                    boolean passedAcceptanceLimit = score >= Float.parseFloat(acceptanceLimit);

                    if (scoreInValidRange && scoresAcceptable) {
                        ParameterValue parameterValue = updateScoreState(passedAcceptanceLimit);

                        if (parameterValue == null) {
                            notUpdatedNationalCodes.put(item.getNationalCode(), "خطا در ثبت نمره");
                            return;
                        }

                        classStudent.setScoresStateId(parameterValue.getId());
                        classStudent.setScore(score);
                        classStudent.setTestScore(testScore);
                        classStudent.setDescriptiveScore(descriptiveScore);
                        classStudent.setClassScore(classScore);
                        classStudent.setPracticalScore(practicalScore);

                    } else {
                        notUpdatedNationalCodes.put(item.getNationalCode(), "نمرات ثبت شده در بازه ی درستی نیستند");
                    }
                } else if (testQuestionType.equals("PreTest")) {
                    if (scoreInValidRange && scoresAcceptable) {
                        classStudent.setPreTestScore(score);
                        classStudent.setTestScore(testScore);
                        classStudent.setDescriptiveScore(descriptiveScore);
                    } else {
                        notUpdatedNationalCodes.put(item.getNationalCode(), "نمرات ثبت شده در بازه ی درستی نیستند");
                    }
                }
                classStudentService.save(classStudent);

            } catch (Exception e) {
                notUpdatedNationalCodes.put(item.getNationalCode(), "خطا در ثبت نمره");
            }
        });

        return notUpdatedNationalCodes;

    }

    private boolean isScoresAcceptable(String cClassScore, String cPracticalScore, Double classScore, Double practicalScore) {
        double importedClassScore = (classScore) == null ? 0 : classScore;
        double importedPracticalScore = (practicalScore) == null ? 0 : practicalScore;
        double classClassScore = (cClassScore) == null ? 0D : Double.parseDouble(cClassScore);
        double classPracticalScore = (cPracticalScore) == null ? 0D : Double.parseDouble(cPracticalScore);
        return importedClassScore <= classClassScore && importedPracticalScore <= classPracticalScore;

    }

    private boolean isScoreInValidRange(Float score, String scoringMethod, Double classScore, Float testScore, Float descriptiveScore, Double practicalScore) {
        if (scoringMethod.equals("2")) { // از 100 نمره
            return score >= 0 && score <= 100 && (classScore + testScore + descriptiveScore + practicalScore == score);
        }
        if (scoringMethod.equals("3")) { // از 20 نمره
            return score >= 0 && score <= 20 && (classScore + testScore + descriptiveScore + practicalScore == score);
        }
        return false;
    }

    private ParameterValue updateScoreState(boolean passedAcceptanceLimit) {
        Long passedCodeId = parameterValueService.getId("PassdByGrade"); // 400 - قبول با نمره
        Long notPassedCodeId = parameterValueService.getId("TotalFailed"); // 403 - مردود

        ParameterValue parameterValue;

        if (passedAcceptanceLimit) {
            parameterValue = parameterValueService.findById(passedCodeId).orElse(null);
        } else {
            parameterValue = parameterValueService.findById(notPassedCodeId).orElse(null);
        }
        return parameterValue;
    }

    @Override
    public Boolean updateQuestionActivationState(Long questionId, Boolean isActive) {
        return questionBankService.update(questionId, isActive);
    }

    @Override
    public Boolean updateQuestionsActivationState(List<Long> questionIds, Boolean isActive) {
        try {
            questionIds.forEach(questionId->{
                questionBankService.update(questionId, isActive);
            });
        }catch (Exception e){

        }
        finally {
            return true;
        }

     }

}
