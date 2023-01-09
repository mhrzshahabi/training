package com.nicico.training.service;

import com.nicico.training.dto.ViewEvaluationIndexByFieldReportDTO;
import com.nicico.training.iservice.IViewEvaluationIndexByFieldReportService;
import com.nicico.training.model.ViewEvaluationIndexByFieldReport;
import com.nicico.training.repository.ViewEvaluationIndexByFieldDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class ViewEvaluationIndexByFieldReportService extends BaseService<ViewEvaluationIndexByFieldReport, Long, ViewEvaluationIndexByFieldReportDTO.Info, ViewEvaluationIndexByFieldReportDTO.Info, ViewEvaluationIndexByFieldReportDTO.Info, ViewEvaluationIndexByFieldReportDTO.Info, ViewEvaluationIndexByFieldDAO> implements IViewEvaluationIndexByFieldReportService {

    @Autowired
    ViewEvaluationIndexByFieldReportService(ViewEvaluationIndexByFieldDAO viewEvaluationIndexByFieldDAO) {
        super(new ViewEvaluationIndexByFieldReport(), viewEvaluationIndexByFieldDAO);
    }

}
