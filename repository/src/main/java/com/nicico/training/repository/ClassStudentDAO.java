package com.nicico.training.repository;

import com.nicico.training.model.ClassStudent;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Collection;
import java.util.List;
import java.util.Optional;

public interface ClassStudentDAO extends JpaRepository<ClassStudent, Long>, JpaSpecificationExecutor<ClassStudent> {

    @Query(value = "select tbl_course.C_Evaluation from tbl_class_student join tbl_class on tbl_class_student.class_id = tbl_class.Id join tbl_course on tbl_class.F_COURSE = tbl_course.Id where (tbl_class_student.student_id=:studentId and tbl_class_student.class_id=:classId )", nativeQuery = true)
    List<Long> findEvaluationStudentInClass(@Param("studentId") Long studentId, @Param("classId") Long classId);

    @Query(value = "select STUDENT_ID from  tbl_class_student  where CLASS_ID=:classId and SCORES_STATE_ID in (448,405,449,406,404,400,401,403,450)",nativeQuery = true)
     List<Long> getScoreState(@Param("classId") Long classId);

    @Modifying
    @Query(value = "update TBL_CLASS_STUDENT set " +
            "EVALUATION_STATUS_REACTION = :reaction, " +
            "EVALUATION_STATUS_LEARNING = :learning, " +
            "EVALUATION_STATUS_BEHAVIOR = :behavior, " +
            "EVALUATION_STATUS_RESULTS = :results " +
            "where id = :idClassStudent", nativeQuery = true)
    int setStudentFormIssuance(Long idClassStudent, Integer reaction, Integer learning, Integer behavior, Integer results);

    @Modifying
    @Query(value = "update TBL_CLASS_STUDENT set " +
            "evaluation_audience_type_id = :AudienceType " +
            "where id = :idClassStudent", nativeQuery = true)
    int setStudentFormIssuanceAudienceType(Long idClassStudent, Long AudienceType);

    @Modifying
    @Query(value = "update  TBL_CLASS_STUDENT set scores_state_id = 401 ,  failure_reason_id = null where CLASS_ID =:id ", nativeQuery = true)
    void setTotalStudentWithOutScore(@Param("id") Long id);

    Optional<ClassStudent> findByTclassIdAndStudentId(Long tclassId, Long studentId);

    List<ClassStudent> findByTclassId(Long classId);

    List<ClassStudent> findByTclassIdAndPreTestScoreIsNull(Long id);

    ClassStudent getClassStudentById(Long classStudentId);

    Integer countClassStudentsByTclassId(Long classId);

    @Modifying
    @Query(value = "update TBL_CLASS_STUDENT set TBL_CLASS_STUDENT.PRESENCE_TYPE_ID =:presenceTypeId where id =:id", nativeQuery = true)
    void setPeresenceTypeId(Long presenceTypeId, Long id);

    @Modifying
    @Query(value = "update TBL_CLASS_STUDENT set " +
            "evaluation_audience_id = :AudienceId " +
            "where id = :idClassStudent", nativeQuery = true)
    int setStudentFormIssuanceAudienceId(Long idClassStudent, Long AudienceId);

    @Query(value = "select mc.c_object_mobile,count(*) as cnt from tbl_message_contact mc inner join tbl_message m on m.id=mc.f_message_id where mc.n_count_sent>0 and m.f_message_class=:classId and m.f_message_user_type=679 group by mc.c_object_mobile", nativeQuery = true)
    List<Object> getStatusSendMessageStudents(Long classId);

    List<ClassStudent> findAllByTclassId(long classId);

    @Query(value = "SELECT tbl_class.c_start_date,VIEW_CONTACT_INFO.MOBILE_FOR_SMS AS MOBILE,tbl_class_student.id,tbl_class_student.class_id FROM tbl_class_student INNER JOIN tbl_class ON tbl_class_student.class_id = tbl_class.id INNER JOIN tbl_student ON tbl_class_student.student_id = tbl_student.id " +
            " INNER JOIN VIEW_CONTACT_INFO ON VIEW_CONTACT_INFO.ID = TBL_STUDENT.F_CONTACT_INFO WHERE tbl_class.c_start_date > :s1 AND  tbl_class.c_start_date < :s2", nativeQuery = true)
    List<Object> findAllUserMobiles(String s1, String s2);

    @Query(value = "SELECT\n" +

            "     tbl_class_student.id\n" +
            "FROM\n" +
            "         tbl_class_student\n" +
            "    INNER JOIN tbl_student ON tbl_class_student.student_id = tbl_student.id\n" +
            "WHERE\n" +
            "    tbl_class_student.class_id = :classId \n" +
            "    AND national_code = :nationalCode ", nativeQuery = true)
    List<Long> getClassStudentIdByClassCodeAndNationalCode(@Param("classId") Long classId, @Param("nationalCode") String nationalCode);

    @Query(value = "\n" +
            "SELECT *\n" +
            "FROM (\n" +
            "         SELECT a.*, rownum r__\n" +
            "         FROM (\n" +
            "                  SELECT DISTINCT tbl_teacher.c_teacher_code,\n" +
            "                                  tbl_class.id                                                     AS classid,\n" +
            "                                  tbl_teacher.id                                                   AS teacherid,\n" +
            "                                  tbl_class.c_code                                                 AS code,\n" +
            "                                  tbl_class.c_title_class                                          AS title,\n" +
            "                                  tbl_course.c_title_fa                                            AS name,\n" +
            "                                  tbl_class.n_max_capacity                                         AS capacity,\n" +
            "                                  tbl_class.n_h_duration                                           AS duration,\n" +
            "                                  view_complex.c_title                                             AS location,\n" +
            "                                  CASE\n" +
            "                                      WHEN tbl_class.c_status = 1 THEN\n" +
            "                                          4\n" +
            "                                      WHEN tbl_class.c_status = 2 THEN\n" +
            "                                          1\n" +
            "                                      WHEN tbl_class.c_status = 3 THEN\n" +
            "                                          2\n" +
            "                                      WHEN tbl_class.c_status = 4 THEN\n" +
            "                                          3\n" +
            "                                      WHEN tbl_class.c_status = 5 THEN\n" +
            "                                          2\n" +
            "                                      END                                                          AS coursestatus,\n" +
            "                                  CASE\n" +
            "                                      WHEN tbl_class.f_teaching_method_id = 639 THEN\n" +
            "                                          1\n" +
            "                                      ELSE\n" +
            "                                          2\n" +
            "                                      END                                                          AS classtype,\n" +
            "                                  tbl_class.c_start_date                                           AS startdate,\n" +
            "                                  tbl_class.c_end_date                                             AS finishdate,\n" +
            "                                  concat(concat(tbl_personal_info.c_first_name_fa, ' '),\n" +
            "                                         tbl_personal_info.c_last_name_fa)                         as instructor,\n" +
            "                                  evaluation.eval,\n" +
            "                                  tbl_class.f_supervisor                                           AS supervisorId,\n" +
            "                                  tbl_class.f_planner                                              AS plannerId,\n" +
            "                                  concat(concat(supervisor.FIRST_NAME, ' '), supervisor.LAST_NAME) AS supervisorNAME,\n" +
            "                                  concat(concat(planner.FIRST_NAME, ' '), planner.LAST_NAME)       AS plannerNAME\n" +
            "                  FROM tbl_class_student\n" +
            "                           INNER JOIN tbl_class ON tbl_class_student.class_id = tbl_class.id\n" +
            "                           INNER JOIN tbl_teacher ON tbl_class.f_teacher = tbl_teacher.id\n" +
            "                           INNER JOIN tbl_course ON tbl_class.f_course = tbl_course.id\n" +
            "                           LEFT JOIN view_complex ON tbl_class.complex_id = view_complex.id\n" +
            "                           INNER JOIN tbl_personal_info ON tbl_teacher.f_personality = tbl_personal_info.id\n" +
            "                           LEFT JOIN TBL_PERSONNEL planner on TBL_CLASS.F_PLANNER = planner.ID\n" +
            "                           LEFT JOIN TBL_PERSONNEL supervisor on TBL_CLASS.F_SUPERVISOR = supervisor.ID\n" +
            "                           LEFT JOIN(\n" +
            "                      SELECT teacher.id AS std,\n" +
            "                             eval.id    AS eval,\n" +
            "                             class.id   AS class\n" +
            "                      FROM tbl_evaluation eval\n" +
            "                               INNER JOIN tbl_teacher teacher ON eval.f_evaluator_id = teacher.id\n" +
            "                               INNER JOIN tbl_personal_info personal ON teacher.f_personality = personal.id\n" +
            "                               INNER JOIN tbl_class class ON eval.f_class_id = class.id\n" +
            "                               INNER JOIN tbl_parameter_value ON eval.f_evaluator_type_id = tbl_parameter_value.id\n" +
            "                      WHERE personal.c_national_code = :nationalCode\n" +
            "                        AND class.teacher_online_eval_status = 1\n" +
            "                        AND tbl_parameter_value.c_code = '11'\n" +
            "                  ) evaluation ON (evaluation.class = tbl_class.id And evaluation.std = tbl_teacher.id)\n" +
            "                  WHERE tbl_teacher.c_teacher_code = :nationalCode\n" +
            "                  ORDER BY classid Desc) a\n" +
            "         WHERE rownum < ((:page * :sizee) + 1)\n" +
            "     )\n" +
            "WHERE r__ >= (((:page - 1) * :sizee) + 1)",nativeQuery = true)
    List<Object> findAllClassByTeacher(String nationalCode, int page,int sizee);


