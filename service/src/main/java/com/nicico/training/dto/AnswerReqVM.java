package com.nicico.training.dto;

import com.nicico.training.model.enums.RequestStatus;
import lombok.Data;

@Data
public class AnswerReqVM {
    private String reference;
    private String response;
    private RequestStatus requestStatus;
}
