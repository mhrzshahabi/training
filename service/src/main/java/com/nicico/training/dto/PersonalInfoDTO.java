package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.dto.enums.EGenderDTO;
import com.nicico.training.dto.enums.EMarriedDTO;
import com.nicico.training.dto.enums.EMilitaryDTO;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class PersonalInfoDTO {

    @NotEmpty
    @ApiModelProperty(required = true)
    private String firstNameFa;
    @NotEmpty
    @ApiModelProperty(required = true)
    private String lastNameFa;
    @NotEmpty
    @ApiModelProperty(required = true)
    private String firstNameEn;
    private String lastNameEn;
    private String nationalCode;
    private String fatherName;
    private String birthDate;
    private String birthLocation;
    private String birthCertificate;
    private String birthCertificateLocation;
    private String religion;
    private String nationality;
    private String description;
    private String attachPhoto;
    private String photo;
    private String jobTitle;
    private String jobLocation;
    private Integer militaryId;
    private Integer marriedId;
    private Integer genderId;
    private Long educationLevelId;
    private Long educationMajorId;
    private Long educationOrientationId;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("PersonalInfoSafeCreate")
    public static class SafeCreate extends PersonalInfoDTO {
        private ContactInfoDTO.Info contactInfo;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("PersonalInfoSafeUpdate")
    public static class SafeUpdate extends PersonalInfoDTO {
        private Long id;
        private ContactInfoDTO.CreateOrUpdate contactInfo;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("contractInfo")
    public static class contractInfo extends PersonalInfoDTO {
        private Long id;
        private String firstNameFa;
        private String lastNameFa;
        private String nationalCode;
        private ContactInfoDTO.Info contactInfo;
        private AccountInfoDTO.Info accountInfo;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("PersonalInfoCustom")
    public static class PersonalInfoCustom{
        private Long id;
        private String firstNameFa;
        private String lastNameFa;
        private String nationalCode;
    }


    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("PersonalInfoGrid")
    public static class Grid{
        private Long id;
        private String firstNameFa;
        private String lastNameFa;
        private EducationLevelDTO.EducationLevelInfoTuple educationLevel;
        private EducationMajorDTO.EducationMajorInfoTuple educationMajor;
        private ContactInfoDTO.Grid contactInfo;
        private Integer version;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("PersonalInfoReport")
    public static class Report{
        private Long id;
        private String firstNameFa;
        private String lastNameFa;
        private String nationalCode;
        private EducationMajorDTO.EducationMajorInfoTuple educationMajor;
        private ContactInfoDTO.Grid contactInfo;
        private Integer version;
        public String getName(){
            return firstNameFa + " " + lastNameFa;
        }
    }



    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("PersonalInfoInfo")
    public static class Info extends PersonalInfoDTO {
        private Long id;
        private EMilitaryDTO.EMilitaryInfoTuple eMilitary;
        private EMarriedDTO.EMarriedInfoTuple eMarried;
        private EGenderDTO.EGenderInfoTuple eGender;
        private EducationLevelDTO.EducationLevelInfoTuple educationLevel;
        private EducationMajorDTO.EducationMajorInfoTuple educationMajor;
        private EducationOrientationDTO.EducationOrientationInfoTuple educationOrientation;
        private ContactInfoDTO.Info contactInfo;
        private AccountInfoDTO.Info accountInfo;
        private Integer version;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CompanyManager")
    public static class CompanyManager {
        private Long id;
        private String firstNameFa;
        private String lastNameFa;
        private String nationalCode;
        private ContactInfoDTO.ManagerContactInfo contactInfo;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("PersonalInfoCreateOrUpdateRq")
    public static class CreateOrUpdate extends PersonalInfoDTO {
        private Long id;
        private ContactInfoDTO.CreateOrUpdate contactInfo;
        private AccountInfoDTO.CreateOrUpdate accountInfo;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("PersonalInfoCreateRq")
    public static class Create extends PersonalInfoDTO {
        private Long id;
        private ContactInfoDTO.Create contactInfo;
        private AccountInfoDTO.Create accountInfo;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("PersonalInfoUpdateRq")
    public static class Update extends PersonalInfoDTO {
        private Long id;
        private ContactInfoDTO.CreateOrUpdate contactInfo;
        private AccountInfoDTO.CreateOrUpdate accountInfo;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("PersonalInfoDeleteRq")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("PersonalInfoSpecRs")
    public static class PersonalInfoSpecRs {
        private SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("CompetenceSpecRs")
    public static class CompetenceSpecRs {
        private SpecRs response;
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
    public static class FullName{
        private String firstNameFa;
        private String lastNameFa;
    }

}