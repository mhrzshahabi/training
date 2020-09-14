package com.nicico.training.repository;

import com.nicico.training.model.PersonnelDurationNAReport;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface PersonnelDurationNAReportDAO extends JpaRepository<PersonnelDurationNAReport, Long>, JpaSpecificationExecutor<PersonnelDurationNAReport> {
}
