package com.nicico.training.repository;

import com.nicico.training.model.QuestionProtocol;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface TestQuestionProtocolDAO extends JpaRepository<QuestionProtocol, Long>, JpaSpecificationExecutor<QuestionProtocol> {

    List<QuestionProtocol> findAllByExamId(Long id);

    QuestionProtocol findByQuestionId(Long questionId);

    @Query(value = """
            SELECT
                *
            FROM
                tbl_question_protocol qp
            WHERE
                qp.question_id IN (:ids)
            """, nativeQuery = true)
    List<QuestionProtocol> findByQuestionIds(@Param("ids") List<Long> questionId);
    Optional<QuestionProtocol>findFirstByQuestionIdAndExamId(Long questionId,Long examId);
}
