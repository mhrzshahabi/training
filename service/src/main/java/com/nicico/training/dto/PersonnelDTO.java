package com.nicico.training.dto;


import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class PersonnelDTO implements Serializable {

    @Getter
    @Setter
    @Accessors
    @ApiModel("Personnel - Info")
    public static class Info {
        private Long id;
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
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Student - Ids")
    public static class Ids {
        @NotNull
        @ApiModelProperty(required = true)
        private List<String> ids;
    }



    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("PersonnelSpecRs")
    public static class PersonnelSpecRs {
        private PersonnelDTO.SpecRs response;
    }

    //*********************************

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
