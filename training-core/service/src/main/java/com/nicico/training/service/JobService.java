package com.nicico.training.service;

/*
AUTHOR: ghazanfari_f
DATE: 6/8/2019
TIME: 7:49 AM
*/

import com.nicico.copper.core.domain.criteria.SearchUtil;
import com.nicico.copper.core.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.JobCompetenceDTO;
import com.nicico.training.dto.JobDTO;
import com.nicico.training.iservice.IJobService;
import com.nicico.training.model.Job;
import com.nicico.training.repository.CompetenceDAO;
import com.nicico.training.repository.JobDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class JobService implements IJobService {

    private final JobDAO jobDAO;
    private final CompetenceDAO competenceDAO;
    private final ModelMapper mapper;

    @Transactional(readOnly = true)
    @Override
    public JobDTO.Info get(Long id) {
        final Optional<Job> optionalJob = jobDAO.findById(id);
        final Job job = optionalJob.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.JobNotFound));
        return mapper.map(job, JobDTO.Info.class);
    }

    @Transactional
    @Override
    public List<JobDTO.Info> list() {
        List<Job> jobList = jobDAO.findAll();
        return mapper.map(jobList, new TypeToken<List<JobDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public JobDTO.Info create(JobDTO.Create request) {
        Job job = mapper.map(request, Job.class);
        return mapper.map(jobDAO.saveAndFlush(job), JobDTO.Info.class);
    }

    @Transactional
    @Override
    public JobDTO.Info update(Long id, JobDTO.Update request) {
        Optional<Job> optionalJob = jobDAO.findById(id);
        Job currentJob = optionalJob.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.JobNotFound));

        Job job = new Job();
        mapper.map(currentJob, job);
        mapper.map(request, job);

        return mapper.map(jobDAO.saveAndFlush(job), JobDTO.Info.class);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        jobDAO.deleteById(id);
    }

    @Transactional
    @Override
    public void delete(JobDTO.Delete request) {
        final List<Job> jobList = jobDAO.findAllById(request.getIds());
        jobDAO.deleteAll(jobList);
    }

    @Override
    public SearchDTO.SearchRs<JobDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(jobDAO, request, job -> mapper.map(job, JobDTO.Info.class));
    }

    @Transactional(readOnly = true)
    @Override
    public List<JobCompetenceDTO.Info> getJobCompetence(Long jobId) {
        final Optional<Job> optionalJob = jobDAO.findById(jobId);
        final Job job = optionalJob.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.JobNotFound));

        List<JobCompetenceDTO.Info> list = new ArrayList<>();
        Optional.ofNullable(job.getJobCompetenceSet())
                .ifPresent(t ->
                        t.forEach(jobCompetence ->
                                list.add(mapper.map(jobCompetence, JobCompetenceDTO.Info.class))
                        ));
        return list;
    }

     @Transactional(readOnly = true)
    @Override
    public List<JobDTO.Info> getOtherJobs(Long competenceId) {
        final List<Job> jobList = jobDAO.findOtherJobsForCompetence(competenceId);
        return mapper.map(jobList, new TypeToken<List<JobDTO.Info>>() {
        }.getType());
    }

}
