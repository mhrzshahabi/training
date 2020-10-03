package com.nicico.training.repository;

import com.nicico.training.model.ViewSkillNA;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface ViewSkillNADAO extends JpaRepository<ViewSkillNA, Long>, JpaSpecificationExecutor<ViewSkillNA> {
}
