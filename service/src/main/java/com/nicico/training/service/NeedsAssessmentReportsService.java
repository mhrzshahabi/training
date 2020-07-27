package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.NICICOSpecification;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.NeedsAssessmentReportsDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.PersonnelDTO;
import com.nicico.training.dto.PostDTO;
import com.nicico.training.iservice.ICourseService;
import com.nicico.training.iservice.IPersonnelService;
import com.nicico.training.iservice.ISkillService;
import com.nicico.training.model.*;
import com.nicico.training.repository.*;
import lombok.RequiredArgsConstructor;
import org.apache.commons.collections.map.MultiValueMap;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.function.Supplier;
import java.util.stream.Collectors;

import static com.nicico.training.service.BaseService.makeNewCriteria;
import static com.nicico.training.service.NeedsAssessmentTempService.getCriteria;

@Service
@RequiredArgsConstructor
public class NeedsAssessmentReportsService {

    private final List<String> needsAssessmentPriorityCodes = Arrays.asList("AZ", "AB", "AT");

    private final ModelMapper modelMapper;

    private final PostDAO postDAO;
    private final JobDAO jobDAO;
    private final PostGradeDAO postGradeDAO;
    private final NeedsAssessmentDAO needsAssessmentDAO;
    private final NeedsAssessmentTempDAO needsAssessmentTempDAO;

    private final ClassStudentReportService classStudentReportService;
    private final IPersonnelService personnelService;
    private final ParameterValueService parameterValueService;
    private final ICourseService courseService;
    private final ISkillService skillService;

    @Transactional(readOnly = true)
//    @Override
    public SearchDTO.SearchRs<NeedsAssessmentReportsDTO.ReportInfo> search(SearchDTO.SearchRq request, Long objectId, String objectType, String personnelNo) {
        List<NeedsAssessmentReportsDTO.ReportInfo> needsAssessmentReportList = getCourseList(objectId, objectType, personnelNo);
        SearchDTO.SearchRs<NeedsAssessmentReportsDTO.ReportInfo> rs = new SearchDTO.SearchRs<>();
        rs.setTotalCount((long) needsAssessmentReportList.size());
        rs.setList(needsAssessmentReportList);
        return rs;
    }

    @Transactional(readOnly = true)
//    @Override
    public List<NeedsAssessmentReportsDTO.ReportInfo> getCourseList(Long objectId, String objectType, String personnelNo) {

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
        if (personnelNo != null && !mustPass.isEmpty()) {
            PersonnelDTO.Info student = personnelService.getPOrRegisteredP(personnelNo, p -> modelMapper.map(p, PersonnelDTO.Info.class));
            if (student == null) {
                throw new TrainingException(TrainingException.ErrorType.NotFound);
            }
            Set<Long> passedCourseIds = classStudentReportService.getPassedCoursesIdsOfStudentByNationalCode(student.getNationalCode());
            Map<Long, Boolean> isPassed = passedCourseIds.stream().collect(Collectors.toMap(id -> id, id -> true));

            for (int i = 0; i < mustPass.size(); i++) {
                if (classStudentReportService.isPassed(needsAssessmentList.get(i).getSkill().getCourse(), isPassed))
                    mustPass.get(i).getSkill().getCourse().setScoresState(passedCodeId);
                else
                    mustPass.get(i).getSkill().getCourse().setScoresState(notPassedCodeId);
            }
        }
        return mustPass;
    }

    @Transactional(readOnly = true)
//    @Override
    public List<NeedsAssessment> getNeedsAssessmentList(Long objectId, String objectType) {
        SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, new ArrayList<>());
        criteriaRq.getCriteria().add(makeNewCriteria(null, null, EOperator.or, new ArrayList<>()));
//        criteriaRq.getCriteria().add(makeNewCriteria("eDeleted", 75L, EOperator.notEqual, null));
        addCriteria(criteriaRq.getCriteria().get(0), objectType, objectId, null, null, true);
        List<NeedsAssessment> needsAssessmentList = needsAssessmentDAO.findAll(NICICOSpecification.of(criteriaRq));
        return removeDuplicateNAs(needsAssessmentList);
    }

    @Transactional(readOnly = true)
    public List<NeedsAssessment> getUnverifiedNeedsAssessmentList(Long objectId, String objectType) {
        List<NeedsAssessment> needsAssessmentList = new ArrayList<>();
        SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.and, new ArrayList<>());
        criteriaRq.getCriteria().add(makeNewCriteria(null, null, EOperator.or, new ArrayList<>()));
