package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.*;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

public interface ICourseService {

	CourseDTO.Info get(Long id);

	List<CourseDTO.Info> list();
	List<CourseDTO.Info> preCourseList(Long id);

    @Transactional
    void setPreCourse(Long id, List<Long> preCourseList);

    @Transactional
    void setEqualCourse(Long id, List<String> equalCourseList);

    List<Map> equalCourseList(Long id);

	CourseDTO.Info create(CourseDTO.Create request);

	CourseDTO.Info update(Long id, CourseDTO.Update request);

	void delete(Long id);

	void delete(CourseDTO.Delete request);

	SearchDTO.SearchRs<CourseDTO.Info> search(SearchDTO.SearchRq request);

    //-------jafari--------
    SearchDTO.SearchRs<CourseDTO.GoalsWithSyllabus> searchDetails(SearchDTO.SearchRq request);

    List<GoalDTO.Info> getgoal(Long courseId);
	List<GoalDTO.Info> getGoalWithOut(Long courseId);
	List<SkillDTO.Info> getSkill(Long courseId);


    List<CompetenceDTO.Info> getCompetenceQuery(Long courseId);

    List<CompetenceDTO.Info> getCompetence(Long courseId);

    List<SkillGroupDTO.Info> getSkillGroup(Long courseId);

    List<JobDTO.Info> getJob(Long courseId);

    List<PostDTO.Info> getPost(Long courseId);

    String getMaxCourseCode(String str);

	void  getCourseIdvGoalsId(Long courseId, List<Long> goalIdList);

	void removeCourseSGoal(Long courseId, List<Long> goalIdList);

	boolean  checkForDelete(Long id);

	void deletGoal(Long id);

    @Transactional
    String getDomain(Long id);

    @Transactional(readOnly = true)
    List<TeacherDTO.TeacherFullNameTuple> getTeachers(Long courseId);
}
