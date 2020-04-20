package com.nicico.training.repository;/* com.nicico.training.repository
@Author:jafari-h
@Date:5/28/2019
@Time:2:37 PM
*/

import com.nicico.training.model.Goal;
import com.nicico.training.model.StudentClassReportView;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface StudentClassReportViewDAO extends JpaRepository<StudentClassReportView, Long>, JpaSpecificationExecutor<StudentClassReportView> {
    @Query(value = "SELECT DISTINCT  VIEW_STUDENT_CLASSSTUDENT_CLASS_TERM_COURSE.CLASS_STUDENT_SCORES_STATE FROM VIEW_STUDENT_CLASSSTUDENT_CLASS_TERM_COURSE WHERE VIEW_STUDENT_CLASSSTUDENT_CLASS_TERM_COURSE.CLASS_STUDENT_SCORES_STATE is not null order by VIEW_STUDENT_CLASSSTUDENT_CLASS_TERM_COURSE.CLASS_STUDENT_SCORES_STATE", nativeQuery = true)
    List<String> findAllScoreStateFromViewSCRV();
}
