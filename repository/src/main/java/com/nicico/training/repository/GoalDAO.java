package com.nicico.training.repository;

import com.nicico.training.model.Goal;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface GoalDAO extends JpaRepository<Goal, Long>, JpaSpecificationExecutor<Goal> {
}
