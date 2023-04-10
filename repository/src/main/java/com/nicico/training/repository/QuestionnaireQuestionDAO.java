package com.nicico.training.repository;

import com.nicico.training.model.QuestionnaireQuestion;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface QuestionnaireQuestionDAO extends BaseDAO<QuestionnaireQuestion, Long> {

    @Query(value = "select Tbl_Questionnaire_Question.* from Tbl_Questionnaire_Question  join Tbl_Questionnaire on  Tbl_Questionnaire_Question.F_Questionnaire = Tbl_Questionnaire.Id join Tbl_Evaluation_Question on Tbl_Questionnaire_Question.F_Evaluation_Question = Tbl_Evaluation_Question.Id  where (Tbl_Questionnaire.E_Enabled = 494) and (Tbl_Evaluation_Question.f_domain_id = :domainId)",nativeQuery = true)
    List<QuestionnaireQuestion> findActiveQuestionnaries(Long domainId);


    QuestionnaireQuestion findByQuestionnaireIdAndEvaluationQuestionId(Long questionnaireId,Long evaluationQuestionId);

    @Query(value = """
            SELECT
                tbl_evaluation_question.c_question,
                tbl_parameter_value.c_title
            FROM
                tbl_questionnaire_question
                INNER JOIN tbl_evaluation_question ON tbl_questionnaire_question.f_evaluation_question = tbl_evaluation_question.id
                INNER JOIN tbl_parameter_value ON tbl_evaluation_question.f_domain_id = tbl_parameter_value.id
            WHERE
                tbl_questionnaire_question.f_questionnaire = :questionnaire_id
            """, nativeQuery = true)
    List<?> getQuestionsByQuestionnaireId(@Param("questionnaire_id") Long questionnaireId);
}
