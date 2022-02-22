package com.nicico.training.dto;


import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;

@Getter
@Setter
public class ElsTeacherInfoDto extends BaseResponse {

    private Long id;
    private String firstName;
    private String lastName;
    private String fatherName;
    private String nationalCode;
    private Long birthDate;
    private String mobileNumber;
    private Long teachingBackground;
    private String iban;
    private String email;
}
