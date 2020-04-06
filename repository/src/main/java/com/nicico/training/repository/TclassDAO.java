package com.nicico.training.repository;
/* com.nicico.training.repository
@Author:roya
*/

import com.nicico.training.model.Tclass;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;

@Repository
public interface TclassDAO extends JpaRepository<Tclass, Long>, JpaSpecificationExecutor<Tclass> {

    List<Tclass> findByCourseIdAndTermId(Long courseId, Long termId);

    @Modifying
    @Query(value = "update TBL_CLASS set C_WORKFLOW_ENDING_STATUS = :workflowEndingStatus, C_WORKFLOW_ENDING_STATUS_CODE = :workflowEndingStatusCode, C_STATUS_DATE = :statusDate where ID = :classId", nativeQuery = true)
    public int updateClassState(Long classId, String workflowEndingStatus, Integer workflowEndingStatusCode, Date statusDate);

    @Query(value = "select MAX(C_WORKFLOW_ENDING_STATUS_CODE) from TBL_CLASS where ID = :classId", nativeQuery = true)
    public Integer getWorkflowEndingStatusCode(Long classId);

    @Query(value = "select * from TBL_CLASS where F_TEACHER = :tID", nativeQuery = true)
    public List<Tclass> getTeacherClasses(Long tID);

    @Query(value = "SELECT SUM(C.n_h_duration) as TrainingTime FROM tbl_class_student CS INNER JOIN tbl_class C ON C.id = CS.class_id INNER JOIN tbl_student S ON S.id = CS.student_id WHERE S.national_code =:national_code AND INSTR(C.c_start_date, :year) > 0", nativeQuery = true)
    public Long getStudentTrainingTime(String national_code, String year);

    @Query(value = " SELECT " +
            "    c.id, '<b class=\"clickableCell\">' || c.c_code || '</b>', c.c_title_class, c.n_h_duration , c.c_start_date, c.c_end_date, c.c_status as classStatus_id, " +
            "    case when c.c_status = 1 then 'برنامه ریزی' when c.c_status = 2 then 'در حال اجرا' when c.c_status = 3 then 'پایان یافته' end as classStatus, " +
            "    case when INSTR(cs.scores_state, 'قبول')>0 then 1 when INSTR(cs.scores_state, 'مردود')>0 then 0 end as score_state_id, " +
            "    '(<b class=\"'|| case when INSTR(cs.scores_state, 'قبول')>0 then 'acceptRTL' when INSTR(cs.scores_state, 'مردود')>0 then 'rejectedRTL' end ||'\">' || cs.scores_state || '</b>)' || case when cs.score is not null then ' نمره: ' || cs.score else '' end || case when  cs.failure_reason is not null then ' <' ||  cs.failure_reason || '>' else '' end as score_state, " +
            "    case when co.e_run_type = 1 then 'داخلي' when co.e_run_type = 2 then 'اعزام' when co.e_run_type = 3 then 'سمينار داخلي' " +
            "     when co.e_run_type = 4 then 'سمينار اعزام' when co.e_run_type = 5 then 'حين كار' when co.e_run_type = 6 then 'خارجی' " +
            "      when co.e_run_type = 7 then 'سمینار خارجی' when co.e_run_type = 8 then 'مجازي' when co.e_run_type = 9 then 'بازآموزي' " +
            "       when co.e_run_type = 10 then 'جعبه ابزار' end as ERun_Type, co.id as course_id, co.c_title_fa as course_title " +
            " FROM " +
            "    tbl_class c " +
            "    INNER JOIN tbl_class_student cs ON c.id = cs.class_id " +
            "    INNER JOIN tbl_student s ON s.id = cs.student_id " +
            "    INNER JOIN tbl_course co ON co.id = c.f_course " +
            " WHERE " +
            "    s.national_code =:national_code ", nativeQuery = true)
    public List<?> findAllPersonnelClass(String national_code);

    Tclass findTclassByIdEquals(Long classId);

}