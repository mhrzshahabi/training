package com.nicico.training.mapper.request;

import com.nicico.training.dto.RequestReqVM;
import com.nicico.training.dto.RequestResVM;
import com.nicico.training.mapper.fms.AttachmentMapper;
import com.nicico.training.model.Request;
import org.mapstruct.*;

import java.util.List;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN,uses = {AttachmentMapper.class})
public interface RequestMapper {
    @Mappings({
            @Mapping(target = "requestAttachmentDtos",source = "requestAttachments"),
            @Mapping(target = "responseAttachmentDtos",source = "responseAttachments")
    })
    RequestResVM mapEntityToRes(Request request);

    List<RequestResVM> mapListEntityToRes(List<Request> requests);

    Request mapReqToEntity(RequestReqVM requestReqVM);


}
