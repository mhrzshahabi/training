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
public class CommitteeOfExpertsUsersDTO implements Serializable {


    private Long id;

    private String type;
    private String nationalCode;
    private String personnelNo;
    private String personnelNo2;
    private String firstName;
    private String lastName;
    private String phone;
    private String postTitle;
    private String role;
    private String position;


    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CommitteeOfExpertsUsersInfo")
    public static class Info extends CommitteeOfExpertsUsersDTO {
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
    @ApiModel("CommitteeOfExpertsUsersCreateRq")
    public static class Create extends CommitteeOfExpertsUsersDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CommitteeOfExpertsUsersUpdateRq")
    public static class Update extends CommitteeOfExpertsUsersDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CommitteeOfExpertsUsersDeleteRq")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CommitteeOfExpertsUsersIdListRq")
    public static class CommitteeIdList {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("CommitteeOfExpertsUsersSpecRs")
    public static class CommitteeSpecRs {
        private CommitteeOfExpertsUsersDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<CommitteeOfExpertsUsersDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}