    @Query(value = "\n" +
            "SELECT *\n" +
            "FROM (\n" +
            "         SELECT a.*, rownum r__\n" +
            "         FROM (\n" +
            "                  SELECT DISTINCT tbl_teacher.c_teacher_code,\n" +
            "                                  tbl_class.id                                                     AS classid,\n" +
            "                                  tbl_teacher.id                                                   AS teacherid,\n" +
            "                                  tbl_class.c_code                                                 AS code,\n" +
            "                                  tbl_class.c_title_class                                          AS title,\n" +
            "                                  tbl_course.c_title_fa                                            AS name,\n" +
            "                                  tbl_class.n_max_capacity                                         AS capacity,\n" +
            "                                  tbl_class.n_h_duration                                           AS duration,\n" +
            "                                  view_complex.c_title                                             AS location,\n" +
            "                                  CASE\n" +
            "                                      WHEN tbl_class.c_status = 1 THEN\n" +
            "                                          4\n" +
            "                                      WHEN tbl_class.c_status = 2 THEN\n" +
            "                                          1\n" +
            "                                      WHEN tbl_class.c_status = 3 THEN\n" +
            "                                          2\n" +
            "                                      WHEN tbl_class.c_status = 4 THEN\n" +
            "                                          3\n" +
            "                                      WHEN tbl_class.c_status = 5 THEN\n" +
            "                                          2\n" +
            "                                      END                                                          AS coursestatus,\n" +
            "                                  CASE\n" +
            "                                      WHEN tbl_class.f_teaching_method_id = 639 THEN\n" +
            "                                          1\n" +
            "                                      ELSE\n" +
            "                                          2\n" +
            "                                      END                                                          AS classtype,\n" +
            "                                  tbl_class.c_start_date                                           AS startdate,\n" +
            "                                  tbl_class.c_end_date                                             AS finishdate,\n" +
            "                                  concat(concat(tbl_personal_info.c_first_name_fa, ' '),\n" +
            "                                         tbl_personal_info.c_last_name_fa)                         as instructor,\n" +
            "                                  evaluation.eval,\n" +
            "                                  tbl_class.f_supervisor                                           AS supervisorId,\n" +
            "                                  tbl_class.f_planner                                              AS plannerId,\n" +
            "                                  concat(concat(supervisor.FIRST_NAME, ' '), supervisor.LAST_NAME) AS supervisorNAME,\n" +
            "                                  concat(concat(planner.FIRST_NAME, ' '), planner.LAST_NAME)       AS plannerNAME\n" +
            "                  FROM tbl_class_student\n" +
            "                           INNER JOIN tbl_class ON tbl_class_student.class_id = tbl_class.id\n" +
            "                           INNER JOIN tbl_teacher ON tbl_class.f_teacher = tbl_teacher.id\n" +
            "                           INNER JOIN tbl_course ON tbl_class.f_course = tbl_course.id\n" +
            "                           LEFT JOIN view_complex ON tbl_class.complex_id = view_complex.id\n" +
            "                           INNER JOIN tbl_personal_info ON tbl_teacher.f_personality = tbl_personal_info.id\n" +
            "                           LEFT JOIN TBL_PERSONNEL planner on TBL_CLASS.F_PLANNER = planner.ID\n" +
            "                           LEFT JOIN TBL_PERSONNEL supervisor on TBL_CLASS.F_SUPERVISOR = supervisor.ID\n" +
            "                           LEFT JOIN(\n" +
            "                      SELECT teacher.id AS std,\n" +
            "                             eval.id    AS eval,\n" +
            "                             class.id   AS class\n" +
            "                      FROM tbl_evaluation eval\n" +
            "                               INNER JOIN tbl_teacher teacher ON eval.f_evaluator_id = teacher.id\n" +
            "                               INNER JOIN tbl_personal_info personal ON teacher.f_personality = personal.id\n" +
            "                               INNER JOIN tbl_class class ON eval.f_class_id = class.id\n" +
            "                               INNER JOIN tbl_parameter_value ON eval.f_evaluator_type_id = tbl_parameter_value.id\n" +
            "                      WHERE personal.c_national_code = :nationalCode\n" +
            "                        AND class.teacher_online_eval_status = 1\n" +
            "                        AND tbl_parameter_value.c_code = '11'\n" +
            "                  ) evaluation ON (evaluation.class = tbl_class.id And evaluation.std = tbl_teacher.id)\n" +
            "       LEFT JOIN tbl_test_question ON (tbl_class.id = tbl_test_question.f_class and tbl_test_question.c_test_question_type = 'PreTest')\n" +
            "" +
            "                  WHERE tbl_teacher.c_teacher_code = :nationalCode\n " +
            " and  tbl_class.c_evaluation !='1'  " +
            " and tbl_test_question.id is null  " +
            "                  ORDER BY classid Desc) a\n" +
            "         WHERE rownum < ((:page * :sizee) + 1)\n" +
            "     )\n" +
            "WHERE r__ >= (((:page - 1) * :sizee) + 1)",nativeQuery = true)
    List<Object> findAllClassByTeacherForPre(String nationalCode, int page,int sizee);




    @Query(value = "\n" +
            "SELECT *\n" +
            "FROM (\n" +
            "         SELECT a.*, rownum r__\n" +
            "         FROM (\n" +
            "                  SELECT DISTINCT tbl_teacher.c_teacher_code,\n" +
            "                                  tbl_class.id                                                     AS classid,\n" +
            "                                  tbl_teacher.id                                                   AS teacherid,\n" +
            "                                  tbl_class.c_code                                                 AS code,\n" +
            "                                  tbl_class.c_title_class                                          AS title,\n" +
            "                                  tbl_course.c_title_fa                                            AS name,\n" +
            "                                  tbl_class.n_max_capacity                                         AS capacity,\n" +
            "                                  tbl_class.n_h_duration                                           AS duration,\n" +
            "                                  view_complex.c_title                                             AS location,\n" +
            "                                  CASE\n" +
            "                                      WHEN tbl_class.c_status = 1 THEN\n" +
            "                                          4\n" +
            "                                      WHEN tbl_class.c_status = 2 THEN\n" +
            "                                          1\n" +
            "                                      WHEN tbl_class.c_status = 3 THEN\n" +
            "                                          2\n" +
            "                                      WHEN tbl_class.c_status = 4 THEN\n" +
            "                                          3\n" +
            "                                      WHEN tbl_class.c_status = 5 THEN\n" +
            "                                          2\n" +
            "                                      END                                                          AS coursestatus,\n" +
            "                                  CASE\n" +
            "                                      WHEN tbl_class.f_teaching_method_id = 639 THEN\n" +
            "                                          1\n" +
            "                                      ELSE\n" +
            "                                          2\n" +
            "                                      END                                                          AS classtype,\n" +
            "                                  tbl_class.c_start_date                                           AS startdate,\n" +
            "                                  tbl_class.c_end_date                                             AS finishdate,\n" +
            "                                  concat(concat(tbl_personal_info.c_first_name_fa, ' '),\n" +
            "                                         tbl_personal_info.c_last_name_fa)                         as instructor,\n" +
            "                                  evaluation.eval,\n" +
            "                                  tbl_class.f_supervisor                                           AS supervisorId,\n" +
            "                                  tbl_class.f_planner                                              AS plannerId,\n" +
            "                                  concat(concat(supervisor.FIRST_NAME, ' '), supervisor.LAST_NAME) AS supervisorNAME,\n" +
            "                                  concat(concat(planner.FIRST_NAME, ' '), planner.LAST_NAME)       AS plannerNAME\n" +
            "                  FROM tbl_class_student\n" +
            "                           INNER JOIN tbl_class ON tbl_class_student.class_id = tbl_class.id\n" +
            "                           INNER JOIN tbl_teacher ON tbl_class.f_teacher = tbl_teacher.id\n" +
            "                           INNER JOIN tbl_course ON tbl_class.f_course = tbl_course.id\n" +
            "                           LEFT JOIN view_complex ON tbl_class.complex_id = view_complex.id\n" +
            "                           INNER JOIN tbl_personal_info ON tbl_teacher.f_personality = tbl_personal_info.id\n" +
            "                           LEFT JOIN TBL_PERSONNEL planner on TBL_CLASS.F_PLANNER = planner.ID\n" +
            "                           LEFT JOIN TBL_PERSONNEL supervisor on TBL_CLASS.F_SUPERVISOR = supervisor.ID\n" +
            "                           LEFT JOIN(\n" +
            "                      SELECT teacher.id AS std,\n" +
            "                             eval.id    AS eval,\n" +
            "                             class.id   AS class\n" +
            "                      FROM tbl_evaluation eval\n" +
            "                               INNER JOIN tbl_teacher teacher ON eval.f_evaluator_id = teacher.id\n" +
            "                               INNER JOIN tbl_personal_info personal ON teacher.f_personality = personal.id\n" +
            "                               INNER JOIN tbl_class class ON eval.f_class_id = class.id\n" +
            "                               INNER JOIN tbl_parameter_value ON eval.f_evaluator_type_id = tbl_parameter_value.id\n" +
            "                      WHERE personal.c_national_code = :nationalCode\n" +
            "                        AND class.teacher_online_eval_status = 1\n" +
            "                        AND tbl_parameter_value.c_code = '11'\n" +
            "                  ) evaluation ON (evaluation.class = tbl_class.id And evaluation.std = tbl_teacher.id)\n" +
            "       LEFT JOIN tbl_test_question ON (tbl_class.id = tbl_test_question.f_class and tbl_test_question.c_test_question_type = 'FinalTest')\n" +
            "                  WHERE tbl_teacher.c_teacher_code = :nationalCode\n " +
            "  and    tbl_class.c_scoring_method != '1' and tbl_class.c_scoring_method != '4'  and tbl_test_question.id is null  " +
            "                  ORDER BY classid Desc) a\n" +
            "         WHERE rownum < ((:page * :sizee) + 1)\n" +
            "     )\n" +
            "WHERE r__ >= (((:page - 1) * :sizee) + 1)",nativeQuery = true)
    List<Object> findAllClassByTeacherForExam(String nationalCode, int page,int sizee);
    @Query(value = "\n" +
            "SELECT DISTINCT tbl_teacher.c_teacher_code,\n" +
            "                tbl_class.id                                                                             AS classid,\n" +
            "                tbl_teacher.id                                                                           AS teacherid,\n" +
            "                tbl_class.c_code                                                                         AS code,\n" +
            "                tbl_class.c_title_class                                                                  AS title,\n" +
            "                tbl_course.c_title_fa                                                                    AS name,\n" +
            "                tbl_class.n_max_capacity                                                                 AS capacity,\n" +
            "                tbl_class.n_h_duration                                                                   AS duration,\n" +
            "                view_complex.c_title                                                                     AS location,\n" +
            "                CASE\n" +
            "                    WHEN tbl_class.c_status = 1 THEN\n" +
            "                        4\n" +
            "                    WHEN tbl_class.c_status = 2 THEN\n" +
            "                        1\n" +
            "                    WHEN tbl_class.c_status = 3 THEN\n" +
            "                        2\n" +
            "                    WHEN tbl_class.c_status = 4 THEN\n" +
            "                        3\n" +
            "                    WHEN tbl_class.c_status = 5 THEN\n" +
            "                        2\n" +
            "                    END                                                                                  AS coursestatus,\n" +
            "                CASE\n" +
            "                    WHEN tbl_class.f_teaching_method_id = 639 THEN\n" +
            "                        1\n" +
            "                    ELSE\n" +
            "                        2\n" +
            "                    END                                                                                  AS classtype,\n" +
            "                tbl_class.c_start_date                                                                   AS startdate,\n" +
            "                tbl_class.c_end_date                                                                     AS finishdate,\n" +
            "                concat(concat(tbl_personal_info.c_first_name_fa, ' '), tbl_personal_info.c_last_name_fa) as instructor,\n" +
            "                evaluation.eval,\n" +
            "                tbl_class.f_supervisor                                                                   AS supervisorId,\n" +
            "                tbl_class.f_planner                                                                      AS plannerId,\n" +
            "                concat(concat(supervisor.FIRST_NAME, ' '), supervisor.LAST_NAME)                         AS supervisorNAME,\n" +
            "                concat(concat(planner.FIRST_NAME, ' '), planner.LAST_NAME)                               AS plannerNAME\n" +
            "FROM tbl_class_student\n" +
            "         INNER JOIN tbl_class ON tbl_class_student.class_id = tbl_class.id\n" +
            "         INNER JOIN tbl_teacher ON tbl_class.f_teacher = tbl_teacher.id\n" +
            "         INNER JOIN tbl_course ON tbl_class.f_course = tbl_course.id\n" +
            "         LEFT JOIN view_complex ON tbl_class.complex_id = view_complex.id\n" +
            "         INNER JOIN tbl_personal_info ON tbl_teacher.f_personality = tbl_personal_info.id\n" +
            "         LEFT JOIN TBL_PERSONNEL planner on TBL_CLASS.F_PLANNER = planner.ID\n" +
            "         LEFT JOIN TBL_PERSONNEL supervisor on TBL_CLASS.F_SUPERVISOR = supervisor.ID\n" +
            "         LEFT JOIN(\n" +
            "    SELECT teacher.id AS std,\n" +
            "           eval.id    AS eval,\n" +
            "           class.id   AS class\n" +
            "    FROM tbl_evaluation eval\n" +
            "             INNER JOIN tbl_teacher teacher ON eval.f_evaluator_id = teacher.id\n" +
            "             INNER JOIN tbl_personal_info personal ON teacher.f_personality = personal.id\n" +
            "             INNER JOIN tbl_class class ON eval.f_class_id = class.id\n" +
            "             INNER JOIN tbl_parameter_value ON eval.f_evaluator_type_id = tbl_parameter_value.id\n" +
            "    WHERE personal.c_national_code = :nationalCode\n" +
            "      AND class.teacher_online_eval_status = 1\n" +
            "      AND tbl_parameter_value.c_code = '11'\n" +
            ") evaluation ON (evaluation.class = tbl_class.id And evaluation.std = tbl_teacher.id)\n" +
            "WHERE tbl_teacher.c_teacher_code = :nationalCode \n" +
            "ORDER BY classid Desc "
            ,nativeQuery = true)
    List<Object> findAllCountClassByTeacher(String nationalCode);



