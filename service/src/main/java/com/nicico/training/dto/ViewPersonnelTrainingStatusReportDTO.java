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
    private String personnelNo;

    @ApiModelProperty
    private String personnelNationalCode;

    @ApiModelProperty
    private String personnelFirstName;

    @ApiModelProperty
    private String personnelLastName;

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
    private String personnelCppAffairs;

    @ApiModelProperty
    private String personnelCppArea;

    @ApiModelProperty
    private String courseCode;

    @ApiModelProperty
    private String courseTitleFa;

    @ApiModelProperty
    private String skillCode;

    @ApiModelProperty
    private String skillTitle;

    @ApiModelProperty
    private String Title;

    @ApiModelProperty
    private String courseType;

    @ApiModelProperty
    private String title1;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ViewPersonnelTrainingStatusReportInfo")
    public static class Info extends ViewPersonnelTrainingStatusReportDTO{
        private Long id;
    }
}
