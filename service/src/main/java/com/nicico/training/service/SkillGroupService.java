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
import com.nicico.training.dto.SkillDTO;
import com.nicico.training.dto.SkillGroupDTO;
import com.nicico.training.iservice.ISkillGroupService;
import com.nicico.training.model.Competence;
import com.nicico.training.model.Job;
import com.nicico.training.model.Skill;
import com.nicico.training.model.SkillGroup;
import com.nicico.training.repository.CompetenceDAO;
import com.nicico.training.repository.SkillDAO;
import com.nicico.training.repository.SkillGroupDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;

//import java.util.Set;

@Service
@RequiredArgsConstructor
public class SkillGroupService implements ISkillGroupService {


    private final ModelMapper modelMapper;
    private final SkillGroupDAO skillGroupDAO;
    private final SkillDAO skillDAO;
    private final CompetenceDAO competenceDAO;

    @Transactional(readOnly = true)
    @Override
    public SkillGroupDTO.Info get(Long id) {

        final Optional<SkillGroup> cById = skillGroupDAO.findById(id);
        final SkillGroup skillGroup = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.EquipmentNotFound));

        return modelMapper.map(skillGroup, SkillGroupDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public List<SkillGroupDTO.Info> list() {
        final List<SkillGroup> cAll = skillGroupDAO.findAll();

        return modelMapper.map(cAll, new TypeToken<List<SkillGroupDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public SkillGroupDTO.Info create(SkillGroupDTO.Create request) {
        final SkillGroup skillGroup = modelMapper.map(request, SkillGroup.class);

        return save(skillGroup, request.getCompetenceIds(), request.getSkillIds());
    }

    @Transactional
    @Override
    public void addSkill(Long skillId, Long skillGroupId) {
        final Optional<SkillGroup> skillGroupById = skillGroupDAO.findById(skillGroupId);
        final SkillGroup skillGroup = skillGroupById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillGroupNotFound));

        final Optional<Skill> skillById = skillDAO.findById(skillId);
        final Skill skill = skillById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillNotFound));
        skillGroup.getSkillSet().add(skill);
    }


    @Transactional
    @Override
    public void addSkills(Long skillGroupId, Set<Long> skillIds) {

        final Optional<SkillGroup> skillGroupById = skillGroupDAO.findById(skillGroupId);
        final SkillGroup skillGroup = skillGroupById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillGroupNotFound));

        Set<Skill> skillSet = skillGroup.getSkillSet();

        for (Long skillId : skillIds) {

            final Optional<Skill> optionalSkill = skillDAO.findById(skillId);
            final Skill skill = optionalSkill.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillNotFound));
            skillSet.add(skill);
        }
        skillGroup.setSkillSet(skillSet);
    }


    @Transactional
    @Override
    public SkillGroupDTO.Info update(Long id, SkillGroupDTO.Update request) {
        final Optional<SkillGroup> cById = skillGroupDAO.findById(id);
        final SkillGroup skillGroup = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillGroupNotFound));

        SkillGroup updating = new SkillGroup();
        modelMapper.map(skillGroup, updating);
        modelMapper.map(request, updating);

        return save(updating, request.getCompetenceIds(), request.getSkillIds());
    }

    @Transactional
    @Override
    public void delete(Long id) {
        skillGroupDAO.deleteById(id);
    }

    @Transactional
    @Override
    public void delete(SkillGroupDTO.Delete request) {
        final List<SkillGroup> cAllById = skillGroupDAO.findAllById(request.getIds());

        skillGroupDAO.deleteAll(cAllById);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<SkillGroupDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(skillGroupDAO, request, skillGroup -> modelMapper.map(skillGroup, SkillGroupDTO.Info.class));
    }

    // ------------------------------

    private SkillGroupDTO.Info save(SkillGroup skillGroup, Set<Long> competenceIds, Set<Long> skillIds) {
        final Set<Skill> skills = new HashSet<>();
        final Set<Competence> competences = new HashSet<>();
        Optional.ofNullable(skillIds)
                .ifPresent(skillIdSet -> skillIdSet
                        .forEach(skillIdss ->
                                skills.add(skillDAO.findById(skillIdss)
                                        .orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillNotFound)))
                        ));
        Optional.ofNullable(competenceIds)
                .ifPresent(competenceIdSet -> competenceIdSet
                        .forEach(competenceIdss ->
                                competences.add(competenceDAO.findById(competenceIdss)
                                        .orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CompetenceNotFound)))
                        ));

        skillGroup.setCompetenceSet(competences);
        skillGroup.setSkillSet(skills);
        //final SkillGroup saved = skillGroupDAO.saveAndFlush(skillGroup);
        final SkillGroup saved = skillGroupDAO.save(skillGroup);

        return modelMapper.map(saved, SkillGroupDTO.Info.class);
    }


    @Override
    @Transactional
    public List<CompetenceDTO.Info> getCompetence(Long skillGroupId) {
        final Optional<SkillGroup> optionalSkillGroup = skillGroupDAO.findById(skillGroupId);
        final SkillGroup skillGroup = optionalSkillGroup.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillGroupNotFound));

        return modelMapper.map(skillGroup.getCompetenceSet(), new TypeToken<List<CompetenceDTO.Info>>() {
        }.getType());
    }

    @Override
    @Transactional
    public List<JobDTO.Info> getJobs(Long skillGroupID) {
        final Optional<SkillGroup> optionalSkillGroup = skillGroupDAO.findById(skillGroupID);
        final SkillGroup skillGroup = optionalSkillGroup.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillGroupNotFound));
        Set<Competence> competenceSet = skillGroup.getCompetenceSet();
        Set<Job> jobs = new HashSet<>();
