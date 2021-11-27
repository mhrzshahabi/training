package com.nicico.training.mapper.selfdeclaration;

import com.nicico.training.dto.SelfDeclarationDTO;
import com.nicico.training.model.SelfDeclaration;
import org.mapstruct.Mapper;

import org.mapstruct.ReportingPolicy;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public interface SelfDeclarationMapper {

    SelfDeclaration requestToEntity(SelfDeclarationDTO selfDeclarationDTO);

}
