package com.nicico.training.repository;

import com.nicico.training.model.PersonnelCourseNotPassedReportView;
import com.nicico.training.model.compositeKey.PersonnelCourseKey;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface PersonnelCourseNotPassedReportViewDAO extends JpaRepository<PersonnelCourseNotPassedReportView, PersonnelCourseKey>, JpaSpecificationExecutor<PersonnelCourseNotPassedReportView> {
}
