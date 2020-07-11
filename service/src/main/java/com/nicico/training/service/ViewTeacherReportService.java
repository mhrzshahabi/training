package com.nicico.training.service;

import com.nicico.training.dto.ViewTeacherReportDTO;
import com.nicico.training.model.ViewTeacherReport;
import com.nicico.training.repository.ViewTeacherReportDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class ViewTeacherReportService extends BaseService<ViewTeacherReport, Long, ViewTeacherReportDTO.Info, ViewTeacherReportDTO.Info, ViewTeacherReportDTO.Info, ViewTeacherReportDTO.Info, ViewTeacherReportDAO>{

    @Autowired
    ViewTeacherReportService(ViewTeacherReportDAO viewTeacherReportDAO) {
        super(new ViewTeacherReport(), viewTeacherReportDAO);
    }

}
