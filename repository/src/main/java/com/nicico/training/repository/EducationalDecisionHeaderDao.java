package com.nicico.training.repository;

import com.nicico.training.model.EducationalDecisionHeader;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface EducationalDecisionHeaderDao extends JpaRepository<EducationalDecisionHeader, Long>, JpaSpecificationExecutor<EducationalDecisionHeader> {


}