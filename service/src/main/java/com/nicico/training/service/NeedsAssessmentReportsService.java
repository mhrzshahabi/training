package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.NICICOSpecification;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.NeedsAssessmentReportsDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.PersonnelDTO;
import com.nicico.training.iservice.ICourseService;
import com.nicico.training.iservice.IPersonnelService;
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

@Service
@RequiredArgsConstructor
public class NeedsAssessmentReportsService {

    private final ModelMapper modelMapper;

    private final PostDAO postDAO;
    private final JobDAO jobDAO;
    private final PostGradeDAO postGradeDAO;
    private final NeedsAssessmentDAO needsAssessmentDAO;

    private final ClassStudentReportService classStudentReportService;
    private final IPersonnelService personnelService;
    private final ParameterValueService parameterValueService;
    private final ICourseService courseService;

    @Transactional(readOnly = true)
//    @Override
    public SearchDTO.SearchRs<NeedsAssessmentReportsDTO.ReportInfo> search(SearchDTO.SearchRq request, Long objectId, String objectType, String personnelNo) {
//        getCourseNAList(request, 5679L, true);
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
            PersonnelDTO.Info student = personnelService.get(personnelNo);
            Set<Long> passedCourseIds = classStudentReportService.getPassedCourseAndEQSIdsByNationalCode(student.getNationalCode());
            Map<Long, Boolean> isPassed = passedCourseIds.stream().collect(Collectors.toMap(id -> id, id -> true));

            for (int i = 0; i < mustPass.size(); i++) {
                if (classStudentReportService.isPassed(needsAssessmentList.get(i).getSkill().getCourse(), isPassed))
                    mustPass.get(i).getSkill().getCourse().setScoresState(passedCodeId.toString());
            }
        }
        return mustPass;
    }

    @Transactional(readOnly = true)
//    @Override
    public List<NeedsAssessment> getNeedsAssessmentList(Long objectId, String objectType) {
        SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.or, new ArrayList<>());
        addCriteria(criteriaRq, objectType, objectId);
        List<NeedsAssessment> needsAssessmentList = needsAssessmentDAO.findAll(NICICOSpecification.of(criteriaRq));
        needsAssessmentList.sort(Comparator.comparingInt(a -> NeedsAssessment.priorityList.indexOf(a.getObjectType())));
        List<NeedsAssessment> withoutDuplicate = new ArrayList<>();
        needsAssessmentList.forEach(needsAssessment -> {
            if (withoutDuplicate.stream().noneMatch(wd -> wd.getSkill().equals(needsAssessment.getSkill())))
                withoutDuplicate.add(needsAssessment);
        });
        return withoutDuplicate;
    }

    @Transactional(readOnly = true)
