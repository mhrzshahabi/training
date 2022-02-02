package com.nicico.training.service;

import com.nicico.copper.core.SecurityUtil;
import com.nicico.training.dto.ViewTeacherReportDTO;
import com.nicico.training.iservice.IViewTeacherReportService;
import com.nicico.training.model.ViewTeacherReport;
import com.nicico.training.repository.ViewTeacherReportDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class ViewTeacherReportService extends BaseService<ViewTeacherReport, Long, ViewTeacherReportDTO.Info, ViewTeacherReportDTO.Info, ViewTeacherReportDTO.Info, ViewTeacherReportDTO.Info, ViewTeacherReportDAO> implements IViewTeacherReportService {


    @Autowired
    ViewTeacherReportService(ViewTeacherReportDAO viewTeacherReportDAO) {
        super(new ViewTeacherReport(), viewTeacherReportDAO);
    }

    @Override
    public ViewTeacherReport findFirstByNationalCode(String nationalCode) {
        return dao.findFirstByNationalCode(nationalCode);
    }
}