//        criteriaRq.getCriteria().add(makeNewCriteria("eDeleted", 75L, EOperator.notEqual, null));
        addCriteria(criteriaRq.getCriteria().get(0), objectType, objectId, objectType, objectId, false);
        if (!criteriaRq.getCriteria().get(0).getCriteria().isEmpty())
            needsAssessmentList.addAll(needsAssessmentDAO.findAll(NICICOSpecification.of(criteriaRq)));

        SearchDTO.CriteriaRq tempCriteriaRq = getCriteria(objectType, objectId);
//        tempCriteriaRq.getCriteria().add(makeNewCriteria("eDeleted", 75L, EOperator.notEqual, null));
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
            switch (needsAssessment.getObjectType()) {
                case "Post":
                    try {
                        if (((Post) needsAssessment.getObject()).getCode() != null && !postCodes.containsValue(needsAssessment.getObject()))
                            postCodes.put(needsAssessment.getNeedsAssessmentPriorityId(), needsAssessment.getObject());
                    } catch (Exception ex) {
                        ex.printStackTrace();
                        return;
                    }
                    break;
                case "PostGroup":
                    try {
                        ((PostGroup) needsAssessment.getObject()).getPostSet().forEach(post -> {
                            try {
                                if (post.getCode() != null && !postCodes.containsValue(post))
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
                        ((Job) needsAssessment.getObject()).getPostSet().forEach(post -> {
                            try {
                                if (post.getCode() != null && !postCodes.containsValue(post))
                                    postCodes.put(needsAssessment.getNeedsAssessmentPriorityId(), post);
                            } catch (Exception ex) {
                                ex.printStackTrace();
                            }
                        });
                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }
                    break;
                case "JobGroup":
                    try {
                        ((JobGroup) needsAssessment.getObject()).getJobSet().forEach(job -> job.getPostSet().forEach(post -> {
                            try {
                                if (post.getCode() != null && !postCodes.containsValue(post))
                                    postCodes.put(needsAssessment.getNeedsAssessmentPriorityId(), post);
                            } catch (Exception ex) {
                                ex.printStackTrace();
                            }
                        }));
                        break;
                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }
                case "PostGrade":
                    try {
                        ((PostGrade) needsAssessment.getObject()).getPostSet().forEach(post -> {
                            try {
                                if (post.getCode() != null && !postCodes.containsValue(post))
                                    postCodes.put(needsAssessment.getNeedsAssessmentPriorityId(), post);
                            } catch (Exception ex) {
                                ex.printStackTrace();
                            }
                        });
                        break;
                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }
                case "PostGradeGroup":
                    try {
                        ((PostGradeGroup) needsAssessment.getObject()).getPostGradeSet().forEach(postGrade -> postGrade.getPostSet().forEach(post -> {
                            try {
                                if (post.getCode() != null && !postCodes.containsValue(post))
                                    postCodes.put(needsAssessment.getNeedsAssessmentPriorityId(), post);
                            } catch (Exception ex) {
                                ex.printStackTrace();
                            }
                        }));
                        break;
                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }
            }
        });
        return postCodes;
    }

    @Transactional(readOnly = true)
//    @Override
    public SearchDTO.SearchRs<PostDTO.Info> getSkillNAPostList(SearchDTO.SearchRq request, Long skillId) {
        Skill skill = skillService.getSkill(skillId);
        List<NeedsAssessment> needsAssessments = new ArrayList<>(skill.getNeedsAssessments());
        MultiValueMap postsGByPriority = getNAPostsGByPriority(needsAssessments);
        SearchDTO.SearchRs<PostDTO.Info> searchRs = new SearchDTO.SearchRs<>();
        searchRs.setTotalCount((long) postsGByPriority.values().size());
        searchRs.setList(modelMapper.map(postsGByPriority.values(), new TypeToken<List<PostDTO.Info>>() {
        }.getType()));
        return searchRs;
    }

    @Transactional(readOnly = true)
