package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.EmploymentHistoryDTO;

import java.util.List;

public interface IEmploymentHistoryService {

    EmploymentHistoryDTO.Info get(Long id);

    List<EmploymentHistoryDTO.Info> list();

    EmploymentHistoryDTO.Info create(EmploymentHistoryDTO.Create request);

    EmploymentHistoryDTO.Info update(Long id, EmploymentHistoryDTO.Update request);

    void delete(Long id);

    void delete(EmploymentHistoryDTO.Delete request);

    SearchDTO.SearchRs<EmploymentHistoryDTO.Info> search(SearchDTO.SearchRq request, Long teacherId);
}
