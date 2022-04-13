package com.nicico.training.repository;

import com.nicico.training.model.CourseAudit;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface CourseAuditDAO extends JpaRepository<CourseAudit, Long>, JpaSpecificationExecutor<CourseAudit> {

    @Query(value = "select * from tbl_course_aud  where ID = :courseId ORDER BY rev desc", nativeQuery = true)
    List<CourseAudit> getCourseAuditsById(Long courseId);
}
