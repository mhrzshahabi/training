package com.nicico.training.service;/*
com.nicico.training.service
@author : banifatemi
@Date : 6/8/2019
@Time :9:16 AM
    */

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.CompetenceDTO;
import com.nicico.training.dto.JobDTO;
import com.nicico.training.dto.JobGroupDTO;
import com.nicico.training.iservice.IJobGroupService;
import com.nicico.training.model.Job;
import com.nicico.training.model.JobGroup;
import com.nicico.training.repository.CompetenceDAO;
import com.nicico.training.repository.JobDAO;
import com.nicico.training.repository.JobGroupDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;

@Service
@RequiredArgsConstructor
public class JobGroupService implements IJobGroupService {


    private final ModelMapper modelMapper;
    private final JobGroupDAO jobGroupDAO;
    private final JobDAO jobDAO;
    private final CompetenceDAO competenceDAO;

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

        return save(updating, request.getJobIds());
    }

    @Transactional
    @Override
    public void delete(Long id) {
        jobGroupDAO.deleteById(id);
    }

    @Transactional
    @Override
    public void delete(JobGroupDTO.Delete request) {
        final List<JobGroup> cAllById = jobGroupDAO.findAllById(request.getIds());

        jobGroupDAO.deleteAll(cAllById);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<JobGroupDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(jobGroupDAO, request, jobGroup -> modelMapper.map(jobGroup, JobGroupDTO.Info.class));
    }

    // ------------------------------

    private JobGroupDTO.Info save(JobGroup jobGroup, Set<Long> jobIds) {
        final Set<Job> jobs = new HashSet<>();
//        final Set<Competence> competences = new HashSet<>();
        Optional.ofNullable(jobIds)
                .ifPresent(jobIdSet -> jobIdSet
                        .forEach(jobId ->
                                jobs.add(jobDAO.findById(jobId)
                                        .orElseThrow(() -> new TrainingException(TrainingException.ErrorType.JobNotFound)))
                        ));
//        Optional.ofNullable(competenceIds)
//                .ifPresent(competenceIdSet -> competenceIdSet
//                        .forEach(competenceIdss ->
//                                competences.add(competenceDAO.findById(competenceIdss)
//                                        .orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CompetenceNotFound)))
//                        ));

//        jobGroup.setCompetenceSet(competences);
        jobGroup.setJobSet(jobs);
        //final JobGroup saved = jobGroupDAO.saveAndFlush(jobGroup);
        final JobGroup saved = jobGroupDAO.save(jobGroup);
        return modelMapper.map(saved, JobGroupDTO.Info.class);
    }


    @Override
    @Transactional
    public List<CompetenceDTO.Info> getCompetence(Long jobGroupId) {
        final Optional<JobGroup> optionalJobGroup = jobGroupDAO.findById(jobGroupId);
        final JobGroup jobGroup = optionalJobGroup.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.JobGroupNotFound));

//        return modelMapper.map(jobGroup.getCompetenceSet(), new TypeToken<List<CompetenceDTO.Info>>() {}.getType());
        return null;
    }

    @Override
    @Transactional
    public List<JobDTO.Info> getJobs(Long jobGroupID) {
//        final Optional<JobGroup> optionalJobGroup = jobGroupDAO.findById(jobGroupID);
//        final JobGroup jobGroup = optionalJobGroup.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.JobGroupNotFound));
//        Set<Competence> competenceSet = jobGroup.getCompetenceSet();
//        Set<Job> jobs = new HashSet<>();
//      --------------------------------------- By f.ghazanfari - start ---------------------------------------
//        for (Competence competence:jobGroup.getCompetenceSet()
//             ) {
//
//            for (JobCompetence jobCompetence:competence.getJobCompetenceSet()
//                 ) {
//                jobs.add(jobCompetence.getJob());
//
//            }
//        }
//      --------------------------------------- By f.ghazanfari - end ---------------------------------------
//        return modelMapper.map(jobs, new TypeToken<List<JobDTO.Info>>() {}.getType());
        return null;
    }

    @Override
    @Transactional
    public boolean canDelete(Long jobGroupId) {
        List<CompetenceDTO.Info> competences = getCompetence(jobGroupId);
        if (competences.isEmpty() || competences.size() == 0)
            return true;
        else
            return false;
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
    public void removeFromCompetency(Long jobGroupId, Long competenceId) {

//        Optional<JobGroup> optionalJobGroup = jobGroupDAO.findById(jobGroupId);
//        final JobGroup jobGroup = optionalJobGroup.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.JobGroupNotFound));
//        final Optional<Competence> optionalCompetence = competenceDAO.findById(competenceId);
//        final Competence competence = optionalCompetence.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CompetenceNotFound));
//        jobGroup.getCompetenceSet().remove(competence);
    }

    @Override
    @Transactional
    public void removeFromAllCompetences(Long jobGroupId) {

//        Optional<JobGroup> optionalJobGroup = jobGroupDAO.findById(jobGroupId);
//        final JobGroup jobGroup = optionalJobGroup.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.JobGroupNotFound));
//        jobGroup.getCompetenceSet().clear();

    }

    @Override
    @Transactional
    public Set<JobDTO.Info> unAttachJobs(Long jobGroupId) {
        final Optional<JobGroup> optionalJobGroup = jobGroupDAO.findById(jobGroupId);
        final JobGroup jobGroup = optionalJobGroup.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.JobGroupNotFound));

        Set<Job> activeJobs = jobGroup.getJobSet();
        List<Job> allJobs = jobDAO.findAll();
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
