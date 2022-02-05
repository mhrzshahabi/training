package com.nicico.training.service;

import com.nicico.training.dto.ViewCoursesPassedPersonnelReportDTO;
import com.nicico.training.iservice.IViewCoursesPassedPersonnelReportService;
import com.nicico.training.model.ViewCoursesPassedPersonnelReport;
import com.nicico.training.repository.ViewCoursesPassedPersonnelReportDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class ViewCoursesPassedPersonnelReportService extends BaseService<ViewCoursesPassedPersonnelReport, Long, ViewCoursesPassedPersonnelReportDTO.Grid, ViewCoursesPassedPersonnelReportDTO.Grid, ViewCoursesPassedPersonnelReportDTO.Grid, ViewCoursesPassedPersonnelReportDTO.Grid, ViewCoursesPassedPersonnelReportDAO> implements IViewCoursesPassedPersonnelReportService {

        @Autowired
        ViewCoursesPassedPersonnelReportService(ViewCoursesPassedPersonnelReportDAO viewCoursesPassedPersonnelReportDAO) {
                super(new ViewCoursesPassedPersonnelReport(), viewCoursesPassedPersonnelReportDAO);
        }

}