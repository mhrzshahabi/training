package com.nicico.training.repository;

import com.nicico.training.model.TrainingRequestManagement;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface TrainingRequestManagementDAO extends JpaRepository<TrainingRequestManagement, Long>, JpaSpecificationExecutor<TrainingRequestManagement> {
 }
