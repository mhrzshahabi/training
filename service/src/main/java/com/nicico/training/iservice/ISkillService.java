package com.nicico.training.iservice;/*
com.nicico.training.iservice
@author : banifatemi
@Date : 6/8/2019
@Time :9:03 AM
    */


import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.*;
import org.springframework.data.domain.Pageable;

import java.util.List;

public interface ISkillService {
    SkillDTO.Info get(Long id);

    List<SkillDTO.Info> list();

    SkillDTO.Info create(SkillDTO.Create request);

    SkillDTO.Info update(Long id, Object request);

    void delete(Long id);

    void delete(SkillDTO.Delete request);

    SearchDTO.SearchRs<SkillDTO.Info> search(SearchDTO.SearchRq request);

    // ---------------
    String getMaxSkillCode(String skillCodeStart);

    CourseDTO.Info getCourses(Long skillID);

    List<CourseDTO.Info> getUnAttachedCourses(Long skillID, Pageable pageable);

    Integer getUnAttachedCoursesCount(Long skillID);

    //    List<CompetenceDTO.Info> getCompetences(Long skillID);
//    List<CompetenceDTO.Info> getUnAttachedCompetences(Long skillID, Pageable pageable);
//    Integer getUnAttachedCompetencesCount(Long skillID);
    List<SkillGroupDTO.Info> getSkillGroups(Long skillID);

    List<NeedAssessmentDTO.Info> getNeedAssessment(Long skillID);

    List<SkillGroupDTO.Info> getUnAttachedSkillGroups(Long skillID, Pageable pageable);

    Integer getUnAttachedSkillGroupsCount(Long skillID);
//    List<JobDTO.Info> getJobs(Long skillID);


    CategoryDTO.Info getCategory(Long skillID);

    SubCategoryDTO.Info getSubCategory(Long skillID);

    SkillLevelDTO.Info getSkillLevel(Long skillID);

    boolean isSkillDeletable(Long skillId);

    void removeSkillGroup(Long skillGroupId, Long skillId);

    void removeSkillGroups(List<Long> skillGroupIds, Long skillId);

    void addSkillGroup(Long skillGroupId, Long skillId);

    void addSkillGroups(List<Long> request, Long skillId);

//    void removeCompetence(Long competenceId,Long skillId);
//    void removeCompetences(List<Long> competenceIds,Long skillId);
//    void addCompetence(Long competenceId,Long skillId);
//    void addCompetences(List<Long>  ids, Long skillId);

    void removeCourse(Long courseId, Long skillId);

    void removeCourses(List<Long> courseIds, Long skillId);

    void addCourse(Long courseId, Long skillId);

    void addCourses(List<Long> ids, Long skillId);
}
