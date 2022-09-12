package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.QuestionBankTestQuestionDTO;
import com.nicico.training.dto.question.ElsExamRequestResponse;
import com.nicico.training.iservice.IQuestionBankTestQuestionService;
import com.nicico.training.mapper.evaluation.EvaluationBeanMapper;
import com.nicico.training.model.*;
import com.nicico.training.repository.*;
import dto.Question.QuestionData;
import dto.exam.ExamData;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.security.acls.model.NotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import request.exam.ElsExamRequest;
import request.exam.ExamImportedRequest;

import java.util.List;
import java.util.Locale;
import java.util.Optional;
import java.util.stream.Collectors;

@RequiredArgsConstructor
@Service
public class QuestionBankTestQuestionService implements IQuestionBankTestQuestionService {

    TclassDAO tclassDAO;
    TeacherDAO teacherDAO;
    ModelMapper modelMapper;
    ContactInfoDAO contactInfoDAO;
    TestQuestionDAO testQuestionDAO;
    QuestionBankDAO questionBankDAO;
    PersonalInfoDAO personalInfoDAO;
    ParameterValueDAO parameterValueDAO;
    ClassStudentService classStudentService;
    EvaluationBeanMapper evaluationBeanMapper;
    QuestionBankTestQuestionDAO questionBankTestQuestionDAO;
    MessageSource messageSource;


    @Autowired
    public QuestionBankTestQuestionService(TclassDAO tclassDAO,
                                           TeacherDAO teacherDAO,
                                           ModelMapper modelMapper,
                                           ContactInfoDAO contactInfoDAO,
                                           TestQuestionDAO testQuestionDAO,
                                           QuestionBankDAO questionBankDAO,
                                           PersonalInfoDAO personalInfoDAO,
                                           ParameterValueDAO parameterValueDAO,
                                           ClassStudentService classStudentService,
                                           EvaluationBeanMapper evaluationBeanMapper,
                                           QuestionBankTestQuestionDAO questionBankTestQuestionDAO,
                                           MessageSource messageSource) {

        this.teacherDAO = teacherDAO;
        this.tclassDAO = tclassDAO;
        this.modelMapper = modelMapper;
        this.contactInfoDAO = contactInfoDAO;
        this.testQuestionDAO = testQuestionDAO;
        this.questionBankDAO = questionBankDAO;
        this.personalInfoDAO = personalInfoDAO;
        this.parameterValueDAO = parameterValueDAO;
        this.classStudentService = classStudentService;
        this.evaluationBeanMapper = evaluationBeanMapper;
        this.questionBankTestQuestionDAO = questionBankTestQuestionDAO;
        this.messageSource = messageSource;
    }