//    @Override
    public SearchDTO.SearchRs<NeedsAssessmentReportsDTO.CourseNAS> getCourseNA(SearchDTO.SearchRq request, Long courseId, Boolean passedReport) {

        List<NeedsAssessmentReportsDTO.CourseNAS> result = new ArrayList<>();
        needsAssessmentPriorityCodes.forEach(code -> {
            Long pId = parameterValueService.getId(code);
            result.add(new NeedsAssessmentReportsDTO.CourseNAS().setNeedsAssessmentPriorityId(pId));
        });
        Course course = courseService.getCourse(courseId);
        List<NeedsAssessment> needsAssessments = new ArrayList<>();
        course.getSkillSet().forEach(skill -> needsAssessments.addAll(skill.getNeedsAssessments()));
        Comparator<NeedsAssessment> comparator = Comparator.comparing(na -> NeedsAssessment.priorityList.indexOf(na.getObjectType()));
        comparator = comparator.thenComparing(NeedsAssessment::getNeedsAssessmentPriorityId);
        needsAssessments.sort(comparator);
        MultiValueMap postsGByPriority = getNAPostsGByPriority(needsAssessments);
        postsGByPriority.forEach((priority, postList) -> {
            SearchDTO.CriteriaRq personnelCriteria = makeNewCriteria(null, null, EOperator.and, new ArrayList<>());
            if (request.getCriteria() != null)
                personnelCriteria.getCriteria().add(request.getCriteria());
            for (int i = 0; i < ((List<Post>) postList).size(); i += 900) {
                int endIndex = i + 900 >= ((List<Post>) postList).size() ? ((List<Post>) postList).size() - 1 : i + 900;
                personnelCriteria.getCriteria().add(makeNewCriteria("postCode", ((List<Post>) postList).subList(i, endIndex).stream().map(Post::getCode).collect(Collectors.toList()), EOperator.inSet, null));
            }
            List<PersonnelDTO.Info> personnelInfoList = personnelService.search(new SearchDTO.SearchRq().setCriteria(personnelCriteria).setDistinct(true)).getList();
            NeedsAssessmentReportsDTO.CourseNAS courseNAS = result.stream().filter(courseNAS1 -> courseNAS1.getNeedsAssessmentPriorityId().equals((Long) priority)).findFirst().orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
            courseNAS.setTotalPersonnelCount(personnelInfoList.size());
            if (passedReport) {
                personnelInfoList.forEach(p -> {
                    if (classStudentReportService.isPassed(course, p.getNationalCode()))
                        courseNAS.setPassedPersonnelCount(courseNAS.getPassedPersonnelCount() + 1);
                });
            }
//            result.add(courseNAS);
        });
        SearchDTO.SearchRs<NeedsAssessmentReportsDTO.CourseNAS> searchRs = new SearchDTO.SearchRs<>();
        searchRs.setTotalCount((long) result.size());
        searchRs.setList(result);
        return searchRs;
    }

    @Transactional(readOnly = true)
    public void addCriteria(SearchDTO.CriteriaRq criteriaRq, String objectType, Long objectId, String mainObjectType, Long mainObjectId, boolean isVerified) {
        Supplier<TrainingException> trainingExceptionSupplier = () -> new TrainingException(TrainingException.ErrorType.NotFound);
        if (isVerified || !objectType.equals(mainObjectType) || !objectId.equals(mainObjectId)) {
            List<SearchDTO.CriteriaRq> list = new ArrayList<>();
            list.add(makeNewCriteria("objectId", objectId, EOperator.equals, null));
            list.add(makeNewCriteria("objectType", objectType, EOperator.equals, null));
            criteriaRq.getCriteria().add(makeNewCriteria(null, null, EOperator.and, list));
        }
        switch (objectType) {
            case "Post":
                Optional<Post> optionalPost = postDAO.findById(objectId);
                Post currentPost = optionalPost.orElseThrow(trainingExceptionSupplier);
                if (currentPost.getJob() != null)
                    addCriteria(criteriaRq, "Job", currentPost.getJob().getId(), mainObjectType, mainObjectId, isVerified);
                if (currentPost.getPostGrade() != null)
                    addCriteria(criteriaRq, "PostGrade", currentPost.getPostGrade().getId(), mainObjectType, mainObjectId, isVerified);
                currentPost.getPostGroupSet().forEach(postGroup -> addCriteria(criteriaRq, "PostGroup", postGroup.getId(), mainObjectType, mainObjectId, isVerified));
                break;
            case "Job":
                Optional<Job> optionalJob = jobDAO.findById(objectId);
                Job currentJob = optionalJob.orElseThrow(trainingExceptionSupplier);
                currentJob.getJobGroupSet().forEach(jobGroup -> addCriteria(criteriaRq, "JobGroup", jobGroup.getId(), mainObjectType, mainObjectId, isVerified));
                break;
            case "PostGrade":
                Optional<PostGrade> optionalPostGrade = postGradeDAO.findById(objectId);
                PostGrade currentPostGrade = optionalPostGrade.orElseThrow(trainingExceptionSupplier);
                currentPostGrade.getPostGradeGroup().forEach(postGradeGroup -> addCriteria(criteriaRq, "PostGradeGroup", postGradeGroup.getId(), mainObjectType, mainObjectId, isVerified));
                break;
        }
    }
}
