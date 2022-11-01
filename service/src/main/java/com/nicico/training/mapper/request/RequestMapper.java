package com.nicico.training.mapper.request;

import com.nicico.training.dto.RequestReqVM;
import com.nicico.training.dto.RequestResVM;
import com.nicico.training.mapper.fms.AttachmentMapper;
import com.nicico.training.model.Request;
import com.nicico.training.model.enums.EnumsConverter;
import com.nicico.training.model.enums.UserRequestType;
import org.mapstruct.*;

import java.util.List;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN,uses = {AttachmentMapper.class})
public interface RequestMapper {

    @Mappings({
            @Mapping(target = "requestAttachmentDtos",source = "requestAttachments"),
            @Mapping(target = "responseAttachmentDtos",source = "responseAttachments"),
            @Mapping(target = "userRequestTypeTitle", source = "type", qualifiedByName = "toUserRequestTypeTitle")
    })
    RequestResVM mapEntityToRes(Request request);

    List<RequestResVM> mapListEntityToRes(List<Request> requests);

    @Mapping(target = "type", source = "userRequestTypeId", qualifiedByName = "toUserRequestType")
    Request mapReqToEntity(RequestReqVM requestReqVM);

    @Named("toUserRequestType")
    default UserRequestType toUserRequestType(Long userRequestTypeId) {
        if (userRequestTypeId != null) {
            EnumsConverter.UserRequestTypeConverter userRequestTypeConverter = new EnumsConverter.UserRequestTypeConverter();
            return userRequestTypeConverter.convertToEntityAttribute(userRequestTypeId.intValue());
        } else return null;
    }

    @Named("toUserRequestTypeTitle")
    default String toUserRequestTypeTitle(UserRequestType type) {
        if (type != null)
        return type.getTitleFa();
        else return "";
    }

}
