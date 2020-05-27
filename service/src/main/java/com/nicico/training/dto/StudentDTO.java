package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotNull;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class StudentDTO {

    @ApiModelProperty(required = true)
    private String firstName;
    @ApiModelProperty(required = true)
    private String lastName;
    @ApiModelProperty(required = true)
    private String nationalCode;
    @ApiModelProperty(required = true)
    private String companyName;
    @ApiModelProperty(required = true)
    private String personnelNo;
    private String personnelNo2;
    private String fatherName;
    private String birthCertificateNo;
    private String birthDate;
    private Integer age;
    private String birthPlace;
    private String employmentDate;
    private String postTitle;
    private String postCode;
    private String postAssignmentDate;
    private String complexTitle;
    private String operationalUnitTitle;
    private String employmentTypeTitle;
    private String maritalStatusTitle;
    private String workPlaceTitle;
    private String workTurnTitle;
    private String educationLevelTitle;
    private String jobNo;
    private String jobTitle;
    private Integer employmentStatusId;
    private String employmentStatus;
    private String contractNo;
    private String educationMajorTitle;
    private String gender;
    private String militaryStatus;
    private String educationLicenseType;
    private String departmentTitle;
    private String departmentCode;
    private String contractDescription;
    private String workYears;
    private String workMonths;
    private String workDays;
    private String insuranceCode;
    private String postGradeTitle;
    private String postGradeCode;
    private String ccpCode;
    private String ccpArea;
    private String ccpAssistant;
    private String ccpAffairs;
    private String ccpSection;
    private String ccpUnit;
    private String ccpTitle;
    private String scoresState;
    private String failureReason;
    private Float score;

    @Getter
    @Setter
    @Accessors
    @ApiModel("Student - Info")
    public static class Info extends StudentDTO {
        private Long id;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Student - Create")
    public static class Create extends StudentDTO {
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Student - Update")
    public static class Update extends StudentDTO {
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Student - Delete")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Student - Ids")
    public static class Ids {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("Student - SpecRs")
    public static class StudentSpecRs {
        private SpecRs response;
    }

    // ---------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<StudentDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }

    @Getter
    @Setter
    @Accessors
    @ApiModel("Student - ClassStudentInfo")
    public static class ClassStudentInfo {
        private Long id;
        @ApiModelProperty(required = true)
        private String firstName;
        @ApiModelProperty(required = true)
        private String lastName;
        @ApiModelProperty(required = true)
        private String nationalCode;
        @ApiModelProperty(required = true)
        private String personnelNo;
        private String personnelNo2;
        private String postTitle;
        private String ccpArea;
        private String ccpAssistant;
        private String ccpAffairs;
        private String ccpSection;
        private String ccpUnit;
        private String fatherName;
    }

    @Getter
    @Setter
    @Accessors
    @ApiModel("Student - Attendance")
    public static class AttendanceInfo {
        private Long id;
        @ApiModelProperty(required = true)
        private String firstName;
        @ApiModelProperty(required = true)
        private String lastName;
        @ApiModelProperty(required = true)
        private String nationalCode;
        @ApiModelProperty(required = true)
        private String personnelNo;
        private String personnelNo2;
        @ApiModelProperty(required = true)
        private String companyName;
    }

    @Getter
    @Setter
    @Accessors
    @ApiModel("Student - Scores")
    public static class ScoresInfo {
        private Long id;
        @ApiModelProperty(required = true)
        private String firstName;
        @ApiModelProperty(required = true)
        private String lastName;
        @ApiModelProperty(required = true)
        private String nationalCode;
        @ApiModelProperty(required = true)
        private String personnelNo;
    }

    @Getter
    @Setter
    @Accessors
    @ApiModel("Student - ClassesOfStudentInfo")
    public static class ClassesOfStudentInfo {
        private String postTitle;
    }
    @Getter
    @Setter
    @Accessors
    @ApiModel("Clear - Attendance")
    public static class clearAttendance {
        private String firstName;
        private String lastName;
        private String personnelNo;
        private String jobTitle;
        private String educationMajorTitle;
        private String ccpAffairs;

        @Getter(AccessLevel.NONE)
        private String fullName;

        public String getFullName(){
            return firstName + " " + lastName;
        }
    }
}
