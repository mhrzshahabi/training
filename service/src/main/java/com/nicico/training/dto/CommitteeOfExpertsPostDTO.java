package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
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
public class CommitteeOfExpertsPostDTO implements Serializable {


    private Long id;

    private String objectType;
    private String objectCode;
    private String userNationalCode;
    private String userName;
    private String phone;



    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CommitteeOfExpertsPostsInfo")
    public static class Info extends CommitteeOfExpertsPostDTO {
        private Long id;
        private Date createdDate;
        private String createdBy;
        private Date lastModifiedDate;
        private String lastModifiedBy;
//        private SubcategoryDTO.SubCategoryInfoTuple subCategory;
//        private CategoryDTO.CategoryInfoTuple category;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CommitteeOfExpertsPostsCreateRq")
    public static class Create extends CommitteeOfExpertsPostDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CommitteeOfExpertsPostsUpdateRq")
    public static class Update extends CommitteeOfExpertsPostDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CommitteeOfExpertsPostsDeleteRq")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CommitteeOfExpertsPostsIdListRq")
    public static class CommitteeIdList {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("CommitteeOfExpertsPostsSpecRs")
    public static class CommitteeSpecRs {
        private CommitteeOfExpertsPostDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<CommitteeOfExpertsPostDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}

