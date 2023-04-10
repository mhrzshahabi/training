package com.nicico.training.iservice;


import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.training.dto.QuestionnaireQuestionDTO;
import com.nicico.training.model.QuestionnaireQuestion;

import java.util.List;

public interface IQuestionnaireQuestionService {

    List<QuestionnaireQuestionDTO.Info> list();

    QuestionnaireQuestionDTO.Info checkAndCreate(QuestionnaireQuestionDTO.Create create);

    QuestionnaireQuestionDTO.Info update(Long id, QuestionnaireQuestionDTO.Update update);

    QuestionnaireQuestionDTO.Info delete(Long id);

    TotalResponse<QuestionnaireQuestionDTO.Info> search(NICICOCriteria nicicoCriteria);


    List<QuestionnaireQuestion> getEvaluationQuestion(Long l);

    QuestionnaireQuestion getById(Long QuestionnaireQuestionId);

    List<?> getQuestionsByQuestionnaireId(Long questionnaireId);

}
