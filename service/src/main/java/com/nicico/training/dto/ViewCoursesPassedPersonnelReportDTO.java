package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.io.Serializable;

@Getter
@Setter
@Accessors(chain = true)
public class ViewCoursesPassedPersonnelReportDTO implements Serializable {

    @ApiModelProperty(required = true)
    private String empNo;

    @ApiModelProperty
    private String personnelNo;

    @ApiModelProperty
    private String nationalCode;

    @ApiModelProperty
    private String firstName;

    @ApiModelProperty
    private String lastName;

    @ApiModelProperty
    private String courseCode;

    @ApiModelProperty
    private String courseTitleFa;

    @ApiModelProperty
    private Long classStudentScoresStateId;

    @ApiModelProperty
    private String classStartDate;

    @ApiModelProperty
    private String classEndDate;

    @ApiModelProperty
    private Long classHDduration;

    @ApiModelProperty
    private String termCode;

    @ApiModelProperty
    private String termTitleFa;

    @ApiModelProperty
    private Long termId;

    @ApiModelProperty
    private String classYear;

    @ApiModelProperty
    private String postGradeCode;

    @ApiModelProperty
    private String affairs;

    @ApiModelProperty
    private String area;

    @ApiModelProperty
    private String assistant;

    @ApiModelProperty
    private String section;

    @ApiModelProperty
    private String unit;

    @ApiModelProperty
    private String companyName;

    @ApiModelProperty
    private String complexTitle;

    @ApiModelProperty
    private String courseType;

    @ApiModelProperty
    private Long naPriorityId;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ViewCoursesPassedPersonnelReportInfo")
    public static class Info extends ViewCoursesPassedPersonnelReportDTO {
        private Long id;
    }
}
