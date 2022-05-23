package com.nicico.training.iservice;

import response.exam.ElsExamStudentsStateDto;

import java.util.List;

public interface IExamMonitoringService {

    List<ElsExamStudentsStateDto> getExamMonitoringData(List<ElsExamStudentsStateDto> studentsList);
}
