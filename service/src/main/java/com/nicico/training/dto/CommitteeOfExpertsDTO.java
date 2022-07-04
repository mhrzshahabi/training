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
public class CommitteeOfExpertsDTO implements Serializable {

    private Long id;

    private List<String> complexes;

    private String title;

    private String address;

    private String phone;

    private String fax;

    private String email;

    private String createdBy;

    private String lastModifiedBy;

    private Date lastModifiedDate;

    private Date createdDate;


    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CommitteeOfExpertsInfo")
    public static class Info extends CommitteeOfExpertsDTO {
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
    @ApiModel("CommitteeCreateRq-Create")
    public static class Create extends CommitteeOfExpertsDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CommitteeOfExpertsUpdateRq")
    public static class Update extends CommitteeOfExpertsDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CommitteeOfExpertsDeleteRq")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CommitteeOfExpertsIdListRq")
    public static class CommitteeIdList {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("CommitteeOfExpertsSpecRs")
    public static class CommitteeSpecRs {
        private CommitteeOfExpertsDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<CommitteeOfExpertsDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CommitteeCreateRq-CreatePartOfPersons")
    public static class CreatePartOfPersons  {
        private String role;
        private String position;
        private String personnelType;
        private Long personnelId;
        private Long parentId;

    }
    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CommitteeCreateRq-CreatePartOfPosts")
    public static class CreatePartOfPosts  {
        private String postType;
        private Long postId;
        private String postCode;
        private Long parentId;

    }
}