    @Query(value = "\n" +
            "SELECT DISTINCT tbl_teacher.c_teacher_code,\n" +
            "                tbl_class.id                                                                             AS classid,\n" +
            "                tbl_teacher.id                                                                           AS teacherid,\n" +
            "                tbl_class.c_code                                                                         AS code,\n" +
            "                tbl_class.c_title_class                                                                  AS title,\n" +
            "                tbl_course.c_title_fa                                                                    AS name,\n" +
            "                tbl_class.n_max_capacity                                                                 AS capacity,\n" +
            "                tbl_class.n_h_duration                                                                   AS duration,\n" +
            "                view_complex.c_title                                                                     AS location,\n" +
            "                CASE\n" +
            "                    WHEN tbl_class.c_status = 1 THEN\n" +
            "                        4\n" +
            "                    WHEN tbl_class.c_status = 2 THEN\n" +
            "                        1\n" +
            "                    WHEN tbl_class.c_status = 3 THEN\n" +
            "                        2\n" +
            "                    WHEN tbl_class.c_status = 4 THEN\n" +
            "                        3\n" +
            "                    WHEN tbl_class.c_status = 5 THEN\n" +
            "                        2\n" +
            "                    END                                                                                  AS coursestatus,\n" +
            "                CASE\n" +
            "                    WHEN tbl_class.f_teaching_method_id = 639 THEN\n" +
            "                        1\n" +
            "                    ELSE\n" +
            "                        2\n" +
            "                    END                                                                                  AS classtype,\n" +
            "                tbl_class.c_start_date                                                                   AS startdate,\n" +
            "                tbl_class.c_end_date                                                                     AS finishdate,\n" +
            "                concat(concat(tbl_personal_info.c_first_name_fa, ' '), tbl_personal_info.c_last_name_fa) as instructor,\n" +
            "                evaluation.eval,\n" +
            "                tbl_class.f_supervisor                                                                   AS supervisorId,\n" +
            "                tbl_class.f_planner                                                                      AS plannerId,\n" +
            "                concat(concat(supervisor.FIRST_NAME, ' '), supervisor.LAST_NAME)                         AS supervisorNAME,\n" +
            "                concat(concat(planner.FIRST_NAME, ' '), planner.LAST_NAME)                               AS plannerNAME\n" +
            "FROM tbl_class_student\n" +
            "         INNER JOIN tbl_class ON tbl_class_student.class_id = tbl_class.id\n" +
            "         INNER JOIN tbl_teacher ON tbl_class.f_teacher = tbl_teacher.id\n" +
            "         INNER JOIN tbl_course ON tbl_class.f_course = tbl_course.id\n" +
            "         LEFT JOIN view_complex ON tbl_class.complex_id = view_complex.id\n" +
            "         INNER JOIN tbl_personal_info ON tbl_teacher.f_personality = tbl_personal_info.id\n" +
            "         LEFT JOIN TBL_PERSONNEL planner on TBL_CLASS.F_PLANNER = planner.ID\n" +
            "         LEFT JOIN TBL_PERSONNEL supervisor on TBL_CLASS.F_SUPERVISOR = supervisor.ID\n" +
            "         LEFT JOIN(\n" +
            "    SELECT teacher.id AS std,\n" +
            "           eval.id    AS eval,\n" +
            "           class.id   AS class\n" +
            "    FROM tbl_evaluation eval\n" +
            "             INNER JOIN tbl_teacher teacher ON eval.f_evaluator_id = teacher.id\n" +
            "             INNER JOIN tbl_personal_info personal ON teacher.f_personality = personal.id\n" +
            "             INNER JOIN tbl_class class ON eval.f_class_id = class.id\n" +
            "             INNER JOIN tbl_parameter_value ON eval.f_evaluator_type_id = tbl_parameter_value.id\n" +
            "    WHERE personal.c_national_code = :nationalCode\n" +
            "      AND class.teacher_online_eval_status = 1\n" +
            "      AND tbl_parameter_value.c_code = '11'\n" +
            ") evaluation ON (evaluation.class = tbl_class.id And evaluation.std = tbl_teacher.id)" +
            "       LEFT JOIN tbl_test_question ON (tbl_class.id = tbl_test_question.f_class and tbl_test_question.c_test_question_type = 'PreTest')\n \n" +
            "WHERE tbl_teacher.c_teacher_code = :nationalCode \n" +
            " and  tbl_class.c_evaluation !='1'" +
            " and  tbl_test_question.id is null " +
            "ORDER BY classid Desc "
            ,nativeQuery = true)
    List<Object> findAllCountClassByTeacherForPre(String nationalCode);





    @Query(value = "\n" +
            "SELECT DISTINCT tbl_teacher.c_teacher_code,\n" +
            "                tbl_class.id                                                                             AS classid,\n" +
            "                tbl_teacher.id                                                                           AS teacherid,\n" +
            "                tbl_class.c_code                                                                         AS code,\n" +
            "                tbl_class.c_title_class                                                                  AS title,\n" +
            "                tbl_course.c_title_fa                                                                    AS name,\n" +
            "                tbl_class.n_max_capacity                                                                 AS capacity,\n" +
            "                tbl_class.n_h_duration                                                                   AS duration,\n" +
            "                view_complex.c_title                                                                     AS location,\n" +
            "                CASE\n" +
            "                    WHEN tbl_class.c_status = 1 THEN\n" +
            "                        4\n" +
            "                    WHEN tbl_class.c_status = 2 THEN\n" +
            "                        1\n" +
            "                    WHEN tbl_class.c_status = 3 THEN\n" +
            "                        2\n" +
            "                    WHEN tbl_class.c_status = 4 THEN\n" +
            "                        3\n" +
            "                    WHEN tbl_class.c_status = 5 THEN\n" +
            "                        2\n" +
            "                    END                                                                                  AS coursestatus,\n" +
            "                CASE\n" +
            "                    WHEN tbl_class.f_teaching_method_id = 639 THEN\n" +
            "                        1\n" +
            "                    ELSE\n" +
            "                        2\n" +
            "                    END                                                                                  AS classtype,\n" +
            "                tbl_class.c_start_date                                                                   AS startdate,\n" +
            "                tbl_class.c_end_date                                                                     AS finishdate,\n" +
            "                concat(concat(tbl_personal_info.c_first_name_fa, ' '), tbl_personal_info.c_last_name_fa) as instructor,\n" +
            "                evaluation.eval,\n" +
            "                tbl_class.f_supervisor                                                                   AS supervisorId,\n" +
            "                tbl_class.f_planner                                                                      AS plannerId,\n" +
            "                concat(concat(supervisor.FIRST_NAME, ' '), supervisor.LAST_NAME)                         AS supervisorNAME,\n" +
            "                concat(concat(planner.FIRST_NAME, ' '), planner.LAST_NAME)                               AS plannerNAME\n" +
            "FROM tbl_class_student\n" +
            "         INNER JOIN tbl_class ON tbl_class_student.class_id = tbl_class.id\n" +
            "         INNER JOIN tbl_teacher ON tbl_class.f_teacher = tbl_teacher.id\n" +
            "         INNER JOIN tbl_course ON tbl_class.f_course = tbl_course.id\n" +
            "         LEFT JOIN view_complex ON tbl_class.complex_id = view_complex.id\n" +
            "         INNER JOIN tbl_personal_info ON tbl_teacher.f_personality = tbl_personal_info.id\n" +
            "         LEFT JOIN TBL_PERSONNEL planner on TBL_CLASS.F_PLANNER = planner.ID\n" +
            "         LEFT JOIN TBL_PERSONNEL supervisor on TBL_CLASS.F_SUPERVISOR = supervisor.ID\n" +
            "         LEFT JOIN(\n" +
            "    SELECT teacher.id AS std,\n" +
            "           eval.id    AS eval,\n" +
            "           class.id   AS class\n" +
            "    FROM tbl_evaluation eval\n" +
            "             INNER JOIN tbl_teacher teacher ON eval.f_evaluator_id = teacher.id\n" +
            "             INNER JOIN tbl_personal_info personal ON teacher.f_personality = personal.id\n" +
            "             INNER JOIN tbl_class class ON eval.f_class_id = class.id\n" +
            "             INNER JOIN tbl_parameter_value ON eval.f_evaluator_type_id = tbl_parameter_value.id\n" +
            "    WHERE personal.c_national_code = :nationalCode\n" +
            "      AND class.teacher_online_eval_status = 1\n" +
            "      AND tbl_parameter_value.c_code = '11'\n" +
            ") evaluation ON (evaluation.class = tbl_class.id And evaluation.std = tbl_teacher.id)" +
            "    LEFT JOIN tbl_test_question ON (tbl_class.id = tbl_test_question.f_class and tbl_test_question.c_test_question_type = 'FinalTest')" +
            "\n" +
            "WHERE tbl_teacher.c_teacher_code = :nationalCode \n" +
            "    and    tbl_class.c_scoring_method != '1' and tbl_class.c_scoring_method != '4' and  tbl_test_question.id is null " +
            "ORDER BY classid Desc "
            ,nativeQuery = true)
    List<Object> findAllCountClassByTeacherForExam(String nationalCode);



