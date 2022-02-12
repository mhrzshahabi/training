package com.nicico.training.iservice;

import com.nicico.training.model.ClassStudent;

import java.util.List;

public interface IClassStudentReportService {
    List<ClassStudent> searchClassRegisterOfStudentByNationalCode(String nationalCode);
}
