package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotNull;
import java.util.Date;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class StudentDTO {
    
    @ApiModelProperty(required = true)
    private String studentID;

    @ApiModelProperty(required = true)
    private String fullNameFa;

    @ApiModelProperty(required = true)
    private String fullNameEn;

    private String personalID;
    private String department;
    private String license;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Student - Info")
    public static class Info {
        private long id;
        private String firstName;
        private String lastName;
        private String nationalCode;
        private String companyName;
        private String personnelNo;
        private String personnelNo2;
        private String employmentStatus;
        private String complexTitle;
        private String workPlaceTitle;
        private String workTurnTitle;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Student- Info All")
    public static class InfoAll  {

        private long id;
        private String firstName;
        private String lastName;
        private String fatherName;

        private String companyName;
        private String personnelNo;
        private String birthCertificateNo;
        private String birthDate;

        private Integer age;
        private String birthPlace;
        private String nationalCode;
        private Integer active;

        private Integer deleted;
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
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("StudentCreateRq")
    public static class Create extends StudentDTO {
       }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("StudentUpdateRq")
    public static class Update extends StudentDTO {
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("StudentDeleteRq")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("StudentSpecRs")
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
}