    @Query(value = "SELECT *\n" +
            "FROM (\n" +
            "         SELECT a.*, rownum r__\n" +
            "         FROM (\n" +
            "                  SELECT DISTINCT tbl_student.national_code,\n" +
            "                                  tbl_class.id                                                     AS classid,\n" +
            "                                  tbl_class.f_teacher,\n" +
            "                                  tbl_class.c_code                                                 AS code,\n" +
            "                                  tbl_class.c_title_class                                          AS title,\n" +
            "                                  tbl_course.c_title_fa                                            AS name,\n" +
            "                                  tbl_class.n_max_capacity                                         AS capacity,\n" +
            "                                  tbl_class.n_h_duration                                           AS duration,\n" +
            "                                  view_complex.c_title                                             AS location,\n" +
            "                                  CASE\n" +
            "                                      WHEN tbl_class.c_status = 1 THEN\n" +
            "                                          4\n" +
            "                                      WHEN tbl_class.c_status = 2 THEN\n" +
            "                                          1\n" +
            "                                      WHEN tbl_class.c_status = 3 THEN\n" +
            "                                          2\n" +
            "                                      WHEN tbl_class.c_status = 4 THEN\n" +
            "                                          3\n" +
            "                                      WHEN tbl_class.c_status = 5 THEN\n" +
            "                                          2\n" +
            "                                      END                                                          AS coursestatus,\n" +
            "                                  CASE\n" +
            "                                      WHEN tbl_class.f_teaching_method_id = 639 THEN\n" +
            "                                          1\n" +
            "                                      ELSE\n" +
            "                                          2\n" +
            "                                      END                                                          AS classtype,\n" +
            "                                  tbl_class.c_start_date                                           AS startdate,\n" +
            "                                  tbl_class.c_end_date                                             AS finishdate,\n" +
            "                                  concat(concat(tbl_personal_info.c_first_name_fa, ' '),\n" +
            "                                         tbl_personal_info.c_last_name_fa)                         AS instructor,\n" +
            "                                  evaluation.eval,\n" +
            "                                  tbl_class.f_supervisor                                           AS supervisorId,\n" +
            "                                  tbl_class.f_planner                                              AS plannerId,\n" +
            "                                  concat(concat(supervisor.FIRST_NAME, ' '), supervisor.LAST_NAME) AS supervisorNAME,\n" +
            "                                  concat(concat(planner.FIRST_NAME, ' '), planner.LAST_NAME)       AS plannerNAME\n" +
            "                  FROM tbl_class_student\n" +
            "                           INNER JOIN tbl_class ON tbl_class_student.class_id = tbl_class.id\n" +
            "                           INNER JOIN tbl_course ON tbl_class.f_course = tbl_course.id\n" +
            "                           LEFT JOIN view_complex ON tbl_class.complex_id = view_complex.id\n" +
            "                           INNER JOIN tbl_student ON tbl_class_student.student_id = tbl_student.id\n" +
            "                           INNER JOIN tbl_teacher ON tbl_class.f_teacher = tbl_teacher.id\n" +
            "                           INNER JOIN tbl_personal_info ON tbl_teacher.f_personality = tbl_personal_info.id\n" +
            "                           left JOIN TBL_PERSONNEL planner on TBL_CLASS.F_PLANNER = planner.ID\n" +
            "                           left JOIN TBL_PERSONNEL supervisor on TBL_CLASS.F_SUPERVISOR = supervisor.ID\n" +
            "                           LEFT JOIN(SELECT student.id AS std,\n" +
            "                                            eval.id    AS eval,\n" +
            "                                            class.id   as class\n" +
            "                                     FROM tbl_evaluation eval\n" +
            "                                              INNER JOIN tbl_class_student cs ON eval.f_evaluator_id = cs.id\n" +
            "                                              INNER JOIN tbl_student student ON cs.student_id = student.id\n" +
            "                                              INNER JOIN tbl_class class ON eval.f_class_id = class.id\n" +
            "                                              INNER JOIN tbl_parameter_value\n" +
            "                                                         ON eval.f_evaluator_type_id = tbl_parameter_value.id\n" +
            "                                     WHERE student.national_code = :nationalCode\n" +
            "                                       AND class.student_online_eval_status = 1\n" +
            "                                       AND cs.evaluation_status_reaction = 1\n" +
            "                                       And tbl_parameter_value.c_code = '32'\n" +
            "                  ) evaluation ON (evaluation.class = tbl_class.id And evaluation.std = tbl_student.id)\n" +
            "                  WHERE tbl_student.national_code = :nationalCode\n" +
            "                  ORDER BY classid DESC) a\n" +
            "         WHERE rownum < ((:page * :sizee) + 1)\n" +
            "     )\n" +
            "WHERE r__ >= (((:page - 1) * :sizee) + 1)",nativeQuery = true)
    List<Object> findAllClassByStudent(String nationalCode, int page, Integer sizee);
    @Query(value = "SELECT *\n" +
            "FROM (\n" +
            "         SELECT a.*, rownum r__\n" +
            "         FROM (\n" +
            "                  SELECT DISTINCT tbl_student.national_code,\n" +
            "                                  tbl_class.id                                                     AS classid,\n" +
            "                                  tbl_class.f_teacher,\n" +
            "                                  tbl_class.c_code                                                 AS code,\n" +
            "                                  tbl_class.c_title_class                                          AS title,\n" +
            "                                  tbl_course.c_title_fa                                            AS name,\n" +
            "                                  tbl_class.n_max_capacity                                         AS capacity,\n" +
            "                                  tbl_class.n_h_duration                                           AS duration,\n" +
            "                                  view_complex.c_title                                             AS location,\n" +
            "                                  CASE\n" +
            "                                      WHEN tbl_class.c_status = 1 THEN\n" +
            "                                          4\n" +
            "                                      WHEN tbl_class.c_status = 2 THEN\n" +
            "                                          1\n" +
            "                                      WHEN tbl_class.c_status = 3 THEN\n" +
            "                                          2\n" +
            "                                      WHEN tbl_class.c_status = 4 THEN\n" +
            "                                          3\n" +
            "                                      WHEN tbl_class.c_status = 5 THEN\n" +
            "                                          2\n" +
            "                                      END                                                          AS coursestatus,\n" +
            "                                  CASE\n" +
            "                                      WHEN tbl_class.f_teaching_method_id = 639 THEN\n" +
            "                                          1\n" +
            "                                      ELSE\n" +
            "                                          2\n" +
            "                                      END                                                          AS classtype,\n" +
            "                                  tbl_class.c_start_date                                           AS startdate,\n" +
            "                                  tbl_class.c_end_date                                             AS finishdate,\n" +
            "                                  concat(concat(tbl_personal_info.c_first_name_fa, ' '),\n" +
            "                                         tbl_personal_info.c_last_name_fa)                         AS instructor,\n" +
            "                                  evaluation.eval,\n" +
            "                                  tbl_class.f_supervisor                                           AS supervisorId,\n" +
            "                                  tbl_class.f_planner                                              AS plannerId,\n" +
            "                                  concat(concat(supervisor.FIRST_NAME, ' '), supervisor.LAST_NAME) AS supervisorNAME,\n" +
            "                                  concat(concat(planner.FIRST_NAME, ' '), planner.LAST_NAME)       AS plannerNAME\n" +
            "                  FROM tbl_class_student\n" +
            "                           INNER JOIN tbl_class ON tbl_class_student.class_id = tbl_class.id\n" +
            "                           INNER JOIN tbl_course ON tbl_class.f_course = tbl_course.id\n" +
            "                           LEFT JOIN view_complex ON tbl_class.complex_id = view_complex.id\n" +
            "                           INNER JOIN tbl_student ON tbl_class_student.student_id = tbl_student.id\n" +
            "                           INNER JOIN tbl_teacher ON tbl_class.f_teacher = tbl_teacher.id\n" +
            "                           INNER JOIN tbl_personal_info ON tbl_teacher.f_personality = tbl_personal_info.id\n" +
            "                           left JOIN TBL_PERSONNEL planner on TBL_CLASS.F_PLANNER = planner.ID\n" +
            "                           left JOIN TBL_PERSONNEL supervisor on TBL_CLASS.F_SUPERVISOR = supervisor.ID\n" +
            "                           LEFT JOIN(SELECT student.id AS std,\n" +
            "                                            eval.id    AS eval,\n" +
            "                                            class.id   as class\n" +
            "                                     FROM tbl_evaluation eval\n" +
            "                                              INNER JOIN tbl_class_student cs ON eval.f_evaluator_id = cs.id\n" +
            "                                              INNER JOIN tbl_student student ON cs.student_id = student.id\n" +
            "                                              INNER JOIN tbl_class class ON eval.f_class_id = class.id\n" +
            "                                              INNER JOIN tbl_parameter_value\n" +
            "                                                         ON eval.f_evaluator_type_id = tbl_parameter_value.id\n" +
            "                                     WHERE student.national_code = :nationalCode\n" +
            "                                       AND class.student_online_eval_status = 1\n" +
            "                                       AND cs.evaluation_status_reaction = 1\n" +
            "                                       And tbl_parameter_value.c_code = '32'\n" +
            "                  ) evaluation ON (evaluation.class = tbl_class.id And evaluation.std = tbl_student.id)\n" +
            "                  WHERE tbl_student.national_code = :nationalCode\n" +
           "                    And  tbl_class.c_title_class like %:search%\n" +
            "                  ORDER BY classid DESC) a\n" +
            "         WHERE rownum < ((:page * :sizee) + 1)\n" +
            "     )\n" +
            "WHERE r__ >= (((:page - 1) * :sizee) + 1)",nativeQuery = true)
    List<Object> findAllClassByStudentFilter(String nationalCode,String search, int page, Integer sizee);
    @Query(value = "SELECT DISTINCT tbl_student.national_code,\n" +
            "                tbl_class.id                                                                             AS classid,\n" +
            "                tbl_class.f_teacher,\n" +
            "                tbl_class.c_code                                                                         AS code,\n" +
            "                tbl_class.c_title_class                                                                  AS title,\n" +
            "                tbl_course.c_title_fa                                                                    AS name,\n" +
            "                tbl_class.n_max_capacity                                                                 AS capacity,\n" +
            "                tbl_class.n_h_duration                                                                   AS duration,\n" +
            "                view_complex.c_title                                                                     AS location,\n" +
            "                CASE\n" +
            "                    WHEN tbl_class.c_status = 1 THEN\n" +
            "                        4\n" +
            "                    WHEN tbl_class.c_status = 2 THEN\n" +
            "                        1\n" +
            "                    WHEN tbl_class.c_status = 3 THEN\n" +
            "                        2\n" +
            "                    WHEN tbl_class.c_status = 4 THEN\n" +
            "                        3\n" +
            "                    WHEN tbl_class.c_status = 5 THEN\n" +
            "                        2\n" +
            "                    END                                                                                  AS coursestatus,\n" +
            "                CASE\n" +
            "                    WHEN tbl_class.f_teaching_method_id = 639 THEN\n" +
            "                        1\n" +
            "                    ELSE\n" +
            "                        2\n" +
            "                    END                                                                                  AS classtype,\n" +
            "                tbl_class.c_start_date                                                                   AS startdate,\n" +
            "                tbl_class.c_end_date                                                                     AS finishdate,\n" +
            "                concat(concat(tbl_personal_info.c_first_name_fa, ' '), tbl_personal_info.c_last_name_fa) AS instructor,\n" +
            "                evaluation.eval,\n" +
            "                tbl_class.f_supervisor                                                                   AS supervisorId,\n" +
            "                tbl_class.f_planner                                                                      AS plannerId,\n" +
            "                concat(concat(supervisor.FIRST_NAME, ' '), supervisor.LAST_NAME)                         AS supervisorNAME,\n" +
            "                concat(concat(planner.FIRST_NAME, ' '), planner.LAST_NAME)                               AS plannerNAME\n" +
            "FROM tbl_class_student\n" +
            "         INNER JOIN tbl_class ON tbl_class_student.class_id = tbl_class.id\n" +
            "         INNER JOIN tbl_course ON tbl_class.f_course = tbl_course.id\n" +
            "         LEFT JOIN view_complex ON tbl_class.complex_id = view_complex.id\n" +
            "         INNER JOIN tbl_student ON tbl_class_student.student_id = tbl_student.id\n" +
            "         INNER JOIN tbl_teacher ON tbl_class.f_teacher = tbl_teacher.id\n" +
            "         INNER JOIN tbl_personal_info ON tbl_teacher.f_personality = tbl_personal_info.id\n" +
            "         left JOIN TBL_PERSONNEL planner on TBL_CLASS.F_PLANNER = planner.ID\n" +
            "         left JOIN TBL_PERSONNEL supervisor on TBL_CLASS.F_SUPERVISOR = supervisor.ID\n" +
            "         LEFT JOIN(SELECT student.id AS std,\n" +
            "                          eval.id    AS eval,\n" +
            "                          class.id   as class\n" +
            "                   FROM tbl_evaluation eval\n" +
            "                            INNER JOIN tbl_class_student cs ON eval.f_evaluator_id = cs.id\n" +
            "                            INNER JOIN tbl_student student ON cs.student_id = student.id\n" +
            "                            INNER JOIN tbl_class class ON eval.f_class_id = class.id\n" +
            "                            INNER JOIN tbl_parameter_value ON eval.f_evaluator_type_id = tbl_parameter_value.id\n" +
            "                   WHERE student.national_code = :nationalCode\n" +
            "                     AND class.student_online_eval_status = 1\n" +
            "                     AND cs.evaluation_status_reaction = 1\n" +
            "                     And tbl_parameter_value.c_code = '32'\n" +
            ") evaluation ON (evaluation.class = tbl_class.id And evaluation.std = tbl_student.id)\n" +
            "WHERE tbl_student.national_code = :nationalCode \n" +
            "ORDER BY classid desc",nativeQuery = true)
    List<Object> findAllCountClassByStudent(String nationalCode);
    @Query(value = "SELECT DISTINCT tbl_student.national_code,\n" +
            "                tbl_class.id                                                                             AS classid,\n" +
            "                tbl_class.f_teacher,\n" +
            "                tbl_class.c_code                                                                         AS code,\n" +
            "                tbl_class.c_title_class                                                                  AS title,\n" +
            "                tbl_course.c_title_fa                                                                    AS name,\n" +
            "                tbl_class.n_max_capacity                                                                 AS capacity,\n" +
            "                tbl_class.n_h_duration                                                                   AS duration,\n" +
            "                view_complex.c_title                                                                     AS location,\n" +
            "                CASE\n" +
            "                    WHEN tbl_class.c_status = 1 THEN\n" +
            "                        4\n" +
            "                    WHEN tbl_class.c_status = 2 THEN\n" +
            "                        1\n" +
            "                    WHEN tbl_class.c_status = 3 THEN\n" +
            "                        2\n" +
            "                    WHEN tbl_class.c_status = 4 THEN\n" +
            "                        3\n" +
            "                    WHEN tbl_class.c_status = 5 THEN\n" +
            "                        2\n" +
            "                    END                                                                                  AS coursestatus,\n" +
            "                CASE\n" +
            "                    WHEN tbl_class.f_teaching_method_id = 639 THEN\n" +
            "                        1\n" +
            "                    ELSE\n" +
            "                        2\n" +
            "                    END                                                                                  AS classtype,\n" +
            "                tbl_class.c_start_date                                                                   AS startdate,\n" +
            "                tbl_class.c_end_date                                                                     AS finishdate,\n" +
            "                concat(concat(tbl_personal_info.c_first_name_fa, ' '), tbl_personal_info.c_last_name_fa) AS instructor,\n" +
            "                evaluation.eval,\n" +
            "                tbl_class.f_supervisor                                                                   AS supervisorId,\n" +
            "                tbl_class.f_planner                                                                      AS plannerId,\n" +
            "                concat(concat(supervisor.FIRST_NAME, ' '), supervisor.LAST_NAME)                         AS supervisorNAME,\n" +
            "                concat(concat(planner.FIRST_NAME, ' '), planner.LAST_NAME)                               AS plannerNAME\n" +
            "FROM tbl_class_student\n" +
            "         INNER JOIN tbl_class ON tbl_class_student.class_id = tbl_class.id\n" +
            "         INNER JOIN tbl_course ON tbl_class.f_course = tbl_course.id\n" +
            "         LEFT JOIN view_complex ON tbl_class.complex_id = view_complex.id\n" +
            "         INNER JOIN tbl_student ON tbl_class_student.student_id = tbl_student.id\n" +
            "         INNER JOIN tbl_teacher ON tbl_class.f_teacher = tbl_teacher.id\n" +
            "         INNER JOIN tbl_personal_info ON tbl_teacher.f_personality = tbl_personal_info.id\n" +
            "         left JOIN TBL_PERSONNEL planner on TBL_CLASS.F_PLANNER = planner.ID\n" +
            "         left JOIN TBL_PERSONNEL supervisor on TBL_CLASS.F_SUPERVISOR = supervisor.ID\n" +
            "         LEFT JOIN(SELECT student.id AS std,\n" +
            "                          eval.id    AS eval,\n" +
            "                          class.id   as class\n" +
            "                   FROM tbl_evaluation eval\n" +
            "                            INNER JOIN tbl_class_student cs ON eval.f_evaluator_id = cs.id\n" +
            "                            INNER JOIN tbl_student student ON cs.student_id = student.id\n" +
            "                            INNER JOIN tbl_class class ON eval.f_class_id = class.id\n" +
            "                            INNER JOIN tbl_parameter_value ON eval.f_evaluator_type_id = tbl_parameter_value.id\n" +
            "                   WHERE student.national_code = :nationalCode\n" +
            "                     AND class.student_online_eval_status = 1\n" +
            "                     AND cs.evaluation_status_reaction = 1\n" +
            "                     And tbl_parameter_value.c_code = '32'\n" +
            ") evaluation ON (evaluation.class = tbl_class.id And evaluation.std = tbl_student.id)\n" +
            "WHERE tbl_student.national_code = :nationalCode \n" +
           " And  tbl_class.c_title_class like %:search%\n" +
            "ORDER BY classid desc",nativeQuery = true)
    List<Object> findAllCountClassByStudentFilter(String nationalCode,String search);
    @Query(value = "SELECT DISTINCT\n" +
            "    tbl_student.national_code\n" +
            "FROM\n" +
            "         tbl_class_student\n" +
            "    INNER JOIN tbl_student ON tbl_class_student.student_id = tbl_student.id\n" +
            "    INNER JOIN tbl_class ON tbl_class_student.class_id = tbl_class.id\n" +
            "    WHERE tbl_class.c_start_date >= :startDate \n" +
            "    and tbl_class.c_end_date <= :endDate and tbl_student.national_code IN (:ids) ", nativeQuery = true)
    List<String> getStudentBetWeenRangeTime(String startDate, String endDate,List<String> ids);
    @Query(value = "\n" +
            "SELECT *\n" +
            "FROM (\n" +
            "         SELECT a.*, rownum r__\n" +
            "         FROM (\n" +
            "                  SELECT DISTINCT tbl_teacher.c_teacher_code,\n" +
            "                                  tbl_class.id                                                     AS classid,\n" +
            "                                  tbl_teacher.id                                                   AS teacherid,\n" +
            "                                  tbl_class.c_code                                                 AS code,\n" +
            "                                  tbl_class.c_title_class                                          AS title,\n" +
            "                                  tbl_course.c_title_fa                                            AS name,\n" +
            "                                  tbl_class.n_max_capacity                                         AS capacity,\n" +
            "                                  tbl_class.n_h_duration                                           AS duration,\n" +
            "                                  view_complex.c_title                                             AS location,\n" +
            "                                  CASE\n" +
            "                                      WHEN tbl_class.c_status = 1 THEN\n" +
            "                                          4\n" +
            "                                      WHEN tbl_class.c_status = 2 THEN\n" +
            "                                          1\n" +
            "                                      WHEN tbl_class.c_status = 3 THEN\n" +
            "                                          2\n" +
            "                                      WHEN tbl_class.c_status = 4 THEN\n" +
            "                                          3\n" +
            "                                      WHEN tbl_class.c_status = 5 THEN\n" +
            "                                          2\n" +
            "                                      END                                                          AS coursestatus,\n" +
            "                                  CASE\n" +
            "                                      WHEN tbl_class.f_teaching_method_id = 639 THEN\n" +
            "                                          1\n" +
            "                                      ELSE\n" +
            "                                          2\n" +
            "                                      END                                                          AS classtype,\n" +
            "                                  tbl_class.c_start_date                                           AS startdate,\n" +
            "                                  tbl_class.c_end_date                                             AS finishdate,\n" +
            "                                  concat(concat(tbl_personal_info.c_first_name_fa, ' '),\n" +
            "                                         tbl_personal_info.c_last_name_fa)                         as instructor,\n" +
            "                                  evaluation.eval,\n" +
            "                                  tbl_class.f_supervisor                                           AS supervisorId,\n" +
            "                                  tbl_class.f_planner                                              AS plannerId,\n" +
            "                                  concat(concat(supervisor.FIRST_NAME, ' '), supervisor.LAST_NAME) AS supervisorNAME,\n" +
            "                                  concat(concat(planner.FIRST_NAME, ' '), planner.LAST_NAME)       AS plannerNAME\n" +
            "                  FROM tbl_class_student\n" +
            "                           INNER JOIN tbl_class ON tbl_class_student.class_id = tbl_class.id\n" +
            "                           INNER JOIN tbl_teacher ON tbl_class.f_teacher = tbl_teacher.id\n" +
            "                           INNER JOIN tbl_course ON tbl_class.f_course = tbl_course.id\n" +
            "                           LEFT JOIN view_complex ON tbl_class.complex_id = view_complex.id\n" +
            "                           INNER JOIN tbl_personal_info ON tbl_teacher.f_personality = tbl_personal_info.id\n" +
            "                           LEFT JOIN TBL_PERSONNEL planner on TBL_CLASS.F_PLANNER = planner.ID\n" +
            "                           LEFT JOIN TBL_PERSONNEL supervisor on TBL_CLASS.F_SUPERVISOR = supervisor.ID\n" +
            "                           LEFT JOIN(\n" +
            "                      SELECT teacher.id AS std,\n" +
            "                             eval.id    AS eval,\n" +
            "                             class.id   AS class\n" +
            "                      FROM tbl_evaluation eval\n" +
            "                               INNER JOIN tbl_teacher teacher ON eval.f_evaluator_id = teacher.id\n" +
            "                               INNER JOIN tbl_personal_info personal ON teacher.f_personality = personal.id\n" +
            "                               INNER JOIN tbl_class class ON eval.f_class_id = class.id\n" +
            "                               INNER JOIN tbl_parameter_value ON eval.f_evaluator_type_id = tbl_parameter_value.id\n" +
            "                      WHERE personal.c_national_code = :nationalCode\n" +
            "                        AND class.teacher_online_eval_status = 1\n" +
            "                        AND tbl_parameter_value.c_code = '11'\n" +
            "                  ) evaluation ON (evaluation.class = tbl_class.id And evaluation.std = tbl_teacher.id)\n" +
            "                  WHERE tbl_teacher.c_teacher_code = :nationalCode\n" +
            " And  tbl_class.c_title_class like %:search%\n" +
            "                  ORDER BY classid Desc) a\n" +
            "         WHERE rownum < ((:page * :sizee) + 1)\n" +
            "     )\n" +
            "WHERE r__ >= (((:page - 1) * :sizee) + 1)",nativeQuery = true)
    List<Object> findAllClassByTeacherFilter(String nationalCode,String search, int page,int sizee);



