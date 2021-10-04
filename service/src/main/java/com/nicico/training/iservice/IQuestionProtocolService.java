package com.nicico.training.iservice;


import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.QuestionBankDTO;
import com.nicico.training.dto.TestQuestionDTO;
import com.nicico.training.model.QuestionProtocol;
import com.nicico.training.model.TestQuestion;
import dto.exam.ImportedQuestionProtocol;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Set;

public interface IQuestionProtocolService {

    void saveQuestionProtocol(Long sourceExamId, List<ImportedQuestionProtocol> questionProtocols);

    List<QuestionProtocol> findAllByExamId(Long id);

}
