package com.nicico.training.dto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

@Getter
@Setter
@Accessors(chain = true)
public class ViewPersonnelTrainingStatusReportDTO {
    @ApiModelProperty
    private Long naPriorityId;
    @ApiModelProperty
    private Long naIsInNa;
    @ApiModelProperty
    private String classStatus;
    @ApiModelProperty
    private Long classStudentScoresStateId;
    @ApiModelProperty
    private Long classStudentScore;
    @ApiModelProperty
    private Long personnelIsPersonnel;
    @ApiModelProperty
    private Long courseId;
    @ApiModelProperty
    private String courseCode;
    @ApiModelProperty
    private String courseTitleFa;
    @ApiModelProperty
    private String personnelPersonnelNo;
    @ApiModelProperty
    private String personnelFirstName;
    @ApiModelProperty
    private String personnelLastName;
    @ApiModelProperty
    private String personnelNationalCode;
    @ApiModelProperty
    private String personnelCppAffairs;
    @ApiModelProperty
    private String personnelCppArea;
    @ApiModelProperty
    private String personnelCppAssistant;
    @ApiModelProperty
    private String personnelCppCode;
    @ApiModelProperty
    private String personnelCppSection;
    @ApiModelProperty
    private String personnelCppTitle;
    @ApiModelProperty
    private String personnelCppUnit;
    @ApiModelProperty
    private String personnelCompanyName;
    @ApiModelProperty
    private String personnelComplexTitle;
    @ApiModelProperty
    private String personnelJobNo;
    @ApiModelProperty
    private String personnelJobTitle;
    @ApiModelProperty
    private String personnelEmpNo;
    @ApiModelProperty
    private String personnelPostCode;
    @ApiModelProperty
    private String personnelPostGradeCode;
    @ApiModelProperty
    private String personnelPostGradeTitle;
    @ApiModelProperty
    private String personnelPostTitle;
    @ApiModelProperty
    private Long personnelDepartmentId;
    @ApiModelProperty
    private Long personnelPostId;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ViewPersonnelTrainingStatusReportInfo")
    public static class Info extends ViewPersonnelTrainingStatusReportDTO {
        private Long classId;
        private Long personnelId;
    }
}
