package com.nicico.training.service;

import com.nicico.training.dto.ViewPersonnelCourseNaReportDTO;
import com.nicico.training.iservice.IViewPersonnelCourseNaReportService;
import com.nicico.training.model.ViewPersonnelCourseNaReport;
import com.nicico.training.repository.ViewPersonnelCourseNaReportDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class ViewPersonnelCourseNaReportService extends BaseService<ViewPersonnelCourseNaReport, Long, ViewPersonnelCourseNaReportDTO.Grid, ViewPersonnelCourseNaReportDTO.Grid, ViewPersonnelCourseNaReportDTO.Grid, ViewPersonnelCourseNaReportDTO.Grid, ViewPersonnelCourseNaReportDAO> implements IViewPersonnelCourseNaReportService {

        @Autowired
        ViewPersonnelCourseNaReportService(ViewPersonnelCourseNaReportDAO viewPersonnelCourseNaReportDAO) {
                super(new ViewPersonnelCourseNaReport(), viewPersonnelCourseNaReportDAO);
        }

}