package com.nicico.training.dto;

import com.nicico.training.model.enums.RequestStatus;
import com.nicico.training.model.enums.UserRequestType;
import lombok.Data;
import response.question.dto.ElsAttachmentDto;


import java.util.Date;
import java.util.List;

@Data
public class RequestResVM {
    private Long id;

    private String text;

    private String name;

    private String nationalCode;

    private String response;

    private UserRequestType type;

    private RequestStatus status;

    private String reference;

    private Date createdDate;

    private List<ElsAttachmentDto> requestAttachmentDtos;
    private List<ElsAttachmentDto> responseAttachmentDtos;
}
