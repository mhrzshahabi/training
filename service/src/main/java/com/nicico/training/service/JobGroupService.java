package com.nicico.training.service;/*
com.nicico.training.service
@author : banifatemi
@Date : 6/8/2019
@Time :9:16 AM
    */

import com.nicico.copper.common.domain.criteria.NICICOSpecification;
import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.core.SecurityUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.JobDTO;
import com.nicico.training.dto.JobGroupDTO;
import com.nicico.training.iservice.IJobGroupService;
import com.nicico.training.iservice.IWorkGroupService;
import com.nicico.training.model.Job;
import com.nicico.training.model.JobGroup;
import com.nicico.training.model.NeedsAssessmentWithGap;
import com.nicico.training.repository.JobDAO;
import com.nicico.training.repository.JobGroupDAO;
import com.nicico.training.repository.NeedsAssessmentWithGapDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

import static com.nicico.training.service.BaseService.setCriteria;
import static com.nicico.training.service.NeedsAssessmentTempService.getCriteria;

@Service
@RequiredArgsConstructor
public class JobGroupService implements IJobGroupService {


    private final ModelMapper modelMapper;
    private final JobGroupDAO jobGroupDAO;
    private final JobDAO jobDAO;
    private final IWorkGroupService workGroupService;
    private final NeedsAssessmentTempService needsAssessmentTempService;
    private final NeedsAssessmentService needsAssessmentService;
    private final NeedsAssessmentWithGapDAO needsAssessmentWithGapDAO;

