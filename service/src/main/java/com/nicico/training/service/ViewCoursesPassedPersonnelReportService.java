package com.nicico.training.service;

import com.nicico.training.dto.ViewCoursesPassedPersonnelReportDTO;
import com.nicico.training.model.ViewCoursesPassedPersonnelReport;
import com.nicico.training.repository.ViewCoursesPassedPersonnelReportDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


@RequiredArgsConstructor
@Service
public class ViewCoursesPassedPersonnelReportService extends
        BaseService<
                ViewCoursesPassedPersonnelReport,
                Long,
                ViewCoursesPassedPersonnelReportDTO.Info,
                ViewCoursesPassedPersonnelReportDTO.Info,
                ViewCoursesPassedPersonnelReportDTO.Info,
                ViewCoursesPassedPersonnelReportDTO.Info,
                ViewCoursesPassedPersonnelReportDAO> {

    @Autowired
    ViewCoursesPassedPersonnelReportService(ViewCoursesPassedPersonnelReportDAO ViewCoursesPassedPersonnelReportDAO) {
        super(new ViewCoursesPassedPersonnelReport(), ViewCoursesPassedPersonnelReportDAO);
    }

}