package com.nicico.training.mapper.EducationalDecisionMapper;

import com.nicico.training.dto.EducationalDecisionDTO;
import com.nicico.training.model.EducationalDecision;
import org.mapstruct.Mapper;
import org.mapstruct.ReportingPolicy;

import java.util.List;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public interface EducationalDecisionMapper {

    EducationalDecisionDTO.Info toDtoInfo(EducationalDecision educationalDecision);
    List<EducationalDecisionDTO.Info> toDtosInfos(List<EducationalDecision> educationalDecisions);

    EducationalDecision toModel(EducationalDecisionDTO educationalDecisionDto);
    List<EducationalDecision> toModels(List<EducationalDecisionDTO> educationalDecisionDtos);

}
