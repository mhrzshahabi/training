package com.nicico.training.mapper.fms;

import com.nicico.training.model.Attachment;
import dto.fms.AttachmentDto;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.ReportingPolicy;

@Mapper(componentModel = "spring",unmappedTargetPolicy = ReportingPolicy.WARN)
public interface AttachmentMapper {

    @Mapping(target = "key",source = "fileKey")
    @Mapping(target = "description",source = "description")
    @Mapping(target = "fileName",source = "name")
    @Mapping(target = "fileTypeId",source = "type")
    @Mapping(target = "group_id",source = "fmsGroup")
    Attachment toAttachment(AttachmentDto attachmentDto);
}
