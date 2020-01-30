package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.EmploymentHistoryDTO;
import com.nicico.training.model.EmploymentHistory;

public interface IEmploymentHistoryService {

    EmploymentHistoryDTO.Info get(Long id);

    EmploymentHistory getEmploymentHistory(Long id);

    EmploymentHistoryDTO.Info update(Long id, EmploymentHistoryDTO.Update request);

    SearchDTO.SearchRs<EmploymentHistoryDTO.Info> search(SearchDTO.SearchRq request, Long teacherId);

    void addEmploymentHistory(EmploymentHistoryDTO.Create request, Long teacherId);

    void deleteEmploymentHistory(Long teacherId, Long employmentHistoryId);

    SearchDTO.SearchRs<EmploymentHistoryDTO.Grid> deepSearchGrid(SearchDTO.SearchRq request, Long teacherId);
}
