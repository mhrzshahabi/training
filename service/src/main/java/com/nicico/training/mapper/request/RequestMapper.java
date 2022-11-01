package com.nicico.training.mapper.request;

import com.nicico.training.dto.RequestReqVM;
import com.nicico.training.dto.RequestResVM;
import com.nicico.training.iservice.ITclassService;
import com.nicico.training.mapper.fms.AttachmentMapper;
import com.nicico.training.model.Request;
import com.nicico.training.model.enums.EnumsConverter;
import com.nicico.training.model.enums.UserRequestType;
import org.mapstruct.*;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN,uses = {AttachmentMapper.class})
public abstract class RequestMapper {

    @Autowired
    protected ITclassService tClassService;

    @Mappings({
            @Mapping(target = "requestAttachmentDtos",source = "requestAttachments"),
            @Mapping(target = "responseAttachmentDtos",source = "responseAttachments"),
            @Mapping(target = "userRequestTypeTitle", source = "type", qualifiedByName = "toUserRequestTypeTitle"),
            @Mapping(target = "classTitle", source = "classId", qualifiedByName = "toClassTitle")
    })
    public abstract RequestResVM mapEntityToRes(Request request);

    public abstract List<RequestResVM> mapListEntityToRes(List<Request> requests);

    @Mapping(target = "type", source = "userRequestTypeId", qualifiedByName = "toUserRequestType")
    public abstract Request mapReqToEntity(RequestReqVM requestReqVM);

    @Named("toUserRequestType")
    protected UserRequestType toUserRequestType(Long userRequestTypeId) {
        if (userRequestTypeId != null) {
            EnumsConverter.UserRequestTypeConverter userRequestTypeConverter = new EnumsConverter.UserRequestTypeConverter();
            return userRequestTypeConverter.convertToEntityAttribute(userRequestTypeId.intValue());
        } else return null;
    }

    @Named("toUserRequestTypeTitle")
    protected String toUserRequestTypeTitle(UserRequestType type) {
        if (type != null)
        return type.getTitleFa();
        else return "";
    }

    @Named("toClassTitle")
    protected String toClassTitle(Long classId) {
        if (classId != null)
            return tClassService.get(classId).getTitleClass();
        else return "";
    }

}
