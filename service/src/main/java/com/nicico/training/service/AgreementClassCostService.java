package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.AgreementClassCostDTO;
import com.nicico.training.iservice.*;
import com.nicico.training.model.AgreementClassCost;
import com.nicico.training.model.EducationalDecision;
import com.nicico.training.model.TeacherExperienceInfo;
import com.nicico.training.repository.AgreementClassCostDAO;
import lombok.RequiredArgsConstructor;
import org.hibernate.exception.ConstraintViolationException;
import org.modelmapper.ModelMapper;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class AgreementClassCostService implements IAgreementClassCostService {

    private final ModelMapper modelMapper;
    private final ICourseService courseService;
    private final ITclassService tClassService;
    private final ITeacherService teacherService;
    private final AgreementClassCostDAO agreementClassCostDAO;
    private final IEducationalDecisionService educationalDecisionService;
    private final ITeacherExperienceInfoService teacherExperienceInfoService;

    @Transactional
    @Override
    public AgreementClassCostDTO.Info create(AgreementClassCostDTO.Create request) {

        final AgreementClassCost agreementClassCost = modelMapper.map(request, AgreementClassCost.class);
        try {
            return modelMapper.map(agreementClassCostDAO.saveAndFlush(agreementClassCost), AgreementClassCostDTO.Info.class);
        } catch (ConstraintViolationException | DataIntegrityViolationException e) {
            throw new TrainingException(TrainingException.ErrorType.DuplicateRecord);
        }
    }

    @Transactional
    @Override
    public AgreementClassCostDTO.Info update(AgreementClassCostDTO.Update update, Long id) {

        Optional<AgreementClassCost> agreementClassCostOptional = agreementClassCostDAO.findById(id);
        AgreementClassCost agreementClassCost = agreementClassCostOptional.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));

        AgreementClassCost updating = new AgreementClassCost();
        modelMapper.map(agreementClassCost, updating);
        modelMapper.map(update, updating);
        return modelMapper.map(agreementClassCostDAO.saveAndFlush(updating), AgreementClassCostDTO.Info.class);
    }

    @Transactional
    @Override
    public void updateTeachingCostPerHourAuto(Long id, Double teachingCostPerHourAuto) {

        Optional<AgreementClassCost> agreementClassCostOptional = agreementClassCostDAO.findById(id);
        AgreementClassCost agreementClassCost = agreementClassCostOptional.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        agreementClassCost.setTeachingCostPerHourAuto(teachingCostPerHourAuto);
        agreementClassCostDAO.saveAndFlush(agreementClassCost);
    }

    @Transactional
    @Override
    public void createOrUpdateClassCostList(List<AgreementClassCostDTO.Create> costList, Long agreementId) {

        List<AgreementClassCostDTO.Create> costCreateList = costList.stream().filter(item -> item.getId() == null).collect(Collectors.toList());
        List<AgreementClassCostDTO.Create> costUpdateList = costList.stream().filter(item -> item.getId() != null).collect(Collectors.toList());

        if (costCreateList.size() != 0) {
            costCreateList.forEach(item -> {
                item.setAgreementId(agreementId);
                create(item);
            });
        }
        if (costUpdateList.size() != 0) {
            costUpdateList.forEach(item -> update(modelMapper.map(item, AgreementClassCostDTO.Update.class), item.getId()));
        }
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<AgreementClassCostDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(agreementClassCostDAO, request, agreementClassCost -> modelMapper.map(agreementClassCost, AgreementClassCostDTO.Info.class));
    }

    @Transactional
    @Override
    public void delete(Long id) {
        agreementClassCostDAO.deleteById(id);
    }

    @Override
    public List<AgreementClassCost> findAllByAgreementId(Long agreementId) {
        return agreementClassCostDAO.findAllByAgreement_Id(agreementId);
    }

    @Override
    public List<AgreementClassCost> findAll() { return agreementClassCostDAO.findAll(); }

    @Override
    public void calculateTeachingCost(AgreementClassCostDTO.CalcTeachingCostList calcInfoList) {
        String fromDate = calcInfoList.getFromDate();
        try {
            calcInfoList.getCalcTeachingCost().forEach(item -> updateTeachingCostPerHourAuto(item.getId(), calculateTeachingCostAuto(item, fromDate)));
        } catch (TrainingException ex) {
            throw new TrainingException(TrainingException.ErrorType.NotFound, ex.getField(), ex.getMsg());
        }
    }

    private String getTeacherBasicTuitionFee(Long teacherId, String fromDate) {
        String tuitionFee;
        TeacherExperienceInfo teacherExperienceInfo = teacherExperienceInfoService.getLastTeacherExperienceInfoByTeacherId(teacherId);
        if (teacherExperienceInfo != null) {
            Long salaryBase = teacherExperienceInfo.getSalaryBase();
            String teacherRankLiteral = teacherExperienceInfo.getTeacherRank().getLiteral();
            List<EducationalDecision> educationalDecisionList = educationalDecisionService.findAllByDateAndRef(fromDate, "base");
            if (educationalDecisionList.size() != 0) {
                List<EducationalDecision> educationalDecisionSalaryBaseFiltered = educationalDecisionList.stream().filter(item -> item.getBaseTuitionFee().equals(String.valueOf(salaryBase))).collect(Collectors.toList());
                if (educationalDecisionSalaryBaseFiltered.size() != 0) {
                    EducationalDecision educationalDecision = educationalDecisionSalaryBaseFiltered.stream().max(Comparator.comparing(EducationalDecision::getId)).get();
                    switch (teacherRankLiteral) {
                        case "PROFESSOR":
                            tuitionFee = educationalDecision.getProfessorTuitionFee();
                            break;
                        case "ASSOCIATEPROFESSOR":
                            tuitionFee = educationalDecision.getKnowledgeAssistantTuitionFee();
                            break;
                        case "ASSISTANTPROFESSOR":
                            tuitionFee = educationalDecision.getTeacherAssistantTuitionFee();
                            break;
                        case "COACH":
                            tuitionFee = educationalDecision.getInstructorTuitionFee();
                            break;
                        case "EDUCATOR":
                            tuitionFee = educationalDecision.getEducationalAssistantTuitionFee();
                            break;
                        default:
                            throw new TrainingException(TrainingException.ErrorType.NotFound);
                    }
                    return tuitionFee;
                } else throw new TrainingException(TrainingException.ErrorType.NotFound, "TeacherBasicTuitionFee", "مبلغ پایه حق التدریس برای استاد یافت نشد");
            } else throw new TrainingException(TrainingException.ErrorType.NotFound, "TeacherBasicTuitionFee", "مبلغ پایه حق التدریس برای استاد یافت نشد");
        } else throw new TrainingException(TrainingException.ErrorType.NotFound, "TeacherBasicTuitionFee", "مبلغ پایه حق التدریس برای استاد یافت نشد");
    }

    private Double getTeacherEducationalHistoryFactor(Long teacherId, String fromDate) {
        List<EducationalDecision> educationalDecisionFiltered = new ArrayList<>();
        TeacherExperienceInfo teacherExperienceInfo = teacherExperienceInfoService.getLastTeacherExperienceInfoByTeacherId(teacherId);
        if (teacherExperienceInfo != null) {
            Double teachingExperienceYear = teacherExperienceInfo.getTeachingExperience().doubleValue() / 12;
            List<EducationalDecision> educationalDecisionList = educationalDecisionService.findAllByDateAndRef(fromDate, "history");
            if (educationalDecisionList.size() != 0) {

                educationalDecisionList.forEach(item -> {
                    if (teachingExperienceYear >= Double.parseDouble(item.getEducationalHistoryFrom()) && teachingExperienceYear <= Double.parseDouble(item.getEducationalHistoryTo()))
                        educationalDecisionFiltered.add(item);
                });
                if (educationalDecisionFiltered.size() != 0) {
                    return educationalDecisionFiltered.stream().max(Comparator.comparing(EducationalDecision::getId)).get().getEducationalHistoryCoefficient();
                } else throw new TrainingException(TrainingException.ErrorType.NotFound, "TeacherEducationalHistoryFactor", "ضریب سابقه آموزشی یافت نشد");
            } else throw new TrainingException(TrainingException.ErrorType.NotFound, "TeacherEducationalHistoryFactor", "ضریب سابقه آموزشی یافت نشد");
        } else throw new TrainingException(TrainingException.ErrorType.NotFound, "TeacherEducationalHistoryFactor", "ضریب سابقه آموزشی یافت نشد");
    }

    private String getTeachingMethodFactor(Long classId, String fromDate) {
        try {
            String classTeachingMethod = tClassService.getClassTeachingMethod(classId);
            String classCourseType = courseService.getClassCourseType(classId);

            List<EducationalDecision> educationalDecisionList = educationalDecisionService.findAllByDateAndRef(fromDate, "teaching-method");
            if (educationalDecisionList.size() != 0) {

                List<EducationalDecision> educationalDecisionCourseTypeFiltered = educationalDecisionList.stream().filter(item ->
                        item.getTeachingMethod().equals(classTeachingMethod) && item.getCourseTypeTeachingMethod() != null && item.getCourseTypeTeachingMethod().equals(classCourseType)).collect(Collectors.toList());

                List<EducationalDecision> educationalDecisionTeachingMethodFiltered = educationalDecisionList.stream().filter(item -> item.getTeachingMethod().equals(classTeachingMethod) &&
                        item.getCourseTypeTeachingMethod() == null).collect(Collectors.toList());

                if (educationalDecisionCourseTypeFiltered.size() != 0) {
                    return educationalDecisionCourseTypeFiltered.stream().max(Comparator.comparing(EducationalDecision::getId)).get().getCoefficientOfTeachingMethod();
                } else {
                    if (educationalDecisionTeachingMethodFiltered.size() != 0)
                        return educationalDecisionTeachingMethodFiltered.stream().max(Comparator.comparing(EducationalDecision::getId)).get().getCoefficientOfTeachingMethod();
                    else throw new TrainingException(TrainingException.ErrorType.NotFound, "TeachingMethodFactor", "ضریب روش تدریس یافت نشد");
                }
            } else throw new TrainingException(TrainingException.ErrorType.NotFound, "TeachingMethodFactor", "ضریب روش تدریس یافت نشد");
        } catch (Exception e) {
            throw new TrainingException(TrainingException.ErrorType.NotFound, "TeachingMethodFactor", "ضریب روش تدریس یافت نشد");
        }
    }

    private String getCourseTypeFactor(Long classId, String fromDate) {
        try {
            String typeOfSpecializationCourseType = courseService.getClassCourseTechnicalType(classId);
            String courseLevelCourseType = courseService.getClassCourseLevelType(classId);
            String courseForCourseType = tClassService.getClassTargetPopulation(classId);

            List<EducationalDecision> educationalDecisionList = educationalDecisionService.findAllByDateAndRef(fromDate, "course-type");
            if (educationalDecisionList.size() != 0) {

                List<EducationalDecision> educationalDecisionCourseForFiltered = educationalDecisionList.stream().filter(item -> item.getTypeOfSpecializationCourseType().equals(typeOfSpecializationCourseType) &&
                        item.getCourseLevelCourseType() != null && item.getCourseLevelCourseType().equals(courseLevelCourseType) && item.getCourseForCourseType() != null &&
                        item.getCourseForCourseType().equals(courseForCourseType)).collect(Collectors.toList());

                List<EducationalDecision> educationalDecisionCourseLevelFiltered = educationalDecisionList.stream().filter(item -> item.getTypeOfSpecializationCourseType().equals(typeOfSpecializationCourseType) &&
                        item.getCourseLevelCourseType() != null && item.getCourseLevelCourseType().equals(courseLevelCourseType) && item.getCourseForCourseType() == null).collect(Collectors.toList());

                List<EducationalDecision> educationalDecisionTypeOfSpecializationFiltered = educationalDecisionList.stream().filter(item -> item.getTypeOfSpecializationCourseType().equals(typeOfSpecializationCourseType) &&
                        item.getCourseLevelCourseType() == null && item.getCourseForCourseType() == null).collect(Collectors.toList());

                if (educationalDecisionCourseForFiltered.size() != 0) {
                    return educationalDecisionCourseForFiltered.stream().max(Comparator.comparing(EducationalDecision::getId)).get().getCoefficientOfCourseType();
                } else {
                    if (educationalDecisionCourseLevelFiltered.size() != 0) {
                        return educationalDecisionCourseLevelFiltered.stream().max(Comparator.comparing(EducationalDecision::getId)).get().getCoefficientOfCourseType();
                    } else {
                        if (educationalDecisionTypeOfSpecializationFiltered.size() != 0) {
                            return educationalDecisionTypeOfSpecializationFiltered.stream().max(Comparator.comparing(EducationalDecision::getId)).get().getCoefficientOfCourseType();
                        } else throw new TrainingException(TrainingException.ErrorType.NotFound, "CourseTypeFactor", "ضریب نوع دوره یافت نشد");
                    }
                }
            } else throw new TrainingException(TrainingException.ErrorType.NotFound, "CourseTypeFactor", "ضریب نوع دوره یافت نشد");
        } catch (Exception e) {
            throw new TrainingException(TrainingException.ErrorType.NotFound, "CourseTypeFactor", "ضریب نوع دوره یافت نشد");
        }
    }

    private String getDistanceFactor(Long teacherId, String fromDate) {
        String residence = teacherService.getTeacherResidence(teacherId);
        if (residence != null) {
            List<EducationalDecision> educationalDecisionList = educationalDecisionService.findAllByDateAndRef(fromDate, "distance");
            if (educationalDecisionList.size() != 0) {
                return educationalDecisionList.stream().filter(item -> item.getResidence().equals(residence)).max(Comparator.comparing(EducationalDecision::getId)).
                        orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound, "DistanceFactor", "ضریب مسافت یافت نشد")).getDistance();
            } else throw new TrainingException(TrainingException.ErrorType.NotFound, "DistanceFactor", "ضریب مسافت یافت نشد");
        } else
            throw new TrainingException(TrainingException.ErrorType.NotFound, "DistanceFactor", "ضریب مسافت یافت نشد");
    }

    private Double calculateTeachingCostAuto(AgreementClassCostDTO.Info calcTeachingCostData, String fromDate) {
        try {
            String basicTuitionFee = getTeacherBasicTuitionFee(calcTeachingCostData.getTeacherId(), fromDate);
            Double educationalHistoryFactor = getTeacherEducationalHistoryFactor(calcTeachingCostData.getTeacherId(), fromDate);
            String teachingMethodFactor = getTeachingMethodFactor(calcTeachingCostData.getClassId(), fromDate);
            String courseTypeFactor = getCourseTypeFactor(calcTeachingCostData.getClassId(), fromDate);
            String distanceFactor = getDistanceFactor(calcTeachingCostData.getTeacherId(), fromDate);
            return Double.parseDouble(basicTuitionFee) * educationalHistoryFactor * Double.parseDouble(teachingMethodFactor) *
                    Double.parseDouble(courseTypeFactor) * Double.parseDouble(distanceFactor);
        } catch (TrainingException ex) {
            throw new TrainingException(TrainingException.ErrorType.NotFound, ex.getField(), ex.getMsg());
        }
    }

}
