package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Getter
@Setter
@Accessors(chain = true)

public class TeacherDTO {

    @NotEmpty
    @ApiModelProperty(required = true)
    private String teacherCode;
    private String personnelCode;
    private Boolean enableStatus;
    private Boolean inBlackList;
    private Boolean personnelStatus;
    private String economicalCode;
    private String economicalRecordNumber;
    private String otherActivities;
    private Long personalityId;
    private Long majorCategoryId;
    private Long majorSubCategoryId;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TeacherInfo")
    public static class Info extends TeacherDTO {
        private Long id;
        private Set<CategoryDTO.CategoryInfoTuple> categories;
        private Set<SubcategoryDTO.SubCategoryInfoTuple> subCategories;
        private PersonalInfoDTO.Info personality;
        private CategoryDTO.CategoryInfoTuple majorCategory;
        private SubcategoryDTO.SubCategoryInfoTuple majorSubCategory;
        private Integer version;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TeacherGrid")
    public static class Grid{
        private Long id;
        @NotEmpty
        @ApiModelProperty(required = true)
        private String teacherCode;
        private PersonalInfoDTO.Grid personality;
        private Boolean enableStatus;
        private Set<CategoryDTO.Info> categories;
        private Set<SubcategoryDTO.Info> subCategories;
        private Integer version;

        public List<Long> getCategories() {
            if (categories == null)
                return null;
            return categories.stream().map(CategoryDTO.Info::getId).collect(Collectors.toList());
        }

        public List<Long> getSubCategories() {
            if (subCategories == null)
                return null;
            return subCategories.stream().map(SubcategoryDTO.Info::getId).collect(Collectors.toList());
        }

    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TeacherReport")
    public static class Report{
        private Long id;
        private String teacherCode;
        private String personnelCode;
        private PersonalInfoDTO.Report personality;
        private Boolean personnelStatus;
        Set<TeachingHistoryDTO.Info> teachingHistories;
        private String numberOfCourses;
        private String evaluationGrade;
        private String lastCourse;
        private Long lastCourseId;
        private String lastCourseEvaluationGrade;
        private Integer version;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("TeacherSpecRsGrid")
    public static class TeacherSpecRsGrid {
        private SpecRsGrid response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("TeacherSpecRsReport")
    public static class TeacherSpecRsReport {
        private SpecRsReport response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRsReport {
        private List<Report> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }


    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRsGrid {
        private List<Grid> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TeacherCreateRq")
    public static class Create extends TeacherDTO {
        private PersonalInfoDTO.CreateOrUpdate personality;
        private List<CategoryDTO.Info> categories;
        private List<SubcategoryDTO.Info> subCategories;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TeacherUpdateRq")
    public static class Update extends TeacherDTO {
        private PersonalInfoDTO.CreateOrUpdate personality;
        private List<CategoryDTO.Info> categories;
        private List<SubcategoryDTO.Info> subCategories;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("TeacherDeleteRq")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("TeacherSpecRs")
    public static class TeacherSpecRs {
        private SpecRs response;
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
    @ApiModel("TeacherFullNameTuple")
    public static class TeacherFullNameTuple {
        private Long id;
        private PersonalInfoDTO personality;

        public String getFullNameFa() {
            return String.format("%s %s", personality.getFirstNameFa(), personality.getLastNameFa());
        }
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class FullNameSpecRs {
        private List<TeacherFullNameTuple> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("TeacherFullNameSpecRs")
    public static class TeacherFullNameSpecRs {
        private FullNameSpecRs response;
    }
}