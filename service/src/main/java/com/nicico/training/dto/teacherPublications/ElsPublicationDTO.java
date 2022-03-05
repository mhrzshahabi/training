package com.nicico.training.dto.teacherPublications;

import com.nicico.training.dto.CategoryDTO;
import com.nicico.training.dto.SubcategoryDTO;
import com.nicico.training.dto.enums.EPublicationSubjectTypeDTO;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;
import response.BaseResponse;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import java.util.List;
import java.util.stream.Collectors;

@Getter
@Setter
@Accessors(chain = true)
public class ElsPublicationDTO {
    @NotEmpty
    @ApiModelProperty(required = true)
    private String subjectTitle;
    private Long publicationDate;
    private String publicationLocation;
    private String publisher;
    private Integer publicationSubjectTypeId;
    private String publicationNumber;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ElsPublicationDTO.Info")
    public static class Info extends ElsPublicationDTO {
        private Long id;
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
    @ApiModel("ElsPublicationDTO.UpdatedInfo")
    public static class UpdatedInfo extends BaseResponse {
        private Long id;
        @NotEmpty
        @ApiModelProperty(required = true)
        private String subjectTitle;
        private Long publicationDate;
        private String publicationLocation;
        private String publisher;
        private Integer publicationSubjectTypeId;
        private String publicationNumber;
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
    @ApiModel("ElsPublicationDTO.Create")
    public static class Create extends ElsPublicationDTO {
        @ApiModelProperty(required = true)
        private String nationalCode;
        private Long teacherId;
        private List<Long> categoryIds;
        private List<Long> subCategoryIds;

    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ElsPublicationDTO.Create2")
    public static class Create2 extends ElsPublicationDTO {
        private String nationalCode;
        private Long teacherId;
        private List<CategoryDTO.Info> categories;
        private List<SubcategoryDTO.Info> subCategories;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ElsPublicationDTO.Update")
    public static class Update extends ElsPublicationDTO {
        @ApiModelProperty(required = true)
        private Long id;
        private List<Long> categoryIds;
        private List<Long> subCategoryIds;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ElsPublicationDTO.Update2")
    public static class Update2 extends ElsPublicationDTO {
        @ApiModelProperty(required = true)
        private Long id;
        private List<CategoryDTO.Info> categories;
        private List<SubcategoryDTO.Info> subCategories;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ElsPublicationDTO.Delete")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private Long id;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ElsPublicationDTO.DeleteGroup")
    public static class DeleteGroup {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }
}
