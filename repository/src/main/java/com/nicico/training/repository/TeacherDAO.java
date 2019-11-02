package com.nicico.training.repository;

import com.nicico.training.model.Teacher;
import org.springframework.data.domain.Pageable;
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

    @Transactional
    List<Teacher> findByTeacherCode(@Param("teacherCode") String teacherCode);

    @Transactional
    @Query(value = "select tt.* from training.TBL_TEACHER tt  where Not EXISTS(select F_TEACHER from training.TBL_INSTITUTE_TEACHER tit where  tit.F_TEACHER=tt.ID and tit.F_INSTITUTE = ?)", nativeQuery = true)
    List<Teacher> getUnAttachedTeachersByInstituteId(Long instituteID, Pageable pageable);

    @Transactional
    @Query(value = "select count(*) from training.TBL_TEACHER tt  where Not EXISTS(select F_TEACHER from training.TBL_INSTITUTE_TEACHER tit where  tit.F_TEACHER=tt.ID and tit.F_INSTITUTE = ?)", nativeQuery = true)
    Integer getUnAttachedTeachersCountByInstituteId(Long instituteID);


}
