package com.nicico.training.repository;

import com.nicico.training.model.TrainingFileNAReport;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TrainingFileNAReportDAO extends JpaRepository<TrainingFileNAReport, Long>, JpaSpecificationExecutor<TrainingFileNAReport> {

    @Query(value = "select * from VIEW_TRAINING_FILE_NA_REPORT_AND_EQUALS where PERSONNEL_ID=:personnelId", nativeQuery = true)
    List<TrainingFileNAReport> findAllWithEquals(Long personnelId);
}
