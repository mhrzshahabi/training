package com.nicico.training.repository;

import com.nicico.training.model.Role;
import com.nicico.training.model.Teacher;
import com.nicico.training.model.TeacherRole;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


import java.util.List;
import java.util.Optional;

@Repository
public interface TeachersRoleDAO extends JpaRepository<TeacherRole, Long> {
    List<TeacherRole> findAllByTeacher(Teacher teacher);

    Optional<TeacherRole> findByTeacherAndRole(Teacher teacher, Role role);
}
