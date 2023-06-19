package com.nicico.training.repository;

import com.nicico.training.model.Course;
import com.nicico.training.model.Tclass;
import com.nicico.training.model.Teacher;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.*;
import org.springframework.data.repository.query.Param;
import org.springframework.lang.Nullable;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

@Repository
public interface TclassDAO extends JpaRepository<Tclass, Long>, JpaSpecificationExecutor<Tclass> {

    List<Tclass> findByCourseIdAndTermId(Long courseId, Long termId);

    Tclass findFirstByCode (String code);

    @Query(value = """
SELECT
    tbl_course.c_code
FROM
         tbl_class
    INNER JOIN tbl_course ON tbl_class.f_course = tbl_course.id
    WHERE
    tbl_class.c_code = :code
""", nativeQuery = true)
    Object getCourseCodeByClassByCode(String code);

    @Modifying
    @Query(value = "update TBL_CLASS set C_WORKFLOW_ENDING_STATUS = :workflowEndingStatus, C_WORKFLOW_ENDING_STATUS_CODE = :workflowEndingStatusCode, C_STATUS_DATE = :statusDate where ID = :classId", nativeQuery = true)
    int updateClassState(Long classId, String workflowEndingStatus, Integer workflowEndingStatusCode, Date statusDate);

    @Query(value = "select MAX(C_WORKFLOW_ENDING_STATUS_CODE) from TBL_CLASS where ID = :classId", nativeQuery = true)
    Integer getWorkflowEndingStatusCode(Long classId);

    @Query(value = "select * from TBL_CLASS where F_TEACHER = :tID", nativeQuery = true)
    List<Tclass> getTeacherClasses(Long tID);

    @Query(value = "SELECT SUM(C.n_h_duration) as TrainingTime FROM tbl_class_student CS INNER JOIN tbl_class C ON C.id = CS.class_id INNER JOIN tbl_student S ON S.id = CS.student_id WHERE (S.national_code =:national_code OR S.personnel_no = :personnel_no) AND INSTR(C.c_start_date, :year) > 0", nativeQuery = true)
    Long getStudentTrainingTime(String national_code, String personnel_no, String year);

    @Query(value = " SELECT  " +
            "    c.id,c.c_code, c.c_title_class, c.n_h_duration , c.c_start_date, c.c_end_date, c.c_status as classStatus_id,  " +
            "    case when c.c_status = 1 then 'برنامه ریزی' when c.c_status = 2 then 'در حال اجرا' when c.c_status = 3 then 'پایان یافته' end as classStatus,  " +
            "    cs.scores_state_id, " +
            "    '(<b class=\"'|| case when scores_state_id = 400 or scores_state_id =401 then 'acceptRTL' when scores_state_id = 403 then 'rejectedRTL' end ||'\">' || pa.c_title || '</b>)' || case when cs.score is not null then ' نمره: ' || cs.score else '' end || case when   cs.failure_reason_id is not null then ' <' ||  pa2.c_title || '>' else '' end as score_state,   " +
            "    case when co.e_run_type = 1 then 'داخلي' when co.e_run_type = 2 then 'اعزام' when co.e_run_type = 3 then 'سمينار داخلي'  " +
            "     when co.e_run_type = 4 then 'سمينار اعزام' when co.e_run_type = 5 then 'حين كار' when co.e_run_type = 6 then 'خارجی'  " +
            "      when co.e_run_type = 7 then 'سمینار خارجی' when co.e_run_type = 8 then 'مجازي' when co.e_run_type = 9 then 'بازآموزي'  " +
            "       when co.e_run_type = 10 then 'جعبه ابزار' end as ERun_Type, co.id as course_id, co.c_title_fa as course_title,  " +
            "       cs.failure_reason_id,pa2.c_title AS failure_reason , co.c_code as course_code " +
            " FROM  " +
            "    tbl_class c  " +
            "    INNER JOIN tbl_class_student cs ON c.id = cs.class_id  " +
            "    INNER JOIN tbl_student s ON s.id = cs.student_id  " +
            "    INNER JOIN tbl_course co ON co.id = c.f_course  " +
            "    LEFT JOIN tbl_parameter_value pa ON cs.scores_state_id = pa.id " +
            "    LEFT JOIN tbl_parameter_value pa2 ON cs.failure_reason_id = pa2.id " +
            " WHERE  " +
            "    s.national_code =:national_code OR s.personnel_no = :personnel_no ", nativeQuery = true)
    List<?> findAllPersonnelClass(String national_code, String personnel_no);

