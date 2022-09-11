package com.nicico.training.iservice;

import com.nicico.training.dto.TimeInterferenceComprehensiveClassesDTO;
import java.util.List;


public interface ITimeInterferenceComprehensiveClassesReportService {

    List<TimeInterferenceComprehensiveClassesDTO> list(String startDate, String endDate) throws Exception;
}
