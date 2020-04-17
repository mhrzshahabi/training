package com.nicico.training.dto;/* com.nicico.training.dto
@Author:jafari-h
@Date:5/28/2019
@Time:2:39 PM
*/

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import java.util.Date;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class StudentClassReportViewDTO {
    @NotEmpty
    @ApiModelProperty(required = true)
    private Long studentId;

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("StudentClassReportViewInfo")
    public static class Info extends StudentClassReportViewDTO {
        private String studentPersonnelNo;
        private String studentFirstName;
        private String studentLastName;
        private String studentNationalCode;
        private Integer studentActive;
        private String studentPostTitle;
        private String studentPostCode;
        private String studentComplexTitle;
        private String studentEducationLevelTitle;
        private String studentJobNo;
        private String studentJobTitle;
        private String studentCompanyName;
        private String studentPersonnelNo2;
        private String studentPostGradeTitle;
        private String studentPostGradeCode;
        private String studentCcpCode;
        private String studentCcpArea;
        private String studentCcpAssistant;
        private String studentCcpAffairs;
        private String studentCcpSection;
        private String studentCcpUnit;
        private String studentCcpTitle;
        private String termCode;
        private String termTitleFa;
        private String classStudentFailureReason;
        private Float classStudentScore;
        private String classStudentApplicantCompanyName;
        private String classStudentPresenceTypeId;
        private String classStatus;
        private String classCode;
        private String classStartDate;
        private String classEndDate;
        private String classTitle;
        private String classGroup;
        private String courseCode;
        private String courseTitle;
        private String categoryTitle;
    }
}
