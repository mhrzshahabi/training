package com.nicico.training.dto;

import com.nicico.training.model.enums.UserRequestType;
import lombok.Data;
import response.question.dto.ElsAttachmentDto;

import java.util.List;

@Data
public class RequestReqVM {
    private String name;
    private String text;
    private Long classId;
    private String nationalCode;
    private UserRequestType type;
    private List<ElsAttachmentDto> attachments;
}
