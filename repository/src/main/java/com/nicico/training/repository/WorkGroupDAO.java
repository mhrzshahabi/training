package com.nicico.training.repository;

import com.nicico.training.model.WorkGroup;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface WorkGroupDAO extends JpaRepository<WorkGroup, Long>, JpaSpecificationExecutor<WorkGroup> {
}
