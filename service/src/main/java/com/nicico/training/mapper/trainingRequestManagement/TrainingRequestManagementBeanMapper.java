package com.nicico.training.mapper.trainingRequestManagement;


 import com.nicico.training.dto.TrainingRequestManagementDTO;
 import com.nicico.training.model.TrainingRequestManagement;
 import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Named;
import org.mapstruct.ReportingPolicy;

import java.util.Arrays;
import java.util.List;


@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public interface TrainingRequestManagementBeanMapper {

    TrainingRequestManagement toTrainingRequestManagement (TrainingRequestManagementDTO.Create request);

    TrainingRequestManagementDTO.Info toTrainingRequestManagementDto(TrainingRequestManagement trainingRequestManagement);



    List<TrainingRequestManagementDTO.Info> toTrainingRequestManagementDTOs(List<TrainingRequestManagement> trainingRequestManagementList);
}
