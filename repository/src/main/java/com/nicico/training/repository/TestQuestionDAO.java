package com.nicico.training.repository;

import com.nicico.training.model.State;
import com.nicico.training.model.TestQuestion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TestQuestionDAO extends JpaRepository<TestQuestion, Long>, JpaSpecificationExecutor<TestQuestion> {

    @Query(value = "select * from tbl_test_question where b_is_pre_test_question=:isPreTestQuestion and f_class=:tclassId and rownum=1", nativeQuery = true)
    TestQuestion findTestQuestionByTclassAndPreTestQuestion(Long tclassId, boolean isPreTestQuestion);
}
