package com.nicico.training.mapper.EducationalDecisionHeaderMapper;

import com.nicico.training.dto.EducationalDecisionHeaderDTO;
import com.nicico.training.model.EducationalDecisionHeader;
import org.mapstruct.Mapper;
import org.mapstruct.ReportingPolicy;

import java.util.List;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public interface EducationalDecisionHeaderMapper {

    EducationalDecisionHeaderDTO.Info toDtoInfo(EducationalDecisionHeader educationalDecisionHeader);
    List<EducationalDecisionHeaderDTO.Info> toDtosInfos(List<EducationalDecisionHeader> educationalDecisionHeaders);

    EducationalDecisionHeader toModel(EducationalDecisionHeaderDTO educationalDecisionHeaderDto);
    List<EducationalDecisionHeader> toModels(List<EducationalDecisionHeaderDTO> educationalDecisionHeaderDtos);

}
