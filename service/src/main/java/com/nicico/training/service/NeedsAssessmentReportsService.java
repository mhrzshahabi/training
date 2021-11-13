package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.NICICOSpecification;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.*;
import com.nicico.training.mapper.needAssessmentGroupResult.NeedAssessmentGroupResultMapper;
import com.nicico.training.model.*;
import com.nicico.training.repository.*;
import lombok.RequiredArgsConstructor;
import org.apache.commons.collections.map.MultiValueMap;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import request.needsassessment.NeedAssessmentGroupJobPromotionDto;
import request.needsassessment.NeedAssessmentGroupJobPromotionRequestDto;
import request.needsassessment.NeedAssessmentGroupJobPromotionResponseDto;

import javax.persistence.EntityManager;
import java.util.*;
import java.util.function.Function;
import java.util.function.Supplier;
import java.util.stream.Collectors;

import static com.nicico.training.service.BaseService.makeNewCriteria;
import static com.nicico.training.service.NeedsAssessmentTempService.getCriteria;

@Service
@RequiredArgsConstructor
public class NeedsAssessmentReportsService implements INeedsAssessmentReportsService {

    private final List<String> needsAssessmentPriorityCodes = Arrays.asList("AZ", "AB", "AT", "AE");

    private final ModelMapper modelMapper;
    private final NeedAssessmentGroupResultMapper needAssessmentGroupResultMapper;

    private final PostDAO postDAO;
    private final TrainingPostDAO trainingPostDAO;
    private final JobDAO jobDAO;
    private final PostGradeDAO postGradeDAO;
    private final PostGroupDAO postGroupDAO;
    private final JobGroupDAO jobGroupDAO;
    private final PostGradeGroupDAO postGradeGroupDAO;
    private final NeedsAssessmentDAO needsAssessmentDAO;
    private final NeedsAssessmentTempDAO needsAssessmentTempDAO;
    private final PersonnelDAO personnelDAO;
    private final PersonnelCoursePassedNAReportViewDAO personnelCoursePassedNAReportViewDAO;

    private final ClassStudentReportService classStudentReportService;
    private final IPersonnelService personnelService;
    private final ParameterValueService parameterValueService;
    private final ParameterDAO parameterDAO;
    private final ITclassService tClassService;
    private final ICourseService courseService;
    private final ISkillService skillService;
    private final NeedAssessmentGroupResultDAO needAssessmentGroupResultDAO;
    protected EntityManager entityManager;
    private final ParameterValueDAO parameterValueDAO;

    @Transactional(readOnly = true)
//    @Override
    public SearchDTO.SearchRs<NeedsAssessmentReportsDTO.ReportInfo> search(SearchDTO.SearchRq request, Long objectId, String objectType, Long personnelId) {
        List<NeedsAssessmentReportsDTO.ReportInfo> needsAssessmentReportList = getCourseList(objectId, objectType, personnelId);
        SearchDTO.SearchRs<NeedsAssessmentReportsDTO.ReportInfo> rs = new SearchDTO.SearchRs<>();
        rs.setTotalCount((long) needsAssessmentReportList.size());
        rs.setList(needsAssessmentReportList);
        return rs;
    }

