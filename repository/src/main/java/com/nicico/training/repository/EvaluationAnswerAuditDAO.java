package com.nicico.training.repository;

import com.nicico.training.model.EvaluationAnswerAudit;
import com.nicico.training.model.compositeKey.EvaluationAnswerAuditId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface EvaluationAnswerAuditDAO extends JpaRepository<EvaluationAnswerAudit, EvaluationAnswerAuditId>, JpaSpecificationExecutor<EvaluationAnswerAudit> {

    @Query(value = "select * from TBL_EVALUATION_ANSWER_AUD  where f_evaluation_id = :evaluationId ORDER BY rev", nativeQuery = true)
    List<EvaluationAnswerAudit> getAuditData(long evaluationId);
}