    @Query(value = "\n" +
            "SELECT *\n" +
            "FROM (\n" +
            "         SELECT a.*, rownum r__\n" +
            "         FROM (\n" +
            "                  SELECT DISTINCT tbl_teacher.c_teacher_code,\n" +
            "                                  tbl_class.id                                                     AS classid,\n" +
            "                                  tbl_teacher.id                                                   AS teacherid,\n" +
            "                                  tbl_class.c_code                                                 AS code,\n" +
            "                                  tbl_class.c_title_class                                          AS title,\n" +
            "                                  tbl_course.c_title_fa                                            AS name,\n" +
            "                                  tbl_class.n_max_capacity                                         AS capacity,\n" +
            "                                  tbl_class.n_h_duration                                           AS duration,\n" +
            "                                  view_complex.c_title                                             AS location,\n" +
            "                                  CASE\n" +
            "                                      WHEN tbl_class.c_status = 1 THEN\n" +
            "                                          4\n" +
            "                                      WHEN tbl_class.c_status = 2 THEN\n" +
            "                                          1\n" +
            "                                      WHEN tbl_class.c_status = 3 THEN\n" +
            "                                          2\n" +
            "                                      WHEN tbl_class.c_status = 4 THEN\n" +
            "                                          3\n" +
            "                                      WHEN tbl_class.c_status = 5 THEN\n" +
            "                                          2\n" +
            "                                      END                                                          AS coursestatus,\n" +
            "                                  CASE\n" +
            "                                      WHEN tbl_class.f_teaching_method_id = 639 THEN\n" +
            "                                          1\n" +
            "                                      ELSE\n" +
            "                                          2\n" +
            "                                      END                                                          AS classtype,\n" +
            "                                  tbl_class.c_start_date                                           AS startdate,\n" +
            "                                  tbl_class.c_end_date                                             AS finishdate,\n" +
            "                                  concat(concat(tbl_personal_info.c_first_name_fa, ' '),\n" +
            "                                         tbl_personal_info.c_last_name_fa)                         as instructor,\n" +
            "                                  evaluation.eval,\n" +
            "                                  tbl_class.f_supervisor                                           AS supervisorId,\n" +
            "                                  tbl_class.f_planner                                              AS plannerId,\n" +
            "                                  concat(concat(supervisor.FIRST_NAME, ' '), supervisor.LAST_NAME) AS supervisorNAME,\n" +
            "                                  concat(concat(planner.FIRST_NAME, ' '), planner.LAST_NAME)       AS plannerNAME\n" +
            "                  FROM tbl_class_student\n" +
            "                           INNER JOIN tbl_class ON tbl_class_student.class_id = tbl_class.id\n" +
            "                           INNER JOIN tbl_teacher ON tbl_class.f_teacher = tbl_teacher.id\n" +
            "                           INNER JOIN tbl_course ON tbl_class.f_course = tbl_course.id\n" +
            "                           LEFT JOIN view_complex ON tbl_class.complex_id = view_complex.id\n" +
            "                           INNER JOIN tbl_personal_info ON tbl_teacher.f_personality = tbl_personal_info.id\n" +
            "                           LEFT JOIN TBL_PERSONNEL planner on TBL_CLASS.F_PLANNER = planner.ID\n" +
            "                           LEFT JOIN TBL_PERSONNEL supervisor on TBL_CLASS.F_SUPERVISOR = supervisor.ID\n" +
            "                           LEFT JOIN(\n" +
            "                      SELECT teacher.id AS std,\n" +
            "                             eval.id    AS eval,\n" +
            "                             class.id   AS class\n" +
            "                      FROM tbl_evaluation eval\n" +
            "                               INNER JOIN tbl_teacher teacher ON eval.f_evaluator_id = teacher.id\n" +
            "                               INNER JOIN tbl_personal_info personal ON teacher.f_personality = personal.id\n" +
            "                               INNER JOIN tbl_class class ON eval.f_class_id = class.id\n" +
            "                               INNER JOIN tbl_parameter_value ON eval.f_evaluator_type_id = tbl_parameter_value.id\n" +
            "                      WHERE personal.c_national_code = :nationalCode\n" +
            "                        AND class.teacher_online_eval_status = 1\n" +
            "                        AND tbl_parameter_value.c_code = '11'\n" +
            "                  ) evaluation ON (evaluation.class = tbl_class.id And evaluation.std = tbl_teacher.id)\n" +
            "                  WHERE tbl_teacher.c_teacher_code = :nationalCode and  tbl_class.c_evaluation !='1' \n" +
            " And  tbl_class.c_title_class like %:search%\n" +
            "                  ORDER BY classid Desc) a\n" +
            "         WHERE rownum < ((:page * :sizee) + 1)\n" +
            "     )\n" +
            "WHERE r__ >= (((:page - 1) * :sizee) + 1)",nativeQuery = true)
    List<Object> findAllClassByTeacherFilterForPre(String nationalCode,String search, int page,int sizee);


