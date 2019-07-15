package com.nicico.training.repository;

import com.nicico.training.model.EducationLevel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface EducationLevelDAO extends JpaRepository<EducationLevel,Long>, JpaSpecificationExecutor<EducationLevel> {
}
