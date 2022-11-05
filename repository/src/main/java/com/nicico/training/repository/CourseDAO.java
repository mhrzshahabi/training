package com.nicico.training.repository;

import com.nicico.jpa.model.repository.NicicoRepository;
import com.nicico.training.model.Course;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CourseDAO extends NicicoRepository<Course> {

    @Query(value = "select c.* from TBL_COURSE c  where Not EXISTS(select F_COURSE from TBL_SKILL sc where  sc.F_COURSE=c.ID and sc.ID = ?)", nativeQuery = true)
    List<Course> getUnAttachedCoursesBySkillId(Long skillId, Pageable pageable);

    @Query(value = "select count(*) from TBL_COURSE c  where Not EXISTS(select F_COURSE from TBL_SKILL sc where  sc.F_COURSE=c.ID and sc.ID = ?)", nativeQuery = true)
    Integer getUnAttachedCoursesCountBySkillId(Long skillId);

    List<Course> findByCodeStartingWith(String code);

    @Modifying
    @Query(value = " update TBL_COURSE set C_WORKFLOW_STATUS = :workflowStatus, C_WORKFLOW_STATUS_CODE = :workflowStatusCode  where ID = :courseId ", nativeQuery = true)
    int updateCourseState(Long courseId, String workflowStatus, Integer workflowStatusCode);

    List<Course> findAllById(Long courseId);

    List<Course> findByCodeEquals(String code);

    Course findCourseByIdEquals(Long courseId);

    boolean existsByTitleFa(String titleFa);

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

    @Query(value = "select \n" +
            "course_id\n" +
            "from\n" +
            "(\n" +
            "            select \n" +
            "                    \n" +
            "                    reference_course,\n" +
            "                    course_id,\n" +
            "                    course_code,\n" +
            "                    course_title_fa,\n" +
            "                    course_theory_duration,\n" +
            "                     course_technical_type\n" +
            "                    from\n" +
            "                    VIEW_EQUAL_COURSE\n" +
            "                    where reference_course = :courseId\n" +
            "                    union\n" +
            "                     \n" +
            "                     select \n" +
            "                     reference_course,\n" +
            "                            course_id,\n" +
            "                            course_code,\n" +
            "                            course_title_fa,\n" +
            "                            course_theory_duration,\n" +
            "                             course_technical_type\n" +
            "                     from(\n" +
            "                             select \n" +
            "                             leve2.reference_course,\n" +
            "                            leve2.course_id,\n" +
            "                            leve2.course_code,\n" +
            "                            leve2.course_title_fa,\n" +
            "                            leve2.course_theory_duration,\n" +
            "                             leve2.course_technical_type\n" +
            "                             \n" +
            "                            from\n" +
            "                            VIEW_EQUAL_COURSE leve1\n" +
            "                            left join (      select \n" +
            "                                                 reference_course,\n" +
            "                                                course_id,\n" +
            "                                                course_code,\n" +
            "                                                course_title_fa,\n" +
            "                                                course_theory_duration,\n" +
            "                                                course_technical_type\n" +
            "                                     \n" +
            "                                            from\n" +
            "                                                 VIEW_EQUAL_COURSE\n" +
            "                                      \n" +
            "                                     )leve2\n" +
            "                                     on  \n" +
            "                                       leve2.reference_course = leve1.course_id\n" +
            "                                       and leve1.reference_course = :courseId\n" +
            "                         )  \n" +
            "  )\n" +
            "  where course_id is not null", nativeQuery = true)

    List<Long> getAllEqualCourseIds(Long courseId);

    List<Course> findAllByCategoryIdAndSubCategoryId(Long categoryId,Long subCategoryId);

    @Query(value = "SELECT f_goal_id FROM tbl_course_goal where f_course_id= :courseId",nativeQuery = true)
   List<Long> findAllGoalId( Long courseId);

    @Query(value ="SELECT f_pre_course_id FROM tbl_pre_course where f_course_id= :courseId" ,nativeQuery = true)
    List<Long> findAllPreCourseId(Long courseId);

    @Query(value = "SELECT * FROM tbl_course WHERE (category_id IN (:categories) AND subcategory_id IN (:subCategories))",nativeQuery = true)
    List<Course> findAllByCategoryIdAndSubCategoryId(List<Long> categories,List<Long> subCategories);

    @Query(value = "SELECT * FROM tbl_pre_course where f_course_id= :courseId",nativeQuery = true)
    List<Long> findAllPrecourseBy(Long courseId);

    @Modifying
    @Query(value = "update TBL_COURSE set n_theory_duration =:theoryDuration where c_code =:code", nativeQuery = true)
    void updateDurationByCourseCode(String code, Float theoryDuration);

    Optional<Course>findFirstByCode(String code);
}
