package com.nicico.training.dto;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class ElsTeacherCertification {
    private Long id;
    private String nationalCode;
    private String courseTitle;
    private String companyName;
    private Long courseDate;
    private Boolean certificationStatus;
    private String certification;
    private List<Long> categoryIds;
    private List<Long>subcategoryIds;




}
