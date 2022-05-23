package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.OperationalRoleDTO;
import com.nicico.training.dto.ViewTrainingPostDTO;
import com.nicico.training.model.OperationalRole;

import java.util.List;
import java.util.Set;

public interface IOperationalRoleService {
    OperationalRole create(OperationalRole creating);

    List<Long> getUsedPostIdsInRoles(Long roleId);

    List<Long> getUserAccessPostsInRole(Long userId);

    Set<Long> getUserAccessTrainingPostsInRole(Long userId);

    SearchDTO.SearchRs<OperationalRoleDTO.Info> search(SearchDTO.SearchRq searchRq);

    OperationalRole update(Long id, OperationalRole updating);

    void deleteAll(List<Long> request);

    OperationalRole getOperationalRole(Long id);

    String getWorkGroup(Long postId);

    SearchDTO.SearchRs<OperationalRoleDTO.Info> deepSearch(SearchDTO.SearchRq searchRq) throws NoSuchFieldException, IllegalAccessException;

    SearchDTO.SearchRs<ViewTrainingPostDTO.Info> getRoleUsedPostList(Long roleId);

    OperationalRole findById(Long id);

    OperationalRole save(OperationalRole operationalRole);

    void deleteIndividualPost(Long roleId, List<Long> postIds);



}
