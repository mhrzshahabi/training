/*
ghazanfari_f, 8/29/2019, 11:51 AM
*/
package com.nicico.training.service;

import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.copper.core.SecurityUtil;
import com.nicico.training.dto.JobDTO;
import com.nicico.training.iservice.IJobService;
import com.nicico.training.model.Job;
import com.nicico.training.repository.JobDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class JobService implements IJobService {

    private final JobDAO jobDAO;
    private final ModelMapper modelMapper;
    private final WorkGroupService workGroupService;

    @Transactional(readOnly = true)
    @Override
    public List<JobDTO.Info> list() {
        return modelMapper.map(jobDAO.findAll(), new TypeToken<List<JobDTO.Info>>() {
        }.getType());
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<JobDTO.Info> search(SearchDTO.SearchRq request) {
        Long userId = SecurityUtil.getUserId();
        request.setCriteria(workGroupService.applyPermissions(request.getCriteria(), Job.class,userId));
        return SearchUtil.search(jobDAO, request, job -> modelMapper.map(job, JobDTO.Info.class));
    }

    @Transactional(readOnly = true)
    @Override
    public TotalResponse<JobDTO.Info> search(NICICOCriteria request) {
        return SearchUtil.search(jobDAO, request, job -> modelMapper.map(job, JobDTO.Info.class));
    }
}
