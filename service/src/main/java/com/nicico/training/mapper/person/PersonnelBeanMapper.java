package com.nicico.training.mapper.person;

import com.nicico.training.dto.PersonnelDTO;
import com.nicico.training.model.Personnel;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Mappings;
import org.mapstruct.ReportingPolicy;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public interface PersonnelBeanMapper {
     @Mappings({
             @Mapping(target = "firstName",source = "firstName"),
             @Mapping(target = "lastName",source = "lastName")
     })
    PersonnelDTO.PersonnelName toPersonnelDTO(Personnel personnel);
}