    @Query(value = " select " +
            "       id, " +
            "       c_code, " +
            "       c_title_class, " +
            "       n_h_duration, " +
            "       c_start_date, " +
            "       c_end_date, " +
            "       classStatus_id, " +
            "       scores_state_id, " +
            "       score_state, " +
            "       failure_reason_id, " +
            "       failure_reason " +
            "from ( " +
            "         SELECT c.f_course                                                                             AS f_course, " +
            "                c.id                                                                                   AS id, " +
            "                '<b class=\"clickableCell\">' || c.c_code || '</b>'                                      AS c_code, " +
            "                c.c_title_class                                                                        AS c_title_class, " +
            "                c.n_h_duration                                                                         AS n_h_duration, " +
            "                c.c_start_date                                                                         AS c_start_date, " +
            "                c.c_end_date                                                                           AS c_end_date, " +
            "                c.c_status                                                                             as classStatus_id, " +
            "                cs.scores_state_id                                                                     AS scores_state_id, " +
            "                '(<b class=\"' || case " +
            "                                     when scores_state_id = 400 or scores_state_id = 401 then 'acceptRTL' " +
            "                                     when scores_state_id = 403 then 'rejectedRTL' end || '\">' || pa.c_title || " +
            "                '</b>)' || " +
            "                case when cs.score is not null then ' نمره: ' || cs.score else '' end || " +
            "                case when cs.failure_reason_id is not null then ' <' || pa2.c_title || '>' else '' end AS score_state, " +
            "                cs.failure_reason_id                                                                   AS failure_reason_id, " +
            "                pa2.c_title                                                                            AS failure_reason, " +
            "                rank() over (order by c.c_end_date desc)                                                  rnk " +
            "         FROM tbl_class c " +
            "                  INNER JOIN tbl_class_student cs ON c.id = cs.class_id " +
            "                  INNER JOIN tbl_student s ON s.id = cs.student_id " +
            "                  INNER JOIN tbl_course co ON co.id = c.f_course " +
            "                  LEFT JOIN tbl_parameter_value pa ON cs.scores_state_id = pa.id " +
            "                  LEFT JOIN tbl_parameter_value pa2 ON cs.failure_reason_id = pa2.id " +
            "         WHERE c.f_course =:courseId " +
            "           and (s.national_code =:national_code " +
            "             OR s.personnel_no =:personnel_no)) WHERE rnk = 1", nativeQuery = true)
    List<?> findPersonnelClassByCourseId(String national_code, String personnel_no, Long courseId);

    List<Tclass> findTclassesByCourseId(Long id);

    List<Tclass> findByCourseAndTeacher(Course course, Teacher teacher);

    List<Tclass> findByTeacherId(Long teacherId);

    @Query(value = "SELECT max(tClass.C_START_DATE) FROM TBL_CLASS tClass WHERE tClass.F_TEACHER = :teacherId", nativeQuery = true)
    String findLastTeacherClassStartDate(Long teacherId);

    Tclass findTclassByIdEquals(Long classId);

    @EntityGraph(attributePaths = {"institute", "organizer", "course", "term", "classStudents", "classStudents.student", "course.category", "course.subCategory", "trainingPlaceSet", "teacher", "teacher.personality"})
    List<Tclass> getTclassByCourseIdEquals(Long courseId);

    @Modifying
    @Query(value = "update tbl_class set C_HAS_WARNING = :hasWarning where ID = :classId", nativeQuery = true)
    int updateClassHasWarning(Long classId, String hasWarning);

