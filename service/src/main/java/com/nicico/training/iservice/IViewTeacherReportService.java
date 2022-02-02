package com.nicico.training.iservice;

import com.nicico.training.model.ViewTeacherReport;

public interface IViewTeacherReportService {
    ViewTeacherReport findFirstByNationalCode(String nationalCode);

}
