package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.ViewTeacherReportDTO;
import com.nicico.training.model.ViewTeacherReport;

public interface IViewTeacherReportService {
    ViewTeacherReport findFirstByNationalCode(String nationalCode);

    SearchDTO.SearchRs<ViewTeacherReportDTO.Info> search(SearchDTO.SearchRq searchRq);
}