    @Modifying
    @Query(value = " update tbl_class " +
            " set c_has_warning = " +
            " (SELECT DISTINCT " +
            "    case when tbl_alarm.f_class_id is null and tbl_alarm.f_class_id_conflict is null then null else 'alarm' end as alarmStatus " +
            " FROM " +
            "    tbl_alarm  " +
            " WHERE tbl_class.id = :class_id and  (tbl_class.id = tbl_alarm.f_class_id or tbl_class.id = tbl_alarm.f_class_id_conflict)) " +
            " where tbl_class.id = :class_id and tbl_class.c_status <> 3 ", nativeQuery = true)
    int updateAllClassHasWarning(Long class_id);

    @Query(value = "select max(f_term) from tbl_class where id = :classId", nativeQuery = true)
    Long getTermIdByClassId(Long classId);

    @EntityGraph(attributePaths = {"institute", "course", "term", "course.category", "course.subCategory", "classStudents", "classStudents.student", "teacher", "teacher.personality", "trainingPlaceSet"})
    @Override
    List<Tclass> findAll(@Nullable Specification<Tclass> var1);

    boolean existsByTermId(Long termId);

    @Query(value = "select COUNT(*) from tbl_class_student where class_id = :classId \n" +
            "and\n" +
            "pre_test_score is not null", nativeQuery = true)
    Integer checkIfClassHasPreTest(Long classId);

    @Modifying
    @Query(value = "update TBL_CLASS set evaluation_reaction_teacher = :teacherReactionStatus where ID = :classId", nativeQuery = true)
    void updateTeacherReactionStatus(Integer teacherReactionStatus, Long classId);

    @Modifying
    @Transactional
    @Query(value = "update TBL_CLASS set evaluation_reaction_training = :trainingReactionStatus where ID = :classId", nativeQuery = true)
    void updateTrainingReactionStatus(Integer trainingReactionStatus, Long classId);

    @Transactional
    @Query(value = "select evaluation_reaction_teacher from TBL_CLASS where ID = :classId", nativeQuery = true)
    Integer getTeacherReactionStatus(Long classId);

    @Transactional
    @Query(value = "select evaluation_reaction_training from TBL_CLASS where ID = :classId", nativeQuery = true)
    Integer getTrainingReactionStatus(Long classId);

    @Transactional
    @Query(value = "select tmp_table.class_id,count(*) from (select cs.class_id from tbl_class_student cs inner join (select st.id,INF.MOBILE_FOR_SMS MOBILE from tbl_student st left join " +
            " VIEW_CONTACT_INFO inf on st.f_contact_info = inf.id) st on st.id=cs.student_id where cs.class_id in (:classIds) and " +
            " not EXISTS (select NULL from tbl_message_contact mc inner join tbl_message m on m.id=mc.f_message_id where mc.n_count_sent>0 and m.f_message_class = cs.class_id and " +
            "m.f_message_user_type=679 and mc.c_object_mobile=st.mobile)) tmp_table group by tmp_table.class_id", nativeQuery = true)
    List<Object> checkClassesForSendMessage(List<Long> classIds);

//    @Modifying
//    @Query(value = "update TBL_CLASS set TEACHER_ONLINE_EVAL_STATUS = :state where ID = :classId", nativeQuery = true)
//    public void changeOnlineEvalTeacherStatus(Long classId, boolean state);
//
//    @Modifying
//    @Query(value = "update TBL_CLASS set STUDENT_ONLINE_EVAL_STATUS = :state where ID = :classId", nativeQuery = true)
//    public void changeOnlineEvalStudentStatus(Long classId, boolean state);

    @Modifying
    @Query(value = "update TBL_CLASS set C_STATUS = :state where ID = :classId", nativeQuery = true)
    void changeClassStatus(Long classId, String state);

    @Modifying
    @Query(value = "update TBL_CLASS set B_CLASS_TO_ONLINE_STATUS =:state where ID =:classId", nativeQuery = true)
    void changeClassToOnlineStatus(Long classId, boolean state);

