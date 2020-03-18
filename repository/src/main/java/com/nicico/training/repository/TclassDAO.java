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

    @Query(value = "SELECT C.* FROM tbl_class C INNER JOIN tbl_class_student CS ON C.id = CS.class_id  INNER JOIN tbl_student S ON S.id = CS.student_id WHERE S.national_code = :national_code", nativeQuery = true)
    public List<Tclass> findAllPersonnelClass(String national_code);

}