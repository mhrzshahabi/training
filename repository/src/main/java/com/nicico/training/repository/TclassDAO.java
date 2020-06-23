package com.nicico.training.repository;
/* com.nicico.training.repository
@Author:roya
*/

import com.nicico.training.model.Course;
import com.nicico.training.model.Tclass;
import com.nicico.training.model.Teacher;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.*;
import org.springframework.lang.Nullable;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

@Repository
public interface TclassDAO extends JpaRepository<Tclass, Long>, JpaSpecificationExecutor<Tclass> {

    /*@EntityGraph(attributePaths = {"institute","course","term","course.category","course.subCategory"})
    @Override
    Page<Tclass> findAll(@Nullable Specification<Tclass> var1, Pageable var2);*/

    List<Tclass> findByCourseIdAndTermId(Long courseId, Long termId);

    @Modifying
    @Query(value = "update TBL_CLASS set C_WORKFLOW_ENDING_STATUS = :workflowEndingStatus, C_WORKFLOW_ENDING_STATUS_CODE = :workflowEndingStatusCode, C_STATUS_DATE = :statusDate where ID = :classId", nativeQuery = true)
    public int updateClassState(Long classId, String workflowEndingStatus, Integer workflowEndingStatusCode, Date statusDate);

    @Query(value = "select MAX(C_WORKFLOW_ENDING_STATUS_CODE) from TBL_CLASS where ID = :classId", nativeQuery = true)
    public Integer getWorkflowEndingStatusCode(Long classId);

    @Query(value = "select * from TBL_CLASS where F_TEACHER = :tID", nativeQuery = true)
    public List<Tclass> getTeacherClasses(Long tID);

    @Query(value = "SELECT SUM(C.n_h_duration) as TrainingTime FROM tbl_class_student CS INNER JOIN tbl_class C ON C.id = CS.class_id INNER JOIN tbl_student S ON S.id = CS.student_id WHERE (S.national_code =:national_code OR S.personnel_no = :personnel_no) AND INSTR(C.c_start_date, :year) > 0", nativeQuery = true)
    public Long getStudentTrainingTime(String national_code, String personnel_no, String year);

    @Query(value = " SELECT  " +
            "    c.id, '<b class=\"clickableCell\">' || c.c_code || '</b>', c.c_title_class, c.n_h_duration , c.c_start_date, c.c_end_date, c.c_status as classStatus_id,  " +
            "    case when c.c_status = 1 then 'برنامه ریزی' when c.c_status = 2 then 'در حال اجرا' when c.c_status = 3 then 'پایان یافته' end as classStatus,  " +
            "    cs.scores_state_id, " +
            "    '(<b class=\"'|| case when scores_state_id = 400 or scores_state_id =401 then 'acceptRTL' when scores_state_id = 403 then 'rejectedRTL' end ||'\">' || pa.c_title || '</b>)' || case when cs.score is not null then ' نمره: ' || cs.score else '' end || case when   cs.failure_reason_id is not null then ' <' ||  pa2.c_title || '>' else '' end as score_state,   " +
            "    case when co.e_run_type = 1 then 'داخلي' when co.e_run_type = 2 then 'اعزام' when co.e_run_type = 3 then 'سمينار داخلي'  " +
            "     when co.e_run_type = 4 then 'سمينار اعزام' when co.e_run_type = 5 then 'حين كار' when co.e_run_type = 6 then 'خارجی'  " +
            "      when co.e_run_type = 7 then 'سمینار خارجی' when co.e_run_type = 8 then 'مجازي' when co.e_run_type = 9 then 'بازآموزي'  " +
            "       when co.e_run_type = 10 then 'جعبه ابزار' end as ERun_Type, co.id as course_id, co.c_title_fa as course_title,  " +
            "       cs.failure_reason_id,pa2.c_title AS failure_reason  " +
            " FROM  " +
            "    tbl_class c  " +
            "    INNER JOIN tbl_class_student cs ON c.id = cs.class_id  " +
            "    INNER JOIN tbl_student s ON s.id = cs.student_id  " +
            "    INNER JOIN tbl_course co ON co.id = c.f_course  " +
            "    LEFT JOIN tbl_parameter_value pa ON cs.scores_state_id = pa.id " +
            "    LEFT JOIN tbl_parameter_value pa2 ON cs.failure_reason_id = pa2.id " +
            " WHERE  " +
            "    s.national_code =:national_code OR s.personnel_no = :personnel_no ", nativeQuery = true)
    public List<?> findAllPersonnelClass(String national_code, String personnel_no);

    public List<?> findAllTclassByCourseId(Long id);

    public List<Tclass> findTclassesByCourseId(Long id);

    List<Tclass> findByCourseAndTeacher(Course course, Teacher teacher);

    List<Tclass> findByCourseIdAndTeacherId(Long courseId, Long teacherId);

    List<Tclass> findByTeacherId(Long teacherId);

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
            " WHERE tbl_class.id = tbl_alarm.f_class_id or tbl_class.id = tbl_alarm.f_class_id_conflict) " +
            " where tbl_class.c_status <> 3 ", nativeQuery = true)
    int updateAllClassHasWarning();

    @Query(value = "select max(f_term) from tbl_class where id = :classId", nativeQuery = true)
    Long getTermIdByClassId(Long classId);

    @EntityGraph(attributePaths = {"institute", "course", "term", "course.category", "course.subCategory", "classStudents", "classStudents.student", "teacher", "teacher.personality", "trainingPlaceSet"})
    @Override
    List<Tclass> findAll(@Nullable Specification<Tclass> var1);

    boolean existsByTermId(Long termId);

    @Query(value = "select pre_course_test from tbl_class where ID = :classId", nativeQuery = true)
    Integer checkIfClassHasPreTest(Long classId);

    @Modifying
    @Query(value = "update TBL_CLASS set evaluation_reaction_teacher = :teacherReactionStatus where ID = :classId", nativeQuery = true)
    public void updateTeacherReactionStatus(Integer teacherReactionStatus, Long classId);

    @Modifying
    @Transactional
    @Query(value = "update TBL_CLASS set evaluation_reaction_training = :trainingReactionStatus where ID = :classId", nativeQuery = true)
    public void updateTrainingReactionStatus(Integer trainingReactionStatus, Long classId);



}