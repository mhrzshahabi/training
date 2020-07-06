package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotEmpty;
import java.io.Serializable;

@Getter
@Setter
@Accessors(chain = true)
public class ContinuousStatusReportViewDTO implements Serializable {

    //@NotEmpty
    @ApiModelProperty(required = true)
    private String EmpNo;

    @ApiModelProperty
    private String PersonnelNo;

    @ApiModelProperty
    private String NationalCode;

    @ApiModelProperty
    private String FirstName;

    @ApiModelProperty
    private String LastName;

    @ApiModelProperty
    private String ClassCode;

    @ApiModelProperty
    private String CourseCode;

    @ApiModelProperty
    private Integer CourseTitle;

    @ApiModelProperty
    private String ComplexTitle;

    @ApiModelProperty
    private String CompanyName;

    @ApiModelProperty
    private String Area;

    @ApiModelProperty
    private String Assistant;

    @ApiModelProperty
    private Integer Affairs;

    @ApiModelProperty
    private String Unit;

    @ApiModelProperty
    private String PostTitle;

    @ApiModelProperty
    private String PostCode;

    @NotEmpty
    @ApiModelProperty(required = true)
    private String StartDate;

    @NotEmpty
    @ApiModelProperty(required = true)
    private String EndDate;

    @ApiModelProperty
    private Long TermId;

    @ApiModelProperty
    private String Year;

    @ApiModelProperty
    private String RegistryState;

    @ApiModelProperty
    private String EvaluationState;

    @ApiModelProperty
    private String EvaluationPriority;

    @ApiModelProperty
    private String ClassStatus;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ContinuousStatusReportInfo")
    public static class Info extends ContinuousStatusReportViewDTO {
        private Long id;
    }
}
