package com.nicico.training.repository;

import com.nicico.training.model.TeacherPresentableCourse;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TeacherPresentableCourseDAO extends JpaRepository<TeacherPresentableCourse,Long> {
}
