package com.nicico.training.repository;

import com.nicico.training.model.PersonnelCoursePassedNAReportView;
import com.nicico.training.model.compositeKey.PersonnelCourseKey;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface PersonnelCoursePassedNAReportViewDAO extends JpaRepository<PersonnelCoursePassedNAReportView, PersonnelCourseKey>, JpaSpecificationExecutor<PersonnelCoursePassedNAReportView> {

}
