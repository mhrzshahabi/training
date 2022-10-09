package com.nicico.training.iservice;


import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.model.TrainingRequestManagement;

import java.util.List;


public interface ITrainingRequestManagementService {

    TrainingRequestManagement create(TrainingRequestManagement trainingRequestManagement);

    //
    TrainingRequestManagement update(TrainingRequestManagement trainingRequestManagement, Long id);

    //
    TrainingRequestManagement get(Long id);
//
    void delete(Long id);
//
    List<TrainingRequestManagement> getList();
//
    Integer getTotalCount();
//
    List<TrainingRequestManagement> search(SearchDTO.SearchRq request);
}
