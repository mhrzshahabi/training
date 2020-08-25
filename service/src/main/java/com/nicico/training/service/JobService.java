/*
ghazanfari_f, 8/29/2019, 11:51 AM
*/
package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.core.SecurityUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.JobDTO;
import com.nicico.training.dto.JobGroupDTO;
import com.nicico.training.dto.PostDTO;
import com.nicico.training.iservice.IJobGroupService;
import com.nicico.training.iservice.IJobService;
import com.nicico.training.iservice.IWorkGroupService;
import com.nicico.training.model.Job;
import com.nicico.training.repository.JobDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import static com.nicico.training.service.BaseService.makeNewCriteria;
import static com.nicico.training.service.BaseService.setCriteria;

@Service
@RequiredArgsConstructor
public class JobService implements IJobService {

    private final JobDAO jobDAO;
    private final ModelMapper modelMapper;
    private final IWorkGroupService workGroupService;
    private final IJobGroupService jobGroupService;

    @Transactional(readOnly = true)
    @Override
    public List<JobDTO.Info> list() {
        return modelMapper.map(jobDAO.findAll(), new TypeToken<List<JobDTO.Info>>() {
        }.getType());
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<JobDTO.Info> search(SearchDTO.SearchRq request) {
        SearchDTO.CriteriaRq jobCriteria = workGroupService.applyPermissions(Job.class, SecurityUtil.getUserId());
        List<JobGroupDTO.Info> jobGroups = jobGroupService.search(new SearchDTO.SearchRq()).getList();
        jobCriteria.getCriteria().add(makeNewCriteria("jobGroupSet", jobGroups.stream().map(JobGroupDTO.Info::getId).collect(Collectors.toList()), EOperator.inSet, null));
        setCriteria(request, jobCriteria);
        BaseService.setCriteriaToNotSearchDeleted(request);
        return SearchUtil.search(jobDAO, request, job -> modelMapper.map(job, JobDTO.Info.class));
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<JobDTO.Info> searchWithoutPermission(SearchDTO.SearchRq request) {
        return SearchUtil.search(jobDAO, request, job -> modelMapper.map(job, JobDTO.Info.class));
    }

    @Transactional(readOnly = true)
    @Override
    public TotalResponse<JobDTO.Info> search(NICICOCriteria request) {
        return SearchUtil.search(jobDAO, request, job -> modelMapper.map(job, JobDTO.Info.class));
    }

    @Override
    @Transactional(readOnly = true)
    public JobDTO.Info get(Long id) {
        final Job job = jobDAO.findById(id).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        return modelMapper.map(job, JobDTO.Info.class);
    }

    @Override
    @Transactional(readOnly = true)
    public List<PostDTO.Info> getPosts(Long jobId) {
        final Job job = jobDAO.findById(jobId).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        return modelMapper.map(job.getPostSet().stream().filter(post -> post.getDeleted() == null).collect(Collectors.toList()), new TypeToken<List<PostDTO.Info>>() {
        }.getType());
    }

    @Override
    @Transactional(readOnly = true)
    public List<PostDTO.Info> getPostsWithTrainingPost(Long jobId) {
        final Job job = jobDAO.findById(jobId).orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        List<PostDTO.Info> result = new ArrayList<>();

        job.getTrainingPostSet().stream().filter(p-> p.getDeleted() == null).collect(Collectors.toList()).forEach(p -> result.addAll(modelMapper.map(p.getPostSet().stream().filter(r->r.getDeleted() == null).collect(Collectors.toList()), new TypeToken<List<PostDTO.Info>>() {
        }.getType())));

        return result;
    }
}
