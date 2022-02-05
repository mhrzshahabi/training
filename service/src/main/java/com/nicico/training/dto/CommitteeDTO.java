package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.User;
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
public class CommitteeDTO implements Serializable {
    @ApiModelProperty
    private String titleFa;
    @ApiModelProperty
    private String titleEn;
    @ApiModelProperty
    private Long subCategoryId;
    @ApiModelProperty
    private Long categoryId;
    @ApiModelProperty
    private List<User> members;
    @ApiModelProperty
    private String tasks;
    @ApiModelProperty
    private String description;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CommitteeInfo")
    public static class Info extends CommitteeDTO {
        private Long id;
        private Date createdDate;
        private String createdBy;
        private Date lastModifiedDate;
        private String lastModifiedBy;
        private SubcategoryDTO.SubCategoryInfoTuple subCategory;
        private CategoryDTO.CategoryInfoTuple category;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CommitteeCreateRq")
    public static class Create extends CommitteeDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CommitteeUpdateRq")
    public static class Update extends CommitteeDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CommitteeDeleteRq")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CommitteeIdListRq")
    public static class CommitteeIdList {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("CommitteeSpecRs")
    public static class CommitteeSpecRs {
        private CommitteeDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<CommitteeDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}

