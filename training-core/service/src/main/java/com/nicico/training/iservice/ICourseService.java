package com.nicico.training.iservice;

import com.nicico.copper.core.dto.search.SearchDTO;
import com.nicico.training.dto.*;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface ICourseService {

	CourseDTO.Info get(Long id);

	List<CourseDTO.Info> list();

	CourseDTO.Info create(CourseDTO.Create request);

	CourseDTO.Info update(Long id, CourseDTO.Update request);

	void delete(Long id);

	void delete(CourseDTO.Delete request);

	SearchDTO.SearchRs<CourseDTO.Info> search(SearchDTO.SearchRq request);

	List<GoalDTO.Info> getgoal(Long courseId);
	List<GoalDTO.Info> getGoalWithOut(Long courseId);
	List<SkillDTO.Info> getSkill(Long courseId);


    List<CompetenceDTO.Info> getCompetenceQuery(Long courseId);

    List<CompetenceDTO.Info> getCompetence(Long courseId);
    List<JobDTO.Info> getJob(Long courseId);

    String getMaxCourseCode(String str);



	void  getCourseIdvGoalsId(Long courseId,List<Long> goalIdList);

	void removeCourseSGoal(Long courseId, List<Long> goalIdList);




}
