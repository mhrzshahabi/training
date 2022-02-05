package com.nicico.training.dto;

import com.nicico.training.dto.enums.EPublicationSubjectTypeDTO;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import java.util.List;
import java.util.stream.Collectors;

@Getter
@Setter
@Accessors(chain = true)
public class PublicationDTO {
    @NotEmpty
    @ApiModelProperty(required = true)
    private String subjectTitle;
    private String publicationDate;
    private String publicationLocation;
    private String publisher;
    private Long teacherId;
    private Integer publicationSubjectTypeId;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Publication - Info")
    public static class Info extends PublicationDTO {
        private Long id;
        private Integer version;
        private List<CategoryDTO.CategoryInfoTuple> categories;
        private List<SubcategoryDTO.SubCategoryInfoTuple> subCategories;
        private EPublicationSubjectTypeDTO.EPublicationSubjectTypeInfoTuple publicationSubjectType;

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
    @ApiModel("Publication - Create")
    public static class Create extends PublicationDTO {
        private Long id;
        private List<CategoryDTO.Info> categories;
        private List<SubcategoryDTO.Info> subCategories;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Publication - Update")
    public static class Update extends PublicationDTO {
        private Long id;
        private List<CategoryDTO.Info> categories;
        private List<SubcategoryDTO.Info> subCategories;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Publication - Delete")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }
}
