package com.nicico.training.repository;

import com.nicico.training.model.QuestionProtocol;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TestQuestionProtocolDAO extends JpaRepository<QuestionProtocol, Long>, JpaSpecificationExecutor<QuestionProtocol> {

    List<QuestionProtocol> findAllByExamId(Long id);

    QuestionProtocol findByQuestionId(Long questionId);
}
