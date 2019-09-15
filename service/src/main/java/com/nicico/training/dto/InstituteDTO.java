package com.nicico.training.dto;
/* com.nicico.training.dto
@Author:roya
*/

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.dto.enums.EInstituteTypeDTO;
import com.nicico.training.dto.enums.ELicenseTypeDTO;
import com.nicico.training.model.*;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import java.util.Date;
import java.util.List;
import java.util.Set;

@Getter
@Setter
@Accessors(chain = true)
@JsonInclude(JsonInclude.Include.NON_NULL)
@JsonIgnoreProperties(ignoreUnknown = true)
public class InstituteDTO {
    
    @NotEmpty
    @ApiModelProperty(required = true)
    private String titleFa;

    @ApiModelProperty
    private String titleEn;

    private Long addressId;
    private Long accountInfoId;
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

    @NotEmpty
    @ApiModelProperty(required = true)
    private Integer einstituteTypeId;

    @NotEmpty
    @ApiModelProperty(required = true)
    private Integer elicenseTypeId;

    private Long parentInstituteId;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("InstituteInfo")
    public static class Info extends InstituteDTO {
        private Long id;
        private Date createdDate;
        private String createdBy;
        private Date lastModifiedDate;
        private String lastModifiedBy;
        private Set<TeacherDTO.TeacherInfoTuple> teacherSet;
        private Set<EquipmentDTO.Info> equipmentSet;
        private Set<TrainingPlaceDTO.Info> trainingPlaceSet;
        private AddressDTO.Info address;
        private AccountInfoDTO.Info accountInfo;
        private PersonalInfoDTO.Info manager;
        private InstituteDTO.Info  parentInstitute;
        private EInstituteTypeDTO.EInstituteTypeInfoTuple eInstituteType;
        private ELicenseTypeDTO.ELicenseTypeInfoTuple eLicenseType;
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("InstituteCreateRq")
    public static class Create extends InstituteDTO {
        AddressDTO.Create address;
        AccountInfoDTO.Create accountInfo;
        Set<Long> equipmentIds;
        Set<Long> trainingPlaceIds;
        Set<Long> teacherIds;
       }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("InstituteUpdateRq")
    public static class Update extends InstituteDTO {
        AddressDTO address;
        AccountInfoDTO accountInfo;
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("InstituteDeleteRq")
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
    @ApiModel("InstituteSpecRs")
    public static class InstituteSpecRs {
        private SpecRs response;
    }

    // ---------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<InstituteDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
