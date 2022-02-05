package com.nicico.training.service;

import com.nicico.training.dto.ViewUnfinishedClassesReportDTO;
import com.nicico.training.iservice.IViewUnfinishedClassesReportService;
import com.nicico.training.model.ViewUnfinishedClassesReport;
import com.nicico.training.repository.ViewUnfinishedClassesReportDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class ViewUnfinishedClassesReportService extends BaseService<
        ViewUnfinishedClassesReport,
        Long,
        ViewUnfinishedClassesReportDTO.Grid,
        ViewUnfinishedClassesReportDTO.Grid,
        ViewUnfinishedClassesReportDTO.Grid,
        ViewUnfinishedClassesReportDTO.Grid,
        ViewUnfinishedClassesReportDAO> implements IViewUnfinishedClassesReportService {

        @Autowired
        ViewUnfinishedClassesReportService(ViewUnfinishedClassesReportDAO viewUnfinishedClassesReportDAO) {
                super(new ViewUnfinishedClassesReport(), viewUnfinishedClassesReportDAO);
        }
}