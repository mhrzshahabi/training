package com.nicico.training.dto;

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
public class TeachingHistoryDTO {
    private String courseTitle;
    private Long educationLevelId;
    private Long studentsLevelId;
    private Integer duration;
    private String startDate;
    private String endDate;
    private Long teacherId;
    private String companyName;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TeachingHistory - Info")
    public static class Info extends TeachingHistoryDTO {
        private Long id;
        private Integer version;
        private List<CategoryDTO.CategoryInfoTuple> categories;
        private List<SubcategoryDTO.SubCategoryInfoTuple> subCategories;
        private EducationLevelDTO.Info educationLevel;
        private ParameterValueDTO.TupleInfo studentsLevel;

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
    @ApiModel("TeachingHistory - Create")
    public static class Create extends TeachingHistoryDTO {
        private Long id;
        private List<CategoryDTO.Info> categories;
        private List<SubcategoryDTO.Info> subCategories;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TeachingHistory - Update")
    public static class Update extends TeachingHistoryDTO {
        private Long id;
        private List<CategoryDTO.Info> categories;
        private List<SubcategoryDTO.Info> subCategories;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TeachingHistory - Delete")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }
}
