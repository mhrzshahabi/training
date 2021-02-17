package com.nicico.training.repository;

import com.nicico.training.model.ViewTrainingPost;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ViewTrainingPostDAO extends BaseDAO<ViewTrainingPost, Long> {

    @Query(value = "SELECT p.* FROM VIEW_TRAINING_POST p WHERE p.N_COMPETENCE_COUNT =:compCount AND p.C_AREA =:area", nativeQuery = true)
    List<ViewTrainingPost> findAllByAreaAndCompetenceCount(Integer compCount, String area);
}
