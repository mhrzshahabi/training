package com.nicico.training.dto;


import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.io.Serializable;

@Getter
@Setter
@Accessors(chain = true)
public class PersonnelDTO implements Serializable {

    @Getter
    @Setter
    @Accessors
    @ApiModel("Personnel - Info")
    public static class Info {

        private Long autoId;
        private Long id;
        private String personnelNo;
        private String firstName;
        private String lastName;
        private String fatherName;
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
    }
}
