package com.nicico.training.service;/*
com.nicico.training.service
@author : banifatemi
@Date : 6/8/2019
@Time :9:15 AM
    */

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.core.SecurityUtil;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.ICourseService;
import com.nicico.training.iservice.ISkillGroupService;
import com.nicico.training.iservice.ISkillService;
import com.nicico.training.iservice.IWorkGroupService;
import com.nicico.training.model.*;
import com.nicico.training.repository.*;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

import static com.nicico.training.service.BaseService.makeNewCriteria;
import static com.nicico.training.service.BaseService.setCriteria;

@Service
@RequiredArgsConstructor
public class SkillService implements ISkillService {
    private final ModelMapper modelMapper;
    private final SkillDAO skillDAO;
    private final CourseDAO courseDAO;
    private final NeedAssessmentDAO needAssessmentDAO;
    private final SkillGroupDAO skillGroupDAO;
    private final SkillLevelDAO skillLevelDAO;
    private final CategoryDAO categoryDAO;
    private final SubcategoryDAO subCategoryDAO;
    private final IWorkGroupService workGroupService;
    private final ISkillGroupService skillGroupService;
    private final ICourseService courseService;
    private String saveType = "";

    @Transactional(readOnly = true)
    @Override
    public SkillDTO.Info get(Long id) {
        final Optional<Skill> ssById = skillDAO.findById(id);
        final Skill skill = ssById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillNotFound));
        return modelMapper.map(skill, SkillDTO.Info.class);
    }

    @Transactional
    @Override
    public List<SkillDTO.Info> list() {
        final List<Skill> ssAll = skillDAO.findAll();
        return modelMapper.map(ssAll, new TypeToken<List<SkillDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public List<SkillDTO.Info> listCourseIsNull() {
        final List<Skill> ssAll = skillDAO.findByCourseIsNull();
        return modelMapper.map(ssAll, new TypeToken<List<SkillDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public SkillDTO.Info create(SkillDTO.Create request) {
        final Skill skill = modelMapper.map(request, Skill.class);
        Set<Long> competences = new HashSet<Long>();
//        Long defaultCompetence=request.getDefaultCompetenceId();
//        if(defaultCompetence!=null && defaultCompetence>0){
//            competences.add(defaultCompetence);
//            request.setCompetenceIds(competences);
//        }
        saveType = "create";
        return save(skill, request.getCourseIds(), request.getSkillGroupIds());
    }

    @Transactional
    @Override
    public SkillDTO.Info update(Long id, Object request) {

        final Optional<Skill> optionalSkill = skillDAO.findById(id);
        final Skill currentSkill = optionalSkill.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillNotFound));

        SkillDTO.Update requestSkill = modelMapper.map(request, SkillDTO.Update.class);
        Skill updating = new Skill();
        modelMapper.map(currentSkill, updating);
        modelMapper.map(requestSkill, updating);
        if (!requestSkill.getCourseId().equals(currentSkill.getCourseId())) {
            updating.setCourseMainObjectiveId(null);
        }
        Skill skill = skillDAO.saveAndFlush(updating);
        if (skill.getCourseId() != null)
            courseService.updateHasSkill(skill.getCourseId(), true);
        else
            courseService.updateHasSkill(skill.getCourseId(), null);
        return modelMapper.map(skill, SkillDTO.Info.class);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        skillDAO.deleteById(id);
    }

    @Transactional
    @Override
    public void delete(SkillDTO.Delete request) {
        final List<Skill> ssAllById = skillDAO.findAllById(request.getIds());
        skillDAO.deleteAll(ssAllById);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<SkillDTO.Info> search(SearchDTO.SearchRq request) {
        SearchDTO.CriteriaRq skillCriteria = workGroupService.applyPermissions(Skill.class, SecurityUtil.getUserId());
        List<SkillGroupDTO.Info> skillGroups = skillGroupService.search(new SearchDTO.SearchRq()).getList();
        skillCriteria.getCriteria().add(makeNewCriteria("skillGroupSet", skillGroups.stream().map(SkillGroupDTO.Info::getId).collect(Collectors.toList()), EOperator.inSet, null));
        setCriteria(request, skillCriteria);
        return SearchUtil.search(skillDAO, request, skill -> modelMapper.map(skill, SkillDTO.Info.class));
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<SkillDTO.Info> searchWithoutPermission(SearchDTO.SearchRq request) {
        return SearchUtil.search(skillDAO, request, skill -> modelMapper.map(skill, SkillDTO.Info.class));
    }

    @Transactional(readOnly = true)
    @Override
    public String getMaxSkillCode(String skillCodeStart) {
        return skillDAO.findMaxSkillCode(skillCodeStart);
    }

    // ---------------

    @Transactional
    SkillDTO.Info save(Skill skill, Set<Long> courseIds, Set<Long> skillGroupIds) {
        final Set<Course> courses = new HashSet<>();
        final Set<CompetenceOld> competences = new HashSet<>();
        final Set<SkillGroup> skillGroups = new HashSet<>();

        Optional.ofNullable(courseIds)
                .ifPresent(courseIdSet -> courseIdSet
                        .forEach(courseId ->
                                courses.add(courseDAO.findById(courseId)
                                        .orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CourseNotFound)))
                        ));

        Optional.ofNullable(skillGroupIds)
                .ifPresent(skillGroupIdSet -> skillGroupIdSet
                        .forEach(skillGroupId ->
                                skillGroups.add(skillGroupDAO.findById(skillGroupId)
                                        .orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillGroupNotFound)))
                        ));

        final Optional<SkillLevel> slById = skillLevelDAO.findById(skill.getSkillLevelId());
        final SkillLevel skillLevel = slById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillLevelNotFound));

        final Optional<Category> categoryById = categoryDAO.findById(skill.getCategoryId());
        final Category category = categoryById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CategoryNotFound));

        final Optional<Subcategory> subCategoryById = subCategoryDAO.findById(skill.getSubCategoryId());
        final Subcategory subCategory = subCategoryById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SubCategoryNotFound));

        final Skill saved = skillDAO.saveAndFlush(skill);

        if (saved.getCourseId() != null)
            courseService.updateHasSkill(saved.getCourseId(), true);

        saveType = "";
        return modelMapper.map(saved, SkillDTO.Info.class);
    }

    // ------------------------------

    @Transactional(readOnly = true)
    @Override
    public CourseDTO.Info getCourses(Long skillID) {

        final Optional<Skill> optionalSkill = skillDAO.findById(skillID);
        final Skill skill = optionalSkill.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillNotFound));
        return modelMapper.map(skill.getCourse(), CourseDTO.Info.class);
    }


    @Transactional
    @Override
    public List<NeedAssessmentDTO.Info> getNeedAssessment(Long skillID) {
        final Optional<Skill> optionalSkill = skillDAO.findById(skillID);
        final Skill skill = optionalSkill.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillNotFound));
        return modelMapper.map(skill.getNeedAssessments(), new TypeToken<List<NeedAssessmentDTO.Info>>() {
        }.getType());
    }

    @Transactional(readOnly = true)
    @Override
    public List<CourseDTO.Info> getUnAttachedCourses(Long skillID, Pageable pageable) {

        final Optional<Skill> optionalSkill = skillDAO.findById(skillID);
        final Skill skill = optionalSkill.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillNotFound));


        return modelMapper.map(courseDAO.getUnAttachedCoursesBySkillId(skillID, pageable), new TypeToken<List<CourseDTO.Info>>() {
        }.getType());
    }

    @Transactional(readOnly = true)
    @Override
    public Integer getUnAttachedCoursesCount(Long skillID) {
        final Optional<Skill> optionalSkill = skillDAO.findById(skillID);
        final Skill skill = optionalSkill.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillNotFound));


        return courseDAO.getUnAttachedCoursesCountBySkillId(skillID);
    }

    @Transactional(readOnly = true)
    @Override
    public List<SkillGroupDTO.Info> getSkillGroups(Long skillID) {
        final Optional<Skill> optionalSkill = skillDAO.findById(skillID);
        final Skill skill = optionalSkill.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillNotFound));


        return modelMapper.map(skill.getSkillGroupSet(), new TypeToken<List<SkillGroupDTO.Info>>() {
        }.getType());
    }

    @Transactional(readOnly = true)
    @Override
    public List<SkillGroupDTO.Info> getUnAttachedSkillGroups(Long skillID, Pageable pageable) {
        final Optional<Skill> optionalSkill = skillDAO.findById(skillID);
        final Skill skill = optionalSkill.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillNotFound));

        return modelMapper.map(skillGroupDAO.getUnAttachedSkillGroupsBySkillId(skillID, pageable), new TypeToken<List<SkillGroupDTO.Info>>() {
        }.getType());
    }

