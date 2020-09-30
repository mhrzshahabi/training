package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.Goal;
import com.nicico.training.model.enums.ELevelType;
import com.nicico.training.model.enums.ERunType;
import com.nicico.training.model.enums.ETechnicalType;
import com.nicico.training.model.enums.ETheoType;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.AllArgsConstructor;
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

public class CourseDTO implements Serializable {

    @NotEmpty
    @ApiModelProperty(required = true)
    private String code;

    @NotEmpty
    @ApiModelProperty(required = true)
    private String titleFa;

    @ApiModelProperty(required = true)
    private String titleEn;

    @NotNull
    @ApiModelProperty(required = true)
    private Float theoryDuration;

    @NotEmpty
    @ApiModelProperty(required = true)
    private Float minTeacherEvalScore;

    @NotEmpty
    @ApiModelProperty(required = true)
    private Long minTeacherExpYears;

    @NotNull
    @ApiModelProperty(required = true)
    private String minTeacherDegree;

    private String description;

    @ApiModelProperty
    private String needText;

    @ApiModelProperty(required = true)
    private String workflowStatus;

    @ApiModelProperty(required = true)
    private String workflowStatusCode;

    private String evaluation;

    private String behavioralLevel;

    @NotEmpty
    private String scoringMethod;

    private String acceptancelimit;

    private Integer startEvaluation;

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CourseTupleInfo")
    public static class TupleInfo {
        private Long id;
        @NotEmpty
        @ApiModelProperty(required = true)
        private String code;

        @NotEmpty
        @ApiModelProperty(required = true)
        private String titleFa;
    }

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
        private ERunType eRunType;
        private ELevelType eLevelType;
        private ETechnicalType eTechnicalType;
        private ETheoType eTheoType;
        private Long categoryId;
        private Long subCategoryId;
        private SubcategoryDTO.SubCategoryInfoTuple subCategory;
        private CategoryDTO.CategoryInfoTuple category;
        private Boolean hasGoal;
        private Boolean hasSkill;

    }    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CourseInfoPrint")
    public static class InfoPrint extends CourseDTO {
        private Long id;
        private Date createdDate;
        private String createdBy;
        private Date lastModifiedDate;
        private String lastModifiedBy;
        private ERunType eRunType;
        private ELevelType eLevelType;
        private ETechnicalType eTechnicalType;
        private ETheoType eTheoType;
        private CategoryDTO.CategoryInfoTuple category;
        private SubcategoryDTO.SubCategoryInfoTuple subCategory;
        private Boolean hasGoal;
        private Boolean hasSkill;
    }

    //-------------------------------
    @Getter
    @Setter
    @ApiModel("CourseInfoTuple")
    public static class CourseInfoTuple {
        private Long id;
        private String code;
        private String titleFa;
        private String evaluation;
        private ERunType eRunType;
        private CategoryDTO.CategoryInfoTuple category;
        private SubcategoryDTO.SubCategoryInfoTuple subCategory;
    }

    @Getter
    @Setter
    @ApiModel("CourseWeeklySchedule")
    public static class CourseWeeklySchedule {
        private Long id;
        private String code;
        private String titleFa;
        private String evaluation;
        private Float theoryDuration;
        private Long categoryId;
        private Long subCategoryId;
    }

    @Getter
    @Setter
    @ApiModel("CourseClassReport")
    public static class CourseClassReport {
        private Long id;
        private String code;
        private String titleFa;
        private Long categoryId;
        private Long subCategoryId;
    }

    @Getter
    @Setter
    @ApiModel("courseWithOutTeacher")
    @AllArgsConstructor
    public  static class courseWithOutTeacher{
        private Long id;
        private String code;
        private String title;
        private String max_start_date;
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CourseCreateRq")
    public static class Create extends CourseDTO {
        @NotEmpty
        @ApiModelProperty(required = true)
        private int runTypeId;

        @NotEmpty
        @ApiModelProperty(required = true)
        private int levelTypeId;

        @NotEmpty
        @ApiModelProperty(required = true)
        private int theoTypeId;

        @NotEmpty
        @ApiModelProperty(required = true)
        private int technicalTypeId;

        @NotEmpty
        @ApiModelProperty(required = true)
        private CategoryDTO.Info category;

        @NotEmpty
        @ApiModelProperty(required = true)
        private SubcategoryDTO.Info subCategory;

        @NotEmpty
        private List<Long> mainObjectiveIds;
//
//        @ApiModelProperty(required = true)
//        private List<Long> preCourseListId;
//
//        @ApiModelProperty(required = true)
//        private List<String> equalCourseListId;
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CourseUpdateRq")
    public static class Update extends CourseDTO {
        @NotEmpty
        @ApiModelProperty(required = true)
        private Integer eRunTypeId;

        @NotEmpty
        @ApiModelProperty(required = true)
        private Integer eLevelTypeId;

        @NotEmpty
        @ApiModelProperty(required = true)
        private Integer eTheoTypeId;

        @NotEmpty
        @ApiModelProperty(required = true)
        private Integer eTechnicalTypeId;

        @NotEmpty
        @ApiModelProperty(required = true)
        private Long categoryId;

        @NotEmpty
        @ApiModelProperty(required = true)
        private Long subCategoryId;

//        @NotNull
//        @ApiModelProperty(required = true)
//        private Integer version;

        private String evaluation;

        private String behavioralLevel;

        @NotEmpty
        private List<Long> mainObjectiveIds;

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
    public static class SpecRs<T> {
        private List<T> data;
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

    // ------------------------------

    @Getter
    @Setter
    @ApiModel("CourseInfoTupleLite")
    public static class CourseInfoTupleLite {
        private Long id;
        private String code;
        private String titleFa;
    }

    @Getter
    @Setter
    @ApiModel("NeedsAssessmentReportInfo")
    public static class NeedsAssessmentReportInfo {
        private Long id;
        private String code;
        private String titleFa;
        private Float theoryDuration;
        private Long scoresState;
    }

    // ------------------------------

    @Getter
    @Setter
    @ApiModel("CourseGoals")
    public static class CourseGoals {
        private List<Goal> goalSet;
    }
    // ------------------------------

    @Getter
    @Setter
    @ApiModel("CourseInfoComboClass")
    public static class CourseInfoComboClass {
        private Long id;
        private String code;
        private String titleFa;
        private String createdBy;
        private Float theoryDuration;
        private Integer startEvaluation;
        private String scoringMethod;
        private String acceptancelimit;
        private CategoryDTO.CategoryInfoTuple category;
    }

    // ------------------------------

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CourseDetailInfo")
    public static class CourseDetailInfo extends CourseDTO {
        private Long id;
        private ERunType eRunType;
        private ELevelType eLevelType;
        private ETechnicalType eTechnicalType;
        private ETheoType eTheoType;
        private CategoryDTO.CategoryTitle category;
        private SubcategoryDTO.SubCategoryInfoTuple subCategory;
        private String mainObjective;
        private String goals;
        private String preCourses;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CreateOrDeletePreCourse")
    public static class AddOrRemovePreCourse {
        private Long courseId;
        private List<Long> preCoursesId;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CourseInfoTuple")
    public static class InfoTuple{
        private Long id;
        private String titleFa;
        private String code;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("CourseInfoTupleSpecRs")
    public static class CourseInfoTupleSpecRs {
        private CourseDTO.InfoTupleSpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class InfoTupleSpecRs<T> {
        private List<T> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }

    //Amin HK
    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("CourseDependence")
    public static class CourseDependence{
        private int numClasses;
        private int numSkills;
        private int numGoals;
    }
}