    @Query(value = "\n" +
            "SELECT *\n" +
            "FROM (\n" +
            "         SELECT a.*, rownum r__\n" +
            "         FROM (\n" +
            "                  SELECT DISTINCT tbl_teacher.c_teacher_code,\n" +
            "                                  tbl_class.id                                                     AS classid,\n" +
            "                                  tbl_teacher.id                                                   AS teacherid,\n" +
            "                                  tbl_class.c_code                                                 AS code,\n" +
            "                                  tbl_class.c_title_class                                          AS title,\n" +
            "                                  tbl_course.c_title_fa                                            AS name,\n" +
            "                                  tbl_class.n_max_capacity                                         AS capacity,\n" +
            "                                  tbl_class.n_h_duration                                           AS duration,\n" +
            "                                  view_complex.c_title                                             AS location,\n" +
            "                                  CASE\n" +
            "                                      WHEN tbl_class.c_status = 1 THEN\n" +
            "                                          4\n" +
            "                                      WHEN tbl_class.c_status = 2 THEN\n" +
            "                                          1\n" +
            "                                      WHEN tbl_class.c_status = 3 THEN\n" +
            "                                          2\n" +
            "                                      WHEN tbl_class.c_status = 4 THEN\n" +
            "                                          3\n" +
            "                                      WHEN tbl_class.c_status = 5 THEN\n" +
            "                                          2\n" +
            "                                      END                                                          AS coursestatus,\n" +
            "                                  CASE\n" +
            "                                      WHEN tbl_class.f_teaching_method_id = 639 THEN\n" +
            "                                          1\n" +
            "                                      ELSE\n" +
            "                                          2\n" +
            "                                      END                                                          AS classtype,\n" +
            "                                  tbl_class.c_start_date                                           AS startdate,\n" +
            "                                  tbl_class.c_end_date                                             AS finishdate,\n" +
            "                                  concat(concat(tbl_personal_info.c_first_name_fa, ' '),\n" +
            "                                         tbl_personal_info.c_last_name_fa)                         as instructor,\n" +
            "                                  evaluation.eval,\n" +
            "                                  tbl_class.f_supervisor                                           AS supervisorId,\n" +
            "                                  tbl_class.f_planner                                              AS plannerId,\n" +
            "                                  concat(concat(supervisor.FIRST_NAME, ' '), supervisor.LAST_NAME) AS supervisorNAME,\n" +
            "                                  concat(concat(planner.FIRST_NAME, ' '), planner.LAST_NAME)       AS plannerNAME,\n" +
            "                                  tbl_course.E_THEO_TYPE as thoe\n" +
            "                  FROM tbl_class_student\n" +
            "                           INNER JOIN tbl_class ON tbl_class_student.class_id = tbl_class.id\n" +
            "                           INNER JOIN tbl_teacher ON tbl_class.f_teacher = tbl_teacher.id\n" +
            "                           INNER JOIN tbl_course ON tbl_class.f_course = tbl_course.id\n" +
            "                           LEFT JOIN view_complex ON tbl_class.complex_id = view_complex.id\n" +
            "                           INNER JOIN tbl_personal_info ON tbl_teacher.f_personality = tbl_personal_info.id\n" +
            "                           LEFT JOIN TBL_PERSONNEL planner on TBL_CLASS.F_PLANNER = planner.ID\n" +
            "                           LEFT JOIN TBL_PERSONNEL supervisor on TBL_CLASS.F_SUPERVISOR = supervisor.ID\n" +
            "                           LEFT JOIN(\n" +
            "                      SELECT teacher.id AS std,\n" +
            "                             eval.id    AS eval,\n" +
            "                             class.id   AS class\n" +
            "                      FROM tbl_evaluation eval\n" +
            "                               INNER JOIN tbl_teacher teacher ON eval.f_evaluator_id = teacher.id\n" +
            "                               INNER JOIN tbl_personal_info personal ON teacher.f_personality = personal.id\n" +
            "                               INNER JOIN tbl_class class ON eval.f_class_id = class.id\n" +
            "                               INNER JOIN tbl_parameter_value ON eval.f_evaluator_type_id = tbl_parameter_value.id\n" +
            "                      WHERE personal.c_national_code = :nationalCode\n" +
            "                        AND class.teacher_online_eval_status = 1\n" +
            "                        AND tbl_parameter_value.c_code = '11'\n" +
            "                  ) evaluation ON (evaluation.class = tbl_class.id And evaluation.std = tbl_teacher.id)\n" +
            "                  WHERE tbl_teacher.c_teacher_code = :nationalCode  and    tbl_class.c_scoring_method != '1' and tbl_class.c_scoring_method != '4'   \n" +
            " And  tbl_class.c_title_class like %:search%\n" +
            "                  ORDER BY classid Desc) a\n" +
            "         WHERE rownum < ((:page * :sizee) + 1)\n" +
            "     )\n" +
            "WHERE r__ >= (((:page - 1) * :sizee) + 1)",nativeQuery = true)
    List<Object> findAllClassByTeacherFilterForExam(String nationalCode,String search, int page,int sizee);

