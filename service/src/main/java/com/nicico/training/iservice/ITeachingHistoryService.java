package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.TeachingHistoryDTO;

import java.util.List;

public interface ITeachingHistoryService {

    TeachingHistoryDTO.Info get(Long id);
//
//    List<TeachingHistoryDTO.Info> list();
//
//    TeachingHistoryDTO.Info create(TeachingHistoryDTO.Create request);

    TeachingHistoryDTO.Info update(Long id, TeachingHistoryDTO.Update request);

//    void delete(Long id);
//
//    void delete(TeachingHistoryDTO.Delete request);

    SearchDTO.SearchRs<TeachingHistoryDTO.Info> search(SearchDTO.SearchRq request, Long teacherId);
}
