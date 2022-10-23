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
            case "REPORT01"-> genericStatisticalIndexReportDAO.needAssessment(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "REPORT02"-> genericStatisticalIndexReportDAO.getTotalHours(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "REPORT03"-> genericStatisticalIndexReportDAO.saraneomomi(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "REPORT04"-> genericStatisticalIndexReportDAO.saratakhasosi(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "REPORT05"-> genericStatisticalIndexReportDAO.saraneModiriati(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "REPORT06"-> genericStatisticalIndexReportDAO.gozarAzAmozesh(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "REPORT07"-> genericStatisticalIndexReportDAO.arzeshyabiYadgiri(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "REPORT08"-> genericStatisticalIndexReportDAO.getTechnicalTrainingNeeds(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "REPORT09"-> genericStatisticalIndexReportDAO.getSkillTrainingNeeds(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "REPORT10"-> genericStatisticalIndexReportDAO.trainingStaffToTotalStaff(complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "REPORT11"-> genericStatisticalIndexReportDAO.teachingLearningLevelOfNewCourses(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "REPORT12"-> genericStatisticalIndexReportDAO.teachingLearningLevelOfFrequentCourses(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "REPORT13"-> genericStatisticalIndexReportDAO.teachingRatioOfInternalTeachers(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "REPORT14"-> genericStatisticalIndexReportDAO.ojt(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "REPORT15"-> genericStatisticalIndexReportDAO.proportionOfTrainingOutsideTheCalendar(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "REPORT16"-> genericStatisticalIndexReportDAO.canceledCourses(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "REPORT17"-> genericStatisticalIndexReportDAO.trainingOutsideTheOrganization(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "REPORT18"-> genericStatisticalIndexReportDAO.trainingWithInTheOrganization(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "REPORT19"-> genericStatisticalIndexReportDAO.specializedTrainingForCustomers(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "REPORT20"-> genericStatisticalIndexReportDAO.HSE(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "REPORT21"-> genericStatisticalIndexReportDAO.lowerThanBachelor(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "REPORT22"-> genericStatisticalIndexReportDAO.trainingOfSupervisors(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "REPORT23"-> genericStatisticalIndexReportDAO.managersTrainingPerCapita(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "REPORT24"-> genericStatisticalIndexReportDAO.capitaOfContractingForces(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "REPORT25"-> genericStatisticalIndexReportDAO.trainingHoursOfTheCompany(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "REPORT26"-> genericStatisticalIndexReportDAO.educationParticipationRateIndex(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "REPORT27"-> genericStatisticalIndexReportDAO.indexOfTheRatioOfImplementedTrainings(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "REPORT28"-> genericStatisticalIndexReportDAO.percentageOfcalendarTitleOfTheCourse(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "REPORT29"-> genericStatisticalIndexReportDAO.percentageOfcalendarTitleOfTheStudent(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "REPORT30"-> genericStatisticalIndexReportDAO.totalNumberOfTeachers(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "REPORT31"-> genericStatisticalIndexReportDAO.totalNumberOfInnerTeachers(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "REPORT32"-> genericStatisticalIndexReportDAO.ratioOfEvaluatedTeachers(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "REPORT33"-> genericStatisticalIndexReportDAO.electronicallyExecuted(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "REPORT34"-> genericStatisticalIndexReportDAO.performedInAbsentia(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "REPORT35"->{
                objectResult = genericStatisticalIndexReportDAO.proportionOfDesignedManagementCourses(fromDate, toDate);
                yield convertObject(objectResult, "محاسبه بر اساس کل سازمان می باشد (دوره)");
        }
            case "REPORT36"->{
                objectResult = genericStatisticalIndexReportDAO.revisedLessonPlansRatio(fromDate, toDate);
                yield convertObject(objectResult, "محاسبه بر اساس کل سازمان می باشد (دوره)");
        }
            case "REPORT37"->{
                objectResult = genericStatisticalIndexReportDAO.proportionOfNewLessonPlans(fromDate, toDate);
                yield convertObject(objectResult, "محاسبه بر اساس کل سازمان می باشد (دوره)");
        }
            case "REPORT38"-> genericStatisticalIndexReportDAO.educationPenetrationRate(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "REPORT39"-> genericStatisticalIndexReportDAO.rateOfEducationInGeneral(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "REPORT40"-> genericStatisticalIndexReportDAO.rateOfEducationInOneYear(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "REPORT41"->{
                objectResult = genericStatisticalIndexReportDAO.lowerThanExpertise(fromDate, toDate);
                yield convertObject(objectResult, "محاسبه بر اساس کل سازمان می باشد (شغل)");
            }
            case "REPORT42"->{
                objectResult = genericStatisticalIndexReportDAO.supervisionJob(fromDate, toDate);
                yield convertObject(objectResult, "محاسبه بر اساس کل سازمان می باشد (شغل)");}
            case "REPORT43"->{
                objectResult = genericStatisticalIndexReportDAO.mastersJob(fromDate, toDate);
                yield convertObject(objectResult, "محاسبه بر اساس کل سازمان می باشد (شغل)");}
            case "REPORT44"->{
                objectResult = genericStatisticalIndexReportDAO.jobModiriati(fromDate, toDate);
                yield convertObject(objectResult, "محاسبه بر اساس کل سازمان می باشد (شغل)");}
            case "REPORT45"->{
                objectResult = genericStatisticalIndexReportDAO.jobNeedAssessment(fromDate, toDate);
                yield convertObject(objectResult, "محاسبه بر اساس کل سازمان می باشد (شغل)");}
            case "REPORT46"->{
                objectResult = genericStatisticalIndexReportDAO.postNeedAssessment(fromDate, toDate);
                yield convertObject(objectResult, "محاسبه بر اساس کل سازمان می باشد (پست)");}
            case "REPORT47"-> genericStatisticalIndexReportDAO.reactiveEvaluationCoverage(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "REPORT48"-> genericStatisticalIndexReportDAO.coursesDeterminedEvaluationMethod(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "REPORT49"-> genericStatisticalIndexReportDAO.coursesTargetDeterminedEvaluationMethod(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "REPORT50"-> genericStatisticalIndexReportDAO.scheduledTraining(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "REPORT51"-> {
                objectResult = genericStatisticalIndexReportDAO.proportionOfkeyOccupationsWithQualifications(fromDate, toDate);
                yield convertObject(objectResult, "محاسبه بر اساس کل سازمان می باشد (پست)");}
            case "REPORT52"-> genericStatisticalIndexReportDAO.theProportionOfSelfTaughtEducationalNeedsOffline(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "REPORT53"->{
                objectResult = genericStatisticalIndexReportDAO.numberOfStandardDesignedCourses(fromDate, toDate);
                yield convertObject(objectResult, "محاسبه بر اساس کل سازمان می باشد ");}
            case "REPORT54"-> genericStatisticalIndexReportDAO.theAmountOfVirtualCoursesProducedElectronic(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "REPORT55"-> genericStatisticalIndexReportDAO.theNumberOfEditedNewMultimediaContents(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "REPORT56"-> genericStatisticalIndexReportDAO.theNumberOfGamifiedContentProduced(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "REPORT57"->{
                objectResult = genericStatisticalIndexReportDAO.nominalTrainingCapacity(fromDate, toDate);
                yield convertObjectAndShowComplex(objectResult,"محاسبه بر اساس کل سازمان می باشد(نمایش مراکز آموزشی)");}
            case "REPORT58"-> genericStatisticalIndexReportDAO.totalEducationCostPerCapita(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "REPORT59"-> genericStatisticalIndexReportDAO.perCapitaCostOfTrainingManagers(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "REPORT60"-> genericStatisticalIndexReportDAO.perCapitaCostOfEmployeeTraining(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "REPORT61"-> genericStatisticalIndexReportDAO.effectivenessRateOfOutputLevelTrainingBehavior (fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "REPORT62"-> genericStatisticalIndexReportDAO.evaluationCoverageRateBehaviorLevel(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
            case "REPORT63"->{
                objectResult = genericStatisticalIndexReportDAO.numberOfActiveExpertCommittees(fromDate, toDate,complexNull,complex);
                yield convertObjectAndShowComplex(objectResult);}
                default -> null;
        };


        return modelMapper.map(result, new TypeToken<List<GenericStatisticalIndexReportDTO>>() {
        }.getType());
    }

    private List<GenericStatisticalIndexReport> convertObjectAndShowComplex(List<Object> objectResult) {
        List<GenericStatisticalIndexReport> result = new ArrayList<>();

        try {
            if (objectResult.size() > 0) {
                for (Object o : objectResult) {
                    Object[] arr = (Object[]) o;
                    GenericStatisticalIndexReport genericStatisticalIndexReport = new GenericStatisticalIndexReport();
                    genericStatisticalIndexReport.setId(Long.parseLong(arr[0].toString()));
                    genericStatisticalIndexReport.setComplexId(Long.parseLong(arr[1].toString()));
                    genericStatisticalIndexReport.setComplex(arr[2].toString());
                    genericStatisticalIndexReport.setBaseOnComplex(Double.parseDouble(arr[3].toString()));

                    result.add(genericStatisticalIndexReport);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    private List<GenericStatisticalIndexReport> convertObject(List<Object> objectResult,
                                                              String title) {
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

    private List<GenericStatisticalIndexReport> convertObjectAndShowComplex(List<Object> objectResult,String title) {
        List<GenericStatisticalIndexReport> result = new ArrayList<>();

        try {
            if (objectResult.size() > 0) {
                for (Object o : objectResult) {
                    Object[] arr = (Object[]) o;
                    GenericStatisticalIndexReport genericStatisticalIndexReport = new GenericStatisticalIndexReport();
                    genericStatisticalIndexReport.setId(Long.parseLong(arr[0].toString()));
                    genericStatisticalIndexReport.setComplexId(Long.parseLong(arr[1].toString()));
                    genericStatisticalIndexReport.setAssistant(arr[2].toString());
                    genericStatisticalIndexReport.setComplex(title);
                    genericStatisticalIndexReport.setBaseOnComplex(Double.parseDouble(arr[3].toString()));

                    result.add(genericStatisticalIndexReport);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
}
