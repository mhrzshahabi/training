package com.nicico.training.iservice;


import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.*;
import java.util.Set;

public interface ITestQuestionService {

    SearchDTO.SearchRs<TestQuestionDTO.Info> search(SearchDTO.SearchRq request);

    Set<QuestionBankDTO.Questions> getAllQuestionsByTestQuestionId(Long testQuestionId);
}
