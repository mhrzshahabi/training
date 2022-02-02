package com.nicico.training.repository;

import com.nicico.training.model.ViewStudentsInCanceledClassReport;
import com.nicico.training.model.compositeKey.ViewStudentsInCanceledClassReportKey;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface ViewStudentsInCanceledClassReportDAO extends JpaRepository<ViewStudentsInCanceledClassReport,ViewStudentsInCanceledClassReportKey>, JpaSpecificationExecutor<ViewStudentsInCanceledClassReport> {
}