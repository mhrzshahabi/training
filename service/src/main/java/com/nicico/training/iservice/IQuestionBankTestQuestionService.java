package com.nicico.training.iservice;


import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.QuestionBankTestQuestionDTO;
import com.nicico.training.dto.TestQuestionDTO;

import java.util.List;

public interface IQuestionBankTestQuestionService {

    SearchDTO.SearchRs<QuestionBankTestQuestionDTO.Info> search(SearchDTO.SearchRq request);

    SearchDTO.SearchRs<QuestionBankTestQuestionDTO.InfoUsed> search1(SearchDTO.SearchRq request);

    void addQuestions(String type, Long classId, List<Long> questionIds);

    void deleteQuestions(String type, Long classId, List<Long> questionIds);
}
