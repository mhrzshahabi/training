package com.nicico.training.repository;

import com.nicico.training.model.Assistant;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface AssistantDAO extends JpaRepository<Assistant, Long>, JpaSpecificationExecutor<Assistant> {
}