    @Transactional(readOnly = true)
    @Override
    public List<NeedsAssessmentReportsDTO.ReportInfo> getCourseList(Long objectId, String objectType, Long personnelId) {

        Long passedCodeId = parameterValueService.getId("Passed");
        Long notPassedCodeId = parameterValueService.getId("false");

        List<NeedsAssessment> needsAssessmentList = getNeedsAssessmentList(objectId, objectType);
        needsAssessmentList = needsAssessmentList.stream().filter(NA -> NA.getSkill().getCourse() != null).collect(Collectors.toList());
        List<NeedsAssessmentReportsDTO.ReportInfo> mustPass = modelMapper.map(needsAssessmentList, new TypeToken<List<NeedsAssessmentReportsDTO.ReportInfo>>() {
        }.getType());
//        for (int i = 1; i < mustPass.size(); i++) {
//            for (int j = 0; j < i; j++) {
//                if (mustPass.get(i).getSkill().getCourse().getId().equals(mustPass.get(j).getSkill().getCourse().getId())) {
//                    if (mustPass.get(i).getNeedsAssessmentPriorityId().equals(mustPass.get(j).getNeedsAssessmentPriorityId())) {
//                        mustPass.remove(i--);
//                        break;
//                    }
//                    CourseDTO.NeedsAssessmentReportInfo newCourse = new CourseDTO.NeedsAssessmentReportInfo();
//                    modelMapper.map(mustPass.get(i).getSkill().getCourse(), newCourse);
//                    mustPass.get(i).getSkill().setCourse(newCourse);
//                    break;
//                }
//            }
//        }
        if (personnelId != null && !mustPass.isEmpty()) {
            PersonnelDTO.Info student = personnelService.get(personnelId);
            if (student == null) {
                throw new TrainingException(TrainingException.ErrorType.NotFound);
            }
            Set<Long> passedCourseIds = classStudentReportService.getPassedCoursesIdsOfStudentByNationalCode(student.getNationalCode());
            Map<Long, Boolean> isPassed = passedCourseIds.stream().collect(Collectors.toMap(id -> id, id -> true));

            for (int i = 0; i < mustPass.size(); i++) {
//                 makeNewCriteria("tclassId", needsAssessmentList.get(i).getC, EOperator.equals, null);

                List<TclassDTO.PersonnelClassInfo> personClasses = tClassService.findPersonnelClassByCourseId(student.getNationalCode(), student.getPersonnelNo(), needsAssessmentList.get(i).getSkill().getCourse().getId());

                if (classStudentReportService.isPassed(needsAssessmentList.get(i).getSkill().getCourse(), isPassed)) {
                    mustPass.get(i).getSkill().getCourse().setScoresState(passedCodeId);
                    if (personClasses.size() > 0) {
                        String courseStatus = personClasses.get(0).getScoreState();
                        if (!passedCourseIds.contains(needsAssessmentList.get(i).getSkill().getCourse().getId()) &&
                                isPassed.get(needsAssessmentList.get(i).getSkill().getCourse().getId()) != null
                                && isPassed.get(needsAssessmentList.get(i).getSkill().getCourse().getId())) {
                            courseStatus += " - دوره معادل گذرانده شده است.";
                            Course course = needsAssessmentList.get(i).getSkill().getCourse().getEqualCourses().get(0).getEqualAndList().get(0);
                            List<EqualCourse> equalCourses = course.getEqualCourses();
                            if (equalCourses.size() > 0) {
                                for (EqualCourse equalCourse : equalCourses) {
                                    if (passedCourseIds.contains(equalCourse.getEqualAndList().get(0).getId())) {
                                        courseStatus += "(";
                                        courseStatus += equalCourse.getEqualAndList().get(0).getTitleFa();
                                        courseStatus += ")";
                                        break;
                                    }
                                }
                            }
                        }
                        mustPass.get(i).getSkill().getCourse().setScoresStatus(courseStatus);
                    }
                } else {
                    mustPass.get(i).getSkill().getCourse().setScoresState(notPassedCodeId);
                    if (personClasses.size() > 0) {
                        mustPass.get(i).getSkill().getCourse().setScoresStatus(personClasses.get(0).getScoreState());
                    }
                }
            }
        }
        return mustPass;
    }

