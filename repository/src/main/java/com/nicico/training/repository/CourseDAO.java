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



     @Query(value =
             "(select  course.id, course.c_code ,course.c_title_fa  , max(tbl_class.c_start_date) max_start_date from " +
                 "(select distinct tbl_course.id, tbl_course.c_code, tbl_course.c_title_fa from tbl_course " +
//                 "inner join tbl_class on tbl_class.f_course = tbl_course.id " +
//                 "inner join tbl_term on tbl_term.id = tbl_class.f_term " +
//                 "inner join tbl_teacher  on tbl_teacher.id = tbl_class.f_teacher " +
//                 "where " +
//                 "  (case when :termIds is null then 1 when INSTR(:termIds,','||tbl_term.id||',',1,1)>0 then 1 end) is not null  and " +
//                 "  (case when :teacherIds is null then 1 when  INSTR(:teacherIds,','||tbl_teacher.id||',',1,1)>0  then 1 end) is not null and " +
//                 "  (case  when :courseIds is null then 1 when INSTR(:courseIds,','||tbl_course.id||',',1,1)>0 then 1 end ) is not null " +
//                 "minus " +
//                 "select distinct tbl_course.id, tbl_course.c_code, tbl_course.c_title_fa from tbl_course " +
                 "inner join tbl_class on tbl_class.f_course = tbl_course.id " +
                 "inner join tbl_term on tbl_term.id = tbl_class.f_term " +
                 "inner join tbl_teacher  on tbl_teacher.id = tbl_class.f_teacher " +
                 "where " +
                 "  (case when :years is null then 1 when INSTR(:years, substr(tbl_term.c_startdate, 1, 4 ),1,1) > 0 then 1 end) is not null and " +
                 "  (case when :startDate is null then 1 when tbl_class.c_start_date >= :startDate then 1 end) is not null and " +
                 "  (case when :strSData2 is null then 1 when tbl_class.c_start_date <= :strSData2 then 1 end) is not null and " +
                 "  (case when :endDate is null then 1 when tbl_class.c_end_date >= :endDate then 1 end) is not null and " +
                 "  (case when :strEData2 is null then 1 when tbl_class.c_end_date <= :strEData2 then 1 end) is not null and " +
                 "  (case when :termIds is null then 1 when INSTR(:termIds,','||tbl_term.id||',',1,1)>0 then 1 end) is not null  and " +
                 "  (case when :teacherIds is null then 1 when  INSTR(:teacherIds,','||tbl_teacher.id||',',1,1)>0  then 1 end) is not null and " +
                 "  (case  when :courseIds is null then 1 when INSTR(:courseIds,','||tbl_course.id||',',1,1)>0 then 1 end ) is not null " +
                 ") course " +
                 "inner join tbl_class on  tbl_class.f_course = course.id " +
                 "where tbl_class.f_teacher is not null  and (tbl_class.c_start_date  not like '//') " +
                 "group by course.id, course.c_code, course.c_title_fa) " +
                 "union " +
                 "select neverprovided.* ,'تا کنون برای این دوره، کلاسی ارائه نشده است' from( " +
                 " select tbl_course.id, tbl_course.c_code ,tbl_course.c_title_fa from tbl_course " +
                 "minus " +
                 "select tbl_course.id, tbl_course.c_code ,tbl_course.c_title_fa from tbl_course inner join tbl_class on tbl_class.f_course = tbl_course.id) neverprovided " //+
              /*":sort "*/, nativeQuery = true)
     List<Object> getCourseWithOutClassWithNeverProvidedAllCourses(String years, Object startDate, Object endDate, Object strSData2, Object strEData2, String termIds, String courseIds, String teacherIds/*, String sort*/);

     @Query(value =
             "(select  course.id, course.c_code ,course.c_title_fa  , max(tbl_class.c_start_date) max_start_date from " +
                     "(select distinct tbl_course.id, tbl_course.c_code, tbl_course.c_title_fa from tbl_course " +
                     "inner join tbl_class on tbl_class.f_course = tbl_course.id " +
                     "inner join tbl_term on tbl_term.id = tbl_class.f_term " +
                     "inner join tbl_teacher  on tbl_teacher.id = tbl_class.f_teacher " +
                     "where " +
                     "  (case when :termIds is null then 1 when INSTR(:termIds,','||tbl_term.id||',',1,1)>0 then 1 end) is not null  and " +
                     "  (case when :teacherIds is null then 1 when  INSTR(:teacherIds,','||tbl_teacher.id||',',1,1)>0  then 1 end) is not null and " +
                     "  (case  when :courseIds is null then 1 when INSTR(:courseIds,','||tbl_course.id||',',1,1)>0 then 1 end ) is not null " +
                     "minus " +
                     "select distinct tbl_course.id, tbl_course.c_code, tbl_course.c_title_fa from tbl_course " +
                     "inner join tbl_class on tbl_class.f_course = tbl_course.id " +
                     "inner join tbl_term on tbl_term.id = tbl_class.f_term " +
                     "inner join tbl_teacher  on tbl_teacher.id = tbl_class.f_teacher " +
                     "where " +
                     "  (case when :years is null then 1 when INSTR(:years, substr(tbl_term.c_startdate, 1, 4 ),1,1) > 0 then 1 end) is not null and " +
                     "  (case when :startDate is null then 1 when tbl_class.c_start_date >= :startDate then 1 end) is not null and " +
                     "  (case when :strSData2 is null then 1 when tbl_class.c_start_date <= :strSData2 then 1 end) is not null and " +
                     "  (case when :endDate is null then 1 when tbl_class.c_end_date >= :endDate then 1 end) is not null and " +
                     "  (case when :strEData2 is null then 1 when tbl_class.c_end_date <= :strEData2 then 1 end) is not null and " +
                     "  (case when :termIds is null then 1 when INSTR(:termIds,','||tbl_term.id||',',1,1)>0 then 1 end) is not null  and " +
                     "  (case when :teacherIds is null then 1 when  INSTR(:teacherIds,','||tbl_teacher.id||',',1,1)>0  then 1 end) is not null and " +
                     "  (case  when :courseIds is null then 1 when INSTR(:courseIds,','||tbl_course.id||',',1,1)>0 then 1 end ) is not null " +
                     ") course " +
                     "inner join tbl_class on  tbl_class.f_course = course.id " +
                     "where tbl_class.f_teacher is not null  and (tbl_class.c_start_date  not like '//') " +
                     "group by course.id, course.c_code, course.c_title_fa) " +
                     "union " +
                     "select neverprovidedThisCourse.* ,'تا کنون برای این دوره، کلاسی ارائه نشده است' from( " +
                     "select tbl_course.id, tbl_course.c_code ,tbl_course.c_title_fa from tbl_course " +
                     "where  (case  when :courseIds is null then 1 when INSTR(:courseIds,','||tbl_course.id||',',1,1)>0 then 1 end ) is not null " +
                     "minus " +
                     "select tbl_course.id, tbl_course.c_code ,tbl_course.c_title_fa from tbl_course inner join tbl_class on tbl_class.f_course = tbl_course.id " +
                     "  where  (case  when :courseIds is null then 1 when INSTR(:courseIds,','||tbl_course.id||',',1,1)>0 then 1 end ) is not null ) neverprovidedThisCourse "//+
              /*":sort "*/, nativeQuery = true)
     List<Object> getCourseWithOutClassWithNeverProvidedThisCourse(String years, Object startDate, Object endDate, Object strSData2, Object strEData2, String termIds, String courseIds, String teacherIds/*, String sort*/);


    @Query(value =
            "(select  course.id, course.c_code ,course.c_title_fa  , max(tbl_class.c_start_date) max_start_date from " +
                    "(select distinct tbl_course.id, tbl_course.c_code, tbl_course.c_title_fa from tbl_course " +
                    "inner join tbl_class on tbl_class.f_course = tbl_course.id " +
                    "inner join tbl_term on tbl_term.id = tbl_class.f_term " +
                    "inner join tbl_teacher  on tbl_teacher.id = tbl_class.f_teacher " +
                    "where " +
                    "  (case when :termIds is null then 1 when INSTR(:termIds,','||tbl_term.id||',',1,1)>0 then 1 end) is not null  and " +
                    "  (case when :teacherIds is null then 1 when  INSTR(:teacherIds,','||tbl_teacher.id||',',1,1)>0  then 1 end) is not null and " +
                    "  (case  when :courseIds is null then 1 when INSTR(:courseIds,','||tbl_course.id||',',1,1)>0 then 1 end ) is not null " +
                    "minus " +
                    "select distinct tbl_course.id, tbl_course.c_code, tbl_course.c_title_fa from tbl_course " +
                    "inner join tbl_class on tbl_class.f_course = tbl_course.id " +
                    "inner join tbl_term on tbl_term.id = tbl_class.f_term " +
                    "inner join tbl_teacher  on tbl_teacher.id = tbl_class.f_teacher " +
                    "where " +
                    "  (case when :years is null then 1 when INSTR(:years, substr(tbl_term.c_startdate, 1, 4 ),1,1) > 0 then 1 end) is not null and " +
                    "  (case when :startDate is null then 1 when tbl_class.c_start_date >= :startDate then 1 end) is not null and " +
                    "  (case when :strSData2 is null then 1 when tbl_class.c_start_date <= :strSData2 then 1 end) is not null and " +
                    "  (case when :endDate is null then 1 when tbl_class.c_end_date >= :endDate then 1 end) is not null and " +
                    "  (case when :strEData2 is null then 1 when tbl_class.c_end_date <= :strEData2 then 1 end) is not null and " +
                    "  (case when :termIds is null then 1 when INSTR(:termIds,','||tbl_term.id||',',1,1)>0 then 1 end) is not null  and " +
                    "  (case when :teacherIds is null then 1 when  INSTR(:teacherIds,','||tbl_teacher.id||',',1,1)>0  then 1 end) is not null and " +
                    "  (case  when :courseIds is null then 1 when INSTR(:courseIds,','||tbl_course.id||',',1,1)>0 then 1 end ) is not null " +
                    ") course " +
                    "inner join tbl_class on  tbl_class.f_course = course.id " +
                    "where tbl_class.f_teacher is not null  and (tbl_class.c_start_date  not like '//') " +
                    "group by course.id, course.c_code, course.c_title_fa) "
            /*":sort "*/, nativeQuery = true)
    List<Object> getCourseWithOutClass(String years, Object startDate, Object endDate, Object strSData2, Object strEData2, String termIds, String courseIds, String teacherIds/*, String sort*/);


}
