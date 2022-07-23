package com.nicico.training.repository;

import com.nicico.training.model.QuestionnaireQuestion;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface QuestionnaireQuestionDAO extends BaseDAO<QuestionnaireQuestion, Long> {

    @Query(value = "select Tbl_Questionnaire_Question.* from Tbl_Questionnaire_Question  join Tbl_Questionnaire on  Tbl_Questionnaire_Question.F_Questionnaire = Tbl_Questionnaire.Id join Tbl_Evaluation_Question on Tbl_Questionnaire_Question.F_Evaluation_Question = Tbl_Evaluation_Question.Id  where (Tbl_Questionnaire.E_Enabled = 494) and (Tbl_Evaluation_Question.f_domain_id = :domainId)",nativeQuery = true)
    List<QuestionnaireQuestion> findActiveQuestionnaries(Long domainId);


    QuestionnaireQuestion findByQuestionnaireIdAndEvaluationQuestionId(Long questionnaireId,Long evaluationQuestionId);
}
