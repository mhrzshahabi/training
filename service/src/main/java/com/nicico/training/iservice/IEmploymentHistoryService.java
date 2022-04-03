package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.EmploymentHistoryDTO;
import com.nicico.training.model.EmploymentHistory;
import response.employmentHistory.ElsEmploymentHistoryFindAllRespDto;

import java.util.List;

public interface IEmploymentHistoryService {

    EmploymentHistoryDTO.Info get(Long id);

    EmploymentHistory getEmploymentHistory(Long id);

    EmploymentHistoryDTO.Info update(Long id, EmploymentHistoryDTO.Update request);

    SearchDTO.SearchRs<EmploymentHistoryDTO.Info> search(SearchDTO.SearchRq request, Long teacherId);

    EmploymentHistoryDTO.Info addEmploymentHistory(EmploymentHistoryDTO.Create request, Long teacherId);

    void deleteEmploymentHistory(Long teacherId, Long employmentHistoryId);

    List<ElsEmploymentHistoryFindAllRespDto> findEmploymentHistoriesByNationalCode(String nationalCode);

    List<ElsEmploymentHistoryFindAllRespDto.Resume> findEmploymentHistoryResumeListByNationalCode(String nationalCode);

}
