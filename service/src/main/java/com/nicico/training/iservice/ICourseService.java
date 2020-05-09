package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.*;
import com.nicico.training.model.Course;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;

public interface ICourseService {

    CourseDTO.Info get(Long id);

    Course getCourse(Long id);

    List<CourseDTO.Info> list();

    List<CourseDTO.Info> preCourseList(Long id);

    void setPreCourse(Long id, List<Long> preCourseList);

    void updateHasSkill(Long id, Boolean hasSkill);

    void setEqualCourse(Long id, List<String> equalCourseList);

    List<Map> equalCourseList(Long id);

    CourseDTO.Info create(CourseDTO.Create request, HttpServletResponse response);

    CourseDTO.Info update(Long id, CourseDTO.Update request);

    void delete(Long id);

    void delete(CourseDTO.Delete request);

    SearchDTO.SearchRs<CourseDTO.Info> search(SearchDTO.SearchRq request);

    //-------jafari--------
    SearchDTO.SearchRs<CourseDTO.GoalsWithSyllabus> searchDetails(SearchDTO.SearchRq request);

    List<GoalDTO.Info> getGoal(Long courseId);

    List<GoalDTO.Info> getGoalWithOut(Long courseId);

    List<SkillDTO.Info> getSkill(Long courseId);


    List<CompetenceDTOOld.Info> getCompetenceQuery(Long courseId);

//    List<CompetenceDTOOld.Info> getCompetence(Long courseId);

//    List<SkillGroupDTO.Info> getSkillGroup(Long courseId);

    List<SkillDTO.Info> getMainObjective(Long courseId);

    List<JobDTO.Info> getJob(Long courseId);

    List<PostDTO.Info> getPost(Long courseId);

    String getMaxCourseCode(String str);

    void getCourseIdvGoalsId(Long courseId, List<Long> goalIdList);

    void removeCourseSGoal(Long courseId, List<Long> goalIdList);

    boolean checkForDelete(Long id);

    void deletGoal(Long id);

    String getDomain(Long id);

    List<TeacherDTO.TeacherFullNameTupleWithFinalGrade> getTeachers(Long courseId);

    int updateCourseState(Long courseId, String workflowStatus, Integer workflowStatusCode);

    //---------------------heydari---------------------------

    CourseDTO.Info updateEvaluation(Long id, CourseDTO.Update request);

    List<CourseDTO.Info> getEvaluation(Long courseId);

    CourseDTO.CourseGoals getCourseGoals(Long courseId);
}
