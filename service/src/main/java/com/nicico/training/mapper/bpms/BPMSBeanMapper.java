package com.nicico.training.mapper.bpms;

import dto.bpms.BPMSUserTasksContentDto;
import dto.bpms.BPMSUserTasksResponseDto;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Named;
import org.mapstruct.ReportingPolicy;

import java.util.LinkedHashMap;
import java.util.List;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public interface BPMSBeanMapper {

    @Mapping(source = "processVariables", target = "createBy", qualifiedByName = "processVariablesToCreateBy")
    @Mapping(source = "processVariables", target = "title", qualifiedByName = "processVariablesToTitle")
    BPMSUserTasksContentDto toUserTasksContent (BPMSUserTasksResponseDto bpmsUserTasksResponseDto);

    List<BPMSUserTasksContentDto> toUserTasksContentList(List<BPMSUserTasksResponseDto> bpmsUserTasksResponseDtoList);

    @Named("processVariablesToCreateBy")
    default String processVariablesToCreateBy(LinkedHashMap<String, Object> variables) {
        if(variables!=null)
        return String.valueOf(variables.get("createBy"));
        else
            return null;
    }

    @Named("processVariablesToTitle")
    default String processVariablesToTitle(LinkedHashMap<String, Object> variables) {
        if(variables!=null)
            return String.valueOf(variables.get("title"));
        else
            return null;
    }
}
