package com.nicico.training.mapper.competenceRequest;


import com.nicico.training.dto.CompetenceRequestDTO;
import com.nicico.training.model.CompetenceRequest;
import com.nicico.training.model.enums.RequestType;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Named;
import org.mapstruct.ReportingPolicy;

import java.util.Arrays;
import java.util.List;


@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public interface CompetenceRequestBeanMapper {

    @Mapping(source = "requestType", target = "requestType", qualifiedByName = "intToRequestType")
    CompetenceRequest toCompetenceRequest (CompetenceRequestDTO.Create request);

    @Mapping(source = "requestType", target = "requestType", qualifiedByName = "RequestTypeToInt")
    CompetenceRequestDTO.Info toCompetenceRequestDto(CompetenceRequest competenceRequestResponse);


    @Named("RequestTypeToInt")
    default int RequestTypeToInt(RequestType requestType) {
        return requestType.getId();
    }

    @Named("intToRequestType")
    default RequestType intToRequestType(int id) {
        return Arrays.stream(RequestType.values())
                .filter(e -> e.getId() == id)
                .findFirst()
                .orElseThrow(() -> new IllegalStateException(String.format("Unsupported type %s.", id)));

    }

    List<CompetenceRequestDTO.Info> toCompetenceRequestDtos(List<CompetenceRequest> competenceRequestResponses);
}
