/*
ghazanfari_f, 8/29/2019, 11:51 AM
*/
package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.core.SecurityUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.*;
import com.nicico.training.model.*;
import com.nicico.training.repository.PostDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.function.Function;
import java.util.stream.Collectors;

import static com.nicico.training.service.BaseService.makeNewCriteria;
import static com.nicico.training.service.BaseService.setCriteria;

@Service
@RequiredArgsConstructor
public class PostService implements IPostService {

    private final PostDAO postDAO;
    private final ModelMapper modelMapper;
    private final IWorkGroupService workGroupService;
    private final IPostGroupService postGroupService;
    private final IJobService jobService;
    private final IJobGroupService jobGroupService;
    private final IPostGradeService postGradeService;
    private final IPostGradeGroupService postGradeGroupService;

    @Transactional(readOnly = true)
    @Override
    public List<PostDTO.Info> list() {
        return modelMapper.map(postDAO.findAll(), new TypeToken<List<PostDTO.Info>>() {
        }.getType());
    }

    @Transactional(readOnly = true)
    @Override
    public PostDTO.Info get(Long id) {
        return modelMapper.map(postDAO.findById(id).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound)), PostDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public Page<Post> listByJobId(Long jobId, Pageable pageable) {
        return postDAO.findAllByJobId(jobId, pageable);
    }

