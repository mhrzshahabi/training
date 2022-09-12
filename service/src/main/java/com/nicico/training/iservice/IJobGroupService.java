package com.nicico.training.iservice;/*
com.nicico.training.iservice
@author : banifatemi
@Date : 6/8/2019
@Time :9:04 AM
    */

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.JobDTO;
import com.nicico.training.dto.JobGroupDTO;
import com.nicico.training.model.JobGroup;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Set;

public interface IJobGroupService {
    JobGroupDTO.Info get(Long id);

    List<JobGroupDTO.Info> list();

    @Transactional(readOnly = true)
    List<JobGroupDTO.Tuple> listTuple();

    JobGroupDTO.Info create(JobGroupDTO.Create request);

    JobGroupDTO.Info update(Long id, JobGroupDTO.Update request);

    void delete(Long id);

    void delete(JobGroupDTO.Delete request);

    void addJob(Long jobGroupId, Long jobId);

    void addJobs(Long jobGroupId, Set<Long> jobIds);

    void removeJob(Long jobGroupId, Long jobId);

    void removeJobs(Long jobGroupId, Set<Long> jobIds);

    Set<JobDTO.Info> unAttachJobs(Long jobGroupId);

    SearchDTO.SearchRs<JobGroupDTO.Info> search(SearchDTO.SearchRq request);

    SearchDTO.SearchRs<JobGroupDTO.Info> searchWithoutPermission(SearchDTO.SearchRq request);

    List<JobDTO.Info> getJobs(Long jobGroupID);


    List<JobGroup> getPostGradeGroupsByJobId(Long objectId);
}
