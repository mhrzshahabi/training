package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.TeachingHistoryDTO;
import com.nicico.training.model.TeachingHistory;
import response.teachingHistory.ElsTeachingHistoryFindAllRespDto;

import java.util.List;

public interface ITeachingHistoryService {

    TeachingHistoryDTO.Info get(Long id);

    TeachingHistory getTeachingHistory(Long id);

    TeachingHistoryDTO.Info update(Long id, TeachingHistoryDTO.Update request);

    SearchDTO.SearchRs<TeachingHistoryDTO.Info> search(SearchDTO.SearchRq request, Long teacherId);

    TeachingHistoryDTO.Info addTeachingHistory(TeachingHistoryDTO.Create request, Long teacherId);

    void deleteTeachingHistory(Long teacherId, Long teachingHistoryId);

    List<ElsTeachingHistoryFindAllRespDto> findTeachingHistoriesByNationalCode(String nationalCode);

    List<ElsTeachingHistoryFindAllRespDto.TeachingHistoryResume> findTeachingHistoriesResumeByNationalCode(String nationalCode);

}
