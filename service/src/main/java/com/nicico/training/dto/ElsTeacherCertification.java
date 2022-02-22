package com.nicico.training.dto;

import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;

import java.util.List;

@Getter
@Setter
public class ElsTeacherCertification extends BaseResponse {
    private Long id;
    private String nationalCode;
    private String courseTitle;
    private String companyName;
    private Long courseDate;
    private Boolean certificationStatus;

    private List<Long> categoryIds;
    private List<Long>subcategoryIds;




}
