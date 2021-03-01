package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.GenericPermissionDTO;
import com.nicico.training.dto.PermissionDTO;
import com.nicico.training.dto.WorkGroupDTO;
import com.nicico.training.model.WorkGroup;

import java.util.List;

public interface IWorkGroupService {

    WorkGroup getWorkGroup(Long id);


    WorkGroupDTO.Info create(WorkGroupDTO.Create request);


    WorkGroupDTO.Info update(Long id, WorkGroupDTO.Update request);


    List<GenericPermissionDTO.Info> editGenericPermissionList(GenericPermissionDTO.Update rq, Long workGroupId);

    List<PermissionDTO.Info> editPermissionList(PermissionDTO.CreateOrUpdate[] rq, Long workGroupId);

    void deleteAll(List<Long> request);


    SearchDTO.SearchRs<WorkGroupDTO.Info> search(SearchDTO.SearchRq request);


    SearchDTO.CriteriaRq getUnassignedRecordsCriteria(String entityName);


    List<PermissionDTO.PermissionFormData> getEntityAttributesList(List<String> entityList);

    List<GenericPermissionDTO.Info> getAllGenericPermissions(Long workGroupId);


    SearchDTO.CriteriaRq applyPermissions(Class entity, Long userId);

    SearchDTO.CriteriaRq addPermissionToCriteria(String entity, SearchDTO.CriteriaRq criteriaRq);

    boolean isAllowUseId(String entity,Long Id);

    Boolean hasAccess(Long userId,Long groupId);
}
