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
//import com.nicico.training.iservice.ISkillGroupService;
import com.nicico.training.iservice.ISkillService;
import com.nicico.training.iservice.IWorkGroupService;
import com.nicico.training.model.*;
import com.nicico.training.repository.*;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.context.support.ResourceBundleMessageSource;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
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
    private final ICourseService courseService;
    private final ResourceBundleMessageSource messageSource;

    @Transactional(readOnly = true)
    @Override
    public SkillDTO.Info get(Long id) {
        return modelMapper.map(getSkill(id), SkillDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public Skill getSkill(Long id) {
        final Optional<Skill> ssById = skillDAO.findById(id);
        return ssById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillNotFound));
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
    public SkillDTO.Info create(SkillDTO.Create request, HttpServletResponse response) {
        final Skill skill = modelMapper.map(request, Skill.class);

//        Optional.ofNullable(courseIds)
//                .ifPresent(courseIdSet -> courseIdSet
//                        .forEach(courseId ->
//                                courses.add(courseDAO.findById(courseId)
//                                        .orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CourseNotFound)))
//                        ));


//        final Optional<SkillLevel> slById = skillLevelDAO.findById(skill.getSkillLevelId());
//        final SkillLevel skillLevel = slById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillLevelNotFound));
//
//        final Optional<Category> categoryById = categoryDAO.findById(skill.getCategoryId());
//        final Category category = categoryById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CategoryNotFound));
//
//        final Optional<Subcategory> subCategoryById = subCategoryDAO.findById(skill.getSubCategoryId());
//        final Subcategory subCategory = subCategoryById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SubCategoryNotFound));

        if (skillDAO.findByTitleFaAndCategoryIdAndSubCategoryIdAndSkillLevelId(request.getTitleFa(), request.getCategoryId(), request.getSubCategoryId(), request.getSkillLevelId()) != null) {
            try {
                Locale locale = LocaleContextHolder.getLocale();
                Skill duplicateSkill1 = skillDAO.findByTitleFaAndCategoryIdAndSubCategoryIdAndSkillLevelId(request.getTitleFa(), request.getCategoryId(), request.getSubCategoryId(), request.getSkillLevelId());
                SkillDTO.Info skillinfo = modelMapper.map(duplicateSkill1, SkillDTO.Info.class);
                response.addHeader("skillCode", skillinfo.getCode());
                response.addHeader("skillName", URLEncoder.encode(skillinfo.getTitleFa(), "UTF-8"));
                response.sendError(406, messageSource.getMessage("skill.duplicate", null, locale));
                return null;
            } catch (IOException e) {
                throw new TrainingException(TrainingException.ErrorType.InvalidData);
            }
        }

        final Skill saved = skillDAO.saveAndFlush(skill);
        if (saved.getCourseId() != null)
            courseService.updateHasSkill(saved.getCourseId(), true);
        return modelMapper.map(saved, SkillDTO.Info.class);
    }

    @Transactional
    @Override
    public SkillDTO.Info update(Long id, Object request, HttpServletResponse response) {

        final Optional<Skill> optionalSkill = skillDAO.findById(id);
        final Skill currentSkill = optionalSkill.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillNotFound));
        SkillDTO.Update requestSkill = modelMapper.map(request, SkillDTO.Update.class);
        Skill skills = skillDAO.findByTitleFaAndCategoryIdAndSubCategoryIdAndSkillLevelId(requestSkill.getTitleFa(), requestSkill.getCategoryId(), requestSkill.getSubCategoryId(), requestSkill.getSkillLevelId());
        if (skills != null && skills.getId() != id) {
            try {

                Locale locale = LocaleContextHolder.getLocale();
                Skill duplicateSkill1 = skillDAO.findByTitleFaAndCategoryIdAndSubCategoryIdAndSkillLevelId(requestSkill.getTitleFa(), requestSkill.getCategoryId(), requestSkill.getSubCategoryId(), requestSkill.getSkillLevelId());
                SkillDTO.Info skillinfo = modelMapper.map(duplicateSkill1, SkillDTO.Info.class);
                response.addHeader("skillCode", skillinfo.getCode());
                response.addHeader("skillName", URLEncoder.encode(skillinfo.getTitleFa(), "UTF-8"));
                response.sendError(406, messageSource.getMessage("skill.duplicate", null, locale));
                return null;
            } catch (IOException e) {
                throw new TrainingException(TrainingException.ErrorType.InvalidData);
            }
        }
        Skill updating = new Skill();
        modelMapper.map(currentSkill, updating);
        modelMapper.map(requestSkill, updating);
        if (requestSkill.getCourseId() == null || !requestSkill.getCourseId().equals(currentSkill.getCourseId())) {
            updating.setCourseMainObjectiveId(null);
        }
        Skill skill = skillDAO.saveAndFlush(updating);
        if (skill.getCourseId() != null)
            courseService.updateHasSkill(skill.getCourseId(), true);
        else if (currentSkill.getCourseId() != null)
            courseService.updateHasSkill(currentSkill.getCourseId(), null);
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
    public SearchDTO.SearchRs<SkillDTO.Info> searchWithoutPermission(SearchDTO.SearchRq request) {
        return SearchUtil.search(skillDAO, request, skill -> modelMapper.map(skill, SkillDTO.Info.class));
    }

    @Transactional(readOnly = true)
