package com.nicico.training.repository;

import com.nicico.training.model.Section;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface SectionDAO extends JpaRepository<Section, Long>, JpaSpecificationExecutor<Section> {
}