package com.nicico.training.service;

import com.nicico.training.dto.ContinuousStatusReportViewDTO;
import com.nicico.training.iservice.IContinuousStatusReportViewService;
import com.nicico.training.model.ContinuousStatusReportView;
import com.nicico.training.repository.ContinuousStatusReportViewDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class ContinuousStatusReportViewService extends BaseService<ContinuousStatusReportView, Long, ContinuousStatusReportViewDTO.Grid, ContinuousStatusReportViewDTO.Grid, ContinuousStatusReportViewDTO.Grid, ContinuousStatusReportViewDTO.Grid, ContinuousStatusReportViewDAO> implements IContinuousStatusReportViewService {

    @Autowired
    ContinuousStatusReportViewService(ContinuousStatusReportViewDAO continuousStatusReportViewDAO) {
        super(new ContinuousStatusReportView(), continuousStatusReportViewDAO);
    }

}
