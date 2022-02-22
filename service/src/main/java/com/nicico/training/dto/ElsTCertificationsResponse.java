package com.nicico.training.dto;

import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;

import java.util.List;

@Getter
@Setter
public class ElsTCertificationsResponse extends BaseResponse {
    private List<ElsTeacherCertificationsDto> elsTeacherCertifications;
}
