package com.nicico.training.dto;

/*
AUTHOR: ghazanfari_f
DATE: 6/8/2019
TIME: 12:02 PM
*/

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.enums.ECompetenceInputType;
import com.nicico.training.model.enums.ETechnicalType;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.util.Date;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
@JsonInclude(JsonInclude.Include.NON_NULL)
@JsonIgnoreProperties(ignoreUnknown = true)
public class CompetenceDTOOld implements Serializable {

    @NotNull
    @ApiModelProperty(required = true)
    private String titleFa;

    @ApiModelProperty
    private String titleEn;

    @ApiModelProperty
    private String description;

    @NotNull
    @ApiModelProperty(required = true)
    private Integer eTechnicalTypeId;

    @NotNull
    @ApiModelProperty(required = true)
    private Integer eCompetenceInputTypeId;

    @ApiModelProperty
    private Integer wfStatus;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Competence DTO Create Req")
    public static class Create extends CompetenceDTOOld {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Competence DTO Update Req")
    public static class Update extends CompetenceDTOOld {

        @NotNull
        @ApiModelProperty(required = true)
        private Integer version;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Competence DTO Delete Req")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Competence DTO Id List Req")
    public static class CompetenceIdList {
        @NotNull
        @ApiModelProperty(required = true)
        List<Long> ids;
    }


    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Competence DTO Info Req")
    public static class Info extends CompetenceDTOOld {
        private Long id;
        private Date createdDate;
        private String createdBy;
        private Date lastModifiedDate;
        private String lastModifiedBy;
        private Integer version;
        private ETechnicalType eTechnicalType;
        private ECompetenceInputType eCompetenceInputType;
       /* private Set<SkillDTO> skillSet;
        private Set<SkillGroupDTO> skillGroupSet;*/
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("CompetenceSpecRs")
    public static class CompetenceSpecRs {
        private CompetenceDTOOld.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<CompetenceDTOOld.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
