package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.OperationalRoleDTO;

import java.util.List;
import java.util.Set;

public interface IOperationalRoleService {
    OperationalRoleDTO.Info create(OperationalRoleDTO.Create request);

    List<Long> getUsedPostIdsInRoles(Long roleId);

    List<Long> getUserAccessPostsInRole(Long userId);

    Set<Long> getUserAccessTrainingPostsInRole(Long userId);

    SearchDTO.SearchRs<OperationalRoleDTO.Info> search(SearchDTO.SearchRq searchRq);

    OperationalRoleDTO.Info update(Long id, OperationalRoleDTO.Update request);

    void deleteAll(List<Long> request);

    String getWorkGroup(Long postId);
}
