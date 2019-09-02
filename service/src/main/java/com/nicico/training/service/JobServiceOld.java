package com.nicico.training.service;

/*
AUTHOR: ghazanfari_f
DATE: 6/8/2019
TIME: 7:49 AM
*/

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.IJobServiceOld;
import com.nicico.training.model.*;
import com.nicico.training.repository.CompetenceDAO;
import com.nicico.training.repository.JobDAOOld;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Service
@RequiredArgsConstructor
public class JobServiceOld implements IJobServiceOld {

    private final JobDAOOld jobDAO;
    private final CompetenceDAO competenceDAO;
    private final ModelMapper mapper;

    @Transactional(readOnly = true)
    @Override
    public JobDTOOld.Info get(Long id) {
        final Optional<JobOld> optionalJob = jobDAO.findById(id);
        final JobOld job = optionalJob.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.JobNotFound));
        return mapper.map(job, JobDTOOld.Info.class);
    }

    @Transactional
    @Override
    public List<JobDTOOld.Info> list() {
        List<JobOld> jobList = jobDAO.findAll();
        return mapper.map(jobList, new TypeToken<List<JobDTOOld.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public JobDTOOld.Info create(JobDTOOld.Create request) {
        JobOld job = mapper.map(request, JobOld.class);
        return mapper.map(jobDAO.saveAndFlush(job), JobDTOOld.Info.class);
    }

    @Transactional
    @Override
    public JobDTOOld.Info update(Long id, JobDTOOld.Update request) {
        Optional<JobOld> optionalJob = jobDAO.findById(id);
        JobOld currentJob = optionalJob.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.JobNotFound));

        JobOld job = new JobOld();
        mapper.map(currentJob, job);
        mapper.map(request, job);

        return mapper.map(jobDAO.saveAndFlush(job), JobDTOOld.Info.class);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        jobDAO.deleteById(id);
    }

    @Transactional
    @Override
    public void delete(JobDTOOld.Delete request) {
        final List<JobOld> jobList = jobDAO.findAllById(request.getIds());
        jobDAO.deleteAll(jobList);
    }

    @Override
    public SearchDTO.SearchRs<JobDTOOld.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(jobDAO, request, job -> mapper.map(job, JobDTOOld.Info.class));
    }

    @Transactional(readOnly = true)
    @Override
    public List<JobCompetenceDTO.Info> getJobCompetence(Long jobId) {
        final Optional<JobOld> optionalJob = jobDAO.findById(jobId);
        final JobOld job = optionalJob.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.JobNotFound));

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
    public List<JobDTOOld.Info> getOtherJobs(Long competenceId) {
        final List<JobOld> jobList = jobDAO.findOtherJobsForCompetence(competenceId);
        return mapper.map(jobList, new TypeToken<List<JobDTOOld.Info>>() {
        }.getType());
    }

    @Transactional(readOnly = true)
    @Override
    public List<SkillDTO.Info> getSkills(Long jobId) {
        final Optional<JobOld> optionalJob = jobDAO.findById(jobId);
        final JobOld job = optionalJob.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.JobNotFound));

        final Set<JobCompetence> jobCompetenceSet = job.getJobCompetenceSet();
        Set<Competence> competenceSet = new HashSet<>();
        Set<Skill> skillSet = new HashSet<>();

        for (JobCompetence jobCompetence : jobCompetenceSet) {
            competenceSet.add(jobCompetence.getCompetence());
        }
        for (Competence competence : competenceSet) {
            skillSet.addAll(competence.getSkillSet());
            for (SkillGroup skillGroup : competence.getSkillGroupSet()) {
                skillSet.addAll(skillGroup.getSkillSet());
            }
        }
        return mapper.map(skillSet, new TypeToken<List<SkillDTO.Info>>() {
        }.getType());
    }

    @Transactional(readOnly = true)
    @Override
    public List<SkillGroupDTO.Info> getSkillGroups(Long jobId) {
        final Optional<JobOld> optionalJob = jobDAO.findById(jobId);
        final JobOld job = optionalJob.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.JobNotFound));

        final Set<JobCompetence> jobCompetenceSet = job.getJobCompetenceSet();
        Set<Competence> competenceSet = new HashSet<>();
        Set<SkillGroup> skillGroupSet = new HashSet<>();

        for (JobCompetence jobCompetence : jobCompetenceSet) {
            competenceSet.add(jobCompetence.getCompetence());
        }

        for (Competence competence : competenceSet) {
            skillGroupSet.addAll(competence.getSkillGroupSet());
        }
        return mapper.map(skillGroupSet, new TypeToken<List<SkillGroupDTO.Info>>() {
        }.getType());
    }

    @Transactional(readOnly = true)
    @Override
    public List<CourseDTO.Info> getCourses(Long jobId) {
        final Optional<JobOld> optionalJob = jobDAO.findById(jobId);
        final JobOld job = optionalJob.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.JobNotFound));

        final Set<JobCompetence> jobCompetenceSet = job.getJobCompetenceSet();
        Set<Competence> competenceSet = new HashSet<>();
        Set<SkillGroup> skillGroupSet = new HashSet<>();
        Set<Skill> skillSet = new HashSet<>();
        Set<Course> courseSet = new HashSet<>();

        for (JobCompetence jobCompetence : jobCompetenceSet) {
            competenceSet.add(jobCompetence.getCompetence());
        }
        for (Competence competence : competenceSet) {
            skillSet.addAll(competence.getSkillSet());
            for (SkillGroup skillGroup : competence.getSkillGroupSet()) {
                skillSet.addAll(skillGroup.getSkillSet());
            }
        }
        for (Skill skill : skillSet) {
            courseSet.addAll(skill.getCourseSet());
        }
        return mapper.map(courseSet, new TypeToken<List<CourseDTO.Info>>() {
        }.getType());
    }

}
