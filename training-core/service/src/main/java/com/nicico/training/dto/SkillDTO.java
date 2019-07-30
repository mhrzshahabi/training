package com.nicico.training.dto;/*
com.nicico.training.dto
@author : banifatemi
@Date : 6/2/2019
@Time :1:12 PM
    */

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.enums.EDomainType;
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
public class SkillDTO {

    @NotNull
    @ApiModelProperty(required = true)
    private String code;

    @NotNull
    @ApiModelProperty(required = true)
    private String titleFa;

    @ApiModelProperty()
    private String titleEn;

    @NotNull
    @ApiModelProperty(required = true)
    private Long skillLevelId;

    @NotNull
    @ApiModelProperty(required = true)
    private Long categoryId;

    @NotNull
    @ApiModelProperty(required = true)
    private Long subCategoryId;

    @NotNull
    @ApiModelProperty(required = true)
    private Integer edomainTypeId;

    @ApiModelProperty()
    private String description;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("SkillInfo")
    public static class Info extends SkillDTO {
        private Long id;
        private SkillLevelDTO.SkillLevelInfoTuple skillLevel;
        private CategoryDTO.CategoryInfoTuple category;
        private SubCategoryDTO.SubCategoryInfoTuple subCategory;
        private EDomainType eDomainType;

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
    @ApiModel("SkillCreateRq")
    public static class Create extends SkillDTO {
        Set<Long> courseIds;
        Set<Long> competenceIds;
        Set<Long> skillGroupIds;

        @NotNull
        @ApiModelProperty(required = true)
        private Long defaultCompetenceId;

    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("SkillUpdateRq")
    public static class Update extends SkillDTO {

        Set<Long> courseIds;
        Set<Long> competenceIds;
        Set<Long> skillGroupIds;

        // ------------------------------

        @NotNull
        @ApiModelProperty(required = true)
        private Integer version;
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("SkillDeleteRq")
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
    @ApiModel("SkillSpecRs")
    public static class SkillSpecRs {
        private SpecRs response;
    }

    // ---------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<SkillDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }


}
