package com.nicico.training.repository;

import com.nicico.training.model.State;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface StateDAO extends JpaRepository<State, Long>, JpaSpecificationExecutor<State> {
}
