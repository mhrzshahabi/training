package com.nicico.training.repository;/* com.nicico.training.repository
@Author:jafari-h
@Date:5/28/2019
@Time:2:37 PM
*/

import com.nicico.training.model.Goal;
import com.nicico.training.model.StudentClassReportView;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface StudentClassReportViewDAO extends JpaRepository<StudentClassReportView, Long>, JpaSpecificationExecutor<StudentClassReportView> {
}
