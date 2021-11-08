package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.enums.EQuestionLevel;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class QuestionBankDTO {

    private String code;
    @ApiModelProperty(required = true)
    private String question;
    @ApiModelProperty(required = true)
    private Long questionTypeId;
    private Long displayTypeId;
    private Long categoryId;
    private Long subCategoryId;
    private Long teacherId;
    private Long courseId;
    private Long tclassId;
    private Integer lines;
    private List<Integer> questionTargets;


    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("QuestionBank-Info")
    public static class Info extends QuestionBankDTO {

        private Long id;
        private ParameterValueDTO.TupleInfo questionType;
        private ParameterValueDTO.TupleInfo displayType;
        private CategoryDTO.CategoryInfoTuple category;
        private SubcategoryDTO.SubCategoryInfoTuple subCategory;
        private TclassDTO.InfoForQB tclass;
        private CourseDTO.InfoTuple course;
        private TeacherDTO.TeacherInfoTuple teacher;
        private EQuestionLevel eQuestionLevel;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("QuestionBank-CreateRq")
    public static class FullInfo extends QuestionBankDTO {

        private String option1;
        private String option2;
        private String option3;
        private String option4;
        private String descriptiveAnswer;
        private Integer multipleChoiceAnswer;
        private Long courseId;
        private Long tclassId;
        private Long teacherId;
        private Boolean hasAttachment;
        private Integer questionLevelId;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Exam")
    public static class Exam {

        private String option1;
        private String option2;
        private String option3;
        private String option4;
        private String question;
        private Integer lines;
        private ParameterValueDTO.TupleInfo questionType;
        private ParameterValueDTO.TupleInfo displayType;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Exam")
    public static class ElsExam {

        private String option1;
        private String option2;
        private String option3;
        private String option4;
        private String question;
        private String answer;
        private String examinerAnswer;
        private Integer lines;
        private ParameterValueDTO.TupleInfo questionType;
        private ParameterValueDTO.TupleInfo displayType;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("FinalTestQuestionBankInfo")
    public static class FinalTestInfo extends QuestionBankDTO {

        private Long id;
        private ParameterValueDTO.TupleInfo questionType;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("QuestionBank-CreateRq")
    public static class Create extends FullInfo {
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("QuestionBank-UpdateRq")
    public static class Update extends FullInfo {

    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("QuestionBank-DeleteRq")
    public static class Delete {
        /*@NotNull
        @ApiModelProperty(required = true)
        private List<Long> ids;*/
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    @ApiModel("QuestionBank-SpecRs")
    public static class QuestionBankSpecRs {
        private SpecRs response;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRs {
        private List<QuestionBankDTO.Info> data;
        private Integer status;
        private Integer startRow;
        private Integer endRow;
        private Integer totalRows;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    public static class getLastId extends QuestionBankDTO {

    }

}
