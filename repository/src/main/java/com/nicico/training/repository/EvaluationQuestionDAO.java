package com.nicico.training.repository;

import com.nicico.training.model.EvaluationQuestion;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

@Repository
public interface EvaluationQuestionDAO extends BaseDAO<EvaluationQuestion, Long> {

    @Query(value = "select count(id) from tbl_questionnaire_question where f_evaluation_question=:evaluationQuestionId",nativeQuery = true)
    Integer usedCount(Long evaluationQuestionId);
}
