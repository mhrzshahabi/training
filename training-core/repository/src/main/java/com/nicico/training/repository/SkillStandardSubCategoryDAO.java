package com.nicico.training.repository;

import com.nicico.training.model.SkillStandardSubCategory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface SkillStandardSubCategoryDAO extends JpaRepository<SkillStandardSubCategory, Long>, JpaSpecificationExecutor<SkillStandardSubCategory> {
}
