package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.NICICOSpecification;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.NeedsAssessmentReportsDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.PersonnelDTO;
import com.nicico.training.iservice.IPersonnelService;
import com.nicico.training.iservice.IPostService;
import com.nicico.training.model.*;
import com.nicico.training.repository.*;
import lombok.RequiredArgsConstructor;
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
    private final NeedAssessmentSkillBasedDAO needsAssessmentDAO;

    private final IPostService postService;
    private final ClassStudentReportService classStudentReportService;
    private final IPersonnelService personnelService;
    private final ParameterValueService parameterValueService;

    @Transactional(readOnly = true)
//    @Override
    public List<NeedsAssessmentReportsDTO.NeedsCourses> getCoursesByPostId(Long postId) {
        Long passedCodeId = parameterValueService.getId("Passed");

        PersonnelDTO.Info student = personnelService.getByPostCode(postId).get(0);

        List<NeedAssessmentSkillBased> needAssessmentSkillBases = getNeedsAssessmentByPostId(postId);
        needAssessmentSkillBases = needAssessmentSkillBases.stream().filter(NA -> NA.getSkill().getCourse() != null).collect(Collectors.toList());
        List<Course> mustTakeCourses = needAssessmentSkillBases.stream().map(NA -> NA.getSkill().getCourse()).collect(Collectors.toList());

        List<NeedsAssessmentReportsDTO.NeedsCourses> courses = modelMapper.map(mustTakeCourses, new TypeToken<List<NeedsAssessmentReportsDTO.NeedsCourses>>() {
        }.getType());

        Set<Long> passedCourseIds = classStudentReportService.getPassedCourseAndEQSIdsByNationalCode(student.getNationalCode());

        for (int i = 0; i < courses.size(); i++) {
            courses.get(i).setEneedAssessmentPriorityId(needAssessmentSkillBases.get(i).getEneedAssessmentPriorityId());
            if (classStudentReportService.isPassedCoursesOfStudentByNationalCode(mustTakeCourses.get(i), passedCourseIds))
                courses.get(i).setStatus(passedCodeId.toString());
        }
        return courses;
    }

    @Transactional(readOnly = true)
//    @Override
    public List<NeedsAssessmentReportsDTO.NeedsCourses> getCoursesByPostCode(String postCode) {
        return getCoursesByPostId(postService.getByPostCode(postCode).getId());
    }

    @Transactional(readOnly = true)
//    @Override
    public List<NeedAssessmentSkillBased> getNeedsAssessmentByPostId(Long postId) {
        SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.or, new ArrayList<>());
        addCriteria(criteriaRq, "Post", postId);
        List<NeedAssessmentSkillBased> needsAssessmentList = needsAssessmentDAO.findAll(NICICOSpecification.of(criteriaRq));
        needsAssessmentList.sort(Comparator.comparingInt(a -> NeedAssessmentSkillBased.priorityList.indexOf(a.getObjectType())));
        List<NeedAssessmentSkillBased> withoutDuplicate = new ArrayList<>();
        needsAssessmentList.forEach(needsAssessment -> {
            if (withoutDuplicate.stream().noneMatch(wd -> wd.getSkill().equals(needsAssessment.getSkill())))
                withoutDuplicate.add(needsAssessment);
        });
        return withoutDuplicate;
    }

    @Transactional(readOnly = true)
//    @Override
    public SearchDTO.SearchRs<NeedsAssessmentReportsDTO.NeedsCourses> search(SearchDTO.SearchRq request, String postCode) {
        List<NeedsAssessmentReportsDTO.NeedsCourses> courses = getCoursesByPostCode(postCode);
        SearchDTO.SearchRs<NeedsAssessmentReportsDTO.NeedsCourses> rs = new SearchDTO.SearchRs<>();
        rs.setTotalCount((long) courses.size());
        rs.setList(courses);
        return rs;
    }


    private void addCriteria(SearchDTO.CriteriaRq criteriaRq, String objectType, Long objectId) {
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
