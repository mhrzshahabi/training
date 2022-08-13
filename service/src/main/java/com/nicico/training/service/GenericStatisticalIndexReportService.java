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
        List<Object> objectResult = new ArrayList<>();
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
                case "report26":
                result = genericStatisticalIndexReportDAO.educationParticipationRateIndex(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
                break;
                case "report27":
                result = genericStatisticalIndexReportDAO.indexOfTheRatioOfImplementedTrainings(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
                break;
                case "report28":
                result = genericStatisticalIndexReportDAO.percentageOfcalendarTitleOfTheCourse(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
                break;
                case "report29":
                result = genericStatisticalIndexReportDAO.percentageOfcalendarTitleOfTheStudent(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
                break;
                case "report30":
                result = genericStatisticalIndexReportDAO.totalNumberOfTeachers(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
                break;
                case "report31":
                result = genericStatisticalIndexReportDAO.totalNumberOfInnerTeachers(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
                break;
                case "report32":
                result = genericStatisticalIndexReportDAO.ratioOfEvaluatedTeachers(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
                break;

                case "report33":
                result = genericStatisticalIndexReportDAO.electronicallyExecuted(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
                break;
                case "report34":
                result = genericStatisticalIndexReportDAO.performedInAbsentia(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
                break;
                case "report35":
                    objectResult = genericStatisticalIndexReportDAO.proportionOfDesignedManagementCourses(fromDate, toDate);
                    result=convertObject(objectResult,"محاسبه بر اساس کل سازمان می باشد (دوره)");
                    break;
                case "report36":
                    objectResult = genericStatisticalIndexReportDAO.revisedLessonPlansRatio(fromDate, toDate);
                    result=convertObject(objectResult,"محاسبه بر اساس کل سازمان می باشد (دوره)");
                    break;
                case "report37":
                    objectResult = genericStatisticalIndexReportDAO.proportionOfNewLessonPlans(fromDate, toDate);
                    result=convertObject(objectResult,"محاسبه بر اساس کل سازمان می باشد (دوره)");

                    break;

            case "report38":
                result = genericStatisticalIndexReportDAO.educationPenetrationRate(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
                break;
            case "report39":
                result = genericStatisticalIndexReportDAO.rateOfEducationInGeneral(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
                break;
            case "report40":
                result = genericStatisticalIndexReportDAO.rateOfEducationInOneYear(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
                break;

            case "report41":
                objectResult = genericStatisticalIndexReportDAO.lowerThanExpertise(fromDate, toDate);
                result=convertObject(objectResult,"محاسبه بر اساس کل سازمان می باشد (شغل)");
                break;

            case "report42":
                objectResult = genericStatisticalIndexReportDAO.supervisionJob(fromDate, toDate);
                result=convertObject(objectResult,"محاسبه بر اساس کل سازمان می باشد (شغل)");
                break;
            case "report43":
                objectResult = genericStatisticalIndexReportDAO.mastersJob(fromDate, toDate);
                result=convertObject(objectResult,"محاسبه بر اساس کل سازمان می باشد (شغل)");

                break;

            case "report44":
                objectResult = genericStatisticalIndexReportDAO.jobModiriati(fromDate, toDate);
                result=convertObject(objectResult,"محاسبه بر اساس کل سازمان می باشد (شغل)");
                break;
            case "report45":
                objectResult = genericStatisticalIndexReportDAO.jobNeedAssessment(fromDate, toDate);
                result=convertObject(objectResult,"محاسبه بر اساس کل سازمان می باشد (شغل)");
                break;

            case "report46":
                objectResult = genericStatisticalIndexReportDAO.postNeedAssessment(fromDate, toDate);
               result=convertObject(objectResult,"محاسبه بر اساس کل سازمان می باشد (پست)");
                break;


            case "report47":
                result = genericStatisticalIndexReportDAO.reactiveEvaluationCoverage(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
                 break;
            case "report48":
                result = genericStatisticalIndexReportDAO.coursesDeterminedEvaluationMethod(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
                 break;
            case "report49":
                result = genericStatisticalIndexReportDAO.coursesTargetDeterminedEvaluationMethod(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
                break;
            case "report50":
                result = genericStatisticalIndexReportDAO.scheduledTraining(fromDate, toDate, complex, complexNull, assistant, assistantNull, affairs, affairsNull);
                break;
        }


        return modelMapper.map(result, new TypeToken<List<GenericStatisticalIndexReportDTO>>() {
        }.getType());
    }

    private List<GenericStatisticalIndexReport> convertObject(List<Object> objectResult,String title) {
        List<GenericStatisticalIndexReport> result = new ArrayList<>();

        try {
            if (objectResult.size() > 0) {
                for (Object o : objectResult) {
                    Object[] arr = (Object[]) o;
                    GenericStatisticalIndexReport genericStatisticalIndexReport=new GenericStatisticalIndexReport();
                    genericStatisticalIndexReport.setId(Long.parseLong(arr[0].toString()));
                    genericStatisticalIndexReport.setBaseOnComplex(Double.parseDouble(arr[1].toString()));
                    genericStatisticalIndexReport.setComplex(title);

                    result.add(genericStatisticalIndexReport);
                }
            }
        }catch (Exception e) {
            e.printStackTrace();
        }
return result;
    }
}
