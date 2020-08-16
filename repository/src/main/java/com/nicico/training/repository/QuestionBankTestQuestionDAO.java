package com.nicico.training.repository;

import com.nicico.training.model.QuestionBankTestQuestion;
import com.nicico.training.model.State;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface QuestionBankTestQuestionDAO extends JpaRepository<QuestionBankTestQuestion, Long>, JpaSpecificationExecutor<QuestionBankTestQuestion> {

    @Modifying
    @Query(value = "delete from tbl_question_bank_test_question where f_test_question = :testQuestionId and f_question_bank in(:questionBankId)", nativeQuery = true)
    void deleteAllByTestQuestionIdAndQuestionBankId(Long testQuestionId, List<Long> questionBankId);
}
