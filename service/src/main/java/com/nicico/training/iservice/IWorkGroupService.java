package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.PermissionDTO;
import com.nicico.training.dto.WorkGroupDTO;
import com.nicico.training.model.WorkGroup;

import java.util.List;

public interface IWorkGroupService {

    WorkGroup getWorkGroup(Long id);


    WorkGroupDTO.Info create(WorkGroupDTO.Create request);


    WorkGroupDTO.Info update(Long id, WorkGroupDTO.Update request);


    List<PermissionDTO.Info> editPermissionList(PermissionDTO.CreateOrUpdate[] rq, Long workGroupId);


    void deleteAll(List<Long> request);


    SearchDTO.SearchRs<WorkGroupDTO.Info> search(SearchDTO.SearchRq request);


    SearchDTO.CriteriaRq getUnassignedRecordsCriteria(String entityName);


    List<PermissionDTO.PermissionFormData> getEntityAttributesList(List<String> entityList);


    SearchDTO.CriteriaRq applyPermissions(Class entity, Long userId);
}
