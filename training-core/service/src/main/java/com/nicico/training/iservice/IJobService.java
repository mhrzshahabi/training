package com.nicico.training.iservice;

import com.nicico.copper.core.dto.search.SearchDTO;
import com.nicico.training.dto.*;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface IJobService {

	JobDTO.Info get(Long id);

	List<JobDTO.Info> list();

	JobDTO.Info create(JobDTO.Create request);

	JobDTO.Info update(Long id, JobDTO.Update request);

	void delete(Long id);

	void delete(JobDTO.Delete request);

	SearchDTO.SearchRs<JobDTO.Info> search(SearchDTO.SearchRq request);

	List<JobCompetenceDTO.Info> getJobCompetence(Long jobId);

	List<JobDTO.Info> getOtherJobs(Long competenceId);

	@Transactional(readOnly = true)
	List<SkillDTO.Info> getSkills(Long competenceId);

	@Transactional(readOnly = true)
    List<SkillGroupDTO.Info> getSkillGroups(Long competenceId);

	@Transactional(readOnly = true)
	List<CourseDTO.Info> getCourses(Long jobId);
}
