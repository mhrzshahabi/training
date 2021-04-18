package com.nicico.training.repository;

import com.nicico.training.model.ViewTrainingPostReport;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ViewTrainingPostReportDAO extends BaseDAO<ViewTrainingPostReport, Long> {

    @Query(value = "SELECT p.* FROM VIEW_TRAINING_POST_REPORT p WHERE p.N_COMPETENCE_COUNT =:compCount AND p.C_MOJTAME_CODE in :areas", nativeQuery = true)
    List<ViewTrainingPostReport> findAllByAreaAndCompetenceCount(Integer compCount, String[] areas);
}
