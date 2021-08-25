package com.nicico.training.repository;
/* com.nicico.training.repository
@Author:roya
*/

import com.nicico.training.model.Student;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@Repository
public interface StudentDAO extends JpaRepository<Student, Long>, JpaSpecificationExecutor<Student> {

    @Query(value = "select Tbl_Class_Student.F_Class from tbl_student join Tbl_Class_Student  on tbl_student.id = Tbl_Class_Student.F_Student   where (tbl_student.nationalcode=:nationalCode and Tbl_Class_Student.f.class=:classId )", nativeQuery = true)
    List<Long> findOneByNationalCodeInClass(@Param("nationalCode") String nationalCode, @Param("classId") Long classId);

    Optional<Student> findByPersonnelNo(@Param("personnelNo") String personnelNo);

    List<Student> findByPostIdAndPersonnelNoAndDepartmentIdAndFirstNameAndLastNameOrderByIdDesc(Long postId, String personnelNo, Long depId, String fName, String lName);
    List<Student> findByNationalCode(String nationalCode);
    @Query(value = "SELECT\n" +
            "    tbl_evaluation.f_evaluator_id,\n" +
            "    tbl_student.national_code,\n" +
            "    tbl_class_student.class_id\n" +
            "FROM\n" +
            "         tbl_evaluation\n" +
            "    INNER JOIN tbl_class_student ON tbl_evaluation.f_evaluator_id = tbl_class_student.id\n" +
            "    INNER JOIN tbl_student ON tbl_class_student.student_id = tbl_student.id\n" +
            "    where tbl_student.national_code =:nationalCode and tbl_class_student.class_id =:classId", nativeQuery = true)
    Long findOneByNationalCode(@Param("nationalCode") String nationalCode, @Param("classId") Long classId);


    /**
     * @param sessionId
     * @return a map which contains list of students of a sesssion with their attendance info
     */
    @Query(value = "select " +
            "       CONCAT(CONCAT(student.FIRST_NAME, ' '), student.LAST_NAME) as fullName, " +
            "       student.NATIONAL_CODE                                      as nationalCode, " +
            "       student.ID                                                 as studentId, " +
            "       attendance.C_STATE                                         as attendanceStateId " +
            "from TBL_STUDENT student " +
            "         inner join TBL_ATTENDANCE attendance on student.ID = attendance.F_STUDENT " +
            "where attendance.F_SESSION =:sessionId", nativeQuery = true)
    List<Map<String,Object>> sessionStudentsBySessionId(@Param("sessionId")Long sessionId);

    @Query(value = "select * from TBL_STUDENT where f_contact_info = :id and active = 1 and deleted = 0" , nativeQuery = true)
    Optional<Student> findByContactInfoId(Long id);

    @Query(value = "select * from TBL_STUDENT where f_contact_info IN(:ids)" , nativeQuery = true)
    List<Student> findAllByContactInfoIds(List<Long> ids);
}
