package com.nicico.training.repository;

import com.nicico.training.model.TeacherExperienceInfo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TeacherExperienceInfoDAO extends JpaRepository<TeacherExperienceInfo,Long> {
}
