package com.nicico.training.dto;
/* com.nicico.training.dto
@Author:roya
*/

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.dto.enums.EInstituteTypeDTO;
import com.nicico.training.dto.enums.ELicenseTypeDTO;
import com.nicico.training.model.TrainingPlace;
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
@JsonInclude(JsonInclude.Include.NON_NULL)
@JsonIgnoreProperties(ignoreUnknown = true)
public class InstituteDTO {
    
    @NotEmpty
    @ApiModelProperty(required = true)
    private String titleFa;

    @ApiModelProperty
    private String titleEn;

    @ApiModelProperty
    private Long stateId;

    @ApiModelProperty
    private Long cityId;

    @ApiModelProperty
    private String postalCode;

    @ApiModelProperty
    private String phone;

    @ApiModelProperty
    private String mobile;

    @ApiModelProperty
    private String fax;

    @ApiModelProperty
    private String webSite;

    @ApiModelProperty
    private String e_mail;

    @ApiModelProperty
    private String restAddress;

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
//        private Set<TeacherDTO.TeacherInfoTuple> teacherSet;
//        private Set<EquipmentDTO.Info> equipmentSet;
//        private Set<TrainingPlaceDTO.Info> trainingPlaceSet;
//        private Set<InstituteAccountDTO.Info> instituteAccountSet;
        private PersonalInfoDTO.Info manager;
        private InstituteDTO.Info  parentInstitute;
        private EInstituteTypeDTO.EInstituteTypeInfoTuple eInstituteType;
        private ELicenseTypeDTO.ELicenseTypeInfoTuple eLicenseType;
        private CityDTO.Info city;
        private StateDTO.Info state;
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("InstituteCreateRq")
    public static class Create extends InstituteDTO {
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
    public static class SpecRs <T> {
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
}
