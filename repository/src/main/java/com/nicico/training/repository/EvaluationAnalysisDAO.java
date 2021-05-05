package com.nicico.training.repository;

import com.nicico.training.model.EvaluationAnalysis;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.List;


@Repository
public interface EvaluationAnalysisDAO extends JpaRepository<EvaluationAnalysis, Long>, JpaSpecificationExecutor<EvaluationAnalysis> {

    List<EvaluationAnalysis> findByTClassId(Long classId);

    void deleteByTClassId(Long id);
}