//    @Override
    public List<NeedsAssessmentReportsDTO.CourseNAS> getCourseNAList(SearchDTO.SearchRq request, Long courseId, Boolean passedReport) {

        List<NeedsAssessmentReportsDTO.CourseNAS> result = new ArrayList<>();
        Course course = courseService.getCourse(courseId);
        List<NeedsAssessment> needsAssessments = new ArrayList<>();
        course.getSkillSet().forEach(skill -> needsAssessments.addAll(skill.getNeedsAssessments()));
        needsAssessments.sort(Comparator.comparingInt(na -> NeedsAssessment.priorityList.indexOf(na.getObjectType())));
        MultiValueMap postCodes = new MultiValueMap();
        needsAssessments.forEach(needsAssessment -> {
            switch (needsAssessment.getObjectType()) {
                case "Post":
                    if (!postCodes.containsValue(((Post) needsAssessment.getObject()).getCode()))
                        postCodes.put(needsAssessment.getNeedsAssessmentPriorityId(), ((Post) needsAssessment.getObject()).getCode());
                    break;
                case "PostGroup":
                    ((PostGroup) needsAssessment.getObject()).getPostSet().forEach(post -> {
                        if (!postCodes.containsValue(post.getCode()))
                            postCodes.put(needsAssessment.getNeedsAssessmentPriorityId(), post.getCode());
                    });
                    break;
                case "Job":
                    ((Job) needsAssessment.getObject()).getPostSet().forEach(post -> {
                        if (!postCodes.containsValue(post.getCode()))
                            postCodes.put(needsAssessment.getNeedsAssessmentPriorityId(), post.getCode());
                    });
                    break;
                case "JobGroup":
                    ((JobGroup) needsAssessment.getObject()).getJobSet().forEach(job -> job.getPostSet().forEach(post -> {
                        if (!postCodes.containsValue(post.getCode()))
                            postCodes.put(needsAssessment.getNeedsAssessmentPriorityId(), post.getCode());
                    }));
                    break;
                case "PostGrade":
                    ((PostGrade) needsAssessment.getObject()).getPostSet().forEach(post -> {
                        if (!postCodes.containsValue(post.getCode()))
                            postCodes.put(needsAssessment.getNeedsAssessmentPriorityId(), post.getCode());
                    });
                    break;
                case "PostGradeGroup":
                    ((PostGradeGroup) needsAssessment.getObject()).getPostGradeSet().forEach(postGrade -> postGrade.getPostSet().forEach(post -> {
                        if (!postCodes.containsValue(post.getCode()))
                            postCodes.put(needsAssessment.getNeedsAssessmentPriorityId(), post.getCode());
                    }));
                    break;
            }
        });

        postCodes.forEach((priority, pCodes) -> {
            SearchDTO.CriteriaRq personnelCriteria = makeNewCriteria(null, null, EOperator.and, new ArrayList<>());
            if (request.getCriteria() != null)
                personnelCriteria.getCriteria().add(request.getCriteria());
            personnelCriteria.getCriteria().add(makeNewCriteria("postCode", pCodes, EOperator.inSet, null));
            List<PersonnelDTO.Info> personnelInfoList = personnelService.search(new SearchDTO.SearchRq().setCriteria(personnelCriteria).setDistinct(true)).getList();
            NeedsAssessmentReportsDTO.CourseNAS courseNAS = new NeedsAssessmentReportsDTO.CourseNAS().setNeedsAssessmentPriorityId((Long) priority).setTotalPersonnelCount(personnelInfoList.size());
            if (passedReport) {
                personnelInfoList.forEach(p -> {
                    if (classStudentReportService.isPassed(course, p.getNationalCode()))
                        courseNAS.setPassedPersonnelCount(courseNAS.getPassedPersonnelCount() + 1);
                });
            }
            result.add(courseNAS);
        });
        return result;
    }

    @Transactional(readOnly = true)
    public void addCriteria(SearchDTO.CriteriaRq criteriaRq, String objectType, Long objectId) {
        Supplier<TrainingException> trainingExceptionSupplier = () -> new TrainingException(TrainingException.ErrorType.NotFound);
        List<SearchDTO.CriteriaRq> list = new ArrayList<>();
        list.add(makeNewCriteria("objectId", objectId, EOperator.equals, null));
        list.add(makeNewCriteria("objectType", objectType, EOperator.equals, null));
        criteriaRq.getCriteria().add(makeNewCriteria(null, null, EOperator.and, list));
        switch (objectType) {
            case "Post":
                Optional<Post> optionalPost = postDAO.findById(objectId);
                Post currentPost = optionalPost.orElseThrow(trainingExceptionSupplier);
                if (currentPost.getJob() != null)
                    addCriteria(criteriaRq, "Job", currentPost.getJob().getId());
                if (currentPost.getPostGrade() != null)
                    addCriteria(criteriaRq, "PostGrade", currentPost.getPostGrade().getId());
                currentPost.getPostGroupSet().forEach(postGroup -> addCriteria(criteriaRq, "PostGroup", postGroup.getId()));
                break;
            case "Job":
                Optional<Job> optionalJob = jobDAO.findById(objectId);
                Job currentJob = optionalJob.orElseThrow(trainingExceptionSupplier);
                currentJob.getJobGroupSet().forEach(jobGroup -> addCriteria(criteriaRq, "JobGroup", jobGroup.getId()));
                break;
            case "PostGrade":
                Optional<PostGrade> optionalPostGrade = postGradeDAO.findById(objectId);
                PostGrade currentPostGrade = optionalPostGrade.orElseThrow(trainingExceptionSupplier);
                currentPostGrade.getPostGradeGroup().forEach(postGradeGroup -> addCriteria(criteriaRq, "PostGradeGroup", postGradeGroup.getId()));
                break;
        }
    }
}