    @Query(value = "\n" +
            "SELECT DISTINCT tbl_teacher.c_teacher_code,\n" +
            "                tbl_class.id                                                                             AS classid,\n" +
            "                tbl_teacher.id                                                                           AS teacherid,\n" +
            "                tbl_class.c_code                                                                         AS code,\n" +
            "                tbl_class.c_title_class                                                                  AS title,\n" +
            "                tbl_course.c_title_fa                                                                    AS name,\n" +
            "                tbl_class.n_max_capacity                                                                 AS capacity,\n" +
            "                tbl_class.n_h_duration                                                                   AS duration,\n" +
            "                view_complex.c_title                                                                     AS location,\n" +
            "                CASE\n" +
            "                    WHEN tbl_class.c_status = 1 THEN\n" +
            "                        4\n" +
            "                    WHEN tbl_class.c_status = 2 THEN\n" +
            "                        1\n" +
            "                    WHEN tbl_class.c_status = 3 THEN\n" +
            "                        2\n" +
            "                    WHEN tbl_class.c_status = 4 THEN\n" +
            "                        3\n" +
            "                    WHEN tbl_class.c_status = 5 THEN\n" +
            "                        2\n" +
            "                    END                                                                                  AS coursestatus,\n" +
            "                CASE\n" +
            "                    WHEN tbl_class.f_teaching_method_id = 639 THEN\n" +
            "                        1\n" +
            "                    ELSE\n" +
            "                        2\n" +
            "                    END                                                                                  AS classtype,\n" +
            "                tbl_class.c_start_date                                                                   AS startdate,\n" +
            "                tbl_class.c_end_date                                                                     AS finishdate,\n" +
            "                concat(concat(tbl_personal_info.c_first_name_fa, ' '), tbl_personal_info.c_last_name_fa) as instructor,\n" +
            "                evaluation.eval,\n" +
            "                tbl_class.f_supervisor                                                                   AS supervisorId,\n" +
            "                tbl_class.f_planner                                                                      AS plannerId,\n" +
            "                concat(concat(supervisor.FIRST_NAME, ' '), supervisor.LAST_NAME)                         AS supervisorNAME,\n" +
            "                concat(concat(planner.FIRST_NAME, ' '), planner.LAST_NAME)                               AS plannerNAME\n" +
            "FROM tbl_class_student\n" +
            "         INNER JOIN tbl_class ON tbl_class_student.class_id = tbl_class.id\n" +
            "         INNER JOIN tbl_teacher ON tbl_class.f_teacher = tbl_teacher.id\n" +
            "         INNER JOIN tbl_course ON tbl_class.f_course = tbl_course.id\n" +
            "         LEFT JOIN view_complex ON tbl_class.complex_id = view_complex.id\n" +
            "         INNER JOIN tbl_personal_info ON tbl_teacher.f_personality = tbl_personal_info.id\n" +
            "         LEFT JOIN TBL_PERSONNEL planner on TBL_CLASS.F_PLANNER = planner.ID\n" +
            "         LEFT JOIN TBL_PERSONNEL supervisor on TBL_CLASS.F_SUPERVISOR = supervisor.ID\n" +
            "         LEFT JOIN(\n" +
            "    SELECT teacher.id AS std,\n" +
            "           eval.id    AS eval,\n" +
            "           class.id   AS class\n" +
            "    FROM tbl_evaluation eval\n" +
            "             INNER JOIN tbl_teacher teacher ON eval.f_evaluator_id = teacher.id\n" +
            "             INNER JOIN tbl_personal_info personal ON teacher.f_personality = personal.id\n" +
            "             INNER JOIN tbl_class class ON eval.f_class_id = class.id\n" +
            "             INNER JOIN tbl_parameter_value ON eval.f_evaluator_type_id = tbl_parameter_value.id\n" +
            "    WHERE personal.c_national_code = :nationalCode\n" +
            "      AND class.teacher_online_eval_status = 1\n" +
            "      AND tbl_parameter_value.c_code = '11'\n" +
            ") evaluation ON (evaluation.class = tbl_class.id And evaluation.std = tbl_teacher.id)\n" +
            "WHERE tbl_teacher.c_teacher_code = :nationalCode \n" +
            " And  tbl_class.c_title_class like %:search%\n" +
            "ORDER BY classid Desc "
            ,nativeQuery = true)
    Collection<Object> findAllCountClassByTeacherFilter(String nationalCode,String search);




    @Query(value = "\n" +
            "SELECT DISTINCT tbl_teacher.c_teacher_code,\n" +
            "                tbl_class.id                                                                             AS classid,\n" +
            "                tbl_teacher.id                                                                           AS teacherid,\n" +
            "                tbl_class.c_code                                                                         AS code,\n" +
            "                tbl_class.c_title_class                                                                  AS title,\n" +
            "                tbl_course.c_title_fa                                                                    AS name,\n" +
            "                tbl_class.n_max_capacity                                                                 AS capacity,\n" +
            "                tbl_class.n_h_duration                                                                   AS duration,\n" +
            "                view_complex.c_title                                                                     AS location,\n" +
            "                CASE\n" +
            "                    WHEN tbl_class.c_status = 1 THEN\n" +
            "                        4\n" +
            "                    WHEN tbl_class.c_status = 2 THEN\n" +
            "                        1\n" +
            "                    WHEN tbl_class.c_status = 3 THEN\n" +
            "                        2\n" +
            "                    WHEN tbl_class.c_status = 4 THEN\n" +
            "                        3\n" +
            "                    WHEN tbl_class.c_status = 5 THEN\n" +
            "                        2\n" +
            "                    END                                                                                  AS coursestatus,\n" +
            "                CASE\n" +
            "                    WHEN tbl_class.f_teaching_method_id = 639 THEN\n" +
            "                        1\n" +
            "                    ELSE\n" +
            "                        2\n" +
            "                    END                                                                                  AS classtype,\n" +
            "                tbl_class.c_start_date                                                                   AS startdate,\n" +
            "                tbl_class.c_end_date                                                                     AS finishdate,\n" +
            "                concat(concat(tbl_personal_info.c_first_name_fa, ' '), tbl_personal_info.c_last_name_fa) as instructor,\n" +
            "                evaluation.eval,\n" +
            "                tbl_class.f_supervisor                                                                   AS supervisorId,\n" +
            "                tbl_class.f_planner                                                                      AS plannerId,\n" +
            "                concat(concat(supervisor.FIRST_NAME, ' '), supervisor.LAST_NAME)                         AS supervisorNAME,\n" +
            "                concat(concat(planner.FIRST_NAME, ' '), planner.LAST_NAME)                               AS plannerNAME\n" +
            "FROM tbl_class_student\n" +
            "         INNER JOIN tbl_class ON tbl_class_student.class_id = tbl_class.id\n" +
            "         INNER JOIN tbl_teacher ON tbl_class.f_teacher = tbl_teacher.id\n" +
            "         INNER JOIN tbl_course ON tbl_class.f_course = tbl_course.id\n" +
            "         LEFT JOIN view_complex ON tbl_class.complex_id = view_complex.id\n" +
            "         INNER JOIN tbl_personal_info ON tbl_teacher.f_personality = tbl_personal_info.id\n" +
            "         LEFT JOIN TBL_PERSONNEL planner on TBL_CLASS.F_PLANNER = planner.ID\n" +
            "         LEFT JOIN TBL_PERSONNEL supervisor on TBL_CLASS.F_SUPERVISOR = supervisor.ID\n" +
            "         LEFT JOIN(\n" +
            "    SELECT teacher.id AS std,\n" +
            "           eval.id    AS eval,\n" +
            "           class.id   AS class\n" +
            "    FROM tbl_evaluation eval\n" +
            "             INNER JOIN tbl_teacher teacher ON eval.f_evaluator_id = teacher.id\n" +
            "             INNER JOIN tbl_personal_info personal ON teacher.f_personality = personal.id\n" +
            "             INNER JOIN tbl_class class ON eval.f_class_id = class.id\n" +
            "             INNER JOIN tbl_parameter_value ON eval.f_evaluator_type_id = tbl_parameter_value.id\n" +
            "    WHERE personal.c_national_code = :nationalCode\n" +
            "      AND class.teacher_online_eval_status = 1\n" +
            "      AND tbl_parameter_value.c_code = '11'\n" +
            ") evaluation ON (evaluation.class = tbl_class.id And evaluation.std = tbl_teacher.id)\n" +
            "WHERE tbl_teacher.c_teacher_code = :nationalCode  and  tbl_class.c_evaluation !='1' \n" +
            " And  tbl_class.c_title_class like %:search%\n" +
            "ORDER BY classid Desc "
            ,nativeQuery = true)
    Collection<Object> findAllCountClassByTeacherFilterForPre(String nationalCode,String search);



