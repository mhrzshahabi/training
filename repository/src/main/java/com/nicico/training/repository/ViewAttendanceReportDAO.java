/*
 * Author: Mehran Golrokhi
 */

package com.nicico.training.repository;

import com.nicico.training.model.ViewAttendanceReport;
import com.nicico.training.model.compositeKey.ViewAttendanceReportKey;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface ViewAttendanceReportDAO extends JpaRepository<ViewAttendanceReport, ViewAttendanceReportKey>, JpaSpecificationExecutor<ViewAttendanceReport> {

}
