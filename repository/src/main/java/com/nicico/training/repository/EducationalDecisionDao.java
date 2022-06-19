package com.nicico.training.repository;

import com.nicico.training.model.EducationalDecision;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface EducationalDecisionDao extends JpaRepository<EducationalDecision, Long>, JpaSpecificationExecutor<EducationalDecision> {

    List<EducationalDecision> findAllByRefAndEducationalDecisionHeaderId(String ref, Long id);

}