//    @Transactional(readOnly = true)
//    @Override
//    public List<NeedAssessmentDTO.Info> getAttachedNeedAssessment(Long skillID) {
//        final Optional<Skill> optionalSkill=skillDAO.findById(skillID)  ;
//        final Skill skill=optionalSkill.orElseThrow(()-> new TrainingException(TrainingException.ErrorType.SkillNotFound));
//        return modelMapper.map( needAssessmentDAO.getNeedAssessmentsBySkillId(skillID),new TypeToken<List<NeedAssessmentDTO.Info>>(){}.getType());
//    }

    @Transactional(readOnly = true)
    @Override
    public Integer getUnAttachedSkillGroupsCount(Long skillID) {
        final Optional<Skill> optionalSkill = skillDAO.findById(skillID);
        final Skill skill = optionalSkill.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillNotFound));


        return skillGroupDAO.getUnAttachedSkillGroupsCountBySkillId(skillID);
    }

    @Transactional(readOnly = true)
    @Override
    public CategoryDTO.Info getCategory(Long skillID) {
        final Optional<Skill> optionalSkill = skillDAO.findById(skillID);
        final Skill skill = optionalSkill.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillNotFound));
        return modelMapper.map(skill.getCategory(), CategoryDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public SubcategoryDTO.Info getSubCategory(Long skillID) {
        final Optional<Skill> optionalSkill = skillDAO.findById(skillID);
        final Skill skill = optionalSkill.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillNotFound));
        return modelMapper.map(skill.getSubCategory(), SubcategoryDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public SkillLevelDTO.Info getSkillLevel(Long skillID) {
        final Optional<Skill> optionalSkill = skillDAO.findById(skillID);
        final Skill skill = optionalSkill.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillNotFound));
        return modelMapper.map(skill.getSkillLevel(), SkillLevelDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public boolean isSkillDeletable(Long skillId) {
        if (skillDAO.getSkillUsedInOther(skillId) != null)
            return true;
        return true;
    }

    @Transactional
    @Override
    public void removeSkillGroup(Long skillGroupId, Long skillId) {
        final Optional<Skill> optionalSkill = skillDAO.findById(skillId);
        final Skill skill = optionalSkill.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillNotFound));
        final Optional<SkillGroup> optionalSkillGroup = skillGroupDAO.findById(skillGroupId);
        final SkillGroup skillGroup = optionalSkillGroup.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillGroupNotFound));
        skillGroup.getSkillSet().remove(skill);
    }

    @Transactional
    @Override
    public void removeSkillGroups(List<Long> skillGroupIds, Long skillId) {
        final Optional<Skill> optionalSkill = skillDAO.findById(skillId);
        final Skill skill = optionalSkill.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillNotFound));
        List<SkillGroup> gAllById = skillGroupDAO.findAllById(skillGroupIds);
        for (SkillGroup skillGroup : gAllById) {
            skillGroup.getSkillSet().remove(skill);
        }
    }

    @Transactional
    @Override
    public void addSkillGroup(Long skillGroupId, Long skillId) {
        final Optional<Skill> optionalSkill = skillDAO.findById(skillId);
        final Skill skill = optionalSkill.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillNotFound));
        final Optional<SkillGroup> optionalSkillGroup = skillGroupDAO.findById(skillGroupId);
        final SkillGroup skillGroup = optionalSkillGroup.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillGroupNotFound));
        skillGroup.getSkillSet().add(skill);
    }

    @Transactional
    @Override
    public void addSkillGroups(List<Long> ids, Long skillId) {
        final Optional<Skill> optionalSkill = skillDAO.findById(skillId);
        final Skill skill = optionalSkill.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillNotFound));
        List<SkillGroup> gAllById = skillGroupDAO.findAllById(ids);
        for (SkillGroup skillGroup : gAllById) {
            skillGroup.getSkillSet().add(skill);
        }
    }

