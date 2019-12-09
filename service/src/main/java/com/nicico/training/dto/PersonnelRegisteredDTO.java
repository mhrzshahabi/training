package com.nicico.training.dto;
/* com.nicico.training.dto
@Author:Lotfy
*/

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

public class PersonnelRegisteredDTO {


    @ApiModelProperty(required = true)
    private String personnelNo;

    @ApiModelProperty(required = true)
    private String firstName;

    @ApiModelProperty(required = true)
    private String lastName;

    @ApiModelProperty(required = true)
    private String nationalCode;

    @ApiModelProperty(required = true)
    private String birthCertificateNo;

    @ApiModelProperty(required = true)
    private String companyName;

    private String birthDate;
    private String birthPlace;
    private String postTitle;
    private String maritalStatus;
    private String educationLevel;
    private String educationMajor;
    private String gender;
    private String militaryStatus;
    private String postGradeTitle;
    private String workTurn;
    private String employmentStatus;
    private String complex;
    private String workPlace;
    private String fatherName;
    private String age;
    private String active;
    private String deleted;
    private String employmentDate;
    private String postCode;
    private String operationalUnit;
    private String employmentType;
    private String jobNo;
    private String jobTitle;
    private String contractNo;
    private String educationLicenseType;
    private String contractDescription;
    private String workYears;
    private String workMonths;
    private String workDays;
    private String insuranceCode;
    private String ccpArea;
    private String ccpAssistant;
    private String ccpAffairs;
    private String ccpSection;
    private String religion;
    private String nationality;
    private String address;
    private String phone;
    private String fax;
    private String mobile;
    private String email;
    private String accountNumber;


    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("PersonnelRegisteredInfo")
    public static class Info extends PersonnelRegisteredDTO {
        private Long id;
        private Date createdDate;
        private String createdBy;
        private Date lastModifiedDate;
        private String lastModifiedBy;
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("PersonnelRegisteredCreateRq")
    public static class Create extends PersonnelRegisteredDTO {
       }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("PersonnelRegisteredUpdateRq")
    public static class Update extends PersonnelRegisteredDTO {
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("PersonnelRegisteredDeleteRq")
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
    @ApiModel("PersonnelRegisteredSpecRs")
    public static class PersonnelRegisteredSpecRs {
        private SpecRs response;
    }

    // ---------------

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
}
