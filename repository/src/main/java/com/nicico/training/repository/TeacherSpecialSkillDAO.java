package com.nicico.training.repository;

import com.nicico.training.model.TeacherSpecialSkill;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TeacherSpecialSkillDAO extends JpaRepository<TeacherSpecialSkill, Long>, JpaSpecificationExecutor<TeacherSpecialSkill> {

    List<TeacherSpecialSkill> findTeacherSpecialSkillByTeacherIdOrderByIdDesc(Long teacherId);
}