    @Transactional(readOnly = true)
//    @Override
    public List<NeedsAssessment> getNeedsAssessmentList(Long objectId, String objectType) {
        List<NeedsAssessment> needsAssessmentList = new ArrayList<>();
        SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, new ArrayList<>());
        criteriaRq.getCriteria().add(makeNewCriteria(null, null, EOperator.or, new ArrayList<>()));
        criteriaRq.getCriteria().add(makeNewCriteria("deleted", null, EOperator.isNull, null));
        addCriteria(criteriaRq.getCriteria().get(0), objectType, objectId, true, true);
        if (!criteriaRq.getCriteria().get(0).getCriteria().isEmpty())
            needsAssessmentList = needsAssessmentDAO.findAll(NICICOSpecification.of(criteriaRq));
        return removeDuplicateNAs(needsAssessmentList);
    }

    @Transactional(readOnly = true)
    public List<NeedsAssessment> getUnverifiedNeedsAssessmentList(Long objectId, String objectType) {
        List<NeedsAssessment> needsAssessmentList = new ArrayList<>();
        SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, new ArrayList<>());
        criteriaRq.getCriteria().add(makeNewCriteria(null, null, EOperator.or, new ArrayList<>()));
        criteriaRq.getCriteria().add(makeNewCriteria("deleted", null, EOperator.isNull, null));
        addCriteria(criteriaRq.getCriteria().get(0), objectType, objectId, true, false);
        if (!criteriaRq.getCriteria().get(0).getCriteria().isEmpty())
            needsAssessmentList.addAll(needsAssessmentDAO.findAll(NICICOSpecification.of(criteriaRq)));

        SearchDTO.CriteriaRq tempCriteriaRq = getCriteria(objectType, objectId, true);
        List<NeedsAssessmentTemp> needsAssessmentTemps = needsAssessmentTempDAO.findAll(NICICOSpecification.of(tempCriteriaRq));
        needsAssessmentList.addAll(modelMapper.map(needsAssessmentTemps, new TypeToken<List<NeedsAssessment>>() {
        }.getType()));
        return removeDuplicateNAs(needsAssessmentList);
    }

    private List<NeedsAssessment> removeDuplicateNAs(List<NeedsAssessment> needsAssessmentList) {
        needsAssessmentList.sort(Comparator.comparingInt(a -> NeedsAssessment.priorityList.indexOf(a.getObjectType())));
        List<NeedsAssessment> withoutDuplicate = new ArrayList<>();
        needsAssessmentList.forEach(needsAssessment -> {
            if (withoutDuplicate.stream().noneMatch(wd -> wd.getSkill().equals(needsAssessment.getSkill())))
                withoutDuplicate.add(needsAssessment);
        });
        return withoutDuplicate;
    }

    private MultiValueMap getNAPostsGByPriority(List<NeedsAssessment> needsAssessments) {
        MultiValueMap postCodes = new MultiValueMap();
        needsAssessments.forEach(needsAssessment -> {
            if (needsAssessment.getDeleted() != null)
                return;
            switch (needsAssessment.getObjectType()) {
                case "Post":
                    try {
                        Post post = ((Post) needsAssessment.getObject());
                        if (post.getCode() != null && post.getDeleted() == null && post.getEnabled() == null && !postCodes.containsValue(needsAssessment.getObject()))
                            postCodes.put(needsAssessment.getNeedsAssessmentPriorityId(), needsAssessment.getObject());
                    } catch (Exception ex) {
                        ex.printStackTrace();
                        return;
                    }
                    break;
                case "PostGroup":
                    try {
                        PostGroup postGroup = ((PostGroup) needsAssessment.getObject());
                        if (postGroup.getDeleted() != null || postGroup.getEnabled() != null)
                            return;
                        extractPostSet(needsAssessment, postGroup.getTrainingPostSet(), postCodes);
                        postGroup.getPostSet().forEach(post -> {
                            try {
                                if (post.getCode() != null && post.getDeleted() == null && post.getEnabled() == null && !postCodes.containsValue(post))
                                    postCodes.put(needsAssessment.getNeedsAssessmentPriorityId(), post);
                            } catch (Exception ex) {
                                ex.printStackTrace();
                            }
                        });
                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }
                    break;
                case "TrainingPost":
                    try {
                        TrainingPost trainingPost = ((TrainingPost) needsAssessment.getObject());
                        if (trainingPost.getDeleted() != null || trainingPost.getEnabled() != null)
                            return;
                        trainingPost.getPostSet().forEach(post -> {
                            try {
                                if (post.getCode() != null && post.getDeleted() == null && post.getEnabled() == null && !postCodes.containsValue(post))
                                    postCodes.put(needsAssessment.getNeedsAssessmentPriorityId(), post);
                            } catch (Exception ex) {
                                ex.printStackTrace();
                            }
                        });
                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }
                    break;
                case "Job":
                    try {
                        Job job = ((Job) needsAssessment.getObject());
                        if (job.getDeleted() != null || job.getEnabled() != null)
                            return;
                        extractPostSet(needsAssessment, job.getTrainingPostSet(), postCodes);
                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }
                    break;
                case "JobGroup":
                    try {
                        JobGroup jobGroup = ((JobGroup) needsAssessment.getObject());
                        if (jobGroup.getDeleted() != null || jobGroup.getEnabled() != null)
                            return;
                        jobGroup.getJobSet().forEach(job -> {
                            try {
                                extractPostSet(needsAssessment, job.getTrainingPostSet(), postCodes);
                            } catch (Exception ex) {
                                ex.printStackTrace();
                            }
                        });
                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }
                    break;
                case "PostGrade":
                    try {
                        PostGrade postGrade = ((PostGrade) needsAssessment.getObject());
                        if (postGrade.getDeleted() != null || postGrade.getEnabled() != null)
                            return;
                        extractPostSet(needsAssessment, postGrade.getTrainingPostSet(), postCodes);
                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }
                    break;

                case "PostGradeGroup":
                    try {
                        PostGradeGroup postGradeGroup = ((PostGradeGroup) needsAssessment.getObject());
                        if (postGradeGroup.getDeleted() != null || postGradeGroup.getEnabled() != null)
                            return;
                        postGradeGroup.getPostGradeSet().forEach(postGrade -> {

                            try {
                                extractPostSet(needsAssessment, postGrade.getTrainingPostSet(), postCodes);
                            } catch (Exception ex) {
                                ex.printStackTrace();
                            }
                        });

                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }
                    break;
            }
        });
        return postCodes;
    }


    private void extractPostSet(NeedsAssessment needsAssessment, Set<TrainingPost> trainingPostSet, MultiValueMap postCodes) {
        if (trainingPostSet == null || trainingPostSet.isEmpty())
            return;
        trainingPostSet.forEach(trainingPost -> {
            try {
                if (trainingPost.getDeleted() != null || trainingPost.getEnabled() != null)
                    return;
                trainingPost.getPostSet().forEach(post -> {
                    try {
                        if (post.getCode() != null && post.getDeleted() == null && post.getEnabled() == null && !postCodes.containsValue(post))
                            postCodes.put(needsAssessment.getNeedsAssessmentPriorityId(), post);
                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }
                });
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        });
    }

    private void convertCriteriaToParams(SearchDTO.CriteriaRq criteria,
                                         HashMap<String, String> map) {
        if (criteria == null)
            return;
        if (criteria.getFieldName() == null) {
            if (criteria.getCriteria() != null && !criteria.getCriteria().isEmpty()) {
                for (int i = 0; i < criteria.getCriteria().size(); i++) {
                    convertCriteriaToParams(criteria.getCriteria().get(i),
                            map);
                }
            }
            return;
        }
        switch (criteria.getFieldName()) {
            case "ccpArea":
                map.put("personnelCppArea", criteria.getValue().toString().substring(1, criteria.getValue().toString().length() - 1));
                break;
            case "ccpAreaCode":
                map.put("personnelCppAreaCode", criteria.getValue().toString().substring(1, criteria.getValue().toString().length() - 1));
                break;
            case "ccpAssistant":
                map.put("personnelCcpAssistant", criteria.getValue().toString().substring(1, criteria.getValue().toString().length() - 1));
                break;
            case "ccpAssistantCode":
                map.put("personnelCcpAssistantCode", criteria.getValue().toString().substring(1, criteria.getValue().toString().length() - 1));
                break;
            case "ccpAffairs":
                map.put("personnelCppAffairs", criteria.getValue().toString().substring(1, criteria.getValue().toString().length() - 1));
                break;
            case "ccpAffairsCode":
                map.put("personnelCppAffairsCode", criteria.getValue().toString().substring(1, criteria.getValue().toString().length() - 1));
                break;
            case "ccpSection":
                map.put("personnelCcpSection", criteria.getValue().toString().substring(1, criteria.getValue().toString().length() - 1));
                break;
            case "ccpSectionCode":
                map.put("personnelCcpSectionCode", criteria.getValue().toString().substring(1, criteria.getValue().toString().length() - 1));
                break;
            case "ccpUnit":
                map.put("personnelCcpUnit", criteria.getValue().toString().substring(1, criteria.getValue().toString().length() - 1));
                break;
            case "ccpUnitCode":
                map.put("personnelCcpUnitCode", criteria.getValue().toString().substring(1, criteria.getValue().toString().length() - 1));
                break;
            case "companyName":
                map.put("personnelCompanyName", criteria.getValue().toString().substring(1, criteria.getValue().toString().length() - 1));
                break;
            case "educationLevelTitle":
                map.put("eduLevelTitle", criteria.getValue().toString().substring(1, criteria.getValue().toString().length() - 1));
                break;
            case "jobId":
                map.put("jobId", criteria.getValue().toString().substring(1, criteria.getValue().toString().length() - 1));
                break;
        }
    }

    @Transactional(readOnly = true)
//    @Override
    public SearchDTO.SearchRs<NeedsAssessmentReportsDTO.CourseNAS> getCourseNA(SearchDTO.SearchRq request, Long courseId, Boolean passedReport) {

        HashMap<String, String> map = new HashMap<>();
        if (request.getCriteria() != null)
            convertCriteriaToParams(request.getCriteria(), map);

        List<List<Integer>> personnelCountByPriority = personnelCoursePassedNAReportViewDAO.getPersonnelCountByPriority(
                courseId,
                map.get("personnelCppArea"),
                map.get("personnelCppAreaCode"),
                map.get("personnelCcpAssistant"),
                map.get("personnelCcpAssistantCode"),
                map.get("personnelCppAffairs"),
                map.get("personnelCppAffairsCode"),
                map.get("personnelCcpSection"),
                map.get("personnelCcpSectionCode"),
                map.get("personnelCcpUnit"),
                map.get("personnelCcpUnitCode"),
                map.get("personnelCompanyName"),
                map.get("eduLevelTitle"),
                map.get("jobId") != null ? Long.parseLong(map.get("jobId")) : -1);

        List<NeedsAssessmentReportsDTO.CourseNAS> result = new ArrayList<>();
        needsAssessmentPriorityCodes.forEach(code -> {
            NeedsAssessmentReportsDTO.CourseNAS courseNAS = new NeedsAssessmentReportsDTO.CourseNAS().setNeedsAssessmentPriorityId(parameterValueService.getId(code));
            int priorityId = courseNAS.getNeedsAssessmentPriorityId().intValue();
            switch (priorityId) {
                case 111:
                    courseNAS.setTotalPersonnelCount(personnelCountByPriority.get(0).get(0));
                    courseNAS.setPassedPersonnelCount(personnelCountByPriority.get(0).get(1));
                    break;
                case 574:
                    courseNAS.setTotalPersonnelCount(personnelCountByPriority.get(0).get(2));
                    courseNAS.setPassedPersonnelCount(personnelCountByPriority.get(0).get(3));
                    break;
                case 112:
                    courseNAS.setTotalPersonnelCount(personnelCountByPriority.get(0).get(4));
                    courseNAS.setPassedPersonnelCount(personnelCountByPriority.get(0).get(5));
                    break;
                case 113:
                    courseNAS.setTotalPersonnelCount(personnelCountByPriority.get(0).get(6));
                    courseNAS.setPassedPersonnelCount(personnelCountByPriority.get(0).get(7));
                    break;
                default:
                    courseNAS.setTotalPersonnelCount(0);
                    courseNAS.setPassedPersonnelCount(0);
                    break;
            }
            result.add(courseNAS);
        });

//        Course course = courseService.getCourse(courseId);
//        List<NeedsAssessment> needsAssessments = new ArrayList<>();
//        course.getSkillSet().forEach(skill -> needsAssessments.addAll(skill.getNeedsAssessments().stream().filter(na -> na.getDeleted() == null).collect(Collectors.toList())));
//        Comparator<NeedsAssessment> comparator = Comparator.comparing(na -> NeedsAssessment.priorityList.indexOf(na.getObjectType()));
//        comparator = comparator.thenComparing(NeedsAssessment::getNeedsAssessmentPriorityId);
//        needsAssessments.sort(comparator);
//        MultiValueMap postsGByPriority = getNAPostsGByPriority(needsAssessments);
//        postsGByPriority.forEach((priority, postList) -> {
//            SearchDTO.CriteriaRq personnelCriteria = makeNewCriteria(null, null, EOperator.and, new ArrayList<>());
//            if (request.getCriteria() != null)
//                personnelCriteria.getCriteria().add(request.getCriteria());
//            for (int i = 0; i < ((List<Post>) postList).size(); i += 900) {
//                int endIndex = i + 900 >= ((List<Post>) postList).size() ? ((List<Post>) postList).size() - 1 : i + 900;
//                personnelCriteria.getCriteria().add(makeNewCriteria("postCode", ((List<Post>) postList).subList(i, endIndex).stream().map(Post::getCode).collect(Collectors.toList()), EOperator.inSet, null));
//            }
//            List<PersonnelDTO.Info> personnelInfoList = personnelService.search(new SearchDTO.SearchRq().setCriteria(personnelCriteria).setDistinct(true)).getList();
//            NeedsAssessmentReportsDTO.CourseNAS courseNAS = result.stream().filter(courseNAS1 -> courseNAS1.getNeedsAssessmentPriorityId().equals((Long) priority)).findFirst().orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
//            courseNAS.setTotalPersonnelCount(personnelInfoList.size());
//            if (passedReport) {
//                personnelInfoList.forEach(p -> {
//                    if (classStudentReportService.isPassed(course, p.getNationalCode()))
//                        courseNAS.setPassedPersonnelCount(courseNAS.getPassedPersonnelCount() + 1);
//                });
//            }
////            result.add(courseNAS);
//        });
        SearchDTO.SearchRs<NeedsAssessmentReportsDTO.CourseNAS> searchRs = new SearchDTO.SearchRs<>();
        searchRs.setTotalCount((long) result.size());
        searchRs.setList(result);
        return searchRs;
    }

    @Transactional(readOnly = true)
    public void addCriteria(SearchDTO.CriteriaRq criteriaRq, String objectType, Long objectId, boolean isFirstObject, boolean addFirstObject) {
        Supplier<TrainingException> trainingExceptionSupplier = () -> new TrainingException(TrainingException.ErrorType.NotFound);
        switch (objectType) {
            case "Post":
                Post currentPost = postDAO.findById(objectId).orElseThrow(trainingExceptionSupplier);
                if (!isFirstObject && (currentPost.getDeleted() != null || currentPost.getEnabled() != null))
                    return;
                currentPost.getTrainingPostSet().forEach(trainingPost -> addCriteria(criteriaRq, "TrainingPost", trainingPost.getId(), false, addFirstObject));
                currentPost.getPostGroupSet().forEach(postGroup -> addCriteria(criteriaRq, "PostGroup", postGroup.getId(), false, addFirstObject));
                break;
            case "TrainingPost":
                TrainingPost currentTrainingPost = trainingPostDAO.findById(objectId).orElseThrow(trainingExceptionSupplier);
                if (!isFirstObject && (currentTrainingPost.getDeleted() != null || currentTrainingPost.getEnabled() != null))
                    return;
                if (currentTrainingPost.getJob() != null)
                    addCriteria(criteriaRq, "Job", currentTrainingPost.getJob().getId(), false, addFirstObject);
                if (currentTrainingPost.getPostGrade() != null)
                    addCriteria(criteriaRq, "PostGrade", currentTrainingPost.getPostGrade().getId(), false, addFirstObject);
                currentTrainingPost.getPostGroupSet().forEach(postGroup -> addCriteria(criteriaRq, "PostGroup", postGroup.getId(), false, addFirstObject));
                break;
            case "PostGroup":
                PostGroup postGroup = postGroupDAO.findById(objectId).orElseThrow(trainingExceptionSupplier);
                if (!isFirstObject && (postGroup.getDeleted() != null || postGroup.getEnabled() != null))
                    return;
                break;
            case "Job":
                Job currentJob = jobDAO.findById(objectId).orElseThrow(trainingExceptionSupplier);
                if (!isFirstObject && (currentJob.getDeleted() != null || currentJob.getEnabled() != null))
                    return;
                currentJob.getJobGroupSet().forEach(jobGroup -> addCriteria(criteriaRq, "JobGroup", jobGroup.getId(), false, addFirstObject));
                break;
            case "JobGroup":
                JobGroup jobGroup = jobGroupDAO.findById(objectId).orElseThrow(trainingExceptionSupplier);
                if (!isFirstObject && (jobGroup.getDeleted() != null || jobGroup.getEnabled() != null))
                    return;
                break;
            case "PostGrade":
                PostGrade currentPostGrade = postGradeDAO.findById(objectId).orElseThrow(trainingExceptionSupplier);
                if (!isFirstObject && (currentPostGrade.getDeleted() != null || currentPostGrade.getEnabled() != null))
                    return;
                currentPostGrade.getPostGradeGroup().forEach(postGradeGroup -> addCriteria(criteriaRq, "PostGradeGroup", postGradeGroup.getId(), false, addFirstObject));
                break;
            case "PostGradeGroup":
                PostGradeGroup postGradeGroup = postGradeGroupDAO.findById(objectId).orElseThrow(trainingExceptionSupplier);
                if (!isFirstObject && (postGradeGroup.getDeleted() != null || postGradeGroup.getEnabled() != null))
                    return;
                break;
        }
        if (!isFirstObject || addFirstObject) {
            List<SearchDTO.CriteriaRq> list = new ArrayList<>();
            list.add(makeNewCriteria("objectId", objectId, EOperator.equals, null));
            list.add(makeNewCriteria("objectType", objectType, EOperator.equals, null));
            criteriaRq.getCriteria().add(makeNewCriteria(null, null, EOperator.and, list));
        }
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<NeedsAssessmentReportsDTO.ReportInfo> searchForBpms(SearchDTO.SearchRq searchRq, String postCode, String objectType, String nationalCode, String personnelNumber) {
        List<NeedsAssessmentReportsDTO.ReportInfo> needsAssessmentReportList = getCourseListForBpms(postCode, objectType, nationalCode, personnelNumber);
        SearchDTO.SearchRs<NeedsAssessmentReportsDTO.ReportInfo> rs = new SearchDTO.SearchRs<>();
        rs.setTotalCount((long) needsAssessmentReportList.size());
        rs.setList(needsAssessmentReportList);
        return rs;
    }

    @Transactional(readOnly = true)
    public List<NeedAssessmentReportUserDTO> findNeedAssessmentByNationalCode(String nationalCode) {
        List<ParameterValue> allParameter = parameterValueDAO.findAll();
        List<NeedAssessmentReportUserDTO> reportUserDTOS = new ArrayList<>();
        PersonnelDTO.PersonalityInfo personalityInfo = personnelService.getByNationalCode(nationalCode);
        List<NeedsAssessmentReportsDTO.ReportInfo> needsAssessmentReportList = getCourseListForBpms(personalityInfo.getPostCode(), "Post", nationalCode, personalityInfo.getPersonnelNo());
        Set<Long> assessmentsType = needsAssessmentReportList.stream().map(NeedsAssessmentReportsDTO.ReportInfo::getNeedsAssessmentPriorityId).collect(Collectors.toSet());
        for (Long aLong : assessmentsType) {
            NeedAssessmentReportUserDTO needAssessmentReportUserDTO = new NeedAssessmentReportUserDTO();
            String title = allParameter.stream().filter(parameterValue -> parameterValue.getId().equals(aLong)).collect(Collectors.toList()).get(0).getTitle();
            needAssessmentReportUserDTO.setAssessment(title);
            List<NeedAssessmentReportUserDTO.CompetenceInfo> competenceInfoList = new ArrayList<>();
            needsAssessmentReportList.stream().filter(reportInfo -> reportInfo.getNeedsAssessmentPriorityId().equals(aLong)).collect(Collectors.toList()).forEach(reportInfo -> {
                NeedAssessmentReportUserDTO.CompetenceInfo competenceInfo = new NeedAssessmentReportUserDTO.CompetenceInfo();
                competenceInfo.setCompetence(reportInfo.getCompetence().getTitle());
                competenceInfo.setCompetenceTypeName(allParameter.stream().filter(parameterValue -> parameterValue.getId().equals(reportInfo.getCompetence().getCompetenceTypeId())).collect(Collectors.toList()).get(0).getTitle());
                competenceInfo.setNeedsAssessmentDomainIdName(allParameter.stream().filter(parameterValue -> parameterValue.getId().equals(reportInfo.getNeedsAssessmentDomainId())).collect(Collectors.toList()).get(0).getTitle());
                competenceInfo.setSkillCode(reportInfo.getSkill().getCode());
                competenceInfo.setSkill(reportInfo.getSkill().getTitleFa());
                competenceInfo.setCourseCode(reportInfo.getSkill().getCourse().getCode());
                competenceInfo.setCourseName(reportInfo.getSkill().getCourse().getTitleFa());
                competenceInfo.setCourseDuration(reportInfo.getSkill().getCourse().getTheoryDuration());
                competenceInfo.setCourseState(allParameter.stream().filter(parameterValue -> parameterValue.getId().equals(reportInfo.getSkill().getCourse().getScoresState())).collect(Collectors.toList()).get(0).getTitle());
                competenceInfoList.add(competenceInfo);
            });
            needAssessmentReportUserDTO.setCompetenceInfoList(competenceInfoList);
            needAssessmentReportUserDTO.setNeedAssessmentCount(competenceInfoList.size());
            //needAssessmentReportUserDTO.setNeedAssessmentDurationCount(competenceInfoList.stream().map(competenceInfo -> competenceInfo.getCourseDuration()).collect(Collectors.toList()).stream().);
            reportUserDTOS.add(needAssessmentReportUserDTO);
        }
        return reportUserDTOS;
    }


    @Transactional(readOnly = true)
    @Override
    public List<NeedsAssessmentReportsDTO.ReportInfo> getCourseListForBpms(String postCode, String objectType, String nationalCode, String personnelNumber) {
        Long passedCodeId = parameterValueService.getId("Passed");
        Long notPassedCodeId = parameterValueService.getId("false");


        List<NeedsAssessment> needsAssessmentList = getNeedsAssessmentListForBpms(postCode, objectType);
        needsAssessmentList = needsAssessmentList.stream().filter(NA -> NA.getSkill().getCourse() != null).collect(Collectors.toList());
        List<NeedsAssessmentReportsDTO.ReportInfo> mustPass = modelMapper.map(needsAssessmentList, new TypeToken<List<NeedsAssessmentReportsDTO.ReportInfo>>() {
        }.getType());

        if (nationalCode != null && !mustPass.isEmpty()) {
            try {
                //1
                PersonnelDTO.Info student = personnelService.getByPersonnelCodeAndNationalCode(nationalCode, personnelNumber);
                if (student == null) {
                    throw new TrainingException(TrainingException.ErrorType.NotFound);
                }

                Set<Long> passedCourseIds = classStudentReportService.getPassedCoursesIdsOfStudentByNationalCode(student.getNationalCode());
                Map<Long, Boolean> isPassed = passedCourseIds.stream().collect(Collectors.toMap(id -> id, id -> true));

                for (int i = 0; i < mustPass.size(); i++) {
                    List<TclassDTO.PersonnelClassInfo> personClasses = tClassService.findPersonnelClassByCourseId(student.getNationalCode(), student.getPersonnelNo(), needsAssessmentList.get(i).getSkill().getCourse().getId());

                    if (classStudentReportService.isPassed(needsAssessmentList.get(i).getSkill().getCourse(), isPassed)) {
                        mustPass.get(i).getSkill().getCourse().setScoresState(passedCodeId);
                        if (personClasses.size() > 0) {
                            String courseStatus = personClasses.get(0).getScoreState();
                            if (!passedCourseIds.contains(needsAssessmentList.get(i).getSkill().getCourse().getId()) &&
                                    isPassed.get(needsAssessmentList.get(i).getSkill().getCourse().getId()) != null
                                    && isPassed.get(needsAssessmentList.get(i).getSkill().getCourse().getId())) {
                                courseStatus += " - دوره معادل گذرانده شده است ";
                            }
                            mustPass.get(i).getSkill().getCourse().setScoresStatus(courseStatus);
                        }
                    } else {
                        mustPass.get(i).getSkill().getCourse().setScoresState(notPassedCodeId);
                        if (personClasses.size() > 0) {
                            mustPass.get(i).getSkill().getCourse().setScoresStatus(personClasses.get(0).getScoreState());
                        }
                    }
                }
            } catch (Exception e) {
                throw new TrainingException(TrainingException.ErrorType.NotFound);

            }


        }
        return mustPass;
    }

    @Transactional(readOnly = true)
    @Override
    public List<NeedsAssessment> getNeedsAssessmentListForBpms(String postCode, String objectType) {
        List<NeedsAssessment> needsAssessmentList = new ArrayList<>();
        SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, new ArrayList<>());
        criteriaRq.getCriteria().add(makeNewCriteria(null, null, EOperator.or, new ArrayList<>()));
        criteriaRq.getCriteria().add(makeNewCriteria("deleted", null, EOperator.isNull, null));
        addCriteriaForBpms(criteriaRq.getCriteria().get(0), objectType, postCode, true, true);
        if (!criteriaRq.getCriteria().get(0).getCriteria().isEmpty())
            needsAssessmentList = needsAssessmentDAO.findAll(NICICOSpecification.of(criteriaRq));
        return removeDuplicateNAs(needsAssessmentList);
    }


    @Transactional(readOnly = true)
    public void addCriteriaForBpms(SearchDTO.CriteriaRq criteriaRq, String objectType, String postCode, boolean isFirstObject, boolean addFirstObject) {
        Supplier<TrainingException> trainingExceptionSupplier = () -> new TrainingException(TrainingException.ErrorType.NotFound);
        if (objectType.equals("Post")) {
            Post currentPost = postDAO.findByCodeAndDeleted(postCode, null).orElseThrow(trainingExceptionSupplier);
            if (!isFirstObject && (currentPost.getDeleted() != null || currentPost.getEnabled() != null))
                return;
            currentPost.getTrainingPostSet().forEach(trainingPost -> addCriteria(criteriaRq, "TrainingPost", trainingPost.getId(), false, addFirstObject));
            currentPost.getPostGroupSet().forEach(postGroup -> addCriteria(criteriaRq, "PostGroup", postGroup.getId(), false, addFirstObject));
        }
        if (!isFirstObject || addFirstObject) {
            List<SearchDTO.CriteriaRq> list = new ArrayList<>();
            list.add(makeNewCriteria("objectCode", postCode, EOperator.equals, null));
            list.add(makeNewCriteria("objectType", objectType, EOperator.equals, null));
            criteriaRq.getCriteria().add(makeNewCriteria(null, null, EOperator.and, list));
        }
    }

    @Transactional(readOnly = true)
    @Override
    public List<NeedAssessmentGroupJobPromotionResponse> createNeedAssessmentResultGroup(NeedAssessmentGroupJobPromotionRequestDto requestDto) {
        Supplier<TrainingException> trainingExceptionSupplier = () -> new TrainingException(TrainingException.ErrorType.NotFound);

        List<NeedAssessmentGroupJobPromotionDto> needAssessmentGroupJobPromotionDtos = requestDto.getNeedAssessmentGroupJobPromotionDtos();
        List<NeedAssessmentGroupJobPromotionResponse> needAssessmentGroupResponse = new ArrayList<>();

        Map<Long, ParameterValue> competenceTypeParamMap = getLongParameterValueMap("competenceType");
        Map<Long, ParameterValue> passedStatusParamMap = getLongParameterValueMap("PassedStatus");
        Map<Long, ParameterValue> needsAssessmentPriorityParamMap = getLongParameterValueMap("NeedsAssessmentPriority");

        for (NeedAssessmentGroupJobPromotionDto dto : needAssessmentGroupJobPromotionDtos) {
            List<NeedsAssessmentReportsDTO.ReportInfo> needsAssessmentReportList = getCourseList(Long.valueOf(dto.getPostId()), "TrainingPost", Long.valueOf(dto.getPersonnelId()));
            TrainingPost currentTrainingPost = trainingPostDAO.findById(Long.valueOf(dto.getPostId())).orElseThrow(trainingExceptionSupplier);

            Personnel personnel = personnelDAO.getOne(Long.valueOf(dto.getPersonnelId()));
            for (NeedsAssessmentReportsDTO.ReportInfo reportInfo : needsAssessmentReportList
            ) {
                NeedAssessmentGroupJobPromotionResponse response = new NeedAssessmentGroupJobPromotionResponse();
                response.setTrainingPostCode(currentTrainingPost.getCode());
                response.setId(reportInfo.getId());
                response.setCompetence(reportInfo.getCompetence());
                if (reportInfo.getCompetence() != null && reportInfo.getCompetence().getCompetenceTypeId() != null) {
                    response.setCompetenceTypeTitle(competenceTypeParamMap.get(reportInfo.getCompetence().getCompetenceTypeId()).getTitle());
                }
                if (reportInfo.getSkill() != null && reportInfo.getSkill().getCourse() != null && reportInfo.getSkill().getCourse().getScoresState() != null) {
                    response.setScoresStateTitle(passedStatusParamMap.get(reportInfo.getSkill().getCourse().getScoresState()).getTitle());
                }
                if (reportInfo.getSkill() != null && reportInfo.getSkill().getCourse() != null && reportInfo.getSkill().getCourse().getScoresStatus() != null) {
                    String master = reportInfo.getSkill().getCourse().getScoresStatus();
                    ;
                    String target = "<b class=\"\">";
                    String replacement = "";
                    master = master.replace(target, replacement);

                    target = "</b>";
                    master = master.replace(target, replacement);

                    target = "<b class=\"acceptRTL\">";
                    master = master.replace(target, replacement);

                    reportInfo.getSkill().getCourse().setScoresStatus(master);
                }
                if (reportInfo.getNeedsAssessmentPriorityId() != null) {
                    response.setNeedsAssessmentPriorityTitle(needsAssessmentPriorityParamMap.get(reportInfo.getNeedsAssessmentPriorityId()).getTitle());
                }
                response.setSkill(reportInfo.getSkill());
                response.setNeedsAssessmentDomainId(reportInfo.getNeedsAssessmentDomainId());
                response.setNeedsAssessmentPriorityId(reportInfo.getNeedsAssessmentPriorityId());
                response.setFirstName(personnel.getFirstName());
                response.setLastName(personnel.getLastName());
                response.setPersonnelNo(personnel.getPersonnelNo());
                response.setPersonnelCcpAffairs(personnel.getCcpAffairs());
                needAssessmentGroupResponse.add(response);
            }
        }
//        Comparator<NeedAssessmentGroupJobPromotionResponse> familyComparatorLambda =
//                (na1, na22) -> na1.getLastName().compareTo(na22.getLastName());
//        Collections.sort(needAssessmentGroupResponse, familyComparatorLambda);

        return needAssessmentGroupResponse;
    }

    private Map<Long, ParameterValue> getLongParameterValueMap(String parameterTypeName) {
        Optional<Parameter> parameterTypePByCode = parameterDAO.findByCode(parameterTypeName);
        Parameter parameter = parameterTypePByCode.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        List<ParameterValue> typeParamList = parameter.getParameterValueList();
        Map<Long, ParameterValue> typeParamMap = convertListToMap(typeParamList);
        return typeParamMap;
    }


    public Map<Long, ParameterValue> convertListToMap(List<ParameterValue> list) {
        Map<Long, ParameterValue> map = list.stream()
                .collect(Collectors.toMap(ParameterValue::getId, Function.identity()));
        return map;
    }


    @Override
    public NeedAssessmentGroupResult createNeedAssessmentGroupResult(byte[] blobFile, String name) {
        String s = UUID.randomUUID().toString();
        NeedAssessmentGroupResult needAssessmentGroupResult = new NeedAssessmentGroupResult();
        needAssessmentGroupResult.setBlobFile(blobFile);
        needAssessmentGroupResult.setExcelReference(s);
        needAssessmentGroupResult.setCreatedBy(name);
        return needAssessmentGroupResultDAO.save(needAssessmentGroupResult);
    }

    @Override
    public NeedAssessmentGroupResult getNeedAssessmentGroupResult(String reference) {
        return needAssessmentGroupResultDAO.findByExcelReference(reference);
    }

    @Override
    public List<NeedAssessmentGroupJobPromotionResponseDto.Info> getGroupJobPromotionListByUser(String userName) {
        List<NeedAssessmentGroupResult> list = needAssessmentGroupResultDAO.findAllByCreatedByOrderByIdDesc(userName);
        return needAssessmentGroupResultMapper.toResultDtoList(list);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        needAssessmentGroupResultDAO.deleteById(id);
    }
}
