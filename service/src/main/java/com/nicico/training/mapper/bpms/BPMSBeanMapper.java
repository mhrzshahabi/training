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
    @Mapping(source = "processVariables", target = "approved", qualifiedByName = "processVariablesToApproved")
    @Mapping(source = "processVariables", target = "assignFrom", qualifiedByName = "processVariablesToAssignFrom")
    @Mapping(source = "processVariables", target = "title", qualifiedByName = "processVariablesToTitle")
    @Mapping(source = "processVariables", target = "objectId", qualifiedByName = "processVariablesToObjectId")
    @Mapping(source = "processVariables", target = "objectType", qualifiedByName = "processVariablesToObjectType")
    BPMSUserTasksContentDto toUserTasksContent (BPMSUserTasksResponseDto bpmsUserTasksResponseDto);

    List<BPMSUserTasksContentDto> toUserTasksContentList(List<BPMSUserTasksResponseDto> bpmsUserTasksResponseDtoList);

    @Named("processVariablesToCreateBy")
    default String processVariablesToCreateBy(LinkedHashMap<String, Object> variables) {
        if(variables!=null)
        return String.valueOf(variables.get("createBy"));
        else
            return null;
    }

    @Named("processVariablesToObjectType")
    default String processVariablesToObjectType(LinkedHashMap<String, Object> variables) {
        if(variables!=null && variables.get("objectType")!=null)
            return String.valueOf(variables.get("objectType"));
        else
            return null;
    }
    @Named("processVariablesToAssignFrom")
    default String processVariablesToAssignFrom(LinkedHashMap<String, Object> variables) {
        if(variables!=null && variables.get("assignFrom")!=null)
            return String.valueOf(variables.get("assignFrom"));
        else
            return null;
    }
    @Named("processVariablesToObjectId")
    default String processVariablesToObjectId(LinkedHashMap<String, Object> variables) {
        if(variables!=null && variables.get("objectId")!=null)
            return String.valueOf(variables.get("objectId"));
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
    @Named("processVariablesToApproved")
    default Boolean processVariablesToApproved(LinkedHashMap<String, Object> variables) {
        if(variables!=null && variables.get("approved")!=null)
            return (Boolean) variables.get("approved");
        else
            return null;
    }
}
