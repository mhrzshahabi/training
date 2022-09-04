package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class ViewActivePersonnelDTO implements Serializable {

    @Getter
    @Setter
    @Accessors
    @ApiModel("Personnel - Personality - Info")
    public static class PersonalityInfo {
        private Long id;
        private String personnelNo;
        private String fullName;
        private String firstName;
        private String lastName;
        private String fatherName;
        private String birthCertificateNo;
        private String birthDate;
        private Integer age;
        private String nationalCode;
        private Integer active;
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
        private String companyName;
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
        private String personnelNo2;
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
        private String address;
        private String phone;
        private String mobile;
        private String email;
        private Long postId;
    }

    @Getter
    @Setter
    @Accessors
    @ApiModel("Personnel - Info")
    public static class Info {
        private Long id;
        private String fullName;
        private String firstName;
        private String lastName;
        private String nationalCode;
        private String companyName;
        private String personnelNo;
        private String personnelNo2;
        private String postTitle;
        private String ccpArea;
        private String ccpAssistant;
        private String ccpAffairs;
        private String ccpSection;
        private String ccpUnit;
        private String ccpTitle;
        private String fatherName;
        private String jobNo;
        private String jobTitle;
        private String postCode;
        private String postGradeTitle;
        private String workPlace;
        private String workYears;
        private String workMonths;
        private String workDays;
        private String employmentType;
        private String employmentStatus;
        private String educationLevelTitle;
        private String educationMajorTitle;
        private String workTurnTitle;
        private String workPlaceTitle;
        private String complexTitle;
        private String address;
        private String phone;
        private String mobile;
        private String email;
        private Long postId;
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

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("PersonnelSpecRs")
    public static class PersonnelSpecRs {
        private ViewActivePersonnelDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }

    @Getter
    @Setter
    @AllArgsConstructor
    @Accessors(chain = true)
    @ApiModel("ComplexTitle")
    public static class StatisticalReport {
        private String complexTitle;
        private String ccpAssistant;
        private String ccpAffairs;
        private String ccpSection;
        private String ccpUnit;
    }

    @Getter
    @Setter
    @AllArgsConstructor
    @Accessors(chain = true)
    @ApiModel("FieldValue")
    public static class FieldValue {
        private String value;
    }
}
