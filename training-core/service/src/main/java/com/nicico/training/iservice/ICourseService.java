package com.nicico.training.iservice;

import com.nicico.copper.core.dto.search.SearchDTO;
import com.nicico.training.dto.CourseDTO;
import com.nicico.training.dto.GoalDTO;
import com.nicico.training.dto.JobDTO;
import com.nicico.training.dto.SkillDTO;

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
	List<JobDTO.Info> getJob(Long courseId);

	void  getCourseIdvGoalsId(Long courseId,List<Long> goalIdList);

	void removeCourseSGoal(Long courseId, List<Long> goalIdList);




}
