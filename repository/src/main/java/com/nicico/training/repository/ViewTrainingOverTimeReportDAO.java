package com.nicico.training.repository;

import com.nicico.training.model.ViewAttendanceOverTimeReportKey;
import com.nicico.training.model.ViewTrainingOverTimeReport;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface ViewTrainingOverTimeReportDAO extends JpaRepository<ViewTrainingOverTimeReport, ViewAttendanceOverTimeReportKey>, JpaSpecificationExecutor<ViewTrainingOverTimeReport> {
}
