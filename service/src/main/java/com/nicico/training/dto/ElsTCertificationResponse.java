package com.nicico.training.dto;

import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;

import java.io.Serializable;

@Getter
@Setter
public class ElsTCertificationResponse  extends BaseResponse implements Serializable {

    private ElsTeacherCertification elsTeacherCertification;
}
