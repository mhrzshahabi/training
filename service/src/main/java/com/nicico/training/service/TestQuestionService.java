package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.QuestionBankDTO;
import com.nicico.training.dto.TestQuestionDTO;
import com.nicico.training.iservice.ITestQuestionService;
import com.nicico.training.model.QuestionBank;
import com.nicico.training.model.TestQuestion;
import com.nicico.training.repository.TestQuestionDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashSet;
import java.util.Set;

@RequiredArgsConstructor
@Service
public class TestQuestionService implements ITestQuestionService {

    private final ModelMapper modelMapper;
    private final TestQuestionDAO testQuestionDAO;


    @Transactional
    @Override
    public SearchDTO.SearchRs<TestQuestionDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(testQuestionDAO, request, term -> modelMapper.map(term, TestQuestionDTO.Info.class));
    }

    @Transactional
    @Override
    public Set<QuestionBankDTO.Questions> getAllQuestionsByTestQuestionId(Long testQuestionId){
        final TestQuestion model = testQuestionDAO.findById(testQuestionId).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.QuestionBankNotFound));
        Set<QuestionBank> result = new HashSet<>();
        model.getQuestionBankTestQuestionList().forEach(q -> result.add(q.getQuestionBank()));
        return modelMapper.map(result, new TypeToken<Set<QuestionBankDTO.Questions>>(){}.getType());
    }
}