//    @Transactional
//    @Override
//    public void removeCompetence(Long competenceId, Long skillId) {
//        final Optional<Skill> optionalSkill=skillDAO.findById(skillId)  ;
//        final Skill skill=optionalSkill.orElseThrow(()-> new TrainingException(TrainingException.ErrorType.SkillNotFound));
//        final Optional<CompetenceOld> optionalCompetence=competenceDAO.findById(competenceId)  ;
//        final CompetenceOld competence=optionalCompetence.orElseThrow(()-> new TrainingException(TrainingException.ErrorType.CompetenceNotFound));
//        competence.getSkillSet().remove(skill);
//
//    }
//
//    @Transactional
//    @Override
//    public void removeCompetences(List<Long> competenceIds, Long skillId) {
//        final Optional<Skill> optionalSkill=skillDAO.findById(skillId)  ;
//        final Skill skill=optionalSkill.orElseThrow(()-> new TrainingException(TrainingException.ErrorType.SkillNotFound));
//        List<CompetenceOld> gAllById = competenceDAO.findAllById(competenceIds);
//        for (CompetenceOld competence : gAllById) {
//            competence.getSkillSet().remove(skill);
//        }
//
//    }
//
//    @Transactional
//    @Override
//    public void addCompetence(Long competenceId, Long skillId) {
//        final Optional<Skill> optionalSkill=skillDAO.findById(skillId)  ;
//        final Skill skill=optionalSkill.orElseThrow(()-> new TrainingException(TrainingException.ErrorType.SkillNotFound));
//        final Optional<CompetenceOld> optionalCompetence=competenceDAO.findById(competenceId)  ;
//        final CompetenceOld competence=optionalCompetence.orElseThrow(()-> new TrainingException(TrainingException.ErrorType.CompetenceNotFound));
//        competence.getSkillSet().add(skill);
//
//    }
//
//    @Transactional
//    @Override
//    public void addCompetences(List<Long> ids, Long skillId) {
//        final Optional<Skill> optionalSkill=skillDAO.findById(skillId)  ;
//        final Skill skill=optionalSkill.orElseThrow(()-> new TrainingException(TrainingException.ErrorType.SkillNotFound));
//        List<CompetenceOld> gAllById = competenceDAO.findAllById(ids);
//        for (CompetenceOld competence : gAllById) {
//            competence.getSkillSet().add(skill);
//        }
//
//    }

    @Transactional
    @Override
    public void removeCourse(Long courseId, Long skillId) {
        final Optional<Skill> optionalSkill = skillDAO.findById(skillId);
        final Skill skill = optionalSkill.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillNotFound));
        skill.setCourseId(null);
        if (Objects.equals(skill.getCourseMainObjectiveId(), courseId))
            skill.setCourseMainObjectiveId(null);
        skillDAO.saveAndFlush(skill);
        courseService.updateHasSkill(courseId, null);
    }

    @Transactional
    @Override
    public void removeCourses(List<Long> courseIds, Long skillId) {
        final Optional<Skill> optionalSkill = skillDAO.findById(skillId);
        final Skill skill = optionalSkill.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillNotFound));
        //Set<Course> courses=skill.getCourseSet();
        List<Course> courses = courseDAO.findAllById(courseIds);
        for (Course course : courses) {
            skill.setCourse(null);
            courseService.updateHasSkill(course.getId(), null);
            //courses.add(course);
        }

        // skill.setCourseSet(courses);

    }

    @Transactional
    @Override
    public void addCourse(Long courseId, Long skillId) {
        final Optional<Skill> optionalSkill = skillDAO.findById(skillId);
        final Skill skill = optionalSkill.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillNotFound));
        skill.setCourseId(courseId);
        skillDAO.save(skill);
        courseService.updateHasSkill(courseId, true);
    }


    @Transactional
    @Override
    public void addCourses(List<Long> ids, Long skillId) {
        final Optional<Skill> optionalSkill = skillDAO.findById(skillId);
        final Skill skill = optionalSkill.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillNotFound));
        List<Course> gAllById = courseDAO.findAllById(ids);
        for (Course course : gAllById) {
            skill.setCourse(course);
            courseService.updateHasSkill(course.getId(), true);
        }
    }

    @Transactional
    @Override
    public List<Skill> getAllByIds(List<Long> ids) {
        List<Skill> skills = skillDAO.findAllById(ids);
        return skills;
    }

    @Transactional(readOnly = true)
    @Override
    public List<SkillDTO> listMainObjective(Long mainObjectiveId) {
        List<Skill> skillList = skillDAO.findByCourseMainObjectiveId(mainObjectiveId);
        return modelMapper.map(skillList, new TypeToken<List<SkillDTO.InfoTuple>>() {
        }.getType());
    }

    @Transactional
    @Override
    public List<Skill> skillList(Long courseId) {
        return skillDAO.findSkillsByCourseMainObjectiveId(courseId);
    }
}
