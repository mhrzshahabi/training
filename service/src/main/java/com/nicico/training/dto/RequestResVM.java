package com.nicico.training.dto;

import com.nicico.training.model.enums.RequestStatus;
import com.nicico.training.model.enums.UserRequestType;
import lombok.Data;


import java.util.Date;

@Data
public class RequestResVM {


    private String text;

    private String name;

    private String nationalCode;

    private String response;

    private String fmsReference;

    private String groupId;

    private UserRequestType type;

    private RequestStatus status;

    private String reference;

    private Date createdDate;
}
