package com.nicico.training.repository;

import com.nicico.training.model.TeacherExperienceInfo;
import com.nicico.training.model.enums.TeacherRank;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface TeacherExperienceInfoDAO extends JpaRepository<TeacherExperienceInfo,Long>, JpaSpecificationExecutor<TeacherExperienceInfo> {

    boolean existsByTeacherRankIdAndTeacherIdAndSalaryBaseAndTeachingExperience(Integer teacherRankId, Long teacherId, Long salaryBase, Long teachingExperience);
}
