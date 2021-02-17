package com.nicico.training.repository;

import com.nicico.training.model.ViewTrainingNeedAssessment;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ViewTrainingNeedAssessmentDAO extends BaseDAO<ViewTrainingNeedAssessment, Long> {

    @Query(value = "SELECT p.* FROM VIEW_TRAINING_NEED_ASSESSMENT p WHERE p.C_ID =:categoryId", nativeQuery = true)
    List<ViewTrainingNeedAssessment> findAllByCategoryId (Long categoryId);
}
