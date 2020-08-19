package com.nicico.training.iservice;


import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.*;

import javax.servlet.http.HttpServletResponse;
import java.util.Set;

public interface ITestQuestionService {

    TestQuestionDTO.fullInfo get(Long id);

    SearchDTO.SearchRs<TestQuestionDTO.Info> search(SearchDTO.SearchRq request);

    Set<QuestionBankDTO.Exam> getAllQuestionsByTestQuestionId(Long testQuestionId);

    void delete (Long id);

    TestQuestionDTO.Info create(TestQuestionDTO.Create request);

    TestQuestionDTO.Info update(Long id, TestQuestionDTO.Update request, HttpServletResponse response);

    void print (HttpServletResponse response ,String type, String fileName, Long testQuestionId, String receiveParams) throws Exception;
}