//      --------------------------------------- By f.ghazanfari - start ---------------------------------------
//        for (Competence competence:skillGroup.getCompetenceSet()
//             ) {
//
//            for (JobCompetence jobCompetence:competence.getJobCompetenceSet()
//                 ) {
//                jobs.add(jobCompetence.getJob());
//
//            }
//        }
//      --------------------------------------- By f.ghazanfari - end ---------------------------------------
        return modelMapper.map(jobs, new TypeToken<List<JobDTO.Info>>() {
        }.getType());
    }

    @Override
    @Transactional
    public boolean canDelete(Long skillGroupId) {
        List<CompetenceDTO.Info> competences = getCompetence(skillGroupId);
        if (competences.isEmpty() || competences.size() == 0)
            return true;
        else
            return false;
    }

    @Override
    @Transactional
    public void removeSkill(Long skillGroupId, Long skillId) {
        Optional<SkillGroup> optionalSkillGroup = skillGroupDAO.findById(skillGroupId);
        final SkillGroup skillGroup = optionalSkillGroup.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillGroupNotFound));
        final Optional<Skill> optionalSkill = skillDAO.findById(skillId);
        final Skill skill = optionalSkill.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillNotFound));
        skillGroup.getSkillSet().remove(skill);
    }

    @Override
    @Transactional
    public void removeFromCompetency(Long skillGroupId, Long competenceId) {

        Optional<SkillGroup> optionalSkillGroup = skillGroupDAO.findById(skillGroupId);
        final SkillGroup skillGroup = optionalSkillGroup.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillGroupNotFound));
        final Optional<Competence> optionalCompetence = competenceDAO.findById(competenceId);
        final Competence competence = optionalCompetence.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CompetenceNotFound));
        skillGroup.getCompetenceSet().remove(competence);
    }

    @Override
    @Transactional
    public void removeFromAllCompetences(Long skillGroupId) {

        Optional<SkillGroup> optionalSkillGroup = skillGroupDAO.findById(skillGroupId);
        final SkillGroup skillGroup = optionalSkillGroup.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillGroupNotFound));
        skillGroup.getCompetenceSet().clear();

    }

    @Override
    @Transactional
    public Set<SkillDTO.Info> unAttachSkills(Long skillGroupId) {
        final Optional<SkillGroup> optionalSkillGroup = skillGroupDAO.findById(skillGroupId);
        final SkillGroup skillGroup = optionalSkillGroup.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillGroupNotFound));

        Set<Skill> activeSkills = skillGroup.getSkillSet();
        List<Skill> allSkills = skillDAO.findAll();
        Set<Skill> unAttachSkills = new HashSet<>();

        for (Skill skill : allSkills) {
            if (!activeSkills.contains(skill))
                unAttachSkills.add(skill);
        }

        Set<SkillDTO.Info> skillInfoSet = new HashSet<>();
        Optional.ofNullable(unAttachSkills)
                .ifPresent(skills1 ->
                        skills1.forEach(skill1 ->
                                skillInfoSet.add(modelMapper.map(skill1, SkillDTO.Info.class))
                        ));

        return skillInfoSet;

    }

    @Override
    @Transactional
    public void removeSkills(Long skillGroupId, Set<Long> skillIds) {
        for (long skillId : skillIds) {
            removeSkill(skillGroupId, skillId);
        }
    }

    @Override
    @Transactional
    public List<SkillDTO.Info> getSkills(Long skillGroupId) {
        final Optional<SkillGroup> optionalSkillGroup = skillGroupDAO.findById(skillGroupId);
        final SkillGroup skillGroup = optionalSkillGroup.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillGroupNotFound));
        return modelMapper.map(skillGroup.getSkillSet(), new TypeToken<List<SkillDTO.Info>>() {
        }.getType());
    }
}
