package com.nicico.training.service;

/*
AUTHOR: ghazanfari_f
DATE: 6/8/2019
TIME: 7:49 AM
*/

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.JobCompetenceDTO;
import com.nicico.training.iservice.IJobCompetenceService;
import com.nicico.training.model.Competence;
import com.nicico.training.model.Job;
import com.nicico.training.model.JobCompetence;
import com.nicico.training.model.JobCompetenceKey;
import com.nicico.training.model.enums.EnumsConverter;
import com.nicico.training.repository.CompetenceDAO;
import com.nicico.training.repository.JobCompetenceDAO;
import com.nicico.training.repository.JobDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.Set;

@Service
@RequiredArgsConstructor
public class JobCompetenceService implements IJobCompetenceService {

    private final JobCompetenceDAO jobCompetenceDAO;
    private final JobDAO jobDAO;
    private final CompetenceDAO competenceDAO;
    private final ModelMapper mapper;
    private final EnumsConverter.EJobCompetenceTypeConverter eJobCompetenceTypeConverter = new EnumsConverter.EJobCompetenceTypeConverter();

    @Transactional(readOnly = true)
    @Override
    public JobCompetenceDTO.Info get(Long id) {
        final Optional<JobCompetence> optionalJobCompetence = jobCompetenceDAO.findById(id);
        final JobCompetence jobCompetence = optionalJobCompetence.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.JobCompetenceNotFound));
        return mapper.map(jobCompetence, JobCompetenceDTO.Info.class);
    }

    @Transactional
    @Override
    public List<JobCompetenceDTO.Info> list() {
        List<JobCompetence> jobCompetenceList = jobCompetenceDAO.findAll();
        return mapper.map(jobCompetenceList, new TypeToken<List<JobCompetenceDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public void createForJob(JobCompetenceDTO.CreateForJob request) {

        Optional<Job> optionalJob = jobDAO.findById(request.getJobId());
        Job job = optionalJob.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.JobNotFound));

        Set<Long> competenceIds = request.getCompetenceIds();
        for (Long id : competenceIds) {
            Optional<Competence> optionalCompetence = competenceDAO.findById(id);
            Competence competence = optionalCompetence.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CompetenceNotFound));
            JobCompetenceKey jobCompetenceKey = new JobCompetenceKey(job.getId(), competence.getId());

            JobCompetence jobCompetence = new JobCompetence();
            jobCompetence.setId(jobCompetenceKey);
            jobCompetence.setEJobCompetenceTypeId(request.getEJobCompetenceTypeId());
            jobCompetenceDAO.saveAndFlush(jobCompetence);
        }
    }

    @Transactional
    @Override
    public void createForCompetence(JobCompetenceDTO.CreateForCompetence request) {

        Optional<Competence> optionalCompetence = competenceDAO.findById(request.getCompetenceId());
        Competence competence = optionalCompetence.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CompetenceNotFound));

        Set<Long> jobIds = request.getJobIds();
        for (Long id : jobIds) {
            Optional<Job> optionalJob = jobDAO.findById(id);
            Job job = optionalJob.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.JobNotFound));
            JobCompetenceKey jobCompetenceKey = new JobCompetenceKey(job.getId(), competence.getId());

            JobCompetence jobCompetence = new JobCompetence();
            jobCompetence.setId(jobCompetenceKey);
            jobCompetence.setEJobCompetenceTypeId(request.getEJobCompetenceTypeId());
            jobCompetenceDAO.saveAndFlush(jobCompetence);
        }
    }

    @Transactional
    @Override
    public void update(JobCompetenceDTO.Update request) {

        Optional<Job> optionalJob = jobDAO.findById(request.getJobId());
        Job job = optionalJob.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.JobNotFound));

        Optional<Competence> optionalCompetence = competenceDAO.findById(request.getCompetenceId());
        Competence competence = optionalCompetence.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CompetenceNotFound));

        Optional<JobCompetence> optionalJobCompetence = jobCompetenceDAO.findById(new JobCompetenceKey(job.getId(), competence.getId()));
        JobCompetence jobCompetence = optionalJobCompetence.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.JobCompetenceNotFound));
        jobCompetence.setEJobCompetenceTypeId(request.getEJobCompetenceTypeId());
        jobCompetenceDAO.saveAndFlush(jobCompetence);
    }

    @Transactional
    @Override
    public void delete(Long jobId, Long competenceId) {
        Optional<Job> optionalJob = jobDAO.findById(jobId);
        Job job = optionalJob.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.JobNotFound));

        Optional<Competence> optionalCompetence = competenceDAO.findById(competenceId);
        Competence competence = optionalCompetence.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CompetenceNotFound));

        JobCompetenceKey key = new JobCompetenceKey(jobId, competenceId);
        jobCompetenceDAO.deleteById(key);
    }

    @Transactional
    @Override
    public void delete(JobCompetenceDTO.Delete request) {
        final List<JobCompetence> jobList = jobCompetenceDAO.findAllById(request.getIds());
        jobCompetenceDAO.deleteAll(jobList);
    }

    @Override
    public SearchDTO.SearchRs<JobCompetenceDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(jobCompetenceDAO, request, jobCompetence -> mapper.map(jobCompetence, JobCompetenceDTO.Info.class));
    }

}
