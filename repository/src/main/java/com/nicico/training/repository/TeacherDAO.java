package com.nicico.training.repository;

import com.nicico.training.model.PersonalInfo;
import com.nicico.training.model.Teacher;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import javax.transaction.Transactional;
import java.util.List;

@Repository
public interface TeacherDAO extends JpaRepository<Teacher, Long>, JpaSpecificationExecutor<Teacher> {
    @Modifying
    @Query(value = "select * from TBL_TEACHER where C_TEACHER_CODE = :teacherCode", nativeQuery = true)
    @Transactional
    public List<Teacher> findByTeacherCode(@Param("teacherCode") String teacherCode);

    @Modifying
    @Query(value = "select * from TBL_TEACHER where C_TEACHER_CODE = :teacherCode and ID != :id",nativeQuery = true)
    @Transactional
    public List<Teacher> findByTeacherCode(@Param("id") Long id, @Param("teacherCode") String teacherCode);

}
