package com.nicico.training.dto;


import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;
import response.BaseResponse;

@Getter
@Setter
@Accessors(chain = true)
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

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ElsTeacherInfoDto.Resume")
    public static class Resume {
        private String birthDate;
        private String fatherName;
        private String teachingBackgroundInMonth;
        private String teachingBackgroundInYear;
        private String iban;
        private String email;
    }
}
