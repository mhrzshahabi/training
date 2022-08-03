package com.nicico.training.service;

import com.nicico.training.dto.GenericStatisticalIndexReportDTO;
import com.nicico.training.iservice.IGenericStatisticalIndexReportService;
import com.nicico.training.model.GenericStatisticalIndexReport;
import com.nicico.training.repository.GenericStatisticalIndexReportDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@RequiredArgsConstructor
@Service
public class GenericStatisticalIndexReportService implements IGenericStatisticalIndexReportService {

    private final ModelMapper modelMapper;
    private final GenericStatisticalIndexReportDAO genericStatisticalIndexReportDAO;

    @Override
    public List<GenericStatisticalIndexReportDTO>  getQueryResult(String reportName,
                                                                 String fromDate,
                                                                 String toDate,
                                                                 List<Object> complex,
                                                                 int complexNull,
                                                                 List<Object> assistant,
                                                                 int assistantNull,
                                                                 List<Object> affairs,
                                                                 int affairsNull) {

        List<GenericStatisticalIndexReport> result = new ArrayList<>();
        switch (reportName) {
            case "report01":
                result = genericStatisticalIndexReportDAO.needAssessment(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
                break;
            case "report02":
                result = genericStatisticalIndexReportDAO.getTotalHours(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
                break;
            case "report03":
                result = genericStatisticalIndexReportDAO.saraneomomi(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
                break;
            case "report04":
                result = genericStatisticalIndexReportDAO.saratakhasosi(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
                break;
            case "report05":
                result = genericStatisticalIndexReportDAO.saraneModiriati(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
                break;
            case "report06":
                result = genericStatisticalIndexReportDAO.gozarAzAmozesh(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
                break;
            case "report07":
                result = genericStatisticalIndexReportDAO.arzeshyabiYadgiri(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
                break;
            case "report08":
                result = genericStatisticalIndexReportDAO.getTechnicalTrainingNeeds(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
                break;
            case "report09":
                result = genericStatisticalIndexReportDAO.getSkillTrainingNeeds(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
                break;
            case "report10":
                result = genericStatisticalIndexReportDAO.posheshFardi(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
                break;
        }


        return modelMapper.map(result, new TypeToken<List<GenericStatisticalIndexReportDTO>>() {
        }.getType());
    }
}
