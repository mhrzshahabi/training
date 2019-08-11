package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.JobCompetenceDTO;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface IJobCompetenceService {

	JobCompetenceDTO.Info get(Long id);

	List<JobCompetenceDTO.Info> list();

	@Transactional
	void createForJob(JobCompetenceDTO.CreateForJob request);

	@Transactional
	void createForCompetence(JobCompetenceDTO.CreateForCompetence request);

	void update(JobCompetenceDTO.Update request);

	void delete(Long jobId, Long competecneId);

	void delete(JobCompetenceDTO.Delete request);

	SearchDTO.SearchRs<JobCompetenceDTO.Info> search(SearchDTO.SearchRq request);
}
