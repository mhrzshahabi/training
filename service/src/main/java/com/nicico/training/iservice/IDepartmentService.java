package com.nicico.training.iservice;

import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.DepartmentDTO;

import java.util.List;

public interface IDepartmentService {

    DepartmentDTO.Info get(Long id);

    List<DepartmentDTO.Info> getAll(List<Long> ids);

    List<DepartmentDTO.Info> list();

    TotalResponse<DepartmentDTO.Info> search(NICICOCriteria request);

    SearchDTO.SearchRs<DepartmentDTO.Info> search(SearchDTO.SearchRq request);

    List<DepartmentDTO.Info> findRootNode();

    List<DepartmentDTO.Info> findByParentId(Long parentId);
}
