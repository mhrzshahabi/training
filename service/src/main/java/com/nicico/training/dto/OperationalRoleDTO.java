package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.persistence.Column;
import java.util.List;
import java.util.Set;

@Getter
@Setter
@Accessors(chain = true)
public class OperationalRoleDTO {
    private String code;
    private String title;
    private String description;
    private Long operationalUnitId;
    private Set<Long> userIds;
    private Set<Long> postIds;
    private Long complexId;
    private Long objectUserId;
    private String objectType;
    private String nationalCode;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("OperationalRole - Info")
    public static class Info extends OperationalRoleDTO {
        private Long id;
        private OperationalUnitDTO.Info operationalUnit;
        private Set<CategoryDTO.CategoryInfoTuple> categories;
        private Set<SubcategoryDTO.SubCategoryInfoTuple> subCategories;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("OperationalRole - Create")
    public static class Create extends OperationalRoleDTO {
        private List<Long> categories;
        private List<Long> subCategories;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("OperationalRole - Update")
    public static class Update extends OperationalRoleDTO {
        private Integer version;
        private List<Long> categories;
        private List<Long> subCategories;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("OperationalRoleSpecRs")
    public static class OperationalRoleSpecRs {
        private OperationalRoleDTO.SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<OperationalRoleDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
