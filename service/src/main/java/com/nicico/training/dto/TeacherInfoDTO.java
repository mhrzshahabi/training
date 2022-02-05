package com.nicico.training.dto;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class TeacherInfoDTO {
    private String teacherCode;
    private String nationalCode;
    private String firstName;
    private String lastName;
    private String fullName;
    private String mobileNumber;
    private String emailAddress;
    private String BirthCertificateNumber;
    private String teacherStatus;
    private List<String> educationFields;
}
