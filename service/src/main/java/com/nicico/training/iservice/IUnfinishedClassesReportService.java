package com.nicico.training.iservice;

import com.nicico.training.dto.UnfinishedClassesReportDTO;

import java.util.List;

public interface IUnfinishedClassesReportService {
    public List<UnfinishedClassesReportDTO> UnfinishedClassesList();
}
