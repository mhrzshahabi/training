package com.nicico.training.repository;


import com.nicico.training.model.ClassStudent;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

import java.util.List;

public interface ClassStudentDAO extends JpaRepository<ClassStudent, Long>, JpaSpecificationExecutor<ClassStudent> {

    @Modifying
    @Query(value = "update TBL_CLASS_STUDENT set " +
            "EVALUATION_STATUS_REACTION = :reaction, " +
            "EVALUATION_STATUS_LEARNING = :learning, " +
            "EVALUATION_STATUS_BEHAVIOR = :behavior, " +
            "EVALUATION_STATUS_RESULTS = :results " +
            "where id = :idClassStudent", nativeQuery = true)
    public int setStudentFormIssuance(Long idClassStudent, Integer reaction, Integer learning, Integer behavior, Integer results);

    List<ClassStudent> findByStudentId(Long studentId);
    @Modifying
    @Query(value = "update  TBL_CLASS_STUDENT set SCORES_STATE = 'قبول بدون نمره' ,  FAILURE_REASON = null where CLASS_ID =:id ", nativeQuery = true)
    void setTotalStudentWithOutScore(@Param("id") Long id);

}
