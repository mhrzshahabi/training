package com.nicico.training.iservice;


import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.*;
import com.nicico.training.model.Skill;
import org.springframework.data.domain.Pageable;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public interface ISkillService {

    SkillDTO.Info get(Long id);
    List<SkillDTO.Info2> getInfoV2(List<Long> ids);

    Skill getSkill(Long id);

    List<SkillDTO.Info> list();

    List<SkillDTO.Info> listCourseIsNull();

    SkillDTO.Info create(SkillDTO.Create request, HttpServletResponse response);

    SkillDTO.Info update(Long id, Object request, HttpServletResponse response);

    void delete(Long id);

    void delete(SkillDTO.Delete request);

    SearchDTO.SearchRs<SkillDTO.Info> searchWithoutPermission(SearchDTO.SearchRq request);

    String getMaxSkillCode(String skillCodeStart);

    CourseDTO.Info getCourses(Long skillID);

    List<CourseDTO.Info> getUnAttachedCourses(Long skillID, Pageable pageable);

    Integer getUnAttachedCoursesCount(Long skillID);


    CategoryDTO.Info getCategory(Long skillID);

    SubcategoryDTO.Info getSubCategory(Long skillID);

    SkillLevelDTO.Info getSkillLevel(Long skillID);

    boolean isSkillDeletable(Long skillId);

    void removeCourse(Long courseId, Long skillId);

    @Transactional
    boolean editSkill(Long id);

    void removeCourses(List<Long> courseIds, Long skillId);

//    void addCourse(Long courseId, Long skillId);

    void addCourses(List<Long> ids, Long skillId);

    List<Skill> getAllByIds(List<Long> ids);

    List<SkillDTO> listMainObjective(Long mainObjectiveId);

    List<Skill> skillList(Long courseId);

    <T> SearchDTO.SearchRs<T> search(SearchDTO.SearchRq request, Class<T> infoType);

    SearchDTO.SearchRs<ViewTrainingPostDTO.Report> getPostsContainsTheSkill(Long skillId);

    <T> SearchDTO.SearchRs<T> searchGeneric(SearchDTO.SearchRq request, Class<T> infoType);

    void addCourse(Long courseId, Long skillId, HttpServletResponse resp) throws IOException;
}
