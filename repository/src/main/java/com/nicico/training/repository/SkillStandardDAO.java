package com.nicico.training.repository;

import com.nicico.training.model.SkillStandard;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface SkillStandardDAO extends JpaRepository<SkillStandard, Long>, JpaSpecificationExecutor<SkillStandard> {
}