//    @Override
    public <T> SearchDTO.SearchRs<T> searchGeneric(SearchDTO.SearchRq request, Class<T> infoType) {
        request = (request != null) ? request : new SearchDTO.SearchRq();
        return SearchUtil.search(skillDAO, request, e -> modelMapper.map(e, infoType));
    }

    @Transactional(readOnly = true)
    @Override
    public String getMaxSkillCode(String skillCodeStart) {
        return skillCodeStart + skillDAO.findMaxSkillCode(skillCodeStart);
    }


    @Transactional(readOnly = true)
    @Override
    public CourseDTO.Info getCourses(Long skillID) {

        final Optional<Skill> optionalSkill = skillDAO.findById(skillID);
        final Skill skill = optionalSkill.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillNotFound));
        return modelMapper.map(skill.getCourse(), CourseDTO.Info.class);
    }


//    @Transactional
//    @Override
//    public List<NeedAssessmentDTO.Info> getNeedAssessment(Long skillID) {
//        final Optional<Skill> optionalSkill = skillDAO.findById(skillID);
//        final Skill skill = optionalSkill.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillNotFound));
//        return modelMapper.map(skill.getNeedAssessments(), new TypeToken<List<NeedAssessmentDTO.Info>>() {
//        }.getType());
//    }

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

//    @Transactional(readOnly = true)
//    @Override
//    public List<SkillGroupDTO.Info> getSkillGroups(Long skillID) {
//        final Optional<Skill> optionalSkill = skillDAO.findById(skillID);
//        final Skill skill = optionalSkill.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillNotFound));
//
//
//        return modelMapper.map(skill.getSkillGroupSet(), new TypeToken<List<SkillGroupDTO.Info>>() {
//        }.getType());
//    }

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
    public boolean editSkill(Long id) {
        final Optional<Skill> optionalSkill = skillDAO.findById(id);
        final Skill skill = optionalSkill.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillNotFound));
        if (skill.getCourseId() != null || skill.getNeedsAssessments().size() > 0) {
            return true;
        }
        return false;

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
//    @Override
    public void addCourse(Long courseId, Long skillId, HttpServletResponse response) throws IOException {
        final Optional<Skill> optionalSkill = skillDAO.findById(skillId);
        final Optional<Course> optionalCourse = courseDAO.findById(courseId);
        final Skill skill = optionalSkill.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SkillNotFound));
        final Course course = optionalCourse.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CourseNotFound));
        if(!course.getCategoryId().equals(skill.getCategoryId())){
            response.sendError(409, messageSource.getMessage("گروه مهارت با دوره یکسان نیست", null, LocaleContextHolder.getLocale()));
            return;
        }
        if(!course.getSubCategoryId().equals(skill.getSubCategoryId())){
            response.sendError(409, messageSource.getMessage("زیر گروه مهارت با دوره یکسان نیست", null, LocaleContextHolder.getLocale()));
            return;
        }
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

    @Transactional(readOnly = true)
    @Override
    public <T> SearchDTO.SearchRs<T> search(SearchDTO.SearchRq request, Class<T> infoType) {
        return SearchUtil.search(skillDAO, request, e -> modelMapper.map(e, infoType));
    }

}
