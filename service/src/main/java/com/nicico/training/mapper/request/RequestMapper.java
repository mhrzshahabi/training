package com.nicico.training.mapper.request;

import com.nicico.training.dto.RequestReqVM;
import com.nicico.training.dto.RequestResVM;
import com.nicico.training.model.Request;
import org.mapstruct.Mapper;
import org.mapstruct.ReportingPolicy;

import java.util.List;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public interface RequestMapper {

    RequestResVM mapEntityToRes(Request request);

    List<RequestResVM> mapListEntityToRes(List<Request> requests);

    Request mapReqToEntity(RequestReqVM requestReqVM);
}
