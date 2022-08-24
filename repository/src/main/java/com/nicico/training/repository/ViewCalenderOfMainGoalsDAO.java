package com.nicico.training.repository;

import com.nicico.training.model.ViewCalenderOfMainGoals;
import com.nicico.training.model.ViewClassCostReporting;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface ViewCalenderOfMainGoalsDAO extends BaseDAO<ViewCalenderOfMainGoals, Long> {
}