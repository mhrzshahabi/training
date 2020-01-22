package com.nicico.training.repository;

import com.nicico.training.model.EvaluationQuestion;
import com.nicico.training.model.QuestionnaireQuestion;
import com.nicico.training.model.enums.EEnabled;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface QuestionnaireQuestionDAO extends BaseDAO<QuestionnaireQuestion, Long> {

    ////    List<QuestionnaireQuestion> findQuestionnaireQuestionByQuestionnaireEEnabledAndEvaluationQuestionDomainId(EEnabled eEnabled, Long domainId);
    List<QuestionnaireQuestion> findQuestionnaireQuestionByQuestionnaireVersionAndEvaluationQuestionDomainId(Integer version, Long domainId);

}
