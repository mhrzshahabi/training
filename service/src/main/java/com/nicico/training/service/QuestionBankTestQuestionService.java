package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.QuestionBankTestQuestionDTO;
import com.nicico.training.dto.TestQuestionDTO;
import com.nicico.training.iservice.IQuestionBankTestQuestionService;
import com.nicico.training.iservice.ITestQuestionService;
import com.nicico.training.model.Post;
import com.nicico.training.model.PostGroup;
import com.nicico.training.model.QuestionBankTestQuestion;
import com.nicico.training.model.TestQuestion;
import com.nicico.training.repository.QuestionBankTestQuestionDAO;
import com.nicico.training.repository.TestQuestionDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@RequiredArgsConstructor
@Service
public class QuestionBankTestQuestionService implements IQuestionBankTestQuestionService {

    private final ModelMapper modelMapper;
    private final QuestionBankTestQuestionDAO questionBankTestQuestionDAO;
    private final TestQuestionDAO testQuestionDAO;


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

    @Transactional
    @Override
    public void addQuestions(String type, Long classId, List<Long> questionIds) {

        boolean isPreTestQuestion = false;

        if (type.equals("preTest")) {
            isPreTestQuestion = true;
        } else if (type.equals("test")) {
            isPreTestQuestion = false;
        } else {
            throw new TrainingException(TrainingException.ErrorType.TestQuestionBadRequest);
        }

        TestQuestion testQuestion = testQuestionDAO.findTestQuestionByTclassAndPreTestQuestion(classId, isPreTestQuestion);

        if (testQuestion == null) {

            testQuestion=new TestQuestion();
            testQuestion.setPreTestQuestion(isPreTestQuestion);
            testQuestion.setTclassId(classId);

            testQuestionDAO.save(testQuestion);
        }

        for (Long questionId:questionIds) {
            QuestionBankTestQuestion questionBankTestQuestion=new QuestionBankTestQuestion();

            questionBankTestQuestion.setQuestionBankId(questionId);
            questionBankTestQuestion.setTestQuestionId(testQuestion.getId());

            questionBankTestQuestionDAO.save(questionBankTestQuestion);
        }

    }

    @Transactional
    @Override
    public void deleteQuestions(String type, Long classId, List<Long> questionIds) {

        boolean isPreTestQuestion = false;

        if (type.equals("preTest")) {
            isPreTestQuestion = true;
        } else if (type.equals("test")) {
            isPreTestQuestion = false;
        } else {
            throw new TrainingException(TrainingException.ErrorType.TestQuestionBadRequest);
        }

        TestQuestion testQuestion = testQuestionDAO.findTestQuestionByTclassAndPreTestQuestion(classId, isPreTestQuestion);

        if (testQuestion == null) {

            throw new TrainingException(TrainingException.ErrorType.TestQuestionNotFound);
        }

        questionBankTestQuestionDAO.deleteAllByTestQuestionIdAndQuestionBankId(testQuestion.getId(),questionIds);

    }
}
