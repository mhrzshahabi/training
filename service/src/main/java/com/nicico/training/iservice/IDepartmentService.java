package com.nicico.training.iservice;

import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.CompetenceWebserviceDTO;
import com.nicico.training.dto.DepartmentDTO;

import java.util.List;
import java.util.Set;

public interface IDepartmentService {

    DepartmentDTO.Info get(Long id);

    List<DepartmentDTO.Info> getAll(List<Long> ids);

    List<DepartmentDTO.Info> list();

    TotalResponse<DepartmentDTO.Info> search(NICICOCriteria request);

    SearchDTO.SearchRs<DepartmentDTO.Info> search(SearchDTO.SearchRq request);

    List<DepartmentDTO.Info> findRootNode();

    List<DepartmentDTO.Info> findByParentId(Long parentId);

    SearchDTO.SearchRs<DepartmentDTO.FieldValue> findAllValuesOfOneFieldFromDepartment(String fieldName);

    List<DepartmentDTO.TSociety> getRoot();

    List<DepartmentDTO.TSociety> getDepartmentByParentId(Long parentId);

    List<DepartmentDTO.TSociety> getDepartmentsByParentIds(List<Long> parentsId);

    List<DepartmentDTO.TSociety> searchSocieties(SearchDTO.SearchRq request);
}
