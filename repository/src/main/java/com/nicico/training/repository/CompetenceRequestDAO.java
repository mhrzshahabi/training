package com.nicico.training.repository;

import com.nicico.training.model.CompetenceRequest;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface CompetenceRequestDAO extends JpaRepository<CompetenceRequest, Long>, JpaSpecificationExecutor<CompetenceRequest> {
 }
