package com.nicico.training.dto;/* com.nicico.training.dto
@Author:jafari-h
@Date:5/28/2019
@Time:2:39 PM
*/

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.AllArgsConstructor;
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
    private Long classStudentId;

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
        private Long classStudentScoresState;
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
        private String courseTitleFa;
        private String categoryTitleFa;
        private Long classHDuration;
    }

    @Getter
    @Setter
    @AllArgsConstructor
    @Accessors(chain = true)
    @ApiModel("ComplexTitle")
    public static class StatisticalReport {
        private String scoreState;
//        private String ccpAssistant;
//        private String ccpAffairs;
//        private String ccpSection;
//        private String ccpUnit;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("StudentClassReportViewInfoTuple")
    public static class InfoTuple extends StudentClassReportViewDTO {
        private String studentPersonnelNo;
        private String studentNationalCode;
        private Long classStudentScoresState;
        private String courseCode;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("StudentClassReportSpecRs")
    public static class StudentClassReportSpecRs {
        private StudentClassReportViewDTO.SpecRs response;
    }

    // ---------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs<T> {
        private List<T> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }

    @Getter
    @Setter
    @AllArgsConstructor
    @Accessors(chain = true)
    @ApiModel("FieldValue")
    public static class FieldValue {
        private String value;
    }


    @Getter
    @Setter
    @ApiModel("CourseInfoSCRV")
    public static class CourseInfoSCRV {
        private Long courseId;
        private String courseCode;
        private String courseTitleFa;
    }

}