    @Transactional(readOnly = true)
    @Override
    public JobGroupDTO.Info get(Long id) {

        final Optional<JobGroup> cById = jobGroupDAO.findById(id);
        final JobGroup jobGroup = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.JobGroupNotFound));

        return modelMapper.map(jobGroup, JobGroupDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public List<JobGroupDTO.Info> list() {
        final List<JobGroup> cAll = jobGroupDAO.findAll();
        return modelMapper.map(cAll, new TypeToken<List<JobGroupDTO.Info>>() {
        }.getType());
    }

    @Transactional(readOnly = true)
    @Override
    public List<JobGroupDTO.Tuple> listTuple() {
        final List<JobGroup> cAll = jobGroupDAO.findAll();
        return modelMapper.map(cAll, new TypeToken<List<JobGroupDTO.Tuple>>() {
        }.getType());
    }

    @Transactional
    @Override
    public JobGroupDTO.Info create(JobGroupDTO.Create request) {
        final JobGroup jobGroup = modelMapper.map(request, JobGroup.class);

        return save(jobGroup, request.getJobIds());
    }

    @Transactional
    @Override
    public void addJob(Long jobId, Long jobGroupId) {
        final Optional<JobGroup> jobGroupById = jobGroupDAO.findById(jobGroupId);
        final JobGroup jobGroup = jobGroupById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.JobGroupNotFound));

        final Optional<Job> jobById = jobDAO.findById(jobId);
        final Job job = jobById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.JobNotFound));
        jobGroup.getJobSet().add(job);
    }


    @Transactional
    @Override
    public void addJobs(Long jobGroupId, Set<Long> jobIds) {

        final Optional<JobGroup> jobGroupById = jobGroupDAO.findById(jobGroupId);
        final JobGroup jobGroup = jobGroupById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.JobGroupNotFound));

        Set<Job> jobSet = jobGroup.getJobSet();

        for (Long jobId : jobIds) {

            final Optional<Job> optionalJob = jobDAO.findById(jobId);
            final Job job = optionalJob.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.JobNotFound));
            jobSet.add(job);
        }
        jobGroup.setJobSet(jobSet);
    }


    @Transactional
    @Override
    public JobGroupDTO.Info update(Long id, JobGroupDTO.Update request) {
        final Optional<JobGroup> cById = jobGroupDAO.findById(id);
        final JobGroup jobGroup = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.JobGroupNotFound));

        JobGroup updating = new JobGroup();
        modelMapper.map(jobGroup, updating);
        modelMapper.map(request, updating);
        return modelMapper.map(jobGroupDAO.saveAndFlush(updating), JobGroupDTO.Info.class);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        if (needsAssessmentService.checkBeforeDeleteObject("JobGroup", id) &&
                needsAssessmentTempService.checkBeforeDeleteObject("JobGroup", id) &&
                checkGapBeforeDeleteObject( id))
            jobGroupDAO.deleteById(id);
        else
            throw new TrainingException(TrainingException.ErrorType.NotDeletable);
    }

    private boolean checkGapBeforeDeleteObject( Long id) {
        List<NeedsAssessmentWithGap> needsAssessments = needsAssessmentWithGapDAO.findAll(NICICOSpecification.of(getCriteria("JobGroup", id, true)));
        if (needsAssessments == null || needsAssessments.isEmpty())
            return true;
        if (needsAssessments.get(0).getMainWorkflowStatusCode() == null) {
            needsAssessmentWithGapDAO.deleteAllByObjectIdAndObjectType(id, "JobGroup");
            return true;
        }
        return false;
    }

    @Transactional
    @Override
    public void delete(JobGroupDTO.Delete request) {
        request.getIds().forEach(id -> delete(id));
//        final List<JobGroup> cAllById = jobGroupDAO.findAllById(request.getIds());
//        jobGroupDAO.deleteAll(cAllById);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<JobGroupDTO.Info> search(SearchDTO.SearchRq request) {
        setCriteria(request, workGroupService.applyPermissions(JobGroup.class, SecurityUtil.getUserId()));
        return SearchUtil.search(jobGroupDAO, request, jobGroup -> modelMapper.map(jobGroup, JobGroupDTO.Info.class));
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<JobGroupDTO.Info> searchWithoutPermission(SearchDTO.SearchRq request) {
        return SearchUtil.search(jobGroupDAO, request, jobGroup -> modelMapper.map(jobGroup, JobGroupDTO.Info.class));
    }

    // ------------------------------

    private JobGroupDTO.Info save(JobGroup jobGroup, Set<Long> jobIds) {
        final Set<Job> jobs = new HashSet<>();
        Optional.ofNullable(jobIds)
                .ifPresent(jobIdSet -> jobIdSet
                        .forEach(jobId ->
                                jobs.add(jobDAO.findById(jobId)
                                        .orElseThrow(() -> new TrainingException(TrainingException.ErrorType.JobNotFound)))
                        ));
        jobGroup.setJobSet(jobs);
        final JobGroup saved = jobGroupDAO.save(jobGroup);
        return modelMapper.map(saved, JobGroupDTO.Info.class);
    }


    @Override
    @Transactional
    public List<JobDTO.Info> getJobs(Long jobGroupID) {
        final Optional<JobGroup> optionalJobGroup = jobGroupDAO.findById(jobGroupID);
        final JobGroup jobGroup = optionalJobGroup.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.JobGroupNotFound));
        return modelMapper.map(jobGroup.getJobSet().stream().filter(job -> job.getDeleted() == null).collect(Collectors.toList()), new TypeToken<List<JobDTO.Info>>() {
        }.getType());
    }


    @Override
    @Transactional(readOnly = true)
    public List<JobGroup> getPostGradeGroupsByJobId(Long id) {
        List<Long> ids = jobGroupDAO.getPostGradeGroupsByJobId(id);
        return jobGroupDAO.findAllById(ids);
    }

    @Override
    @Transactional
    public void removeJob(Long jobGroupId, Long jobId) {
        Optional<JobGroup> optionalJobGroup = jobGroupDAO.findById(jobGroupId);
        final JobGroup jobGroup = optionalJobGroup.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.JobGroupNotFound));
        final Optional<Job> optionalJob = jobDAO.findById(jobId);
        final Job job = optionalJob.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.JobNotFound));
        jobGroup.getJobSet().remove(job);
    }

    @Override
    @Transactional
    public Set<JobDTO.Info> unAttachJobs(Long jobGroupId) {
        final Optional<JobGroup> optionalJobGroup = jobGroupDAO.findById(jobGroupId);
        final JobGroup jobGroup = optionalJobGroup.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.JobGroupNotFound));

        Set<Job> activeJobs = jobGroup.getJobSet();
        SearchDTO.SearchRq searchRq = new SearchDTO.SearchRq();
        BaseService.setCriteriaToNotSearchDeleted(searchRq);
        List<Job> allJobs = jobDAO.findAll(NICICOSpecification.of(searchRq));
        Set<Job> unAttachJobs = new HashSet<>();

        for (Job job : allJobs) {
            if (!activeJobs.contains(job))
                unAttachJobs.add(job);
        }

        Set<JobDTO.Info> jobInfoSet = new HashSet<>();
        Optional.ofNullable(unAttachJobs)
                .ifPresent(jobs1 ->
                        jobs1.forEach(job1 ->
                                jobInfoSet.add(modelMapper.map(job1, JobDTO.Info.class))
                        ));

        return jobInfoSet;

    }

    @Override
    @Transactional
    public void removeJobs(Long jobGroupId, Set<Long> jobIds) {
        for (long jobId : jobIds) {
            removeJob(jobGroupId, jobId);
        }
    }

//    @Override
//    @Transactional
//    public List<JobDTO.Info> getJobs(Long jobGroupId) {
//        final Optional<JobGroup> optionalJobGroup = jobGroupDAO.findById(jobGroupId);
//        final JobGroup jobGroup = optionalJobGroup.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.JobGroupNotFound));
//        return modelMapper.map(jobGroup.getJobSet(), new TypeToken<List<JobDTO.Info>>() {
//        }.getType());
//    }
}
