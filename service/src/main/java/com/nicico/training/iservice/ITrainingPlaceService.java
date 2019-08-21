package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.TrainingPlaceDTO;

import java.util.List;

public interface ITrainingPlaceService {

    TrainingPlaceDTO.Info get(Long id);

    List<TrainingPlaceDTO.Info> list();

    TrainingPlaceDTO.Info create(TrainingPlaceDTO.Create request);

    TrainingPlaceDTO.Info update(Long id, TrainingPlaceDTO.Update request);

    void delete(Long id);

    void delete(TrainingPlaceDTO.Delete request);

    SearchDTO.SearchRs<TrainingPlaceDTO.Info> search(SearchDTO.SearchRq request);

}
