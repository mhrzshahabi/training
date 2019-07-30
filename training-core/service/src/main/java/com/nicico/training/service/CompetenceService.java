package com.nicico.training.service;

/*
AUTHOR: ghazanfari_f
DATE: 6/8/2019
TIME: 12:22 PM
*/

import com.nicico.copper.core.domain.criteria.SearchUtil;
import com.nicico.copper.core.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.ICompetenceService;
import com.nicico.training.model.Competence;
import com.nicico.training.model.Course;
import com.nicico.training.model.Skill;
import com.nicico.training.model.SkillGroup;
import com.nicico.training.model.enums.EnumsConverter;
import com.nicico.training.repository.CompetenceDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;


@Service
@RequiredArgsConstructor
public class CompetenceService implements ICompetenceService {

    private final CompetenceDAO competenceDAO;
    private final ModelMapper mapper;
    private final EnumsConverter.ETechnicalTypeConverter eTechnicalTypeConverter = new EnumsConverter.ETechnicalTypeConverter();
    private final EnumsConverter.ECompetenceInputTypeConverter eCompetenceInputTypeConverter = new EnumsConverter.ECompetenceInputTypeConverter();

    @Transactional(readOnly = true)
    @Override
    public CompetenceDTO.Info get(Long id) {

        final Optional<Competence> optionalCompetence = competenceDAO.findById(id);
        final Competence competence = optionalCompetence.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CompetenceNotFound));
        return mapper.map(competence, CompetenceDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public List<CompetenceDTO.Info> list() {
        List<Competence> competenceList = competenceDAO.findAll();
        return mapper.map(competenceList, new TypeToken<List<CompetenceDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public CompetenceDTO.Info create(CompetenceDTO.Create request) {
        Competence competence = mapper.map(request, Competence.class);
        competence.setETechnicalType(eTechnicalTypeConverter.convertToEntityAttribute(request.getETechnicalTypeId()));
        competence.setECompetenceInputType(eCompetenceInputTypeConverter.convertToEntityAttribute(request.getECompetenceInputTypeId()));
        return mapper.map(competenceDAO.saveAndFlush(competence), CompetenceDTO.Info.class);
    }

    @Transactional
    @Override
    public CompetenceDTO.Info update(Long id, CompetenceDTO.Update request) {
        Optional<Competence> optionalCompetence = competenceDAO.findById(id);
        Competence currentCompetence = optionalCompetence.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CompetenceNotFound));

        Competence competence = new Competence();
        mapper.map(currentCompetence, competence);
        mapper.map(request, competence);
        competence.setETechnicalType(eTechnicalTypeConverter.convertToEntityAttribute(request.getETechnicalTypeId()));
        competence.setECompetenceInputType(eCompetenceInputTypeConverter.convertToEntityAttribute(request.getECompetenceInputTypeId()));
        return mapper.map(competenceDAO.saveAndFlush(competence), CompetenceDTO.Info.class);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        competenceDAO.deleteById(id);
    }

    @Transactional
    @Override
    public void delete(CompetenceDTO.Delete request) {
        final List<Competence> competenceList = competenceDAO.findAllById(request.getIds());
        competenceDAO.deleteAll(competenceList);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<CompetenceDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(competenceDAO, request, competence -> mapper.map(competence, CompetenceDTO.Info.class));
    }

    @Transactional(readOnly = true)
    @Override
    public List<CompetenceDTO.Info> getOtherCompetence(Long jobId) {
        final List<Competence> competenceList = competenceDAO.findOtherCompetencesForJob(jobId);
        return mapper.map(competenceList, new TypeToken<List<CompetenceDTO.Info>>() {
        }.getType());
    }

    @Transactional(readOnly = true)
    @Override
    public List<JobCompetenceDTO.Info> getJobCompetence(Long competenceId) {
        final Optional<Competence> optionalCompetence = competenceDAO.findById(competenceId);
        final Competence competence = optionalCompetence.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CompetenceNotFound));

        List<JobCompetenceDTO.Info> list = new ArrayList<>();
        Optional.ofNullable(competence.getJobCompetenceSet())
                .ifPresent(t ->
                        t.forEach(jobCompetence ->
                                list.add(mapper.map(jobCompetence, JobCompetenceDTO.Info.class))
                        ));
        return list;
    }

    @Transactional(readOnly = true)
    @Override
    public List<SkillDTO.Info> getSkills(Long competenceId) {
        final Optional<Competence> optionalCompetence = competenceDAO.findById(competenceId);
        final Competence competence = optionalCompetence.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CompetenceNotFound));

        List<SkillDTO.Info> list = new ArrayList<>();
        Optional.ofNullable(competence.getSkillSet())
                .ifPresent(t ->
                        t.forEach(skill ->
                                list.add(mapper.map(skill, SkillDTO.Info.class))
                        ));
        return list;
    }

    @Transactional(readOnly = true)
    @Override
    public List<SkillGroupDTO.Info> getSkillGroups(Long competenceId) {
        final Optional<Competence> optionalCompetence = competenceDAO.findById(competenceId);
        final Competence competence = optionalCompetence.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CompetenceNotFound));

        List<SkillGroupDTO.Info> list = new ArrayList<>();
        Optional.ofNullable(competence.getSkillGroupSet())
                .ifPresent(t ->
                        t.forEach(skillGroup ->
                                list.add(mapper.map(skillGroup, SkillGroupDTO.Info.class))
                        ));
        return list;
    }

    @Transactional(readOnly = true)
    @Override
    public List<CourseDTO.Info> getCourses(Long competenceId) {
        final Optional<Competence> optionalCompetence = competenceDAO.findById(competenceId);
        final Competence competence = optionalCompetence.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CompetenceNotFound));

        Set<SkillGroup> skillGroupSet = new HashSet<>();
        Set<Skill> skillSet = new HashSet<>();
        Set<Course> courseSet = new HashSet<>();
        skillGroupSet = competence.getSkillGroupSet();
        skillSet = competence.getSkillSet();

        for (SkillGroup skillGroup : skillGroupSet) {
            skillSet.addAll(skillGroup.getSkillSet());
        }
        for (Skill skill : skillSet) {
            courseSet.addAll(skill.getCourseSet());
        }
        return mapper.map(courseSet, new TypeToken<List<CourseDTO.Info>>() {
        }.getType());
    }
}
