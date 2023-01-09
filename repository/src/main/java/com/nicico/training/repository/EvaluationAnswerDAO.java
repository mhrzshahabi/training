package com.nicico.training.repository;

import com.nicico.training.model.EvaluationAnswer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface EvaluationAnswerDAO extends JpaRepository<EvaluationAnswer, Long>, JpaSpecificationExecutor<EvaluationAnswer> {

    List<EvaluationAnswer> findByEvaluationId(Long eId);

    @Query(value = "SELECT * FROM tbl_evaluation_answer where f_evaluation_id =:eId And f_answer_id is NOT null", nativeQuery = true)
    List<EvaluationAnswer> findByEvaluationIdAndAnswerId(Long eId);

    @Query(value = """
            SELECT
                tbl_course.c_code              AS course_code,
                tbl_class.c_code               AS class_code,
                tbl_student.first_name         AS teacher_first_name,
                tbl_student.last_name          AS teacher_last_name,
                tbl_student.national_code      AS teacher_national_code,
                tbl_department.c_omor_title    AS evaluation_affair,
                tbl_post.c_title_fa            AS post_title,
                tbl_post.c_code                AS post_code,
                tbl_student.emp_no             AS personnel_no2,
                tbl_parameter_value.c_title    AS student_acceptance_status,
                tbl_class_student.score        AS score,
                tbl_evaluation.id              AS evaluation_id,
                eval.avg                       AS evaluation_average,
                tbl_parameter_value1.c_title   AS evaluation_field
            FROM
                tbl_class_student
                INNER JOIN tbl_class ON tbl_class_student.class_id = tbl_class.id
                INNER JOIN tbl_course ON tbl_class.f_course = tbl_course.id
                INNER JOIN tbl_student ON tbl_class_student.student_id = tbl_student.id
                LEFT JOIN tbl_post ON tbl_student.f_post_id = tbl_post.id
                LEFT JOIN tbl_department ON tbl_student.f_department_id = tbl_department.id
                INNER JOIN tbl_parameter_value ON tbl_class_student.scores_state_id = tbl_parameter_value.id
                LEFT JOIN tbl_evaluation ON tbl_class_student.id = tbl_evaluation.f_evaluator_id
                                            AND tbl_class.id = tbl_evaluation.f_class_id
                LEFT JOIN (
                    SELECT
                        f_evaluation_id,
                        CAST(SUM(c_value * f_weight1) / SUM(f_weight1) AS DECIMAL(10, 2)) AS avg,
                        f_domain_id
                    FROM
                        (
                            SELECT
                                tbl_evaluation_answer.f_evaluation_id,
                                tbl_parameter_value.c_value,
                                tbl_questionnaire_question.f_weight AS f_weight1,
                                tbl_evaluation_question.f_domain_id
                            FROM
                                tbl_evaluation_answer
                                INNER JOIN tbl_questionnaire_question ON tbl_evaluation_answer.f_evaluation_question_id = tbl_questionnaire_question.id
                                INNER JOIN tbl_parameter_value ON tbl_evaluation_answer.f_answer_id = tbl_parameter_value.id
                                INNER JOIN tbl_evaluation_question ON tbl_questionnaire_question.f_evaluation_question = tbl_evaluation_question.id
                            WHERE
                                tbl_evaluation_question.f_domain_id IN (:domainList) OR :domainListNullCheck = 1
                        )
                    GROUP BY
                        f_evaluation_id,
                        f_domain_id
                ) eval ON tbl_evaluation.id = eval.f_evaluation_id
                INNER JOIN tbl_parameter_value tbl_parameter_value1 ON eval.f_domain_id = tbl_parameter_value1.id
            WHERE
                tbl_class.c_code IN (:classCodeList) OR :classCodeNullCheck = 1
            ORDER BY
                class_code
            """, nativeQuery = true)
    List<?> getEvaluationIndexByField(@Param("domainList") List<Long> evaluationAreaIds,
                                      @Param("domainListNullCheck") int evaluationListNullCheck,
                                      @Param("classCodeList") List<String> classCodes,
                                      @Param("classCodeNullCheck") int classCodeNullCheck);
}
