package com.nicico.training.iservice;

import com.nicico.training.dto.ClassCourseSumByFeaturesAndDepartmentReportDTO;
import com.nicico.training.dto.ClassCourseSumByFeaturesAndDepartmentReportDTO.GroupBy;
import com.nicico.training.dto.ClassCourseSumByFeaturesAndDepartmentReportDTO.ClassFeatures;
import com.nicico.training.dto.ClassCourseSumByFeaturesAndDepartmentReportDTO.ClassSumByStatus;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface IClassCourseSumByFeaturesAndDepartmentReportService {

    @Transactional(readOnly = true)
    List<ClassCourseSumByFeaturesAndDepartmentReportDTO> getReport(String startDate,
                                                                   String endDate,
                                                                   String mojtameCode,
                                                                   String moavenatCode,
                                                                   String omorCode);

    @Transactional(readOnly = true)
    List<ClassFeatures> getReportForMultipleDepartment(String startDate,
                                                                                                      String endDate,
                                                                                                      List<String> mojtameCodes,
                                                                                                      List<String> moavenatCodes,
                                                                                                      List<String> omorCodes,
                                                                                                      GroupBy groupBy);

    @Transactional(readOnly = true)
    List<ClassSumByStatus> getSumReportByClassStatus(String startDate,
                                                     String endDate,
                                                     List<String> mojtameCodes,
                                                     List<String> moavenatCodes,
                                                     List<String> omorCodes);

    List<ClassSumByStatus> getSummeryGroupByCategory(String startDate, String endDate, List<String> mojtameCodes, List<String> moavenatCodes, List<String> omorCodes);
}
