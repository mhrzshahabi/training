package com.nicico.training.iservice;


import com.nicico.training.model.QuestionProtocol;
import dto.exam.ImportedQuestionProtocol;

import java.util.List;
import java.util.Optional;

public interface IQuestionProtocolService {

    void saveQuestionProtocol(Long sourceExamId, List<ImportedQuestionProtocol> questionProtocols);

    List<QuestionProtocol> findAllByExamId(Long id);
    Optional<QuestionProtocol> findOneByExamIdAndQuestionId(Long id, Long questionId);

    List<QuestionProtocol> findAllByQuestionIds(List<Long> questionIds);

    List<QuestionProtocol> saveAll(List<QuestionProtocol> questionProtocols);


}
