package com.nicico.training.repository;

import com.nicico.training.model.Evaluation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
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
     AND (class.student_online_eval_status = 1  or cs.els_status = 1)
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
         LEFT JOIN tbl_class ON tbl_evaluation.f_class_id = tbl_class.id
             INNER JOIN tbl_parameter_value ON tbl_class_student.scores_state_id = tbl_parameter_value.id

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
          AND tbl_parameter_value.c_code NOT IN ( 'DeleteStudentCauseOfPermittedAbcense', 'StudentCancellation', 'DeleteStudentCauseOfAffairRequest',
    'DeleteStudentCauseOfAbcense', 'ClassDelete' )
           """, nativeQuery = true)
    List<Evaluation> getExecutionEvaluations(String nationalCode,Long levelId);


    @Query(value = """
            SELECT
                tclass.c_code                 AS class_code,
                tclass.c_title_class          AS class_title,
                tclass.c_start_date           AS class_start_date,
                tclass.c_end_date             AS class_end_date,
                tbl_category.id               AS category_id,
                tbl_category.c_title_fa       AS category_title,
                tbl_sub_category.id           AS sub_category_id,
                tbl_sub_category.c_title_fa   AS sub_category_title,
                answer_title.c_title          AS answer_title,
                student.first_name            AS first_name,
                student.last_name             AS last_name,
                student.national_code         AS nationalcode,
                complex.c_title               AS complextitle,
                eval_question.c_question      AS questiontitle,
                teacherinfo.c_first_name_fa   AS teacher_first,
                teacherinfo.c_last_name_fa    AS teacher_last,
                teachercontact.c_mobile       AS teacher_mobile,
                studentcontact.c_mobile       AS student_mobile,
                organizer.c_title_fa          AS organizer,
                eval.f_questionnaire_id,
                questionnaire.c_title,
                tbl_parameter_value.c_title   AS domain_title
            FROM
                tbl_evaluation               eval
                LEFT JOIN tbl_evaluation_answer        answer ON eval.id = answer.f_evaluation_id
                INNER JOIN tbl_class                    tclass ON tclass.id = eval.f_class_id
                LEFT JOIN tbl_institute                organizer ON organizer.id = tclass.f_institute_organizer
                LEFT JOIN tbl_teacher                  teacher ON teacher.id = tclass.f_teacher
                LEFT JOIN tbl_personal_info            teacherinfo ON teacherinfo.id = teacher.f_personality
                LEFT JOIN tbl_contact_info             teachercontact ON teachercontact.id = teacherinfo.f_contact_info
                INNER JOIN tbl_parameter_value          answer_title ON answer.f_answer_id = answer_title.id
                INNER JOIN tbl_class_student            class_student ON eval.f_evaluator_id = class_student.id
                LEFT JOIN tbl_parameter_value          evaluatorparamvalue ON evaluatorparamvalue.id = eval.f_evaluator_type_id
                INNER JOIN tbl_student                  student ON class_student.student_id = student.id
                INNER JOIN tbl_contact_info             studentcontact ON studentcontact.id = student.f_contact_info
                INNER JOIN tbl_questionnaire            questionnaire ON eval.f_questionnaire_id = questionnaire.id
                INNER JOIN tbl_questionnaire_question   questionnaire_q ON answer.f_evaluation_question_id = questionnaire_q.id
                INNER JOIN tbl_evaluation_question      eval_question ON questionnaire_q.f_evaluation_question = eval_question.id
                LEFT JOIN view_complex                 complex ON complex.id = tclass.complex_id
                LEFT JOIN tbl_parameter_value ON eval_question.f_domain_id = tbl_parameter_value.id
                INNER JOIN tbl_course ON tclass.f_course = tbl_course.id
                INNER JOIN tbl_category ON tbl_course.category_id = tbl_category.id
                INNER JOIN tbl_sub_category ON tbl_course.subcategory_id = tbl_sub_category.id
            WHERE
                evaluatorparamvalue.c_code = '32'
                AND eval_question.id IN (:questionIds)
                AND ( :classIds IS NULL OR eval.f_class_id IN (:classIds) )
                AND ( :startDate1 IS NULL OR tclass.c_start_date >= :startDate1 )
                AND ( :startDate2 IS NULL OR tclass.c_start_date <= :startDate2 )
                AND ( :endDate1 IS NULL OR tclass.c_end_date >= :endDate1 )
                AND ( :endDate2 IS NULL OR tclass.c_end_date <= :endDate2 )
                AND ( :catIdNullCheck = 1 OR tbl_category.id IN (:catIds) )
                AND ( :subCatIdNullCheck = 1 OR tbl_sub_category.id IN (:subCatIds) )
            ORDER BY
                eval_question.id,
                nationalcode
            """, nativeQuery = true)
    List<Object> getAnsweredQuestionsDetails(@Param("questionIds") List<Object> questionIds,
                                             @Param("classIds") List<Object> classIds,
                                             @Param("startDate1") String startDate1,
                                             @Param("startDate2") String startDate2,
                                             @Param("endDate1") String endDate1,
                                             @Param("endDate2") String endDate2,
                                             @Param("catIds") List<Object> catIds,
                                             @Param("catIdNullCheck") int catIdNullCheck,
                                             @Param("subCatIds") List<Object> subCatIds,
                                             @Param("subCatIdNullCheck") int subCatIdNullCheck);


    @Query(value = """
            SELECT DISTINCT
                tbl_evaluation.f_questionnaire_id
            FROM
                tbl_evaluation
                INNER JOIN tbl_parameter_value ON tbl_evaluation.f_evaluation_level_id = tbl_parameter_value.id
            WHERE
                tbl_parameter_value.c_code = 'Behavioral'
                AND tbl_evaluation.f_class_id = :classid            
            """, nativeQuery = true)
    List<Long> getBehavioralEvaluationQuestionnairesCount(@Param("classid") long classId);
}
