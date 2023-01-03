package com.nicico.training.repository;

import com.nicico.training.model.Evaluation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface EvaluationDAO extends JpaRepository<Evaluation, Long>, JpaSpecificationExecutor<Evaluation> {

    List<Evaluation> findEvaluationByClassIdAndEvaluatorIdAndEvaluatorTypeId(Long classId, Long evaluatorId, Long evaluatorTypeId);

    List<Evaluation> findEvaluationByClassIdAndEvaluatorIdAndEvaluatorTypeIdAndEvaluatedIdAndEvaluatedTypeId(Long classId, Long evaluatorId,
                                                                                                             Long evaluatorTypeId, Long EvaluatedId, Long EvaluatedTypeId);

    Evaluation findFirstByQuestionnaireTypeIdAndClassIdAndEvaluatorIdAndEvaluatorTypeIdAndEvaluatedIdAndEvaluatedTypeIdAndEvaluationLevelId(
            Long questionnaireTypeId, Long classId, Long evaluatorId, Long evaluatorTypeId, Long evaluatedId,
            Long evaluatedTypeId, Long evaluationLevelId);

    List<Evaluation> findByClassIdAndEvaluatorTypeIdAndEvaluatorIdAndEvaluationLevelIdAndQuestionnaireTypeId(Long classId,
                                                                                                             Long evaluatorTypeId,
                                                                                                             Long evaluatorId,
                                                                                                             Long evaluationLevelId,
                                                                                                             Long questionnaireTypeId);

    List<Evaluation> findEvaluationByClassIdAndEvaluatorTypeIdAndEvaluatedIdAndEvaluatedTypeId(Long classId, Long evaluatorTypeId, Long EvaluatedId, Long EvaluatedTypeId);

    List<Evaluation> findByClassIdAndEvaluatedIdAndEvaluationLevelIdAndQuestionnaireTypeId(Long classId, Long evaluatedId, Long evaluationLevelId, Long questionnaireTypeId);

    Evaluation findFirstByClassIdAndEvaluatedIdAndEvaluatedTypeIdAndEvaluatorTypeIdAndEvaluationLevelIdAndQuestionnaireTypeId(
            Long ClassId, Long EvaluatedId, Long EvaluatedTypeId, Long EvaluatorTypeId, Long EvaluationLevelId, Long QuestionnaireTypeId);

    List<Evaluation> findByClassIdAndEvaluatedIdAndEvaluatedTypeIdAndEvaluationLevelIdAndQuestionnaireTypeId(
            Long ClassId, Long EvaluatedId, Long EvaluatedTypeId, Long EvaluationLevelId, Long QuestionnaireTypeId);

    List<Evaluation> findByClassIdAndEvaluationLevelIdAndQuestionnaireTypeIdAndEvaluatedIdAndEvaluatedTypeIdAndStatus(Long ClassId,
                                                                                                                      Long EvaluationLevelId,
                                                                                                                      Long QuestionnaireTypeId,
                                                                                                                      Long EvaluatedId,
                                                                                                                      Long EvaluatedTypeId,
                                                                                                                      Boolean Status);

    List<Evaluation> findByEvaluatorIdAndEvaluatorTypeIdAndEvaluationLevelIdAndQuestionnaireTypeId(Long EvaluatorId,
                                                                                                   Long EvaluatorTypeId,
                                                                                                   Long EvaluationLevelId,
                                                                                                   Long QuestionnaireTypeId);

    List<Evaluation> findByClassIdAndEvaluationLevelIdAndQuestionnaireTypeId(Long ClassId, Long EvaluationLevelId, Long QuestionnaireTypeId);

    Optional<Evaluation> findTopByClassIdAndQuestionnaireTypeId(Long ClassId, Long typeId);

    @Query(value = "SELECT eval.* " +
            "FROM tbl_EVALUATION eval " +
            "         INNER JOIN TBL_TEACHER teacher ON eval.F_EVALUATOR_ID = teacher.ID " +
            "         INNER JOIN TBL_PERSONAL_INFO personal ON teacher.F_PERSONALITY = personal.ID " +
            "         INNER JOIN TBL_CLASS class ON eval.F_CLASS_ID = class.ID " +
            "WHERE personal.C_NATIONAL_CODE = ?1 " +
            "  AND eval.F_EVALUATOR_TYPE_ID = ?2 " +
            "  AND class.TEACHER_ONLINE_EVAL_STATUS = 1  AND eval.f_evaluation_level_id != 156 ", nativeQuery = true)
    List<Evaluation> getTeacherEvaluationsWithEvaluatorNationalCodeAndEvaluatorList(String evaluatorNationalCode, Long evaluatorTypeId);

    @Query(value = """
SELECT
    eval.*
FROM
         tbl_evaluation eval
    INNER JOIN tbl_class_student cs ON eval.f_evaluator_id = cs.id
    INNER JOIN tbl_student       student ON cs.student_id = student.id
    INNER JOIN tbl_class         class ON eval.f_class_id = class.id
    INNER JOIN tbl_parameter_value ON cs.scores_state_id = tbl_parameter_value.id
WHERE
        student.national_code = ?1\s
    AND eval.f_evaluator_type_id = ?2
    AND class.student_online_eval_status = 1
    AND cs.evaluation_status_reaction = 1
    AND eval.f_evaluation_level_id != 156
    AND eval.f_evaluation_level_id != 757
    AND tbl_parameter_value.c_code NOT IN ( 'DeleteStudentCauseOfPermittedAbcense', 'StudentCancellation', 'DeleteStudentCauseOfAffairRequest',
    'DeleteStudentCauseOfAbcense', 'ClassDelete' )
""", nativeQuery = true)
    List<Evaluation> getStudentEvaluationsWithEvaluatorNationalCodeAndEvaluatorList( String evaluatorNationalCode, Long evaluatorTypeId);

    Evaluation findFirstByQuestionnaireId(Long QuestionnaireId);


    @Query(value = """
       SELECT
        *
       FROM
           tbl_evaluation
           LEFT JOIN tbl_teacher ON tbl_evaluation.f_evaluator_id = tbl_teacher.id
           LEFT JOIN tbl_class_student ON tbl_evaluation.f_evaluator_id = tbl_class_student.id
           LEFT JOIN view_active_personnel ON tbl_evaluation.f_evaluator_id = view_active_personnel.id
           INNER JOIN tbl_student ON tbl_class_student.student_id = tbl_student.id
       WHERE
               tbl_evaluation.b_status = 0
           AND tbl_evaluation.f_evaluation_level_id = :levelId
           AND (
               CASE
                   WHEN tbl_evaluation.f_evaluator_type_id = 187 THEN
                       tbl_teacher.c_teacher_code
                   WHEN tbl_evaluation.f_evaluator_type_id = 188 THEN
                       tbl_student.national_code
                   ELSE
                       view_active_personnel.national_code
               END
           ) = :nationalCode
           and
           b_behavioral_to_online_status = 1
           """, nativeQuery = true)
    List<Evaluation> getBehavioralEvaluations(String nationalCode,Long levelId);




    @Query(value = """
     SELECT
         *
     FROM
         tbl_evaluation
         LEFT JOIN tbl_teacher ON tbl_evaluation.f_evaluator_id = tbl_teacher.id
         LEFT JOIN tbl_class_student ON tbl_evaluation.f_evaluator_id = tbl_class_student.id
         LEFT JOIN view_active_personnel ON tbl_evaluation.f_evaluator_id = view_active_personnel.id
         INNER JOIN tbl_student ON tbl_class_student.student_id = tbl_student.id
         INNER JOIN tbl_class ON tbl_evaluation.f_class_id = tbl_class.id
     WHERE
             tbl_evaluation.b_status = 0
         AND tbl_evaluation.f_evaluation_level_id = :levelId
         AND (
             CASE
                 WHEN tbl_evaluation.f_evaluator_type_id = 187 THEN
                     tbl_teacher.c_teacher_code
                 WHEN tbl_evaluation.f_evaluator_type_id = 188 THEN
                     tbl_student.national_code
                 ELSE
                     view_active_personnel.national_code
             END
         ) = :nationalCode
         and
         tbl_class.student_online_eval_execution_status = 1
           """, nativeQuery = true)
    List<Evaluation> getExecutionEvaluations(String nationalCode,Long levelId);


    @Query(value = """
            SELECT TCLASS.C_CODE            AS class_code,
                                TCLASS.C_TITLE_CLASS     AS class_title,
                                TCLASS.c_start_date     AS class_start_date,
                                TCLASS.c_end_date       AS class_end_date, 
                                ANSWER_TITLE.C_TITLE     AS answer_title,
                                STUDENT.FIRST_NAME       AS first_name,
                               STUDENT.LAST_NAME        AS last_name,
                                 STUDENT.NATIONAL_CODE    AS nationalCode,
                                COMPLEX.C_TITLE          AS complexTitle,
                              EVAL_QUESTION.C_QUESTION AS questionTitle,
                             TEACHERINFO.c_first_name_fa AS teacher_first,
                             TEACHERINFO.c_last_name_fa   AS teacher_last,
                             TEACHERCONTACT.c_mobile     AS teacher_mobile,
                           STUDENTCONTACT.c_mobile     AS student_mobile,
                               ORGANIZER.c_title_fa       AS organizer,
                                EVAL.F_QUESTIONNAIRE_ID,
                              QUESTIONNAIRE.C_TITLE,
                                                       tbl_parameter_value.c_title AS domain_title
                                                                                 
                        FROM TBL_EVALUATION EVAL
                                 LEFT JOIN TBL_EVALUATION_ANSWER ANSWER ON EVAL.ID = ANSWER.F_EVALUATION_ID
                                 INNER JOIN TBL_CLASS TCLASS ON TCLASS.ID = EVAL.F_CLASS_ID
                                 LEFT JOIN TBL_INSTITUTE ORGANIZER ON ORGANIZER.ID = TCLASS.f_institute_organizer
                                   LEFT JOIN TBL_TEACHER TEACHER on TEACHER.ID = TCLASS.f_teacher
                                 LEFT JOIN tbl_personal_info TEACHERINFO on TEACHERINFO.ID=TEACHER.f_personality
                                  LEFT JOIN tbl_contact_info  TEACHERCONTACT on TEACHERCONTACT.id=TEACHERINFO.f_contact_info
                                                                                                                             
                                                                                                                            
                                  INNER JOIN TBL_PARAMETER_VALUE ANSWER_TITLE ON ANSWER.F_ANSWER_ID = ANSWER_TITLE.ID
                                INNER JOIN TBL_CLASS_STUDENT CLASS_STUDENT ON EVAL.F_EVALUATOR_ID = CLASS_STUDENT.ID
                              LEFT JOIN TBL_PARAMETER_VALUE EVALUATORPARAMVALUE
                               ON EVALUATORPARAMVALUE.ID = EVAL.F_EVALUATOR_TYPE_ID --EVAL.F_EVALUATOR_TYPE_ID = 188
                             INNER JOIN TBL_STUDENT STUDENT ON CLASS_STUDENT.STUDENT_ID = STUDENT.ID
                             INNER JOIN tbl_contact_info STUDENTCONTACT ON STUDENTCONTACT.ID=STUDENT.f_contact_info
                              INNER JOIN TBL_QUESTIONNAIRE QUESTIONNAIRE ON EVAL.F_QUESTIONNAIRE_ID = QUESTIONNAIRE.ID
                           INNER JOIN TBL_QUESTIONNAIRE_QUESTION QUESTIONNAIRE_Q ON ANSWER.F_EVALUATION_QUESTION_ID = QUESTIONNAIRE_Q.ID
                            INNER JOIN TBL_EVALUATION_QUESTION EVAL_QUESTION ON QUESTIONNAIRE_Q.F_EVALUATION_QUESTION = EVAL_QUESTION.ID
                             LEFT JOIN VIEW_COMPLEX COMPLEX ON COMPLEX.ID = TCLASS.COMPLEX_ID
                                 LEFT JOIN tbl_parameter_value ON eval_question.f_domain_id = tbl_parameter_value.id
                            
                        WHERE EVALUATORPARAMVALUE.C_CODE = '32'
                          AND (EVAL_QUESTION.ID IN (:questionIds)) 
                          AND (:classIds is null or EVAL.F_CLASS_ID IN (:classIds))
                          AND (:startDate1 is null or TCLASS.c_start_date>=:startDate1)
                          AND (:startDate2 is null or TCLASS.c_start_date<=:startDate2)
                          AND (:endDate1 is null or TCLASS.c_end_date>=:endDate1)
                          AND (:endDate2 is null or TCLASS.c_end_date<=:endDate2)
                        ORDER BY EVAL_QUESTION.ID, nationalCode
            """, nativeQuery = true)
    List<Object> getAnsweredQuestionsDetails(List<Object> questionIds, List<Object> classIds,
                                             String startDate1, String startDate2,
                                             String endDate1, String endDate2);
}
