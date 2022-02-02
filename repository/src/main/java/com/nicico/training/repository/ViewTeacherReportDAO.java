package com.nicico.training.repository;

import com.nicico.training.model.ViewTeacherReport;
import org.springframework.stereotype.Repository;

@Repository
public interface ViewTeacherReportDAO extends BaseDAO<ViewTeacherReport, Long> {

    ViewTeacherReport findFirstByNationalCode(String nationalCode);
}
