package com.nicico.training.repository;

import com.nicico.training.model.ViewReactionEvaluationFormulaReportForCourse;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ViewReactionEvaluationFormulaReportForCourseDAO extends BaseDAO<ViewReactionEvaluationFormulaReportForCourse, Long> {

    @Query(value = "SELECT\n" +
            "ROWNUM as id,n.*\n" +
            "FROM\n" +
            "    (\n" +
            "        SELECT DISTINCT\n" +
            "            f.class_code,\n" +
            "            f.class_status,\n" +
            "            f.class_end_date,\n" +
            "            f.class_start_date,\n" +
            "            f.course_code,\n" +
            "            f.course_titlefa,\n" +
            "            f.sub_category_titlefa,\n" +
            "            f.category_titlefa,\n" +
            "            f.class_id,\n" +
            "            f.course_id,\n" +
            "            f.complex,\n" +
            "            f.is_personnel,\n" +
            "            f.teacher_national_code,\n" +
            "            f.teacher,\n" +
            "            f.final_teacher,\n" +
            "            f.reactione_evaluation_grade,\n" +
            "            f.teacher_grade_to_class,\n" +
            "            f.training_grade_to_teacher,\n" +
            "            f.javab_dade,\n" +
            "            f.total_std,\n" +
            "            f.miangin_javab_dade\n" +
            "        FROM\n" +
            "            (\n" +
            "                SELECT\n" +
            "                    ROWNUM                                                             AS id,\n" +
            "                    z.class_code                                                       AS class_code,\n" +
            "                    CASE\n" +
            "                        WHEN z.status = 1 THEN\n" +
            "                            ' برنامه ریزی'\n" +
            "                        WHEN z.status = 2 THEN\n" +
            "                            ' در حال اجرا'\n" +
            "                        WHEN z.status = 3 THEN\n" +
            "                            ' پایان یافته'\n" +
            "                        WHEN z.status = 4 THEN\n" +
            "                            ' لغو شده'\n" +
            "                        WHEN z.status = 5 THEN\n" +
            "                            'اختتام'\n" +
            "                    END                                                                AS class_status,\n" +
            "                    z.class_start_date                                                 AS class_start_date,\n" +
            "                    z.class_end_date                                                   AS class_end_date,\n" +
            "                    z.course_code                                                      AS course_code,\n" +
            "                    z.course_titlefa                                                   AS course_titlefa,\n" +
            "                    z.category_titlefa                                                 AS category_titlefa,\n" +
            "                    z.sub_category_titlefa                                             AS sub_category_titlefa,\n" +
            "                    z.class_id                                                         AS class_id,\n" +
            "                    z.course_id                                                        AS course_id,\n" +
            "                    z.class_complex                                                    AS complex,\n" +
            "                    z.is_personnel                                                     AS is_personnel,\n" +
            "                    z.teacher_national_code                                            AS teacher_national_code,\n" +
            "                    z.teacher                                                          AS teacher,\n" +
            "                    concat(concat(tbl_student.first_name, ' '), tbl_student.last_name) AS student,\n" +
            "                    tbl_student.emp_no                                                 AS student_emp_number,\n" +
            "                    tbl_student.personnel_no                                           AS student_per_number,\n" +
            "                    tbl_department.c_hoze_title                                        AS student_hoze,\n" +
            "                    tbl_department.c_omor_title                                        AS student_omor,\n" +
            "                    tbl_post.c_code                                                    AS student_post_code,\n" +
            "                    tbl_post.c_title_fa                                                AS student_post_title,\n" +
            "                    CAST(tbl_evaluation_analysis.c_teacher_grade AS DECIMAL(10, 2))    AS final_teacher,\n" +
            "                    CAST(tbl_evaluation_analysis.c_reaction_grade AS DECIMAL(10, 2))   AS reactione_evaluation_grade,\n" +
            "                    modares.miangin                                                    AS teacher_grade_to_class,\n" +
            "                    mianginmasol.miangin                                               AS training_grade_to_teacher,\n" +
            "                    clsstu.total_std                                                   AS total_std,\n" +
            "                    CASE\n" +
            "                        WHEN darsadjavab.javabdade IS NULL THEN\n" +
            "                            0\n" +
            "                        ELSE\n" +
            "                            darsadjavab.javabdade\n" +
            "                    END                                                                AS javab_dade,\n" +
            "                    CAST((\n" +
            "                        CASE\n" +
            "                            WHEN darsadjavab.javabdade IS NULL THEN\n" +
            "                                0\n" +
            "                            ELSE\n" +
            "                                darsadjavab.javabdade\n" +
            "                        END\n" +
            "                        / clsstu.total_std) * 100 AS DECIMAL(8, 2))                        AS miangin_javab_dade\n" +
            "                FROM\n" +
            "                         (\n" +
            "                        SELECT\n" +
            "                            class_id,\n" +
            "                            student_id,\n" +
            "                            total_std\n" +
            "                        FROM\n" +
            "                            (\n" +
            "                                SELECT\n" +
            "                                    tbl_class_student.class_id,\n" +
            "                                    tbl_class_student.student_id,\n" +
            "                                    COUNT(*)\n" +
            "                                    OVER(PARTITION BY tbl_class_student.class_id) total_std\n" +
            "                                FROM\n" +
            "                                    tbl_class_student\n" +
            "                            )\n" +
            "                        WHERE\n" +
            "                            total_std > 0\n" +
            "                    ) clsstu\n" +
            "                    INNER JOIN (\n" +
            "                        SELECT\n" +
            "                            ROWNUM                                                                                   AS id,\n" +
            "                            tclass.id                                                                                AS class_id,\n" +
            "                            tclass.c_code                                                                            AS class_code,\n" +
            "                            tclass.c_status                                                                          AS status,\n" +
            "                            tclass.c_start_date                                                                      AS class_start_date,\n" +
            "                            tclass.c_end_date                                                                        AS class_end_date,\n" +
            "                            course.id                                                                                AS course_id,\n" +
            "                            course.c_code                                                                            AS course_code,\n" +
            "                            course.c_title_fa                                                                        AS course_titlefa,\n" +
            "                            cat.c_title_fa                                                                           AS category_titlefa,\n" +
            "                            sucat.c_title_fa                                                                         AS sub_category_titlefa,\n" +
            "                            concat(concat(tbl_personal_info.c_first_name_fa, ' '), tbl_personal_info.c_last_name_fa) AS teacher,\n" +
            "                            tbl_personal_info.c_first_name_fa                                                        AS teacher_name,\n" +
            "                            tbl_personal_info.c_last_name_fa                                                         AS teacher_family,\n" +
            "                            tbl_personal_info.c_national_code                                                        AS teacher_national_code,\n" +
            "                            view_complex.c_title                                                                     AS class_complex,\n" +
            "                            CASE\n" +
            "                                WHEN tbl_teacher.b_personnel = 0 THEN\n" +
            "                                    'برون سازمانی'\n" +
            "                                WHEN tbl_teacher.b_personnel = 1 THEN\n" +
            "                                    'درون سازمانی'\n" +
            "                            END                                                                                      AS is_personnel\n" +
            "                        FROM\n" +
            "                                 tbl_class tclass\n" +
            "                            INNER JOIN tbl_course       course ON tclass.f_course = course.id\n" +
            "                            INNER JOIN tbl_category     cat ON cat.id = course.category_id\n" +
            "                            INNER JOIN tbl_sub_category sucat ON sucat.id = course.subcategory_id\n" +
            "                            INNER JOIN tbl_teacher ON tclass.f_teacher = tbl_teacher.id\n" +
            "                            INNER JOIN tbl_personal_info ON tbl_teacher.f_personality = tbl_personal_info.id\n" +
            "                            LEFT JOIN view_complex ON tclass.complex_id = view_complex.id\n" +
            "                        WHERE\n" +
            "                                tclass.c_status != '1'\n" +
            "                            AND tclass.c_start_date >= :start \n" +
            "                            AND tclass.c_end_date <= :end \n" +
            "                    )              z ON clsstu.class_id = z.class_id\n" +
            "                    LEFT JOIN tbl_student ON clsstu.student_id = tbl_student.id\n" +
            "                    LEFT JOIN tbl_department ON tbl_student.f_department_id = tbl_department.id\n" +
            "                    LEFT JOIN tbl_post ON tbl_student.f_post_id = tbl_post.id\n" +
            "                    LEFT JOIN tbl_evaluation_analysis ON clsstu.class_id = tbl_evaluation_analysis.f_tclass\n" +
            "                    LEFT JOIN tbl_evaluation f ON z.class_id = f.f_class_id\n" +
            "                                                  AND f.f_evaluator_type_id = '187'\n" +
            "                    LEFT JOIN (\n" +
            "                        SELECT\n" +
            "                            CAST(SUM(rate * w) / SUM(w) AS DECIMAL(8, 2)) AS miangin,\n" +
            "                            idmodares\n" +
            "                        FROM\n" +
            "                            (\n" +
            "                                SELECT\n" +
            "                                    tbl_questionnaire_question.f_weight   AS w,\n" +
            "                                    tbl_parameter_value.c_value           AS rate,\n" +
            "                                    tbl_evaluation_answer.f_evaluation_id AS idmodares\n" +
            "                                FROM\n" +
            "                                         tbl_evaluation_answer\n" +
            "                                    INNER JOIN tbl_questionnaire_question ON tbl_evaluation_answer.f_evaluation_question_id = tbl_questionnaire_question.\n" +
            "                                    id\n" +
            "                                    INNER JOIN tbl_parameter_value ON tbl_evaluation_answer.f_answer_id = tbl_parameter_value.id\n" +
            "                            )\n" +
            "                        GROUP BY\n" +
            "                            idmodares\n" +
            "                    )              modares ON f.id = modares.idmodares\n" +
            "                    LEFT JOIN tbl_evaluation masol ON z.class_id = masol.f_class_id\n" +
            "                                                      AND masol.f_evaluator_type_id = '454'\n" +
            "                    LEFT JOIN (\n" +
            "                        SELECT\n" +
            "                            CAST(SUM(rate * w) / SUM(w) AS DECIMAL(8, 2)) AS miangin,\n" +
            "                            idmodares\n" +
            "                        FROM\n" +
            "                            (\n" +
            "                                SELECT\n" +
            "                                    tbl_questionnaire_question.f_weight   AS w,\n" +
            "                                    tbl_parameter_value.c_value           AS rate,\n" +
            "                                    tbl_evaluation_answer.f_evaluation_id AS idmodares\n" +
            "                                FROM\n" +
            "                                         tbl_evaluation_answer\n" +
            "                                    INNER JOIN tbl_questionnaire_question ON tbl_evaluation_answer.f_evaluation_question_id = tbl_questionnaire_question.\n" +
            "                                    id\n" +
            "                                    INNER JOIN tbl_parameter_value ON tbl_evaluation_answer.f_answer_id = tbl_parameter_value.id\n" +
            "                            )\n" +
            "                        GROUP BY\n" +
            "                            idmodares\n" +
            "                    )              mianginmasol ON masol.id = mianginmasol.idmodares\n" +
            "                    LEFT JOIN (\n" +
            "                        SELECT\n" +
            "                            COUNT(*)                  AS javabdade,\n" +
            "                            tbl_evaluation.f_class_id AS classid\n" +
            "                        FROM\n" +
            "                            tbl_evaluation\n" +
            "                        WHERE\n" +
            "                                tbl_evaluation.b_status = 1\n" +
            "                            AND tbl_evaluation.f_evaluator_type_id = 188\n" +
            "                        GROUP BY\n" +
            "                            tbl_evaluation.f_class_id,\n" +
            "                            tbl_evaluation.b_status,\n" +
            "                            tbl_evaluation.f_evaluator_type_id\n" +
            "                    )              darsadjavab ON z.class_id = darsadjavab.classid\n" +
            "                ORDER BY\n" +
            "                    class_code\n" +
            "            ) f\n" +
            "    )n",nativeQuery = true)
    List<ViewReactionEvaluationFormulaReportForCourse> getAllForCourse(String start, String end);
}
