package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.*;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface IJobServiceOld {

	JobDTOOld.Info get(Long id);

	List<JobDTOOld.Info> list();

	JobDTOOld.Info create(JobDTOOld.Create request);

	JobDTOOld.Info update(Long id, JobDTOOld.Update request);

	void delete(Long id);

	void delete(JobDTOOld.Delete request);

	SearchDTO.SearchRs<JobDTOOld.Info> search(SearchDTO.SearchRq request);

	List<JobCompetenceDTO.Info> getJobCompetence(Long jobId);

	List<JobDTOOld.Info> getOtherJobs(Long competenceId);

	@Transactional(readOnly = true)
	List<SkillDTO.Info> getSkills(Long competenceId);

	@Transactional(readOnly = true)
    List<SkillGroupDTO.Info> getSkillGroups(Long competenceId);

	@Transactional(readOnly = true)
	List<CourseDTO.Info> getCourses(Long jobId);
}
