package com.nicico.training.dto;

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

@Getter
@Setter
@Accessors(chain = true)
public class SubcategoryDTO {
    @NotEmpty
    @ApiModelProperty(required = true)
    private String code;
    @NotEmpty
    @ApiModelProperty(required = true)
    private String titleFa;
    @ApiModelProperty
    private String titleEn;
    @NotEmpty
    @ApiModelProperty(required = true)
    private Long categoryId;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("SubCategoryInfo")
    public static class Info extends SubcategoryDTO {
        private Long id;
        private CategoryDTO.CategoryInfoTuple category;
        private Date createdDate;
        private String createdBy;
        private Date lastModifiedDate;
        private String lastModifiedBy;
        private Integer version;
    }

    @Getter
    @Setter
    @ApiModel("SubCategoryInfoTuple")
    public static class SubCategoryInfoTuple {
        private Long id;
        private String titleFa;
        private String titleEn;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("SubCategoryCreateRq")
    public static class Create extends SubcategoryDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("SubCategoryUpdateRq")
    public static class Update extends SubcategoryDTO {
        @NotNull
        @ApiModelProperty(required = true)
        private Integer version;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("SubCategoryDeleteRq")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("SubCategorySpecRs")
    public static class SubCategorySpecRs {
        private SubcategoryDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<SubcategoryDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
