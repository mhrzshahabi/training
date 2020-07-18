package com.nicico.training.repository;

import com.nicico.training.model.EvaluationQuestion;
import com.nicico.training.model.QuestionnaireQuestion;
import com.nicico.training.model.enums.EEnabled;
import org.springframework.stereotype.Repository;
import org.springframework.data.jpa.repository.Query;

import java.util.ArrayList;
import java.util.List;

import java.util.List;

@Repository
public interface QuestionnaireQuestionDAO extends BaseDAO<QuestionnaireQuestion, Long> {

    List<QuestionnaireQuestion> findQuestionnaireQuestionByQuestionnaireVersionAndEvaluationQuestionDomainId(Integer version, Long domainId);

//    List<QuestionnaireQuestion> findQuestionnaireQuestionByQuestionnaireeEnabledAndEvaluationQuestionDomainId(Long eenabled, Long domainId);


    @Query(value = "select Tbl_Questionnaire_Question.* from Tbl_Questionnaire_Question  join Tbl_Questionnaire on  Tbl_Questionnaire_Question.F_Questionnaire = Tbl_Questionnaire.Id join Tbl_Evaluation_Question on Tbl_Questionnaire_Question.F_Evaluation_Question = Tbl_Evaluation_Question.Id  where (Tbl_Questionnaire.E_Enabled = 1) and (Tbl_Evaluation_Question.f_domain_id = 53)", nativeQuery = true)
    ArrayList<QuestionnaireQuestion> findEvaluationTeacherQuestions();

    List<QuestionnaireQuestion>findByEvaluationQuestionDomainAndEEnabled(int domainId , int enabled);

}
