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
import java.util.Set;

@Getter
@Setter
@Accessors(chain = true)
public class CategoryDTO {
    @NotEmpty
    @ApiModelProperty(required = true)
    private String code;
    @NotEmpty
    @ApiModelProperty(required = true)
    private String titleFa;
    @ApiModelProperty
    private String titleEn;
    @ApiModelProperty
    private String description;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CategoryInfo")
    public static class Info extends CategoryDTO {
        private Long id;
        private Date createdDate;
        private String createdBy;
        private Date lastModifiedDate;
        private String lastModifiedBy;
        private Integer version;
    }

    @Getter
    @Setter
    @ApiModel("CategoryInfoTuple")
    public static class CategoryInfoTuple extends CategoryDTO {
        private Long id;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CategoryCreateRq")
    public static class Create extends CategoryDTO {
        private Set<Long> subCategoryIds;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CategoryUpdateRq")
    public static class Update extends CategoryDTO {
        private Set<Long> subCategoryIds;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CategoryDeleteRq")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("CategorySpecRs")
    public static class CategorySpecRs {
        private CategoryDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<CategoryDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }

    @Getter
    @Setter
    @ApiModel("CategoryInfoTuple")
    public static class CategoryTitle {
        private Long id;
        private String titleFa;
        private String titleEn;
    }
}
