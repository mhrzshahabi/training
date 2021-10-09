package com.nicico.training.repository;

import com.nicico.training.model.QuestionBankTestQuestion;
import org.springframework.data.jpa.repository.*;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface QuestionBankTestQuestionDAO extends JpaRepository<QuestionBankTestQuestion, Long>, JpaSpecificationExecutor<QuestionBankTestQuestion> {

    @Modifying
    @Query(value = "delete from tbl_question_bank_test_question where f_test_question = :testQuestionId and f_question_bank in(:questionBankId)", nativeQuery = true)
    void deleteAllByTestQuestionIdAndQuestionBankId(Long testQuestionId, List<Long> questionBankId);

    @Query(value = "select F_QUESTION_BANK from tbl_question_bank_test_question where F_TEST_QUESTION = :testQuestionId", nativeQuery = true)
    List<Long> findQuestionBankIdsByTestQuestionId(Long testQuestionId);

    @Query(value = "select * from tbl_question_bank_test_question b INNER JOIN tbl_question_bank q ON b.f_question_bank = q.id " + "INNER JOIN tbl_test_question t ON b.f_test_question = t.id WHERE t.b_is_pre_test_question =:isPreTestQuestion AND t.f_class =:classId", nativeQuery = true)
    List<QuestionBankTestQuestion> findByTypeAndClassId(@Param("isPreTestQuestion") boolean isPreTestQuestion, @Param("classId") Long classId);

    List<QuestionBankTestQuestion> findByQuestionBankIdAndTestQuestionId(Long questionBankId, Long testQuestionId);

    List<QuestionBankTestQuestion> findByTestQuestionId(Long testQuestionId);

    @EntityGraph(attributePaths = {"questionBank"}, type= EntityGraph.EntityGraphType.FETCH)
    List<QuestionBankTestQuestion> findAllByTestQuestionId(Long testQuestionId);

    List<QuestionBankTestQuestion> findAllByQuestionBankId(Long questionBankId);

//    @Query(value = "SELECT * FROM tbl_question_bank_test_question b LEFT JOIN b.f_question_bank WHERE b.f_test_question = :testQuestionId" , nativeQuery = true)
//    @EntityGraph(attributePaths = {"questionBank"}, type= EntityGraph.EntityGraphType.FETCH)
//    List<QuestionBankTestQuestion> findByTestQuestionId(@Param("testQuestionId") Long testQuestionId);
}
