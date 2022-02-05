package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotNull;
import java.util.List;
import java.util.stream.Collectors;

@Getter
@Setter
@Accessors(chain = true)
public class EmploymentHistoryDTO {
    private String companyName;
    private String jobTitle;
    private String startDate;
    private String endDate;
    private Long teacherId;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("EmploymentHistory - Info")
    public static class Info extends EmploymentHistoryDTO {
        private Long id;
        private Integer version;
        private List<CategoryDTO.CategoryInfoTuple> categories;
        private List<SubcategoryDTO.SubCategoryInfoTuple> subCategories;

        public List<Long> getCategoriesIds() {
            if (categories == null)
                return null;
            return categories.stream().map(CategoryDTO.CategoryInfoTuple::getId).collect(Collectors.toList());
        }

        public List<Long> getSubCategoriesIds() {
            if (subCategories == null)
                return null;
            return subCategories.stream().map(SubcategoryDTO.SubCategoryInfoTuple::getId).collect(Collectors.toList());
        }
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("EmploymentHistory - Create")
    public static class Create extends EmploymentHistoryDTO {
        private Long id;
        private List<CategoryDTO.Info> categories;
        private List<SubcategoryDTO.Info> subCategories;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("EmploymentHistory - Update")
    public static class Update extends EmploymentHistoryDTO {
        private Long id;
        private List<CategoryDTO.Info> categories;
        private List<SubcategoryDTO.Info> subCategories;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("EmploymentHistory - Delete")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

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

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("EmploymentHistorySpecRs")
    public static class EmploymentHistorySpecRs {
        private SpecRs response;
    }
}
