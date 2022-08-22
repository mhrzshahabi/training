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
    public List<GenericStatisticalIndexReportDTO> getQueryResult(String reportName,
                                                                 String fromDate,
                                                                 String toDate,
                                                                 List<Object> complex,
                                                                 int complexNull,
                                                                 List<Object> assistant,
                                                                 int assistantNull,
                                                                 List<Object> affairs,
                                                                 int affairsNull) {



        
        List<GenericStatisticalIndexReport> result;
        List<Object> objectResult;
        result = switch (reportName) {
            case "report01"-> genericStatisticalIndexReportDAO.needAssessment(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "report02"-> genericStatisticalIndexReportDAO.getTotalHours(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "report03"-> genericStatisticalIndexReportDAO.saraneomomi(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "report04"-> genericStatisticalIndexReportDAO.saratakhasosi(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "report05"-> genericStatisticalIndexReportDAO.saraneModiriati(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "report06"-> genericStatisticalIndexReportDAO.gozarAzAmozesh(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "report07"-> genericStatisticalIndexReportDAO.arzeshyabiYadgiri(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "report08"-> genericStatisticalIndexReportDAO.getTechnicalTrainingNeeds(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "report09"-> genericStatisticalIndexReportDAO.getSkillTrainingNeeds(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "report10"-> genericStatisticalIndexReportDAO.trainingStaffToTotalStaff(complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "report11"-> genericStatisticalIndexReportDAO.teachingLearningLevelOfNewCourses(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "report12"-> genericStatisticalIndexReportDAO.teachingLearningLevelOfFrequentCourses(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "report13"-> genericStatisticalIndexReportDAO.teachingRatioOfInternalTeachers(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "report14"-> genericStatisticalIndexReportDAO.ojt(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "report15"-> genericStatisticalIndexReportDAO.proportionOfTrainingOutsideTheCalendar(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "report16"-> genericStatisticalIndexReportDAO.canceledCourses(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "report17"-> genericStatisticalIndexReportDAO.trainingOutsideTheOrganization(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "report18"-> genericStatisticalIndexReportDAO.trainingWithInTheOrganization(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "report19"-> genericStatisticalIndexReportDAO.specializedTrainingForCustomers(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "report20"-> genericStatisticalIndexReportDAO.HSE(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "report21"-> genericStatisticalIndexReportDAO.lowerThanBachelor(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "report22"-> genericStatisticalIndexReportDAO.trainingOfSupervisors(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "report23"-> genericStatisticalIndexReportDAO.managersTrainingPerCapita(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "report24"-> genericStatisticalIndexReportDAO.capitaOfContractingForces(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "report25"-> genericStatisticalIndexReportDAO.trainingHoursOfTheCompany(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "report26"-> genericStatisticalIndexReportDAO.educationParticipationRateIndex(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "report27"-> genericStatisticalIndexReportDAO.indexOfTheRatioOfImplementedTrainings(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "report28"-> genericStatisticalIndexReportDAO.percentageOfcalendarTitleOfTheCourse(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "report29"-> genericStatisticalIndexReportDAO.percentageOfcalendarTitleOfTheStudent(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "report30"-> genericStatisticalIndexReportDAO.totalNumberOfTeachers(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "report31"-> genericStatisticalIndexReportDAO.totalNumberOfInnerTeachers(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "report32"-> genericStatisticalIndexReportDAO.ratioOfEvaluatedTeachers(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "report33"-> genericStatisticalIndexReportDAO.electronicallyExecuted(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "report34"-> genericStatisticalIndexReportDAO.performedInAbsentia(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "report35"->{
                objectResult = genericStatisticalIndexReportDAO.proportionOfDesignedManagementCourses(fromDate, toDate);
                yield convertObject(objectResult, "محاسبه بر اساس کل سازمان می باشد (دوره)");
        }
            case "report36"->{
                objectResult = genericStatisticalIndexReportDAO.revisedLessonPlansRatio(fromDate, toDate);
                yield convertObject(objectResult, "محاسبه بر اساس کل سازمان می باشد (دوره)");
        }
            case "report37"->{
                objectResult = genericStatisticalIndexReportDAO.proportionOfNewLessonPlans(fromDate, toDate);
                yield convertObject(objectResult, "محاسبه بر اساس کل سازمان می باشد (دوره)");
        }
            case "report38"-> genericStatisticalIndexReportDAO.educationPenetrationRate(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "report39"-> genericStatisticalIndexReportDAO.rateOfEducationInGeneral(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "report40"-> genericStatisticalIndexReportDAO.rateOfEducationInOneYear(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "report41"->{
                objectResult = genericStatisticalIndexReportDAO.lowerThanExpertise(fromDate, toDate);
                yield convertObject(objectResult, "محاسبه بر اساس کل سازمان می باشد (شغل)");
            }
            case "report42"->{
                objectResult = genericStatisticalIndexReportDAO.supervisionJob(fromDate, toDate);
                yield convertObject(objectResult, "محاسبه بر اساس کل سازمان می باشد (شغل)");}
            case "report43"->{
                objectResult = genericStatisticalIndexReportDAO.mastersJob(fromDate, toDate);
                yield convertObject(objectResult, "محاسبه بر اساس کل سازمان می باشد (شغل)");}
            case "report44"->{
                objectResult = genericStatisticalIndexReportDAO.jobModiriati(fromDate, toDate);
                yield convertObject(objectResult, "محاسبه بر اساس کل سازمان می باشد (شغل)");}
            case "report45"->{
                objectResult = genericStatisticalIndexReportDAO.jobNeedAssessment(fromDate, toDate);
                yield convertObject(objectResult, "محاسبه بر اساس کل سازمان می باشد (شغل)");}
            case "report46"->{
                objectResult = genericStatisticalIndexReportDAO.postNeedAssessment(fromDate, toDate);
                yield convertObject(objectResult, "محاسبه بر اساس کل سازمان می باشد (پست)");}
            case "report47"-> genericStatisticalIndexReportDAO.reactiveEvaluationCoverage(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "report48"-> genericStatisticalIndexReportDAO.coursesDeterminedEvaluationMethod(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "report49"-> genericStatisticalIndexReportDAO.coursesTargetDeterminedEvaluationMethod(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "report50"-> genericStatisticalIndexReportDAO.scheduledTraining(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "report60"-> genericStatisticalIndexReportDAO.perCapitaCostOfEmployeeTraining(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
                default -> null;
        };


        return modelMapper.map(result, new TypeToken<List<GenericStatisticalIndexReportDTO>>() {
        }.getType());
    }

    private List<GenericStatisticalIndexReport> convertObject(List<Object> objectResult, String title) {
        List<GenericStatisticalIndexReport> result = new ArrayList<>();

        try {
            if (objectResult.size() > 0) {
                for (Object o : objectResult) {
                    Object[] arr = (Object[]) o;
                    GenericStatisticalIndexReport genericStatisticalIndexReport = new GenericStatisticalIndexReport();
                    genericStatisticalIndexReport.setId(Long.parseLong(arr[0].toString()));
                    genericStatisticalIndexReport.setBaseOnComplex(Double.parseDouble(arr[1].toString()));
                    genericStatisticalIndexReport.setComplex(title);

                    result.add(genericStatisticalIndexReport);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
}
