package com.nicico.training.iservice;

import com.nicico.training.dto.ClassCourseSumByFeaturesAndDepartmentReportDTO;
import com.nicico.training.dto.ClassCourseSumByFeaturesAndDepartmentReportDTO.GroupBy;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface IClassCourseSumByFeaturesAndDepartmentReportService {

    @Transactional(readOnly = true)
    List<ClassCourseSumByFeaturesAndDepartmentReportDTO> getReport(String startDate,
                                                                   String endDate,
                                                                   String mojtameCode,
                                                                   String moavenatCode,
                                                                   String omorCode,
                                                                   GroupBy groupBy);
}
