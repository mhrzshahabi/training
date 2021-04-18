package com.nicico.training.service;

import com.nicico.training.dto.ViewTrainingPostDTO;
import com.nicico.training.model.ViewTrainingPost;
import com.nicico.training.model.ViewTrainingPostReport;
import com.nicico.training.repository.ViewTrainingPostDAO;
import com.nicico.training.repository.ViewTrainingPostReportDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class ViewTrainingPostReportService extends BaseService<ViewTrainingPostReport, Long, ViewTrainingPostDTO.Report, ViewTrainingPostDTO.Report, ViewTrainingPostDTO.Report, ViewTrainingPostDTO.Report, ViewTrainingPostReportDAO>{

    @Autowired
    ViewTrainingPostReportService(ViewTrainingPostReportDAO viewTrainingPostReportDAO) {
        super(new ViewTrainingPostReport(), viewTrainingPostReportDAO);
    }
}
