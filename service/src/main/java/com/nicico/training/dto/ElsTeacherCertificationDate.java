package com.nicico.training.dto;

import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;

import java.util.List;

@Getter
@Setter
public class ElsTeacherCertificationDate extends BaseResponse {
    private Long id;
    private String nationalCode;
    private String courseTitle;
    private String companyName;
    private String courseDate;
    private String courseEndDate;
    private String duration;
    private Boolean certificationStatus;
    private String certification;
    private List<Long> categoryIds;
    private List<Long>subcategoryIds;

}
