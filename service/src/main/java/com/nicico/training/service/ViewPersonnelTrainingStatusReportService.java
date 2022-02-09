package com.nicico.training.service;

import com.nicico.training.dto.ViewPersonnelTrainingStatusReportDTO;
import com.nicico.training.iservice.IViewPersonnelTrainingStatusReportService;
import com.nicico.training.model.ViewPersonnelTrainingStatusReport;
import com.nicico.training.model.compositeKey.PersonnelClassKey;
import com.nicico.training.repository.ViewPersonnelTrainingStatusReportDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class ViewPersonnelTrainingStatusReportService extends BaseService<ViewPersonnelTrainingStatusReport, PersonnelClassKey, ViewPersonnelTrainingStatusReportDTO.Info, ViewPersonnelTrainingStatusReportDTO.Info, ViewPersonnelTrainingStatusReportDTO.Info, ViewPersonnelTrainingStatusReportDTO.Info, ViewPersonnelTrainingStatusReportDAO> implements IViewPersonnelTrainingStatusReportService {
    @Autowired
    ViewPersonnelTrainingStatusReportService(ViewPersonnelTrainingStatusReportDAO viewPersonnelTrainingStatusReportDAO) {
        super(new ViewPersonnelTrainingStatusReport(), viewPersonnelTrainingStatusReportDAO);
    }
}
