package com.nicico.training.repository;

import com.nicico.training.model.BehavioralGoal;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface BehavioralGoalsDAO extends JpaRepository<BehavioralGoal,Long>, JpaSpecificationExecutor<BehavioralGoal> {
}
