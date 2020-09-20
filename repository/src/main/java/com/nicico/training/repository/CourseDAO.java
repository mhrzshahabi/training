package com.nicico.training.repository;

import com.nicico.jpa.model.repository.NicicoRepository;
import com.nicico.training.model.Course;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CourseDAO extends NicicoRepository<Course> {
    @Query(value = "select c.* from TBL_COURSE c  where Not EXISTS(select F_COURSE from TBL_SKILL sc where  sc.F_COURSE=c.ID and sc.ID = ?)", nativeQuery = true)
    List<Course> getUnAttachedCoursesBySkillId(Long skillId, Pageable pageable);

    @Query(value = "select count(*) from TBL_COURSE c  where Not EXISTS(select F_COURSE from TBL_SKILL sc where  sc.F_COURSE=c.ID and sc.ID = ?)", nativeQuery = true)
    Integer getUnAttachedCoursesCountBySkillId(Long skillId);

    List<Course> findByCodeStartingWith(String code);

    @Query(value = "select * from TBL_COURSE where C_TITLE_FA = :titleFa", nativeQuery = true)
    List<Course> findByTitleFa(@Param("titleFa") String titleFa);

    @Modifying
    @Query(value = " update TBL_COURSE set C_WORKFLOW_STATUS = :workflowStatus, C_WORKFLOW_STATUS_CODE = :workflowStatusCode  where ID = :courseId ", nativeQuery = true)
    public int updateCourseState(Long courseId, String workflowStatus, Integer workflowStatusCode);

    List<Course> findAllById(Long courseId);

    List<Course> findByCodeEquals(String code);

    Course findCourseByIdEquals(Long courseId);

    boolean existsByTitleFa(String titleFa);

    @Modifying
    @Query(value = "select distinct Course_ID from VIEW_NA_REPORT where COURSE_ID = :courseId", nativeQuery = true)
    List<Long> getCourseNeedAssessmentStatus(Long courseId);

    @Query(value = "select distinct tbl_course.id from tbl_needs_assessment inner join tbl_skill on tbl_needs_assessment.f_skill=tbl_skill.id inner join tbl_course on tbl_course.id=tbl_skill.f_course where tbl_course.id in (:courseIds)", nativeQuery = true)
    List<Long> isExistInNeedsAssessment(List<Long> courseIds);

    @Query(value = "SELECT tbl_course.n_theory_duration FROM tbl_course where ID = :courseId", nativeQuery = true)
    Float getCourseTheoryDurationById(Long courseId);



}

