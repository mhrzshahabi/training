package com.nicico.training.repository;

import com.nicico.training.model.ViewLearningEvaluationCourseReport;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ViewLearningEvaluationCourseReportDAO extends JpaRepository<ViewLearningEvaluationCourseReport, Long>, JpaSpecificationExecutor<ViewLearningEvaluationCourseReport> {


    List<ViewLearningEvaluationCourseReport>   findAllByEndDateLessThanEqualAndStartDateGreaterThanEqual(String endDate, String startDate);

}