    @Query(value = "\n" +
            "SELECT DISTINCT tbl_teacher.c_teacher_code,\n" +
            "                tbl_class.id                                                                             AS classid,\n" +
            "                tbl_teacher.id                                                                           AS teacherid,\n" +
            "                tbl_class.c_code                                                                         AS code,\n" +
            "                tbl_class.c_title_class                                                                  AS title,\n" +
            "                tbl_course.c_title_fa                                                                    AS name,\n" +
            "                tbl_class.n_max_capacity                                                                 AS capacity,\n" +
            "                tbl_class.n_h_duration                                                                   AS duration,\n" +
            "                view_complex.c_title                                                                     AS location,\n" +
            "                CASE\n" +
            "                    WHEN tbl_class.c_status = 1 THEN\n" +
            "                        4\n" +
            "                    WHEN tbl_class.c_status = 2 THEN\n" +
            "                        1\n" +
            "                    WHEN tbl_class.c_status = 3 THEN\n" +
            "                        2\n" +
            "                    WHEN tbl_class.c_status = 4 THEN\n" +
            "                        3\n" +
            "                    WHEN tbl_class.c_status = 5 THEN\n" +
            "                        2\n" +
            "                    END                                                                                  AS coursestatus,\n" +
            "                CASE\n" +
            "                    WHEN tbl_class.f_teaching_method_id = 639 THEN\n" +
            "                        1\n" +
            "                    ELSE\n" +
            "                        2\n" +
            "                    END                                                                                  AS classtype,\n" +
            "                tbl_class.c_start_date                                                                   AS startdate,\n" +
            "                tbl_class.c_end_date                                                                     AS finishdate,\n" +
            "                concat(concat(tbl_personal_info.c_first_name_fa, ' '), tbl_personal_info.c_last_name_fa) as instructor,\n" +
            "                evaluation.eval,\n" +
            "                tbl_class.f_supervisor                                                                   AS supervisorId,\n" +
            "                tbl_class.f_planner                                                                      AS plannerId,\n" +
            "                concat(concat(supervisor.FIRST_NAME, ' '), supervisor.LAST_NAME)                         AS supervisorNAME,\n" +
            "                concat(concat(planner.FIRST_NAME, ' '), planner.LAST_NAME)                               AS plannerNAME,\n" +
            "               tbl_course.E_THEO_TYPE as thoe\n" +
            "FROM tbl_class_student\n" +
            "         INNER JOIN tbl_class ON tbl_class_student.class_id = tbl_class.id\n" +
            "         INNER JOIN tbl_teacher ON tbl_class.f_teacher = tbl_teacher.id\n" +
            "         INNER JOIN tbl_course ON tbl_class.f_course = tbl_course.id\n" +
            "         LEFT JOIN view_complex ON tbl_class.complex_id = view_complex.id\n" +
            "         INNER JOIN tbl_personal_info ON tbl_teacher.f_personality = tbl_personal_info.id\n" +
            "         LEFT JOIN TBL_PERSONNEL planner on TBL_CLASS.F_PLANNER = planner.ID\n" +
            "         LEFT JOIN TBL_PERSONNEL supervisor on TBL_CLASS.F_SUPERVISOR = supervisor.ID\n" +
            "         LEFT JOIN(\n" +
            "    SELECT teacher.id AS std,\n" +
            "           eval.id    AS eval,\n" +
            "           class.id   AS class\n" +
            "    FROM tbl_evaluation eval\n" +
            "             INNER JOIN tbl_teacher teacher ON eval.f_evaluator_id = teacher.id\n" +
            "             INNER JOIN tbl_personal_info personal ON teacher.f_personality = personal.id\n" +
            "             INNER JOIN tbl_class class ON eval.f_class_id = class.id\n" +
            "             INNER JOIN tbl_parameter_value ON eval.f_evaluator_type_id = tbl_parameter_value.id\n" +
            "    WHERE personal.c_national_code = :nationalCode\n" +
            "      AND class.teacher_online_eval_status = 1\n" +
            "      AND tbl_parameter_value.c_code = '11'\n" +
            ") evaluation ON (evaluation.class = tbl_class.id And evaluation.std = tbl_teacher.id)\n" +
            "WHERE tbl_teacher.c_teacher_code = :nationalCode       and    tbl_class.c_scoring_method != '1' and tbl_class.c_scoring_method != '4'   \n" +
            " And  tbl_class.c_title_class like %:search%\n" +
            "ORDER BY classid Desc "
            ,nativeQuery = true)
    Collection<Object> findAllCountClassByTeacherFilterForExam(String nationalCode,String search);



    @Query(value = """
SELECT
    tbl_session.id,
    tbl_session.c_session_start_hour,
    tbl_session.c_session_end_hour,
    tbl_session.c_session_date,
    tbl_class.c_code,
    tbl_student.first_name,
    tbl_student.last_name
               \s
FROM
         tbl_class_student
    INNER JOIN tbl_class ON tbl_class_student.class_id = tbl_class.id
    INNER JOIN tbl_session ON tbl_session.f_class_id = tbl_class.id
    INNER JOIN tbl_student ON tbl_student.id = tbl_class_student.student_id
WHERE
    ( ( tbl_session.c_session_start_hour < :startHour
        AND tbl_session.c_session_end_hour > :startHour )
      OR ( tbl_session.c_session_start_hour < :endHour
           AND tbl_session.c_session_end_hour > :endHour )\s
             OR ( tbl_session.c_session_start_hour = :startHour
           AND tbl_session.c_session_end_hour = :endHour )
           )
    AND tbl_session.c_session_date = :sessionDate
    AND tbl_student.national_code = :nationalCode
""",nativeQuery = true)
    List<?> getSessionsInterferencePerStudent(@Param("sessionDate") String sessionDate,@Param("startHour") String startHour,@Param("endHour") String endHour, @Param("nationalCode") String nationalCode);

    @Query(value = "SELECT\n" +
            "    st.national_code\n" +
            "FROM\n" +
            "    tbl_class cl\n" +
            "    INNER JOIN tbl_class_student cs ON cl.id = cs.class_id\n" +
            "    INNER JOIN tbl_student       st ON st.id = cs.student_id\n" +
            "WHERE\n" +
            "    cl.id =:classId",nativeQuery = true)
    List<String> findClassStudentsNationalCodeByTclassId(long classId);


    @Query(value = " SELECT\n" +
            "    tbl_contact_info.c_mobile,\n" +
            "    concat(concat(tbl_student1.first_name, ' '), tbl_student1.last_name) fullname,\n" +
            "    tbl_course.c_title_fa,\n" +
            "    tbl_class_student.id,\n" +
            "    tbl_class_student.class_id,\n" +
            "    tbl_class.c_code\n" +
            "FROM\n" +
            "         tbl_class_student\n" +
            "    INNER JOIN tbl_class ON tbl_class_student.class_id = tbl_class.id\n" +
            "    INNER JOIN tbl_student ON tbl_class_student.student_id = tbl_student.id\n" +
            "    INNER JOIN tbl_contact_info ON tbl_student.f_contact_info = tbl_contact_info.id\n" +
            "    LEFT JOIN tbl_evaluation ON tbl_class.id = tbl_evaluation.f_class_id\n" +
            "                                AND tbl_class_student.id = tbl_evaluation.f_evaluator_id\n" +
            "                                AND ( tbl_evaluation.f_evaluator_type_id = 188\n" +
            "                                      AND tbl_evaluation.f_evaluation_level_id = 154 )\n" +
            "    INNER JOIN tbl_student tbl_student1 ON tbl_class_student.student_id = tbl_student1.id\n" +
            "    INNER JOIN tbl_course ON tbl_class.f_course = tbl_course.id\n" +
            "      outer apply ( select c_value  from TBL_PARAMETER_VALUE v where v.C_CODE = 'classBasisDate' ) classBasisDate\n" +
            "WHERE\n" +
            "    tbl_contact_info.c_mobile IS NOT NULL\n" +
            "    AND tbl_class.student_online_eval_status = 1\n" +
            "    AND tbl_class_student.evaluation_status_reaction = 1\n" +
            "                    and\n" +
            "                tbl_class.c_end_date > = classBasisDate.c_value",nativeQuery = true)
    List<?> findAllUsersForSenSmsForUnCompleteReactionEvaluation();



    @Query(value = """
SELECT
    *
FROM
         tbl_class_student
    INNER JOIN tbl_parameter_value ON tbl_class_student.scores_state_id = tbl_parameter_value.id
WHERE
    tbl_class_student.class_id = :classId
    AND
   \s
    tbl_parameter_value.c_code = :scoreCode
""",nativeQuery = true)
    List<ClassStudent> getAllStudentWithScoreCondition(Long classId,String scoreCode);



    @Query(value = """
SELECT  *
FROM
         tbl_class_student
    INNER JOIN tbl_student ON tbl_class_student.student_id = tbl_student.id
    INNER JOIN tbl_class ON tbl_class_student.class_id = tbl_class.id
    INNER JOIN tbl_course ON tbl_class.f_course = tbl_course.id
    WHERE tbl_student.national_code = :nationalCode
    and
    tbl_course.c_code = :code
""",nativeQuery = true)
    List<ClassStudent> checkStudentIsInCourse(String nationalCode, String code);



    @Query(value = """
SELECT  *
FROM
         tbl_class_student
    INNER JOIN tbl_student ON tbl_class_student.student_id = tbl_student.id
    INNER JOIN tbl_class ON tbl_class_student.class_id = tbl_class.id
    WHERE tbl_student.national_code = :nationalCode
    and
    tbl_class.c_code = :code
""",nativeQuery = true)
    List<ClassStudent> checkStudentIsInClass(String nationalCode, String code);




//    @Query(value = """
//            SELECT
//                tbl_class.c_start_date,
//                tbl_class.c_end_date,
//                tbl_parameter_value.c_title,
//                  view_last_md_employee_hr.c_mojtame_code       AS mojtama_id,   \s
//                                     view_last_md_employee_hr.ccp_complex   AS mojtama,   \s
//                                     view_last_md_employee_hr.c_moavenat_code    AS moavenat_id,   \s
//                                     view_last_md_employee_hr.ccp_assistant AS moavenat,   \s
//                                     view_last_md_employee_hr.c_omor_code       AS omoor_id,   \s
//                                     view_last_md_employee_hr.ccp_affairs   AS omoor  \s
//            FROM
//                     tbl_class_student
//                INNER JOIN tbl_class ON tbl_class_student.class_id = tbl_class.id
//                left JOIN tbl_parameter_value ON tbl_class_student.type_of_enter_to_class = tbl_parameter_value.
//                id
//                                     INNER JOIN tbl_student std  ON tbl_class_student.student_id = std.id
//                                                                                       LEFT JOIN view_last_md_employee_hr  ON std.NATIONAL_CODE = view_last_md_employee_hr.C_NATIONAL_CODE
//                                                                                      \s
//                                                                                       WHERE
//                                                                                          tbl_class.C_START_DATE >= :fromDate             \s
//                                                                                       and tbl_class.C_START_DATE <= :toDate\s
//""", nativeQuery = true)
//    List<GenericStatisticalIndexReport> typeOfEnterToClassReport(String fromDate,
//                                                              String toDate,
//                                                              List<Object> complex,
//                                                              int complexNull,
//                                                              List<Object> assistant,
//                                                              int assistantNull,
//                                                              List<Object> affairs,
//                                                              int affairsNull);
//
                                            }