    @Query(value = "select * from tbl_class_aud  where ID = :classId ORDER BY rev", nativeQuery = true)
    List<Tclass> getAuditData(long classId);

    @Query(value = "SELECT * FROM TBL_CLASS WHERE c_status = :status And f_teaching_method_id IN (:longs)", nativeQuery = true)
    List<Tclass> findAllClassWithThisFilter(List<Long> longs, String status);

    @Query(value = "SELECT  * FROM TBL_CLASS WHERE c_status= :status And f_teaching_method_id IN (:longs) And  f_term= :termId ",nativeQuery = true)
    Page<Tclass> findAllClassWithTermFilter(List<Long> longs, String status, Long termId, Pageable pageable);

    @Modifying
    @Query(value = "update TBL_CLASS set C_RELEASE_DATE =:date where ID IN (:classIds)", nativeQuery = true)
    void updateReleaseDate(List<Long> classIds, String date);

    @Modifying
    @Query(value = "update TBL_CLASS u\n" +
            "set\n" +
            "    u.C_STATUS = '2'     \n" +
            "where 1=1\n" +
            "     and  u.C_START_DATE >= '1401/01/01'\n" +
            " and   u.C_START_DATE <= :toDay \n" +
            "     and u.C_STATUS =  '1' \n" +
            "      and u.id in ( select cs.CLASS_ID\n" +
            "                    from  TBL_CLASS_STUDENT cs\n" +
            "                    where cs.CLASS_ID = u.id\n" +
            "                     )", nativeQuery = true)
    void updateClassStatus(String toDay);

    @Modifying
    @Query(value = "update tbl_class set calendar_id = null where calendar_id = :calendarId", nativeQuery = true)
    void updateAllSetToNullByEducationalCalenderId(@Param("calendarId") Long id);


    @Query(value = """
            SELECT
                tbl_class.id,
                tbl_course.c_title_fa,
                tbl_class.c_end_date,
                tbl_class.c_start_date,
                tbl_course.n_theory_duration,
                tbl_student.last_name,
                tbl_student.first_name,
                tbl_class.c_code,
                view_complex.c_title
            FROM
                tbl_student
                INNER JOIN tbl_class_student ON tbl_class_student.student_id = tbl_student.id
                INNER JOIN tbl_class ON tbl_class.id = tbl_class_student.class_id
                INNER JOIN tbl_course ON tbl_class.f_course = tbl_course.id
                INNER JOIN view_complex ON tbl_class.complex_id = view_complex.id
            WHERE
                tbl_class.id IN (
                    :classId
                )
                AND tbl_class.c_status IN (
                    3,
                    5
                )
                AND tbl_class_student.scores_state_id IN (
                    400,
                    401
                )
                AND tbl_student.national_code = :nationalCode
            ORDER BY
                tbl_class.id
            """, nativeQuery = true)
    List<?> getCertification(@Param("nationalCode") String nationalCode, @Param("classId") Long classId, Pageable limit);

    @Query(value = """
            SELECT
                             tbl_class_student.scores_state_id,
                             tbl_class_student.score,
                             tbl_student.first_name,
                             tbl_student.last_name,
                             tbl_course.c_title_fa,
                             tbl_course.n_theory_duration,
                             tbl_class.c_start_date,
                             tbl_class.c_end_date
                         FROM
                             tbl_student
                             INNER JOIN tbl_class_student ON tbl_class_student.student_id = tbl_student.id
                             INNER JOIN tbl_class ON tbl_class.id = tbl_class_student.class_id
                             INNER JOIN tbl_course ON tbl_class.f_course = tbl_course.id
                         WHERE
                             tbl_student.national_code = :nationalcode
                             AND tbl_class.id IN (
                                 :classid
                             )
                         """, nativeQuery = true)
    List<?> getCertificationConfirmation(@Param("nationalcode") String nationalCode, @Param("classid") Long classId);


}