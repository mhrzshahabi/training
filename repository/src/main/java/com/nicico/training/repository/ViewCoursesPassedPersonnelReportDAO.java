package com.nicico.training.repository;

import com.nicico.training.model.ViewCoursesPassedPersonnelReport;
import com.nicico.training.model.compositeKey.PersonnelCourseKey;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

public interface ViewCoursesPassedPersonnelReportDAO extends JpaRepository<ViewCoursesPassedPersonnelReport, PersonnelCourseKey>, JpaSpecificationExecutor<ViewCoursesPassedPersonnelReport> {
}