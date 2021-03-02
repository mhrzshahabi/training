package com.nicico.training.dto.question;

import lombok.Getter;
import lombok.Setter;
import request.exam.ElsExamRequest;
import response.BaseResponse;

@Setter
@Getter
public class ElsExamRequestResponse extends BaseResponse {
    private ElsExamRequest elsExamRequest;
}
