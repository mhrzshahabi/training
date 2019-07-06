package com.nicico.training.repository;

import com.nicico.training.model.SkillGroup;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface SkillStandardGroupDAO extends JpaRepository<SkillGroup, Long>, JpaSpecificationExecutor<SkillGroup> {
}
