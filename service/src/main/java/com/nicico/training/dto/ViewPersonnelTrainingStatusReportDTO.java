package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotEmpty;

@Getter
@Setter
@Accessors(chain = true)
public class ViewPersonnelTrainingStatusReportDTO {

    @ApiModelProperty
    private String organizer;

    @ApiModelProperty
    private String personnelNo;

    @ApiModelProperty
    private String personnelNoTD;

    @ApiModelProperty
    private String personnelNationalCode;

    @ApiModelProperty
    private String personnelFirstName;

    @ApiModelProperty
    private String personnelLastName;

    @ApiModelProperty
    private String personnelJobCode;

    @ApiModelProperty
    private String PersonnelJobTitle;

    @ApiModelProperty
    private String personnel_Post_code;

    @ApiModelProperty
    private String personnelPostGradeCode;

    @ApiModelProperty
    private String personnelPostGradeTitle;

    @ApiModelProperty
    private String personnelPostTitle;

    @ApiModelProperty
    private String company;

    @ApiModelProperty
    private String personnelCppAffairs;

    @ApiModelProperty
    private String personnelCppArea;

    @ApiModelProperty
    private String personnelAssisstant;

    @ApiModelProperty
    private String personnelUnit;

    @ApiModelProperty
    private String courseCode;

    @ApiModelProperty
    private String courseTitleFa;

    @ApiModelProperty
    private String skillCode;

    @ApiModelProperty
    private String skillTitle;

    @ApiModelProperty
    private String acceptanceState;

    @ApiModelProperty
    private String needsAssessmentState;

    @ApiModelProperty
    private String needsAssessmentPriority;

    @ApiModelProperty
    private String classState;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ViewPersonnelTrainingStatusReportInfo")
    public static class Info extends ViewPersonnelTrainingStatusReportDTO{
        private Long id;
    }
}
