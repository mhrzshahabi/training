package com.nicico.training.repository;

import com.nicico.training.model.TestQuestion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TestQuestionDAO extends JpaRepository<TestQuestion, Long>, JpaSpecificationExecutor<TestQuestion> {

    @Query(value = "select * from tbl_test_question where b_is_pre_test_question=:isPreTestQuestion and f_class=:tclassId and rownum=1", nativeQuery = true)
    TestQuestion findTestQuestionByTclassAndPreTestQuestion(Long tclassId, boolean isPreTestQuestion);

    @Query(value = "select count(id) from tbl_test_question where f_class=:tclassId and b_is_pre_test_question=:isPreTestQuestion and id <> :id", nativeQuery = true)
    Integer IsExist(Long tclassId, boolean isPreTestQuestion, Long id);

    @Modifying
    @Query(value = "update tbl_test_question set B_ONLINE_FINAL_EXAM_STATUS = :state where ID = :examId", nativeQuery = true)
    public void changeOnlineFinalExamStatus(Long examId, boolean state);

    @Modifying
    @Query(value = "delete from TBL_CLASS_PRE_COURSE_TEST_QUESTION where f_class_id = :id", nativeQuery = true)
    void deleteClassPreCourseTestQuestion(Long id);

    List<TestQuestion> findByTclassId(Long id);
}
