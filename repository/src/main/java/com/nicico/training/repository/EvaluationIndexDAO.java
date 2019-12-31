package com.nicico.training.repository;

import com.nicico.training.model.EvaluationIndex;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface EvaluationIndexDAO extends JpaRepository<EvaluationIndex, Long>, JpaSpecificationExecutor<EvaluationIndex> {
}
