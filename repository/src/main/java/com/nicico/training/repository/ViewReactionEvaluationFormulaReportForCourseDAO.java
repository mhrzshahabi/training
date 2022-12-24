package com.nicico.training.repository;

import com.nicico.training.model.ViewReactionEvaluationFormulaReportForCourse;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ViewReactionEvaluationFormulaReportForCourseDAO extends BaseDAO<ViewReactionEvaluationFormulaReportForCourse, Long> {

    @Query(value = """
            SELECT
                           ROWNUM AS id,
                           n."CLASS_CODE",
                           n."CLASS_STATUS",
                           n."CLASS_END_DATE",
                           n."CLASS_START_DATE",
                           n."COURSE_CODE",
                           n."COURSE_TITLEFA",
                           n."SUB_CATEGORY_TITLEFA",
                           n."SUB_CATEGORY_ID",
                           n."CATEGORY_TITLEFA",
                           n."CLASS_ID",
                           n."COURSE_ID",
                           n."COMPLEX",
                           n."IS_PERSONNEL",
                           n."TEACHER_NATIONAL_CODE",
                           n."TEACHER",
                           n."FINAL_TEACHER",
                           n."REACTIONE_EVALUATION_GRADE",
                           n."TEACHER_GRADE_TO_CLASS",
                           n."TRAINING_GRADE_TO_TEACHER",
                           n."JAVAB_DADE",
                           n."TOTAL_STD",
                           n."PERCENT_REACTION"
                           --n."MIANGIN_JAVAB_DADE"
                       FROM
                           (
                               SELECT DISTINCT
                                   f.class_code,
                                   f.class_status,
                                   f.class_end_date,
                                   f.class_start_date,
                                   f.course_code,
                                   f.course_titlefa,
                                   f.sub_category_titlefa,
                                   f.sub_category_id,
                                   f.category_titlefa,
                                   f.class_id,
                                   f.course_id,
                                   f.complex,
                                   f.is_personnel,
                                   f.teacher_national_code,
                                   f.teacher,
                                   f.final_teacher,
                                   f.reactione_evaluation_grade,
                                   f.teacher_grade_to_class,
                                   f.training_grade_to_teacher,
                                   f.javab_dade,
                                   f.total_std,
                                   f.percent_reaction
                       --            f.miangin_javab_dade
                                  FROM
                                      (
                                          SELECT
                                              ROWNUM AS id,
                                              z.class_code                  AS class_code,
                                              CASE
                                                  WHEN z.status = 1 THEN
                                                      ' برنامه ریزی'
                                                  WHEN z.status = 2 THEN
                                                      ' در حال اجرا'
                                                  WHEN z.status = 3 THEN
                                                      ' پایان یافته'
                                                  WHEN z.status = 4 THEN
                                                      ' لغو شده'
                                                  WHEN z.status = 5 THEN
                                                      'اختتام'
                                              END AS class_status,
                                              z.class_start_date            AS class_start_date,
                                              z.class_end_date              AS class_end_date,
                                              z.course_code                 AS course_code,
                                              z.course_titlefa              AS course_titlefa,
                                              z.category_titlefa            AS category_titlefa,
                                              z.sub_category_titlefa        AS sub_category_titlefa,
                                              z.sub_category_id             AS sub_category_id,
                                              z.class_id                    AS class_id,
                                              z.course_id                   AS course_id,
                                              z.class_complex               AS complex,
                                              z.is_personnel                AS is_personnel,
                                              z.teacher_national_code       AS teacher_national_code,
                                              z.teacher                     AS teacher,
                                              concat(concat(tbl_student.first_name, ' '), tbl_student.last_name) AS student,
                                              tbl_student.emp_no            AS student_emp_number,
                                              tbl_student.personnel_no      AS student_per_number,
                                              tbl_department.c_hoze_title   AS student_hoze,
                                              tbl_department.c_omor_title   AS student_omor,
                                              tbl_post.c_code               AS student_post_code,
                                              tbl_post.c_title_fa           AS student_post_title,
                                              CAST(tbl_evaluation_analysis.c_teacher_grade AS DECIMAL(10, 2)) AS final_teacher,
                                              CAST(tbl_evaluation_analysis.c_reaction_grade AS DECIMAL(10, 2)) AS reactione_evaluation_grade,
                                              modares.miangin               AS teacher_grade_to_class,
                                              mianginmasol.miangin          AS training_grade_to_teacher,
                                              clsstu.total_std              AS total_std,
                                              CASE
                                                  WHEN darsadjavab.javabdade IS NULL THEN
                                                      0
                                                  ELSE
                                                      darsadjavab.javabdade
                                              END AS javab_dade,
                                              percent_reaction
                                          FROM
                                              (
                                                                                                                   SELECT
                  class_id,
                  student_id,
                  total_std
              FROM
              
                       (
                      SELECT
                          tbl_class_student.class_id,
                          tbl_class_student.student_id,
                          COUNT(*)
                          OVER(PARTITION BY tbl_class_student.class_id) total_std,
                          tbl_class_student.scores_state_id
                      FROM
                          tbl_class_student
                              INNER JOIN tbl_parameter_value ON scores_state_id = tbl_parameter_value.id
              
                          WHERE
                             tbl_parameter_value.c_code not IN ('DeleteStudentCauseOfPermittedAbcense','StudentCancellation','DeleteStudentCauseOfAffairRequest','DeleteStudentCauseOfAbcense','ClassDelete')
                  )
              WHERE
                   
                   total_std > 0
                                              ) clsstu
                                              INNER JOIN (
                                                  SELECT
                                                      ROWNUM AS id,
                                                      tclass.id                           AS class_id,
                                                      tclass.c_code                       AS class_code,
                                                      tclass.c_status                     AS status,
                                                      tclass.c_start_date                 AS class_start_date,
                                                      tclass.c_end_date                   AS class_end_date,
                                                      course.id                           AS course_id,
                                                      course.c_code                       AS course_code,
                                                      course.c_title_fa                   AS course_titlefa,
                                                      cat.c_title_fa                      AS category_titlefa,
                                                      sucat.c_title_fa                    AS sub_category_titlefa,
                                                      sucat.id                            AS sub_category_id,
                                                      concat(concat(tbl_personal_info.c_first_name_fa, ' '), tbl_personal_info.c_last_name_fa) AS teacher,
                                                      tbl_personal_info.c_first_name_fa   AS teacher_name,
                                                      tbl_personal_info.c_last_name_fa    AS teacher_family,
                                                      tbl_personal_info.c_national_code   AS teacher_national_code,
                                                      view_complex.c_title                AS class_complex,
                                                      CASE
                                                          WHEN tbl_teacher.b_personnel = 0 THEN
                                                              'برون سازمانی'
                                                          WHEN tbl_teacher.b_personnel = 1 THEN
                                                              'درون سازمانی'
                                                      END AS is_personnel
                                                  FROM
                                                      tbl_class          tclass
                                                      INNER JOIN tbl_course         course ON tclass.f_course = course.id
                                                      INNER JOIN tbl_category       cat ON cat.id = course.category_id
                                                      INNER JOIN tbl_sub_category   sucat ON sucat.id = course.subcategory_id
                                                      INNER JOIN tbl_teacher ON tclass.f_teacher = tbl_teacher.id
                                                      INNER JOIN tbl_personal_info ON tbl_teacher.f_personality = tbl_personal_info.id
                                                      LEFT JOIN view_complex ON tclass.complex_id = view_complex.id
                                                  WHERE
                                                      tclass.c_status != '1'
                                                      AND tclass.c_start_date >= :start
                                                      AND tclass.c_end_date <= :end
                                              ) z ON clsstu.class_id = z.class_id
                                              LEFT JOIN tbl_student ON clsstu.student_id = tbl_student.id
                                              LEFT JOIN tbl_department ON tbl_student.f_department_id = tbl_department.id
                                              LEFT JOIN tbl_post ON tbl_student.f_post_id = tbl_post.id
                                              LEFT JOIN tbl_evaluation_analysis ON clsstu.class_id = tbl_evaluation_analysis.f_tclass
                                              LEFT JOIN tbl_evaluation   f ON z.class_id = f.f_class_id
                                                                            AND f.f_evaluator_type_id = '187'
                                              LEFT JOIN (
                                                  SELECT
                                                      CAST(SUM(rate * w) / SUM(w) AS DECIMAL(8, 2)) AS miangin,
                                                      idmodares
                                                  FROM
                                                      (
                                                          SELECT
                                                              tbl_questionnaire_question.f_weight     AS w,
                                                              tbl_parameter_value.c_value             AS rate,
                                                              tbl_evaluation_answer.f_evaluation_id   AS idmodares
                                                          FROM
                                                              tbl_evaluation_answer
                                                              INNER JOIN tbl_questionnaire_question ON tbl_evaluation_answer.f_evaluation_question_id = tbl_questionnaire_question
                                                              .id
                                                              INNER JOIN tbl_parameter_value ON tbl_evaluation_answer.f_answer_id = tbl_parameter_value.id
                                                      )
                                                  GROUP BY
                                                      idmodares
                                              ) modares ON f.id = modares.idmodares
                                              LEFT JOIN tbl_evaluation   masol ON z.class_id = masol.f_class_id
                                                                                AND masol.f_evaluator_type_id = '454'
                                              LEFT JOIN (
                                                  SELECT
                                                      CAST(SUM(rate * w) / SUM(w) AS DECIMAL(8, 2)) AS miangin,
                                                      idmodares
                                                  FROM
     
     
                                             (
                                                 SELECT
                                                     tbl_questionnaire_question.f_weight     AS w,
                                                     tbl_parameter_value.c_value             AS rate,
                                                     tbl_evaluation_answer.f_evaluation_id   AS idmodares
                                                 FROM
                                                     tbl_evaluation_answer
                                                     INNER JOIN tbl_questionnaire_question ON tbl_evaluation_answer.f_evaluation_question_id = tbl_questionnaire_question
                                                     .id
                                                     INNER JOIN tbl_parameter_value ON tbl_evaluation_answer.f_answer_id = tbl_parameter_value.id
                                             )
                                         GROUP BY
                                             idmodares
                                     ) mianginmasol ON masol.id = mianginmasol.idmodares
                                     LEFT JOIN (
        SELECT  COUNT(*) AS javabdade,
                                                                               tbl_evaluation.f_class_id AS classid
                                                                           FROM
                                                                               tbl_evaluation
                                                                            LEFT JOIN tbl_class_student ON tbl_evaluation.f_evaluator_id = tbl_class_student.id
                                                                                            INNER JOIN tbl_parameter_value ON tbl_class_student.scores_state_id = tbl_parameter_value.id
     
                                       WHERE
                                       tbl_class_student.id is not null and
                                                                               tbl_evaluation.b_status = 1
                                                                               AND tbl_evaluation.f_evaluator_type_id = 188
                                                                                and f_evaluation_level_id =154
                                                                                and
                                                                                               tbl_parameter_value.c_code not IN ('DeleteStudentCauseOfPermittedAbcense','StudentCancellation','DeleteStudentCauseOfAffairRequest','DeleteStudentCauseOfAbcense','ClassDelete')
     
                                                                            
                                                                           GROUP BY
                                                                               tbl_evaluation.f_class_id,
                                                                               tbl_evaluation.b_status,
                                                                               tbl_evaluation.f_evaluator_type_id
                                     ) darsadjavab ON z.class_id = darsadjavab.classid
                                     LEFT JOIN (
            SELECT
                                             class_id AS class_id,
                                             CASE
                                                 WHEN all_reaction_eval = 0 THEN
                                                     0
                                                 ELSE
                                                     CAST((filled_reaction_eval / all_reaction_eval) * 100 AS DECIMAL(6, 2))
                                             END AS percent_reaction
                                         FROM
                                             (
                                                 SELECT DISTINCT
                                                     cs.class_id AS class_id,
                                                     (
                                                         SELECT
                                                             COUNT(DISTINCT cs.id) --AS filled_reaction_eval
                                                         FROM
                                                             tbl_class_student   cs
                                                             INNER JOIN tbl_class           c ON cs.class_id = c.id
                                                             INNER JOIN tbl_parameter_value ON cs.scores_state_id = tbl_parameter_value.id
                                                         WHERE
                                                             c.id = classx.id
                                                             AND cs.evaluation_status_reaction IN (
                                                                 2,
                                                                 3
                                                             )
                                                             and
                                                              tbl_parameter_value.c_code not IN ('DeleteStudentCauseOfPermittedAbcense','StudentCancellation','DeleteStudentCauseOfAffairRequest','DeleteStudentCauseOfAbcense','ClassDelete')
                                                     ) AS filled_reaction_eval,
                                                     (
                                                         SELECT
                                                             COUNT(DISTINCT cs.id) --AS all_reaction_eval
                                                         FROM
                                                             tbl_class_student   cs
                                                             INNER JOIN tbl_class           c ON cs.class_id = c.id
                                                             INNER JOIN tbl_parameter_value ON cs.scores_state_id = tbl_parameter_value.id
                                                         WHERE
                                                             c.id = classx.id
                                                             AND ( cs.evaluation_status_reaction IN (
                                                                 0,
                                                                 1,
                                                                 2,
                                                                 3
                                                             )
                                                                   OR cs.evaluation_status_reaction IS NULL )
                                                                   and
                                                                   tbl_parameter_value.c_code not IN ('DeleteStudentCauseOfPermittedAbcense','StudentCancellation','DeleteStudentCauseOfAffairRequest','DeleteStudentCauseOfAbcense','ClassDelete')
                                                     ) AS all_reaction_eval
                                                 FROM
                                                     tbl_class_student   cs
                                                     INNER JOIN tbl_class           classx ON cs.class_id = classx.id
                                             )
                                            
                                     ) percent_ ON clsstu.class_id = percent_.class_id
                                 ORDER BY
                                     class_code
                             ) f
                     ) n                                             
                                                           
            """, nativeQuery = true)
    List<ViewReactionEvaluationFormulaReportForCourse> getAllForCourse(String start, String end);
}
