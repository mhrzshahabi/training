package com.nicico.training.repository;

import com.nicico.training.model.ViewTeacherQuestionCountReport;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface ViewTeacherQuestionCountReportDAO extends JpaRepository<ViewTeacherQuestionCountReport, Long>, JpaSpecificationExecutor<ViewTeacherQuestionCountReport> {

}
