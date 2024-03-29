package com.nicico.training.repository;

import com.nicico.training.model.TeacherExperienceInfo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TeacherExperienceInfoDAO extends JpaRepository<TeacherExperienceInfo,Long>, JpaSpecificationExecutor<TeacherExperienceInfo> {

    boolean existsByTeacherRankIdAndTeacherIdAndSalaryBaseAndTeachingExperience(Integer teacherRankId, Long teacherId, Long salaryBase, Long teachingExperience);

    List<TeacherExperienceInfo> findAllByTeacherId(Long teacherId);
}
