package com.nicico.training.iservice;/*
com.nicico.training.iservice
@author : banifatemi
@Date : 6/8/2019
@Time :9:04 AM
    */

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.*;

import java.util.List;
import java.util.Set;

public interface IJobGroupService {
    JobGroupDTO.Info get(Long id);

    List<JobGroupDTO.Info> list();

    JobGroupDTO.Info create(JobGroupDTO.Create request);

    JobGroupDTO.Info update(Long id, JobGroupDTO.Update request);

    void delete(Long id);

    void delete(JobGroupDTO.Delete request);

    void addJob(Long jobGroupId, Long jobId);
    void addJobs(Long jobGroupId, Set<Long> jobIds);
    void removeJob(Long jobGroupId, Long jobId);
    void removeJobs(Long jobGroupId, Set<Long> jobIds);
    void removeFromCompetency(Long jobGroupId, Long competenceId);
    void removeFromAllCompetences(Long jobGroupId);
    Set<JobDTO.Info> unAttachJobs(Long jobGroupId);
    boolean canDelete(Long jobGroupId);

    SearchDTO.SearchRs<JobGroupDTO.Info> search(SearchDTO.SearchRq request);

    List<CompetenceDTO.Info> getCompetence(Long jobGroupID);

    List<JobDTO.Info> getJobs(Long jobGroupID);


}
