package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.NICICOSpecification;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.model.*;
import com.nicico.training.repository.JobDAO;
import com.nicico.training.repository.NeedAssessmentSkillBasedDAO;
import com.nicico.training.repository.PostDAO;
import com.nicico.training.repository.PostGradeDAO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;
import java.util.function.Supplier;
import java.util.stream.Collectors;

import static com.nicico.training.service.BaseService.makeNewCriteria;

@Service
@RequiredArgsConstructor
public class NeedsAssessmentReportsService {


    private final PostDAO postDAO;
    private final JobDAO jobDAO;
    private final PostGradeDAO postGradeDAO;
    private final NeedAssessmentSkillBasedDAO needsAssessmentDAO;

    @Transactional(readOnly = true)
//    @Override
    public List<Course> getCoursesByPostId(Long postId) {
        return getNeedsAssessmentByPostId(postId).stream().map(NA -> NA.getSkill().getCourse()).collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
//    @Override
    public List<NeedAssessmentSkillBased> getNeedsAssessmentByPostId(Long postId) {
//        SearchDTO.CriteriaRq criteriaRq = makeNewCriteria(null, null, EOperator.or, new ArrayList<>());
//        addCriteria(criteriaRq, "Post", postId);
//        List<NeedAssessmentSkillBased> needsAssessmentList = needsAssessmentDAO.findAll(NICICOSpecification.of(criteriaRq));
//        needsAssessmentList.sort(Comparator.comparingInt(a -> NeedAssessmentSkillBased.priorityList.indexOf(a.getObjectType())));
//        List<NeedAssessmentSkillBased> withoutDuplicate = new ArrayList<>();
//        needsAssessmentList.forEach(needsAssessment -> {
//            if (withoutDuplicate.stream().noneMatch(wd -> wd.getSkill().equals(needsAssessment.getSkill())))
//                withoutDuplicate.add(needsAssessment);
//        });
//        return withoutDuplicate;

        return null;
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
