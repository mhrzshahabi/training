package com.nicico.training.service;

import com.nicico.training.dto.ViewTrainingPostDTO;
import com.nicico.training.iservice.IViewTrainingPostReportService;
import com.nicico.training.model.ViewTrainingPostReport;
import com.nicico.training.repository.ViewTrainingPostReportDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class ViewTrainingPostReportService extends BaseService<ViewTrainingPostReport, Long, ViewTrainingPostDTO.Report, ViewTrainingPostDTO.Report, ViewTrainingPostDTO.Report, ViewTrainingPostDTO.Report, ViewTrainingPostReportDAO> implements IViewTrainingPostReportService {

    @Autowired
    ViewTrainingPostReportService(ViewTrainingPostReportDAO viewTrainingPostReportDAO) {
        super(new ViewTrainingPostReport(), viewTrainingPostReportDAO);
    }
}
