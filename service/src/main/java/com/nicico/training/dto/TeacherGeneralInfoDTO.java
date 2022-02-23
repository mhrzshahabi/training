package com.nicico.training.dto;

import lombok.Data;

@Data
public class TeacherGeneralInfoDTO {
    private Long id;
    private Long birthDate;
    private Long teachingBackground;
    private String iban;
    private String email;
}
