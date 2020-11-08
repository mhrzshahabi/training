package com.nicico.training.mapper.tclass;

import com.nicico.training.model.Tclass;
import org.mapstruct.Mapper;
import org.mapstruct.ReportingPolicy;
import response.tclass.dto.TclassDto;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public interface TclassBeanMapper {
    TclassDto toTclassResponse (Tclass tclass);
}
