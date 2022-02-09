package com.nicico.training.service;

import com.nicico.training.dto.ViewEvaluationStaticalReportDTO;
import com.nicico.training.iservice.IViewEvaluationStaticalReportService;
import com.nicico.training.model.ViewEvaluationStaticalReport;
import com.nicico.training.repository.ViewEvaluationStaticalReportDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class ViewEvaluationStaticalReportService extends BaseService<ViewEvaluationStaticalReport, Long, ViewEvaluationStaticalReportDTO.Info, ViewEvaluationStaticalReportDTO.Info, ViewEvaluationStaticalReportDTO.Info, ViewEvaluationStaticalReportDTO.Info, ViewEvaluationStaticalReportDAO> implements IViewEvaluationStaticalReportService {

    @Autowired
    ViewEvaluationStaticalReportService(ViewEvaluationStaticalReportDAO viewEvaluationStaticalReportDAO) {
        super(new ViewEvaluationStaticalReport(), viewEvaluationStaticalReportDAO);
    }

}
