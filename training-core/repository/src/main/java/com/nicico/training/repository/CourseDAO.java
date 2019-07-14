package com.nicico.training.repository;

import com.nicico.training.model.Competence;
import com.nicico.training.model.Course;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CourseDAO extends JpaRepository<Course, Long>, JpaSpecificationExecutor<Course> {
    @Query(value = "select c.* from training.TBL_COURSE c  where Not EXISTS(select F_COURSE_ID from training.TBL_SKILL_COURSE sc where  sc.F_COURSE_ID=c.ID and sc.F_SKILL_ID = ?)", nativeQuery = true)
    List<Course> findCoursesBySkillId(Long skillId);

    List<Course> findByCodeStartingWith(String code);


}

