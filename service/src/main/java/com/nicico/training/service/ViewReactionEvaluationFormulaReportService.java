package com.nicico.training.service;

import com.nicico.training.dto.ViewReactionEvaluationFormulaReportDTO;
import com.nicico.training.iservice.IViewReactionEvaluationFormulaReportService;
import com.nicico.training.model.ViewReactionEvaluationFormulaReport;
import com.nicico.training.repository.ViewReactionEvaluationFormulaReportDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


@RequiredArgsConstructor
@Service
public class ViewReactionEvaluationFormulaReportService extends BaseService<ViewReactionEvaluationFormulaReport, Long, ViewReactionEvaluationFormulaReportDTO.Info, ViewReactionEvaluationFormulaReportDTO.Info, ViewReactionEvaluationFormulaReportDTO.Info, ViewReactionEvaluationFormulaReportDTO.Info, ViewReactionEvaluationFormulaReportDAO> implements IViewReactionEvaluationFormulaReportService {

    private ViewReactionEvaluationFormulaReportDAO viewReactionEvaluationFormulaReportDAO;


    @Autowired
    ViewReactionEvaluationFormulaReportService(ViewReactionEvaluationFormulaReportDAO viewReactionEvaluationFormulaReportDAO) {
        super(new ViewReactionEvaluationFormulaReport(), viewReactionEvaluationFormulaReportDAO);
        this.viewReactionEvaluationFormulaReportDAO = viewReactionEvaluationFormulaReportDAO;

    }

    @Override
    public String getPercentReaction(Long classId) {
        return viewReactionEvaluationFormulaReportDAO.getPercentReaction(classId);
    }
}
