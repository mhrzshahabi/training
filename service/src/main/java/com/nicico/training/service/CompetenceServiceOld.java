package com.nicico.training.service;

/*
AUTHOR: ghazanfari_f
DATE: 6/8/2019
TIME: 12:22 PM
*/

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.ICompetenceServiceOld;
import com.nicico.training.model.*;
import com.nicico.training.model.enums.EnumsConverter;
import com.nicico.training.repository.CompetenceDAOOld;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;


@Service
@RequiredArgsConstructor
public class CompetenceServiceOld implements ICompetenceServiceOld {

    private final CompetenceDAOOld competenceDAO;
    private final ModelMapper mapper;
    private final EnumsConverter.ETechnicalTypeConverter eTechnicalTypeConverter = new EnumsConverter.ETechnicalTypeConverter();
    private final EnumsConverter.ECompetenceInputTypeConverter eCompetenceInputTypeConverter = new EnumsConverter.ECompetenceInputTypeConverter();

    @Transactional(readOnly = true)
    @Override
    public CompetenceDTOOld.Info get(Long id) {

        final Optional<CompetenceOld> optionalCompetence = competenceDAO.findById(id);
        final CompetenceOld competence = optionalCompetence.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CompetenceNotFound));
        return mapper.map(competence, CompetenceDTOOld.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public List<CompetenceDTOOld.Info> list() {
        List<CompetenceOld> competenceList = competenceDAO.findAll();
        return mapper.map(competenceList, new TypeToken<List<CompetenceDTOOld.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public CompetenceDTOOld.Info create(CompetenceDTOOld.Create request) {
        CompetenceOld competence = mapper.map(request, CompetenceOld.class);
        competence.setETechnicalType(eTechnicalTypeConverter.convertToEntityAttribute(request.getETechnicalTypeId()));
        competence.setECompetenceInputType(eCompetenceInputTypeConverter.convertToEntityAttribute(request.getECompetenceInputTypeId()));
        return mapper.map(competenceDAO.saveAndFlush(competence), CompetenceDTOOld.Info.class);
    }

    @Transactional
    @Override
    public CompetenceDTOOld.Info update(Long id, CompetenceDTOOld.Update request) {
        Optional<CompetenceOld> optionalCompetence = competenceDAO.findById(id);
        CompetenceOld currentCompetence = optionalCompetence.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CompetenceNotFound));

        CompetenceOld competence = new CompetenceOld();
        mapper.map(currentCompetence, competence);
        mapper.map(request, competence);
        competence.setETechnicalType(eTechnicalTypeConverter.convertToEntityAttribute(request.getETechnicalTypeId()));
        competence.setECompetenceInputType(eCompetenceInputTypeConverter.convertToEntityAttribute(request.getECompetenceInputTypeId()));
        return mapper.map(competenceDAO.saveAndFlush(competence), CompetenceDTOOld.Info.class);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        competenceDAO.deleteById(id);
    }

    @Transactional
    @Override
    public void delete(CompetenceDTOOld.Delete request) {
        final List<CompetenceOld> competenceList = competenceDAO.findAllById(request.getIds());
        competenceDAO.deleteAll(competenceList);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<CompetenceDTOOld.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(competenceDAO, request, competence -> mapper.map(competence, CompetenceDTOOld.Info.class));
    }

    @Transactional(readOnly = true)
    @Override
    public List<CompetenceDTOOld.Info> getOtherCompetence(Long jobId) {
        final List<CompetenceOld> competenceList = competenceDAO.findOtherCompetencesForJob(jobId);
        return mapper.map(competenceList, new TypeToken<List<CompetenceDTOOld.Info>>() {
        }.getType());
    }

    @Transactional(readOnly = true)
    @Override
    public List<JobCompetenceDTO.Info> getJobCompetence(Long competenceId) {
        final Optional<CompetenceOld> optionalCompetence = competenceDAO.findById(competenceId);
        final CompetenceOld competence = optionalCompetence.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CompetenceNotFound));

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
        final Optional<CompetenceOld> optionalCompetence = competenceDAO.findById(competenceId);
        final CompetenceOld competence = optionalCompetence.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CompetenceNotFound));

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
        final Optional<CompetenceOld> optionalCompetence = competenceDAO.findById(competenceId);
        final CompetenceOld competence = optionalCompetence.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CompetenceNotFound));

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
        final Optional<CompetenceOld> optionalCompetence = competenceDAO.findById(competenceId);
        final CompetenceOld competence = optionalCompetence.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CompetenceNotFound));

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
