package com.nicico.training.mapper.bpms;

import dto.bpms.BPMSUserTasksContentDto;
import dto.bpms.BPMSUserTasksResponseDto;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Named;
import org.mapstruct.ReportingPolicy;

import java.util.ArrayList;
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
    @Mapping(source = "processVariables", target = "returnReason", qualifiedByName = "processVariablesToReturnReason")
    @Mapping(source = "processVariables", target = "requestItemId", qualifiedByName = "processVariablesToRequestItemId")
    @Mapping(source = "processVariables", target = "requestNo", qualifiedByName = "processVariablesToRequestNo")
    @Mapping(source = "processVariables", target = "assigneeList", qualifiedByName = "processVariablesToAssigneeList")
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
    @Named("processVariablesToReturnReason")
    default String processVariablesToReturnReason(LinkedHashMap<String, Object> variables) {
        if(variables!=null && variables.get("returnReason")!=null)
            return String.valueOf(variables.get("returnReason"));
        else
            return " " ;
    }

    @Named("processVariablesToRequestItemId")
    default String processVariablesToRequestItemId(LinkedHashMap<String, Object> variables) {
        if(variables!=null && variables.get("requestItemId")!=null)
            return String.valueOf(variables.get("requestItemId"));
        else
            return null;
    }

    @Named("processVariablesToRequestNo")
    default String processVariablesToRequestNo(LinkedHashMap<String, Object> variables) {
        if(variables!=null && variables.get("requestNo")!=null)
            return String.valueOf(variables.get("requestNo"));
        else
            return null;
    }

    @Named("processVariablesToAssigneeList")
    default List<String> processVariablesToAssigneeList(LinkedHashMap<String, Object> variables) {
        List<String> assigneeList = new ArrayList<>();
        if(variables!=null && variables.get("assigneeList")!=null)
            assigneeList.addAll((List<String>) variables.get("assigneeList"));
        return assigneeList;
    }

}
