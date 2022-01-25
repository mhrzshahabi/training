package com.nicico.training.mapper.fms;

import com.nicico.training.model.Attachment;
import dto.fms.AttachmentDto;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Mappings;
import org.mapstruct.ReportingPolicy;
import response.question.dto.ElsAttachmentDto;

import java.util.List;

@Mapper(componentModel = "spring",unmappedTargetPolicy = ReportingPolicy.WARN)
public interface AttachmentMapper {

    @Mapping(target = "key",source = "fileKey")
    @Mapping(target = "description",source = "description")
    @Mapping(target = "fileName",source = "name")
    @Mapping(target = "fileTypeId",source = "type")
    @Mapping(target = "group_id",source = "fmsGroup")
    Attachment toAttachment(AttachmentDto attachmentDto);

    @Mapping(source = "key",target = "fileKey")
    @Mapping(source = "description",target = "description")
    @Mapping(source = "fileName",target= "name")
    @Mapping(source = "fileTypeId",target = "type")
    @Mapping(source = "group_id",target = "fmsGroup")
    AttachmentDto toAttachmentDTO(Attachment attachment);
    List<AttachmentDto> toAttachmentDtos(List<Attachment> attachments);
  @Mappings({
          @Mapping(target = "fileName",source = "fileName"),
          @Mapping(target = "groupId",source = "group_id"),
          @Mapping(target = "attachment",source="key")
  })
    ElsAttachmentDto toElsAttachmentDto(Attachment attachment);
    List<ElsAttachmentDto> toElsAttachmentDtos(List<Attachment> attachments);



}
