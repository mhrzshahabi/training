package com.nicico.training.iservice;

import com.nicico.training.dto.TrainingOverTimeDTO;

import java.util.List;

public interface ITrainingOverTimeService {
    public List<TrainingOverTimeDTO> getTrainingOverTimeReportList(String startDate, String endDate);
}
