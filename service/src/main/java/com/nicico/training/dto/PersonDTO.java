package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class PersonDTO {

    @ApiModelProperty(required = true)
    private String firstName;
    @ApiModelProperty(required = true)
    private String lastName;
    @ApiModelProperty(required = true)
    private String nationalCode;
    private Integer gender;
    private String personnelNo;
    private String personnelNo2;
    private String fatherName;
    private String birthCertificateNo;
    private String birthDate;
    private String mobile;
    private String phone;
    private String address;
    private String email;

    private String postTitle;
    private String postCode;

    private Integer employmentStatusId;
    private String employmentStatus;
    private String militaryStatus;
    private String educationLevelTitle;
    private String educationMajorTitle;
    private List<String> roles;

    @Getter
    @Setter
    @Accessors
    @ApiModel("Person - Info")
    public static class Info extends PersonDTO {
        private Long id;

        public String getFullName() {
            return (getFirstName() + " " + getLastName()).compareTo("null null")==0?null:getFirstName() + " " + getLastName();
        }
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Person - Create")
    public static class Create extends PersonDTO{
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Person - Update")
    public static class Update extends PersonDTO{
    }

    // ------------------------------





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
    @Accessors
    @ApiModel("Student - ClassStudentInfo")
    public static class PersonInfo {
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
        private String birthCertificateNo;

        private String gender;
    }


}
