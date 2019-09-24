package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.enums.ELevelType;
import com.nicico.training.model.enums.ERunType;
import com.nicico.training.model.enums.ETechnicalType;
import com.nicico.training.model.enums.ETheoType;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.util.Date;
import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
@JsonInclude(JsonInclude.Include.NON_NULL)
@JsonIgnoreProperties(ignoreUnknown = true)
public class CourseDTO implements Serializable {

    @ApiModelProperty(required = true)
    private String code;

    @NotEmpty
    @ApiModelProperty(required = true)
    private String titleFa;

    @ApiModelProperty(required = true)
    private String titleEn;

    @NotNull
    @ApiModelProperty(required = true)
    private Long theoryDuration;

    //    @NotNull
//    @ApiModelProperty(required = true)
//    private Long practicalDuration;

    @ApiModelProperty(required = true)
    private Float minTeacherEvalScore;

    @ApiModelProperty(required = true)
    private Long minTeacherExpYears;

    @NotNull
    @ApiModelProperty(required = true)
    private String minTeacherDegree;

    @ApiModelProperty(required = true)
    private String description;

    @ApiModelProperty(required = true)
    private String mainObjective;

    @ApiModelProperty(required = true)
    private String mainDescription;


//    @ApiModelProperty(required = true)
//    private List<Long> preCourse;



//    @ApiModelProperty(required = true)
//    private List<GoalDTO> goalSet;


    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CourseInfo")
    public static class Info extends CourseDTO {
        private Long id;
        private Date createdDate;
        private String createdBy;
        private Date lastModifiedDate;
        private String lastModifiedBy;
//        private Integer version;
        private ERunType eRunType;
        private ELevelType eLevelType;
        private ETechnicalType eTechnicalType;
        private ETheoType eTheoType;
        private CategoryDTO.CategoryInfoTuple category;
        private SubCategoryDTO.SubCategoryInfoTuple subCategory;
        private Long knowledge;
        private Long skill;
        private Long attitude;
    }

    //-------------------------------
    @Getter
    @Setter
    @ApiModel("CourseInfoTuple")
    public static class CourseInfoTuple {
        private String code;
        private String titleFa;
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CourseCreateRq")
    public static class Create extends CourseDTO {
        @NotNull
        @ApiModelProperty(required = true)
        private Integer eRunTypeId;

        @NotNull
        @ApiModelProperty(required = true)
        private Integer eLevelTypeId;

        @NotNull
        @ApiModelProperty(required = true)
        private Integer eTheoTypeId;

        @NotNull
        @ApiModelProperty(required = true)
        private Integer eTechnicalTypeId;

        @ApiModelProperty(required = true)
        private Long categoryId;

        @ApiModelProperty(required = true)
        private Long subCategoryId;

        @ApiModelProperty(required = true)
        private List<Long> preCourseListId;

        @ApiModelProperty(required = true)
        private List<String> equalCourseListId;
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CourseUpdateRq")
    public static class Update extends CourseDTO {
        @NotNull
        @ApiModelProperty(required = true)
        private Integer eRunTypeId;

        @NotNull
        @ApiModelProperty(required = true)
        private Integer eLevelTypeId;

        @NotNull
        @ApiModelProperty(required = true)
        private Integer eTheoTypeId;

        @NotNull
        @ApiModelProperty(required = true)
        private Integer eTechnicalTypeId;

//        @NotNull
//        @ApiModelProperty(required = true)
//        private Integer version;

        @ApiModelProperty(required = true)
        private Long categoryId;

        @ApiModelProperty(required = true)
        private Long subCategoryId;

        @ApiModelProperty(required = true)
        private List<Long> preCourseListId;

        @ApiModelProperty(required = true)
        private List<String> equalCourseListId;
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CourseDeleteRq")
    public static class Delete {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CourseIdListRq")
    public static class CourseIdList {
        @NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;
    }

    // ------------------------------


    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("CourseSpecRs")
    public static class CourseSpecRs {
        private CourseDTO.SpecRs response;
    }

    // ---------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<CourseDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CourseGoalsSyllabus")
    public static class GoalsWithSyllabus extends CourseDTO {
        private ETechnicalType eTechnicalType;
        private List<GoalDTO.Syllabuses> goalSet;
    }
}
