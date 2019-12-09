package com.nicico.training.dto;/*
com.nicico.training.dto
@author : banifatemi
@Date : 6/2/2019
@Time :2:49 PM
    */

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
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
@Accessors(chain=true)

public class SkillGroupDTO {

    @NotEmpty
    @ApiModelProperty(required = true)
    private String titleFa;

    @ApiModelProperty()
    private String titleEn;

    @ApiModelProperty()
    private String description;
    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain=true)
    @ApiModel("SkillGroupInfo")
    public static class Info extends SkillGroupDTO{
        private Long id;
        private Date createdDate;
        private String createdBy;
        private Date lastModifiedDate;
        private String lastModifiedBy;
        private Integer version;
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("SkillGroupCreateRq")
    public static  class Create extends SkillGroupDTO{
        private Set<Long> skillIds;
        private Set<Long> competenceIds;
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("SkillGroupUpdateRq")
    public static class Update extends SkillGroupDTO{
        private Set<Long> skillIds;
        private Set<Long> competenceIds;
        @NotNull
        @ApiModelProperty(required = true)
        private Integer version;
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("SkillGroupIdListRq")
    public static class SkillGroupIdList{
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;

    }

    // ------------------------------


    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("SkillGroupDeleteRq")
    public static class Delete{
        @NotNull
        @ApiModelProperty(required = true)
        private Set<Long> ids;

    }

    // ------------------------------
    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("SkillGroupSpecRs")
    public static class SkillGroupSpecRs{
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
