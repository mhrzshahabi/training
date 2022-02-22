package com.nicico.training.repository;

import com.nicico.training.model.TeacherSuggestedCourse;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TeacherSuggestedCourseDAO extends JpaRepository<TeacherSuggestedCourse,Long> {
    List<TeacherSuggestedCourse> findAllByTeacherId(Long teacherId);


}
