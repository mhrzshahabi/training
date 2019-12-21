package com.nicico.training.iservice;

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.EquipmentDTO;
import com.nicico.training.dto.TrainingPlaceDTO;
import org.springframework.data.domain.Pageable;

import java.util.List;

public interface ITrainingPlaceService {

    TrainingPlaceDTO.Info get(Long id);

    List<TrainingPlaceDTO.Info> list();

    TrainingPlaceDTO.Info create(Object request);

    TrainingPlaceDTO.Info update(Long id, Object request);

    void delete(Long id);

    void delete(TrainingPlaceDTO.Delete request);

    SearchDTO.SearchRs<TrainingPlaceDTO.Info> search(SearchDTO.SearchRq request);

    List<EquipmentDTO.Info> getEquipments(Long trainingPlaceId);

    void removeEquipment(Long equipmentId, Long trainingPlaceId);

    void removeEquipments(List<Long> equipmentIds, Long trainingPlaceId);

    void addEquipment(Long equipmentId, Long trainingPlaceId);

    void addEquipments(List<Long> equipmentIds, Long trainingPlaceId);

    List<EquipmentDTO.Info> getUnAttachedEquipments(Long trainingPlaceId, Pageable pageable);

    Integer getUnAttachedEquipmentsCount(Long trainingPlaceId);
}
