package com.nicico.training.repository;

import com.nicico.training.model.Course;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CourseDAO extends JpaRepository<Course, Long>, JpaSpecificationExecutor<Course> {
    @Query(value = "select c.* from TBL_COURSE c  where Not EXISTS(select F_COURSE_ID from TBL_SKILL_COURSE sc where  sc.F_COURSE_ID=c.ID and sc.F_SKILL_ID = ?)", nativeQuery = true)
    List<Course> getUnAttachedCoursesBySkillId(Long skillId, Pageable pageable);

    @Query(value = "select count(*) from TBL_COURSE c  where Not EXISTS(select F_COURSE_ID from TBL_SKILL_COURSE sc where  sc.F_COURSE_ID=c.ID and sc.F_SKILL_ID = ?)", nativeQuery = true)
    Integer getUnAttachedCoursesCountBySkillId(Long skillId);

    List<Course> findByCodeStartingWith(String code);

    @Query(value = "select * from TBL_COURSE where C_TITLE_FA = :titleFa", nativeQuery = true)
    List<Course> findByTitleFa(@Param("titleFa") String titleFa);
}

