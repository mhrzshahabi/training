package com.nicico.training.service;

import com.nicico.training.dto.ViewCoursesEvaluationReportDTO;
import com.nicico.training.iservice.IViewCoursesEvaluationReportService;
import com.nicico.training.model.ViewCoursesEvaluationReport;
import com.nicico.training.repository.ViewCoursesEvaluationReportDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class ViewCoursesEvaluationReportService extends BaseService<ViewCoursesEvaluationReport, Long, ViewCoursesEvaluationReportDTO.Info, ViewCoursesEvaluationReportDTO.Info, ViewCoursesEvaluationReportDTO.Info, ViewCoursesEvaluationReportDTO.Info, ViewCoursesEvaluationReportDAO> implements IViewCoursesEvaluationReportService {

    @Autowired
    ViewCoursesEvaluationReportService(ViewCoursesEvaluationReportDAO viewCoursesEvaluationReportDAO) {
        super(new ViewCoursesEvaluationReport(), viewCoursesEvaluationReportDAO);
    }

}
