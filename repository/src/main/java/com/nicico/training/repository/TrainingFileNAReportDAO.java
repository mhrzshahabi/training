package com.nicico.training.repository;

import com.nicico.training.model.TrainingFileNAReport;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface TrainingFileNAReportDAO extends JpaRepository<TrainingFileNAReport, Long>, JpaSpecificationExecutor<TrainingFileNAReport> {
}
