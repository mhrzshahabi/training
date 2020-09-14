package com.nicico.training.mapper;

import com.nicico.training.dto.TclassDTO;
import com.nicico.training.model.Tclass;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.ReportingPolicy;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public interface TrainingClassBeanMapper {

    Tclass updateTClass(TclassDTO.Update request, @MappingTarget Tclass tclass);
}
