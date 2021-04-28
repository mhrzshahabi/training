package com.nicico.training.repository;

import com.nicico.training.model.ViewTrainingPostReport;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ViewTrainingPostReportDAO extends BaseDAO<ViewTrainingPostReport, Long> {

    @Query(value = "SELECT p.* FROM VIEW_TRAINING_POST_REPORT p WHERE p.N_COMPETENCE_COUNT =:compCount AND p.C_MOJTAME_TITLE in :complexes  AND p.C_ASSISTANCE in :assistances " +
            "AND p.C_AFFAIRS in :affairs AND p.C_SECTION in :sections AND p.C_UNIT in :units", nativeQuery = true)
    List<ViewTrainingPostReport> findAllByAreaAndCompetenceCount(Integer compCount, String[] complexes, String[] assistances, String[] affairs, String[] sections, String[] units);
}
