package com.nicico.training.iservice;

import com.nicico.copper.common.domain.criteria.NICICOCriteria;
import com.nicico.copper.common.dto.grid.TotalResponse;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.BehavioralGoalDTO;
import com.nicico.training.dto.JobDTO;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface IBehavioralGoalService {

    BehavioralGoalDTO.Info get(Long id);


    List<BehavioralGoalDTO.Info> list();


    BehavioralGoalDTO.Info create(BehavioralGoalDTO.Create request);


    BehavioralGoalDTO.Info update(Long id, BehavioralGoalDTO.Update request);


    void delete(Long id);


    void delete(BehavioralGoalDTO.Delete request);


    TotalResponse<BehavioralGoalDTO.Info> search(NICICOCriteria request);

    SearchDTO.SearchRs<BehavioralGoalDTO.Info> search(SearchDTO.SearchRq request, Long classId);
}
