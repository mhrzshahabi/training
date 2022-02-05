package com.nicico.training.repository;

import com.nicico.training.model.ViewLearningEvaluationStudentReport;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ViewLearningEvaluationStudentReportDAO extends JpaRepository<ViewLearningEvaluationStudentReport, Long>, JpaSpecificationExecutor<ViewLearningEvaluationStudentReport> {

    List<ViewLearningEvaluationStudentReport> findAllByEndDateLessThanEqualAndStartDateGreaterThanEqual(String endDate, String startDate);
}
