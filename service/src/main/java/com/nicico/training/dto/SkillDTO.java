package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotNull;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class SkillDTO {
    @NotNull
    @ApiModelProperty(required = true)
    private String code;
    @NotNull
    @ApiModelProperty(required = true)
    private String titleFa;
    @ApiModelProperty()
    private String titleEn;
    @NotNull
    @ApiModelProperty(required = true)
    private Long skillLevelId;
    @NotNull
    @ApiModelProperty(required = true)
    private Long categoryId;
    @NotNull
    @ApiModelProperty(required = true)
    private Long subCategoryId;
    @ApiModelProperty()
    private String description;
    private Long courseId;
    private Long courseMainObjectiveId;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("SkillInfoTuple")
    public static class InfoTuple {
        private Long id;
        private String titleFa;
        private Long subCategoryId;
        private String code;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("SkillInfo")
    public static class Info extends SkillDTO {
        private Long id;
        private SkillLevelDTO.SkillLevelInfoTuple skillLevel;
        private CategoryDTO.CategoryInfoTuple category;
        private SubcategoryDTO.SubCategoryInfoTuple subCategory;
        private CourseDTO.CourseInfoTupleLite course;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("SkillInfo")
    public static class Info2 extends SkillDTO {
        private Long id;
        private String limitSufficiency;
        private SkillLevelDTO.SkillLevelInfoTupleV2 skillLevel;
        private CategoryDTO.CategoryInfoTuple category;
        private SubcategoryDTO.SubCategoryInfoTuple subCategory;
        private CourseDTO.CourseInfoTupleLite course;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("SkillInfoTupleENA")
    public static class InfoTupleENA extends SkillDTO {
        private Long id;
        private CourseDTO.CourseInfoTupleLite course;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("SkillInfoENA")
    public static class InfoENA extends SkillDTO {
        private Long id;
        private CourseDTO.Info course;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("NeedsAssessmentReportInfo")
    public static class NeedsAssessmentReportInfo {
        private Long id;
        private String code;
        private String titleFa;
        private CourseDTO.NeedsAssessmentReportInfo course;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("SkillCreateRq")
    public static class Create extends SkillDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("SkillUpdateRq")
    public static class Update extends SkillDTO {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("SkillDeleteRq")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("SkillSpecRs")
    public static class SkillSpecRs {
        private SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs<T> {
        private List<T> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }
}
