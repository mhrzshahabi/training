package com.nicico.training.dto;
/* com.nicico.training.dto
@Author:roya
*/

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.dto.enums.EInstituteTypeDTO;
import com.nicico.training.dto.enums.ELicenseTypeDTO;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

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
    
    @ApiModelProperty(required = true)
    private String code;

    @ApiModelProperty(required = true)
    private String titleFa;

    @ApiModelProperty(required = true)
    private String titleEn;

    private String telephone;
    private String address;
    private String email;
    private String postalCode;
    private String branch;
    private Integer eInstituteTypeId;
    private Integer eLicenseTypeId;

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
        private Set<TeacherDTO.TeacherInfoTuple> teachers;
        private EInstituteTypeDTO.EInstituteTypeInfoTuple eInstituteType;
        private ELicenseTypeDTO.ELicenseTypeInfoTuple eLicenseType;
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("InstituteCreateRq")
    public static class Create extends InstituteDTO {
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
    public static class SpecRs {
        private List<InstituteDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
