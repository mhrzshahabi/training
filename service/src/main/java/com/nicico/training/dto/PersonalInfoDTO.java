package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
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
import java.util.Date;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
@JsonInclude(JsonInclude.Include.NON_NULL)
@JsonIgnoreProperties(ignoreUnknown = true)
public class PersonalInfoDTO {

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("PersonalInfoInfo")
    public static class Info{
        private Long id;
        private Date createdDate;
        private String createdBy;
        private Date lastModifiedDate;
        private String lastModifiedBy;
		private EMilitaryDTO.EMilitaryInfoTuple eMilitary;
		private EMarriedDTO.EMarriedInfoTuple eMarried;
		private EGenderDTO.EGenderInfoTuple eGender;
		private EducationLevelDTO.EducationLevelInfoTuple educationLevel;
		private EducationMajorDTO.EducationMajorInfoTuple educationMajor;
		private EducationOrientationDTO.EducationOrientationInfoTuple educationOrientation;
		private ContactInfoDTO.ContactInfoInfoTuple contactInfo;
		private AccountInfoDTO.AccountInfoInfoTuple accountInfo;
		@NotEmpty
        @ApiModelProperty(required = true)
        private String firstNameFa;
        @NotEmpty
        @ApiModelProperty(required = true)
        private String lastNameFa;
        @NotEmpty
        @ApiModelProperty(required = true)
        private String nationalCode;
        private String fullNameEn;
        private String fatherName;
        private String birthDate;
        private String birthLocation;
        private String birthCertificate;
        private String birthCertificateLocation;
        private String religion;
        private String nationality;
        private String description;
        private String attachPhoto;
        private String workName;
        private String workJob;
        private Integer eMilitaryId;
        private Integer eMarriedId;
        private Integer eGenderId;
        private Long educationLevelId;
        private Long educationMajorId;
        private Long educationOrientationId;
        private Long accountInfoId;
        private Long contactInfoId;
    }

    @Getter
	@Setter
	@ApiModel("PersonalInfoInfoTuple")
	public static class PersonalInfoInfoTuple {
        private String firstNameFa;
        private String lastNameFa;
        private String nationalCode;
        private String fullNameEn;
        private String fatherName;
        private String birthDate;
        private String birthLocation;
        private String birthCertificate;
        private String birthCertificateLocation;
        private String religion;
        private String nationality;
        private String description;
        private String attachPhoto;
        private String workName;
        private String workJob;
        private Integer eMilitaryId;
	    private Integer eMarriedId;
	    private Integer eGenderId;
        private EMilitaryDTO.EMilitaryInfoTuple eMilitary;
        private EMarriedDTO.EMarriedInfoTuple eMarried;
        private EGenderDTO.EGenderInfoTuple eGender;
        private EducationLevelDTO.EducationLevelInfoTuple educationLevel;
        private EducationMajorDTO.EducationMajorInfoTuple educationMajor;
        private EducationOrientationDTO.EducationOrientationInfoTuple educationOrientation;
        private ContactInfoDTO.ContactInfoInfoTuple contactInfo;
        private AccountInfoDTO.AccountInfoInfoTuple accountInfo;
        private Long educationLevelId;
        private Long educationMajorId;
        private Long educationOrientationId;
        }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("PersonalInfoCreateRq")
    public static class Create{
        private ContactInfoDTO.Create contactInfo;
        private AccountInfoDTO.Create accountInfo;
        @NotEmpty
        @ApiModelProperty(required = true)
        private String firstNameFa;
        @NotEmpty
        @ApiModelProperty(required = true)
        private String lastNameFa;
        @NotEmpty
        @ApiModelProperty(required = true)
        private String nationalCode;
        private String fullNameEn;
        private String fatherName;
        private String birthDate;
        private String birthLocation;
        private String birthCertificate;
        private String birthCertificateLocation;
        private String religion;
        private String nationality;
        private String description;
        private String attachPhoto;
        private String workName;
        private String workJob;
        private Integer eMilitaryId;
        private Integer eMarriedId;
        private Integer eGenderId;
        private Long educationLevelId;
        private Long educationMajorId;
        private Long educationOrientationId;
        private Long accountInfoId;
        private Long contactInfoId;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("PersonalInfoUpdateRq")
    public static class Update{
        private ContactInfoDTO.Update contactInfo;
        private AccountInfoDTO.Update accountInfo;
        @NotEmpty
        @ApiModelProperty(required = true)
        private String firstNameFa;
        @NotEmpty
        @ApiModelProperty(required = true)
        private String lastNameFa;
        @NotEmpty
        @ApiModelProperty(required = true)
        private String nationalCode;
        private String fullNameEn;
        private String fatherName;
        private String birthDate;
        private String birthLocation;
        private String birthCertificate;
        private String birthCertificateLocation;
        private String religion;
        private String nationality;
        private String description;
        private String attachPhoto;
        private String workName;
        private String workJob;
        private Integer eMilitaryId;
        private Integer eMarriedId;
        private Integer eGenderId;
        private Long educationLevelId;
        private Long educationMajorId;
        private Long educationOrientationId;
        private Long accountInfoId;
        private Long contactInfoId;
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

}

