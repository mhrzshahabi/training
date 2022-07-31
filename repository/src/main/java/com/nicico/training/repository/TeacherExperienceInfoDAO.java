package com.nicico.training.repository;

import com.nicico.training.model.TeacherExperienceInfo;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.lang.Nullable;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TeacherExperienceInfoDAO extends JpaRepository<TeacherExperienceInfo,Long>, JpaSpecificationExecutor<TeacherExperienceInfo> {

}
