package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.OperationalRoleDTO;

import java.util.List;

public interface IOperationalRoleService {
    OperationalRoleDTO.Info create(OperationalRoleDTO.Create request);

    List<Long> getUsedPostIdsInRoles();

    SearchDTO.SearchRs<OperationalRoleDTO.Info> search(SearchDTO.SearchRq searchRq);

    OperationalRoleDTO.Info update(Long id, OperationalRoleDTO.Update request);
}
