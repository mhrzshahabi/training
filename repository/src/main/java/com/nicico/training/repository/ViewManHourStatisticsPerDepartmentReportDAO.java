package com.nicico.training.repository;

import com.nicico.training.model.ViewManHourStatisticsPerDepartmentReport;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface ViewManHourStatisticsPerDepartmentReportDAO extends JpaRepository<ViewManHourStatisticsPerDepartmentReport, Long>, JpaSpecificationExecutor<ViewManHourStatisticsPerDepartmentReport> {

}
