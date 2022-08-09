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
                result = genericStatisticalIndexReportDAO.trainingStaffToTotalStaff( complex, complexNull, assistant, assistantNull, affairs, affairsNull);
                break;
            case "report11":
                result = genericStatisticalIndexReportDAO.teachingLearningLevelOfNewCourses(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
                break;
            case "report12":
                result = genericStatisticalIndexReportDAO.teachingLearningLevelOfFrequentCourses(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
                break;
            case "report13":
                result = genericStatisticalIndexReportDAO.teachingRatioOfInternalTeachers(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
                break;
            case "report14":
                result = genericStatisticalIndexReportDAO.ojt(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
                break;
            case "report15":
                result = genericStatisticalIndexReportDAO.proportionOfTrainingOutsideTheCalendar(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
                break;
            case "report16":
                result = genericStatisticalIndexReportDAO.canceledCourses(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
                break;
            case "report17":
                result = genericStatisticalIndexReportDAO.trainingOutsideTheOrganization(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
                break;
            case "report18":
                result = genericStatisticalIndexReportDAO.trainingWithInTheOrganization(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
                break;
            case "report19":
                result = genericStatisticalIndexReportDAO.specializedTrainingForCustomers(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
                break;
            case "report20":
                result = genericStatisticalIndexReportDAO.HSE(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
                break;
            case "report21":
                result = genericStatisticalIndexReportDAO.lowerThanBachelor(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
                break;
            case "report22":
                result = genericStatisticalIndexReportDAO.trainingOfSupervisors(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
                break;
            case "report23":
                result = genericStatisticalIndexReportDAO.managersTrainingPerCapita(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
                break;

                case "report24":
                result = genericStatisticalIndexReportDAO.capitaOfContractingForces(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
                break;
                case "report25":
                result = genericStatisticalIndexReportDAO.trainingHoursOfTheCompany(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
                break;
        }


        return modelMapper.map(result, new TypeToken<List<GenericStatisticalIndexReportDTO>>() {
        }.getType());
    }
}
