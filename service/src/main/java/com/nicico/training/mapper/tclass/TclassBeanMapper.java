package com.nicico.training.mapper.tclass;

import com.nicico.training.dto.TclassDTO;
import com.nicico.training.model.Tclass;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Mappings;
import org.mapstruct.ReportingPolicy;
import response.tclass.dto.TclassDto;

import java.util.List;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public interface TclassBeanMapper {
    TclassDto toTclassResponse (Tclass tclass);

    @Mappings({@Mapping(source = "trainingPlaceSet", ignore = true, target = "trainingPlaceIds")})
    TclassDTO toDTO (Tclass tclass);
    List<TclassDTO> toTclassesResponse (List<Tclass> tclasss);
}
