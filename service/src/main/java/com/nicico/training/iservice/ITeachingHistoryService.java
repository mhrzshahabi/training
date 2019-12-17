package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.TeachingHistoryDTO;

public interface ITeachingHistoryService {

    TeachingHistoryDTO.Info get(Long id);

    TeachingHistoryDTO.Info update(Long id, TeachingHistoryDTO.Update request);

    SearchDTO.SearchRs<TeachingHistoryDTO.Info> search(SearchDTO.SearchRq request, Long teacherId);

    void addTeachingHistory(TeachingHistoryDTO.Create request, Long teacherId);

    void deleteTeachingHistory(Long teacherId, Long teachingHistoryId);
}
