package com.nicico.training.repository;

import com.nicico.training.model.ViewUnjustifiedAbsenceReport;
import com.nicico.training.model.compositeKey.ViewUnjustifiedAbsenceReportKey;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface ViewUnjustifiedAbsenceReportDAO extends JpaRepository<ViewUnjustifiedAbsenceReport, ViewUnjustifiedAbsenceReportKey>, JpaSpecificationExecutor<ViewUnjustifiedAbsenceReport> {
}
