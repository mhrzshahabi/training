package com.nicico.training.repository;

import com.nicico.training.model.TeacherPresentableCourse;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TeacherPresentableCourseDAO extends JpaRepository<TeacherPresentableCourse,Long> {

    List<TeacherPresentableCourse> findAllByTeacherId(Long teacherId);
  @Query(value = "SELECT f_category  FROM tbl_teacher_presentable_course_category where f_teacher_presentable_course= :id",nativeQuery = true)
    List<Long> findAllCatById(Long id);
  @Query(value = "SELECT f_subcategory  FROM tbl_teacher_presentable_course_subcategory where f_teacher_presentable_course= :id",nativeQuery = true)
   List<Long>  findAllSubById(Long id);

}
