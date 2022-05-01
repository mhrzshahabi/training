package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.AccountInfo;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import java.util.List;
import java.util.Set;

@Getter
@Setter
@Accessors(chain = true)
public class InstituteDTO {
    @NotEmpty
    @ApiModelProperty(required = true)
    private String titleFa;
    @ApiModelProperty
    private String titleEn;
    private Long contactInfoId;
    private Long managerId;
    private Integer teacherNumPHD;
    private Integer empNumPHD;
    private Integer teacherNumLicentiate;
    private Integer empNumLicentiate;
    private Integer teacherNumMaster;
    private Integer empNumMaster;
    private Integer teacherNumAssociate;
    private Integer empNumAssociate;
    private Integer teacherNumDiploma;
    private Integer empNumDiploma;
    private Long instituteId;
    private String economicalId;
    private Long parentInstituteId;
    private Long licenseTypeId;
    private Long companyTypeId;


    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("InstituteInfo")
    public static class Info extends InstituteDTO {
        private Long id;
        private PersonalInfoDTO.PersonalInfoCustom manager;
        private ContactInfoDTO.InstituteContactInfo contactInfo;
        private InstituteDTO.InstituteInfoTuple parentInstitute;
        private ParameterValueDTO.MinInfo companyType;
        private ParameterValueDTO.MinInfo licenseType;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ContractInfo")
    public static class ContractInfo {
        private Long id;
        private String titleFa;
        private String instituteId;
        private String economicalId;
        private Set<AccountInfo> accountInfoSet;
        private ContactInfoDTO.InstituteContactInfo contactInfo;
    }

    @Getter
    @Setter
    @ApiModel("InstituteSessionTuple")
    public static class InstituteSessionTuple {
        private Long id;
        private String titleFa;
        private PersonalInfoDTO.PersonalInfoCustom manager;
    }

    @Getter
    @Setter
    @ApiModel("InstituteInfoTuple")
    public static class InstituteInfoTuple {
        private Long id;
        private String titleFa;
        private String titleEn;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("InstituteCreateRq")
    public static class Create extends InstituteDTO {
        private ContactInfoDTO.CreateOrUpdate contactInfo;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("InstituteUpdateRq")
    public static class Update extends InstituteDTO {
        private ContactInfoDTO.CreateOrUpdate contactInfo;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("InstituteDeleteRq")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("InstituteSpecRs")
    public static class InstituteSpecRs {
        private SpecRs response;
    }

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
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class InstituteTitle {
        private String titleFa;
        private Long id;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class InstituteWithTrainingPlace {
        private Long id;
        private String titleFa;
        private List<TrainingPlaceDTO.TrainingPlaceTitle> trainingPlaceSet;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ForAgreementInfo")
    public static class ForAgreementInfo {
        private Long id;
        private String titleFa;
        private Long instituteId;
        private String economicalId;
        private ContactInfoDTO.InstituteContactInfo contactInfo;
        private PersonalInfoDTO.CompanyManager manager;
        private Set<AccountInfoDTO.ShabaInfo> accountInfoSet;
        private boolean valid;
    }

}
