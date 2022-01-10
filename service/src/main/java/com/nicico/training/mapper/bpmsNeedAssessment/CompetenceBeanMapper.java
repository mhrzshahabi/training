package com.nicico.training.mapper.bpmsNeedAssessment;

import com.nicico.training.dto.CompetenceDTO;
import dto.BpmsCompetenceDTO;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Mappings;
import org.mapstruct.ReportingPolicy;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public interface CompetenceBeanMapper {
     @Mappings({
             @Mapping(target = "title",source = "title"),
             @Mapping(target = "competenceTypeId",source = "competenceTypeId"),
             @Mapping(target = "categoryId",source = "categoryId"),
             @Mapping(target = "subCategoryId",source = "subCategoryId"),
             @Mapping(target = "code",source = "code"),
             @Mapping(target = "description",source = "description"),
             @Mapping(target = "workFlowStatusCode",source = "workFlowStatusCode"),
     })
     CompetenceDTO.Create toCompetence(BpmsCompetenceDTO competenceDTO);
}