    @Transactional
    @Override
    public SearchDTO.SearchRs<QuestionBankTestQuestionDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(questionBankTestQuestionDAO, request, term -> modelMapper.map(term, QuestionBankTestQuestionDTO.Info.class));
    }

    @Transactional
    @Override
    public SearchDTO.SearchRs<QuestionBankTestQuestionDTO.InfoUsed> search1(SearchDTO.SearchRq request) {
        return SearchUtil.search(questionBankTestQuestionDAO, request, term -> modelMapper.map(term, QuestionBankTestQuestionDTO.InfoUsed.class));
    }

    @Override
    public List<QuestionBankTestQuestionDTO.QuestionBankTestQuestionFinalTest> finalTestList(String type, Long classId) {

        String testQuestionType;
        Locale locale = LocaleContextHolder.getLocale();

        if (type.equalsIgnoreCase("PreTest")) {
            testQuestionType = "PreTest";
        } else if (type.equalsIgnoreCase("test") || type.equalsIgnoreCase("FinalTest")) {
            testQuestionType = "FinalTest";
        } else if (type.equalsIgnoreCase("preparation")) {
            testQuestionType = "Preparation";
        } else {
            throw new TrainingException(TrainingException.ErrorType.TestQuestionBadRequest);
        }

        List<QuestionBankTestQuestion> questionBankTestQuestions = questionBankTestQuestionDAO.findByTypeAndClassId(testQuestionType, classId);
        questionBankTestQuestions.stream().forEach(item -> {

            QuestionBank questionBank = questionBankDAO.findById(item.getQuestionBankId()).orElseThrow(() -> new NotFoundException("QuestionBank Not Found"));
            TestQuestion testQuestion = testQuestionDAO.findById(item.getTestQuestionId()).orElseThrow(() -> new NotFoundException("testQuestion Not Found"));
            if (testQuestion.getTclass().getTeacherId() != null) {

                Teacher teacher = teacherDAO.findById(testQuestion.getTclass().getTeacherId()).orElseThrow(() -> new NotFoundException("teacher Not Found"));
                if (teacher.getPersonalityId() != null) {

                    PersonalInfo personalInfo = personalInfoDAO.findById(teacher.getPersonalityId()).orElseThrow(() -> new NotFoundException("personalInfo Not Found"));
                    if (personalInfo.getContactInfoId() != null) {

                        ContactInfo contactInfo = contactInfoDAO.findById(personalInfo.getContactInfoId()).orElseThrow(() -> new NotFoundException("contactInfo Not Found"));
                        ParameterValue questionType = parameterValueDAO.findById(questionBank.getQuestionTypeId()).orElseThrow(() -> new NotFoundException(""));

                        questionBank.setQuestionType(questionType);
                        testQuestion.getTclass().setTeacher(teacher);
                        testQuestion.getTclass().getTeacher().setPersonality(personalInfo);
                        testQuestion.getTclass().getTeacher().getPersonality().setContactInfo(contactInfo);
                        item.setQuestionBank(questionBank);
                        item.setTestQuestion(testQuestion);

                    } else
                        throw new TrainingException(TrainingException.ErrorType.NotFound, "teacher", messageSource.getMessage("msg.check.class.teacher.info", null, locale));

                } else {
                    throw new TrainingException(TrainingException.ErrorType.NotFound, "teacher", messageSource.getMessage("msg.check.class.teacher.info", null, locale));
                }
            } else
                throw new TrainingException(TrainingException.ErrorType.NotFound, "teacher", messageSource.getMessage("msg.check.class.teacher", null, locale));
        });

        List<QuestionBankTestQuestionDTO.QuestionBankTestQuestionFinalTest> questionFinalTests = questionBankTestQuestions.stream().map(u -> modelMapper.map(u, QuestionBankTestQuestionDTO.QuestionBankTestQuestionFinalTest.class)).collect(Collectors.toList());
        return questionFinalTests;
    }

    @Override
    public boolean validateQuestions(String type, List<QuestionBankTestQuestionDTO.QuestionBankTestQuestionFinalTest> questionFinalTests) {

        ElsExamRequest request;
        ExamImportedRequest object = new ExamImportedRequest();

        QuestionBankTestQuestionDTO.QuestionBankTestQuestionFinalTest questionBankTestQuestionFinalTest = questionFinalTests.get(0);
        TestQuestion testQuestion = testQuestionDAO.findById(questionBankTestQuestionFinalTest.getTestQuestionId()).orElseThrow(() -> new NotFoundException("testQuestion not Found"));
        Tclass tclass = tclassDAO.findById(testQuestion.getTclassId()).orElseThrow(() -> new NotFoundException("tclass not Found"));
        Teacher teacher = teacherDAO.findById(tclass.getTeacherId()).orElseThrow(() -> new NotFoundException("teacher not Found"));
        PersonalInfo personalInfo = personalInfoDAO.findById(teacher.getPersonalityId()).orElseThrow(() -> new NotFoundException("personalInfo not Found"));
        ExamData examData = modelMapper.map(testQuestion, ExamData.class);
        List<QuestionData> questions = modelMapper.map(questionFinalTests, new TypeToken<List<QuestionData>>() {
        }.getType());

        object.setExamItem(examData);
        object.setQuestions(questions);
        final ElsExamRequestResponse elsExamRequestResponse;

        if (type.equalsIgnoreCase("test") || type.equalsIgnoreCase("FinalTest")) {
            elsExamRequestResponse = evaluationBeanMapper.toGetExamRequest(tclass, personalInfo, object,
                    classStudentService.getClassStudents(questionBankTestQuestionFinalTest.getTestQuestion().getTclassId()));
        } else {
            elsExamRequestResponse = evaluationBeanMapper.toGetPreExamRequest(tclass, personalInfo, object,
                    classStudentService.getClassStudents(questionBankTestQuestionFinalTest.getTestQuestion().getTclassId()), type);
        }
        request = elsExamRequestResponse.getElsExamRequest();
        boolean hasWrongCorrectAnswer = evaluationBeanMapper.hasWrongCorrectAnswer(request.getQuestionProtocols());
        if (hasWrongCorrectAnswer || request.getQuestionProtocols().size() == 0)
            throw new TrainingException(TrainingException.ErrorType.InvalidData);
        return true;
    }

    @Transactional
    @Override
    public void addQuestions(String type, Long classId, List<Long> questionIds) {

        String testQuestionType;

        if (type.equalsIgnoreCase("preTest")) {
            testQuestionType = "PreTest";
        } else if (type.equalsIgnoreCase("test") || type.equalsIgnoreCase("FinalTest")) {
            testQuestionType = "FinalTest";
        } else if (type.equalsIgnoreCase("preparation")) {
            testQuestionType = "Preparation";
        } else {
            throw new TrainingException(TrainingException.ErrorType.TestQuestionBadRequest);
        }

        TestQuestion testQuestion = testQuestionDAO.findTestQuestionByTclassAndTestQuestionType(classId, testQuestionType);

        if (testQuestion == null) {

            testQuestion = new TestQuestion();
            testQuestion.setTestQuestionType(testQuestionType);
            testQuestion.setTclassId(classId);
            testQuestionDAO.save(testQuestion);
        }

        for (Long questionId : questionIds) {

            QuestionBankTestQuestion questionBankTestQuestionFind = findByTestQuestionIdAndQuestionBankId(testQuestion.getId(), questionId);
            if (questionBankTestQuestionFind == null) {

                QuestionBankTestQuestion questionBankTestQuestion = new QuestionBankTestQuestion();
                questionBankTestQuestion.setQuestionBankId(questionId);
                questionBankTestQuestion.setTestQuestionId(testQuestion.getId());
                questionBankTestQuestionDAO.save(questionBankTestQuestion);
            }
        }
    }

    @Transactional
    @Override
    public void deleteQuestions(String type, Long classId, List<Long> questionIds) {

        String testQuestionType;

        if (type.equalsIgnoreCase("preTest")) {
            testQuestionType = "PreTest";
        } else if (type.equalsIgnoreCase("test") || type.equalsIgnoreCase("FinalTest")) {
            testQuestionType = "FinalTest";
        } else if (type.equalsIgnoreCase("preparation")) {
            testQuestionType = "Preparation";
        } else {
            throw new TrainingException(TrainingException.ErrorType.TestQuestionBadRequest);
        }

        TestQuestion testQuestion = testQuestionDAO.findTestQuestionByTclassAndTestQuestionType(classId, testQuestionType);

        if (testQuestion == null) {

            throw new TrainingException(TrainingException.ErrorType.TestQuestionNotFound);
        }

        questionBankTestQuestionDAO.deleteAllByTestQuestionIdAndQuestionBankId(testQuestion.getId(), questionIds);

    }

    @Override
    public boolean usedQuestion(Long questionBankId) {
        List<QuestionBankTestQuestion> optionalQuestionBank = questionBankTestQuestionDAO.findAllByQuestionBankId(questionBankId);
        return !optionalQuestionBank.isEmpty();
    }

    @Override
    public List<QuestionBankTestQuestion> getExamQuestions(Long sourceExamId) {
        return questionBankTestQuestionDAO.findAllByTestQuestionId(sourceExamId);
    }

    @Override
    public List<QuestionBankTestQuestion> findByTestQuestionId(Long testId) {
        return questionBankTestQuestionDAO.findByTestQuestionId(testId);
    }

    @Override
    public void save(QuestionBankTestQuestion questionBankTestQuestion) {
        questionBankTestQuestionDAO.save(questionBankTestQuestion);
    }

    @Override
    public QuestionBankTestQuestion findByTestQuestionIdAndQuestionBankId(Long testQuestionId, Long questionBankId) {
        Optional<QuestionBankTestQuestion> questionBankTestQuestion = questionBankTestQuestionDAO.findFirstByTestQuestionIdAndQuestionBankId(testQuestionId, questionBankId);
        return questionBankTestQuestion.orElse(null);
    }

}
