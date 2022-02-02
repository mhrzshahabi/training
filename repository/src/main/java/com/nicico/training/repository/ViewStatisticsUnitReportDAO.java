package com.nicico.training.repository;

import com.nicico.training.model.ViewStatisticsUnitReport;
import com.nicico.training.model.compositeKey.ViewStatisticsUnitReportKey;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface ViewStatisticsUnitReportDAO extends JpaRepository<ViewStatisticsUnitReport, ViewStatisticsUnitReportKey>, JpaSpecificationExecutor<ViewStatisticsUnitReport> {
}
