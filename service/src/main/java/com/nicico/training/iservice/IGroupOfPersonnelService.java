package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.GroupOfPersonnelDTO;
import com.nicico.training.model.GroupOfPersonnel;
import response.BaseResponse;

import java.util.List;
import java.util.Set;

public interface IGroupOfPersonnelService {
    BaseResponse create(GroupOfPersonnelDTO.Create request);
    BaseResponse update(Long id, GroupOfPersonnelDTO.Update request);
    Boolean delete(Long id,String type);
    SearchDTO.SearchRs<GroupOfPersonnelDTO.Info> searchWithoutPermission(SearchDTO.SearchRq request);
    List<Long> getPersonnel(Long id);
    GroupOfPersonnel get(Long id);
    void addPersonnel(Long groupId, Set<Long> ids);
    void removePersonnel(Long groupId, Set<Long> ids);
}
