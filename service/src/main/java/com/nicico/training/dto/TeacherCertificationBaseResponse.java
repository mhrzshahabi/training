package com.nicico.training.dto;

import com.nicico.training.model.TeacherCertification;
import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;

@Getter
@Setter
public class TeacherCertificationBaseResponse extends BaseResponse {
   private ElsTeacherCertification elsTeacherCertification;

}
