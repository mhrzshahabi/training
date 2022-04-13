package com.nicico.training.service;

import com.nicico.training.dto.ViewCoursesEvaluationStatisticalReportDTO;
import com.nicico.training.iservice.IViewCoursesEvaluationStatisticalReportService;
import com.nicico.training.model.ViewCoursesEvaluationStatisticalReport;
import com.nicico.training.repository.ViewCoursesEvaluationStatisticalReportDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class ViewCoursesEvaluationStatisticalReportService extends BaseService<ViewCoursesEvaluationStatisticalReport, Long, ViewCoursesEvaluationStatisticalReportDTO, ViewCoursesEvaluationStatisticalReportDTO, ViewCoursesEvaluationStatisticalReportDTO, ViewCoursesEvaluationStatisticalReportDTO, ViewCoursesEvaluationStatisticalReportDAO> implements IViewCoursesEvaluationStatisticalReportService {

    @Autowired
    ViewCoursesEvaluationStatisticalReportService(ViewCoursesEvaluationStatisticalReportDAO viewCoursesEvaluationStatisticalReportDAO) {
        super(new ViewCoursesEvaluationStatisticalReport(), viewCoursesEvaluationStatisticalReportDAO);
    }

}
