package com.nicico.training.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.io.Serializable;

@Getter
@Setter
@Accessors(chain = true)
public class ViewLmsTrainingFileDTO implements Serializable {
    private String firstName;
    private String lastName;
    private String nationalCode;
    private String empNo;
    private String postTitle;
    private String postCode;
    private String jobTitle;
    private String postGradeTitle;
    private String complex;
    private String assistant;
    private String affairs;
    private String termTitleFa;
    private String scoresState;
    private Float score;
    private String classStatus;
    private String classCode;
    private String startDate;
    private String endDate;
    private String courseCode;
    private String courseTitle;
    private String teacher;
    private String personType;
    private Integer duration;
    private String runType;
    private String companyName;
    private String personnelCode;
}
