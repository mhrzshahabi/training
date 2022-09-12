package com.nicico.training.service;

import com.nicico.training.dto.TimeInterferenceComprehensiveClassesDTO;
import com.nicico.training.iservice.ITimeInterferenceComprehensiveClassesReportService;
import com.nicico.training.mapper.TimeInterferenceComprehensiveClassesReport.TimeInterferenceComprehensiveClassesReportMapper;
import com.nicico.training.model.TimeInterferenceComprehensiveClassesView;
import com.nicico.training.repository.TimeInterferenceComprehensiveClassesReportDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
@RequiredArgsConstructor
public class TimeInterferenceComprehensiveClassesReportService implements ITimeInterferenceComprehensiveClassesReportService {
    private  final TimeInterferenceComprehensiveClassesReportDAO timeInterferenceDAO;
    private  final TimeInterferenceComprehensiveClassesReportMapper mapper;

    @Override
    public List<TimeInterferenceComprehensiveClassesDTO> list(String startDate, String endDate) throws Exception {
        List<TimeInterferenceComprehensiveClassesView>  objectResult = timeInterferenceDAO.list(startDate, endDate);
        return  mapper.toTimeInterferenceComprehensiveClassesDTOs(objectResult);
    }

}
