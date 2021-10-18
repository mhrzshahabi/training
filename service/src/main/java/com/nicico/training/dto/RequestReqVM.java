package com.nicico.training.dto;

import com.nicico.training.model.enums.UserRequestType;
import lombok.Data;

@Data
public class RequestReqVM {

    private String name;
    private String text;
    private String nationalCode;
    private String fmsReference;

    private String groupId;

    private UserRequestType type;
}
