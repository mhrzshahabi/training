package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

@Setter
@Getter
@Accessors(chain = true)
@ApiModel("CertificationDTO")
public class CertificationDTO {
    private String token;
    private Long classId;
    private String nationalCode;


}
