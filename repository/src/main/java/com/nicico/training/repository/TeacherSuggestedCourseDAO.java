package com.nicico.training.repository;

import com.nicico.training.model.TeacherSuggestedCourse;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TeacherSuggestedCourseDAO extends JpaRepository<TeacherSuggestedCourse,Long> {
    List<TeacherSuggestedCourse> findAllByTeacherId(Long teacherId);
    @Query(value = "select f_category from tbl_teacher_suggested_course_category where f_teacher_suggested_course= :suggestedId",nativeQuery = true)
    List<Long> getCategoriesBySuggestedId(Long suggestedId);
    @Query(value = "select f_subcategory from tbl_teacher_suggested_course_subcategory where f_teacher_suggested_course= :suggestedId",nativeQuery = true)
    List<Long>  getSubcategories(Long suggestedId);


}
