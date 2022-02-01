package com.nicico.training.repository;

import com.nicico.training.model.SkillLevel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface SkillLevelDAO extends JpaRepository<SkillLevel, Long>, JpaSpecificationExecutor<SkillLevel> {

    boolean existsByTitleFa(String nameFa);

    boolean existsByTitleFaAndIdIsNot(String nameFa, Long id);
}
