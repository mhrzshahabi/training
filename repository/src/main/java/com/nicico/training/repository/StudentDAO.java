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
import java.util.Optional;

@Repository
public interface StudentDAO extends JpaRepository<Student, Long>, JpaSpecificationExecutor<Student> {

    @Query(value = "select Tbl_Class_Student.F_Class from tbl_student join Tbl_Class_Student  on tbl_student.id = Tbl_Class_Student.F_Student   where (tbl_student.nationalcode=:nationalCode and Tbl_Class_Student.f.class=:classId )", nativeQuery = true)
    List<Long> findOneByNationalCodeInClass(@Param("nationalCode") String nationalCode, @Param("classId") Long classId);

    Optional<Student> findByPersonnelNo(@Param("personnelNo") String personnelNo);

    List<Student> findByPostIdAndPersonnelNoAndDepartmentIdAndFirstNameAndLastNameOrderByIdDesc(Long postId, String personnelNo, Long depId, String fName, String lName);
    List<Student> findByNationalCode(String nationalCode);
}
