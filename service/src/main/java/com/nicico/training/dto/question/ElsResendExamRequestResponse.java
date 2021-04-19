package com.nicico.training.dto.question;

import lombok.Getter;
import lombok.Setter;
import request.exam.ElsExtendedExamRequest;
import response.BaseResponse;

@Setter
@Getter
public class ElsResendExamRequestResponse extends BaseResponse {
    private ElsExtendedExamRequest elsResendExamRequest;
}