    @Transactional(readOnly = true)
    @Override
    public PostDTO.Info getByPostCode(String postCode) {
        Optional<Post> optionalPost = postDAO.findByCode(postCode);
        return modelMapper.map(optionalPost.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.PostNotFound)), PostDTO.Info.class);
    }

    @Override
    public boolean isPostExist(String postCode) {
        Optional<Post> optionalPost = postDAO.findByCodeAndDeleted(postCode,null);
        return optionalPost.isPresent();
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<PostDTO.Info> search(SearchDTO.SearchRq request) {
        SearchDTO.CriteriaRq postCriteria = workGroupService.applyPermissions(Post.class, SecurityUtil.getUserId());

        List<PostGroupDTO.Info> postGroups = postGroupService.search(new SearchDTO.SearchRq()).getList();
        postCriteria.getCriteria().add(makeNewCriteria("postGroupSet", postGroups.stream().map(PostGroupDTO.Info::getId).collect(Collectors.toList()), EOperator.inSet, null));

        List<JobDTO.Info> jobs = jobService.search(new SearchDTO.SearchRq()).getList();
        postCriteria.getCriteria().add(makeNewCriteria("job", jobs.stream().map(JobDTO.Info::getId).collect(Collectors.toList()), EOperator.inSet, null));

        List<PostGradeDTO.Info> PostGrades = postGradeService.search(new SearchDTO.SearchRq()).getList();
        postCriteria.getCriteria().add(makeNewCriteria("postGrade", PostGrades.stream().map(PostGradeDTO.Info::getId).collect(Collectors.toList()), EOperator.inSet, null));

        setCriteria(request, postCriteria);
        return SearchUtil.search(postDAO, request, post -> modelMapper.map(post, PostDTO.Info.class));
    }

    @Transactional(readOnly = true)
    @Override
    public <T> SearchDTO.SearchRs<T> searchWithoutPermission(SearchDTO.SearchRq request, Function converter) {
        return SearchUtil.search(postDAO, request, converter);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<PostDTO.Info> unassignedSearch(SearchDTO.SearchRq request) {
        SearchDTO.CriteriaRq unAssignedPostsCriteria = workGroupService.getUnassignedRecordsCriteria(Post.class.getName());

        SearchDTO.CriteriaRq unAssignedPostGroupsCriteria = workGroupService.getUnassignedRecordsCriteria(PostGroup.class.getName());
        List<PostGroupDTO.Info> postGroups = postGroupService.searchWithoutPermission(new SearchDTO.SearchRq().setCriteria(unAssignedPostGroupsCriteria)).getList();
        unAssignedPostGroupsCriteria = makeNewCriteria(null, null, EOperator.or, new ArrayList<>());
        unAssignedPostGroupsCriteria.getCriteria().add(makeNewCriteria("postGroupSet", null, EOperator.isNull, null));
        unAssignedPostGroupsCriteria.getCriteria().add(makeNewCriteria("postGroupSet", postGroups.stream().map(PostGroupDTO.Info::getId).collect(Collectors.toList()), EOperator.inSet, null));
        unAssignedPostsCriteria.getCriteria().add(unAssignedPostGroupsCriteria);

        SearchDTO.CriteriaRq unAssignedJobsCriteria = workGroupService.getUnassignedRecordsCriteria(Job.class.getName());

        SearchDTO.CriteriaRq unAssignedJobGroupsCriteria = workGroupService.getUnassignedRecordsCriteria(JobGroup.class.getName());
        List<JobGroupDTO.Info> jobGroups = jobGroupService.searchWithoutPermission(new SearchDTO.SearchRq().setCriteria(unAssignedJobGroupsCriteria)).getList();
        unAssignedJobGroupsCriteria = makeNewCriteria(null, null, EOperator.or, new ArrayList<>());
        unAssignedJobGroupsCriteria.getCriteria().add(makeNewCriteria("jobGroupSet", null, EOperator.isNull, null));
        unAssignedJobGroupsCriteria.getCriteria().add(makeNewCriteria("jobGroupSet", jobGroups.stream().map(JobGroupDTO.Info::getId).collect(Collectors.toList()), EOperator.inSet, null));
        unAssignedJobsCriteria.getCriteria().add(unAssignedJobGroupsCriteria);

        List<JobDTO.Info> jobs = jobService.searchWithoutPermission(new SearchDTO.SearchRq().setCriteria(unAssignedJobsCriteria)).getList();
        unAssignedJobsCriteria = makeNewCriteria(null, null, EOperator.or, new ArrayList<>());
        unAssignedJobsCriteria.getCriteria().add(makeNewCriteria("job", null, EOperator.isNull, null));
        unAssignedJobsCriteria.getCriteria().add(makeNewCriteria("job", jobs.stream().map(JobDTO.Info::getId).collect(Collectors.toList()), EOperator.inSet, null));
        unAssignedPostsCriteria.getCriteria().add(unAssignedJobsCriteria);

        SearchDTO.CriteriaRq unAssignedPostGradesCriteria = workGroupService.getUnassignedRecordsCriteria(PostGrade.class.getName());

        SearchDTO.CriteriaRq unAssignedPostGradeGroupsCriteria = workGroupService.getUnassignedRecordsCriteria(PostGradeGroup.class.getName());
        List<PostGradeGroupDTO.Info> postGradeGroups = postGradeGroupService.searchWithoutPermission(new SearchDTO.SearchRq().setCriteria(unAssignedPostGradeGroupsCriteria)).getList();
        unAssignedPostGradeGroupsCriteria = makeNewCriteria(null, null, EOperator.or, new ArrayList<>());
        unAssignedPostGradeGroupsCriteria.getCriteria().add(makeNewCriteria("postGradeGroup", null, EOperator.isNull, null));
        unAssignedPostGradeGroupsCriteria.getCriteria().add(makeNewCriteria("postGradeGroup", postGradeGroups.stream().map(PostGradeGroupDTO.Info::getId).collect(Collectors.toList()), EOperator.inSet, null));
        unAssignedPostGradesCriteria.getCriteria().add(unAssignedPostGradeGroupsCriteria);

        List<PostGradeDTO.Info> PostGrades = postGradeService.searchWithoutPermission(new SearchDTO.SearchRq().setCriteria(unAssignedPostGradesCriteria)).getList();
        unAssignedPostGradesCriteria = makeNewCriteria(null, null, EOperator.or, new ArrayList<>());
        unAssignedPostGradesCriteria.getCriteria().add(makeNewCriteria("postGrade", null, EOperator.isNull, null));
        unAssignedPostGradesCriteria.getCriteria().add(makeNewCriteria("postGrade", PostGrades.stream().map(PostGradeDTO.Info::getId).collect(Collectors.toList()), EOperator.inSet, null));
        unAssignedPostsCriteria.getCriteria().add(unAssignedPostGradesCriteria);

        setCriteria(request, unAssignedPostsCriteria);

        return SearchUtil.search(postDAO, request, post -> modelMapper.map(post, PostDTO.Info.class));
    }

}
