package com.nicico.training.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.nicico.training.model.enums.EQuestionLevel;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;
import response.question.dto.GroupQuestionDto;

import java.util.Date;
import java.util.List;
import java.util.Set;

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
    private Double proposedPointValue;
    private Double proposedTimeValue;
    private Integer lines;
    private List<Integer> questionTargets;
    private Long enabled;
    private String reference;
    private Long classificationId;

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
        private Date createdDate;
        private String createdBy;
        private String questionDesigner;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("QuestionBank-CreateRq")
    public static class FullInfo extends QuestionBankDTO {
        private Long id;
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
        private Boolean isChild;
        private String childPriority;
        private Integer questionLevelId;
        private String questionDesigner;
        private Set<GroupQuestionDto> groupQuestions;
        private Set<Long> groupQuestionIds;
//        private SubcategoryDTO.SubCategoryInfoTuple subCategory;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("QuestionBank-PreViewInfo")
    public static class PreViewInfo {
        private Long id;
        private String question;
        private String questionTypeTitle;
        private String option1;
        private String option2;
        private String option3;
        private String option4;
        private Boolean hasAttachment;
        private String childPriority;
        private List<QuestionBankDTO.PreViewInfo> groupQuestions;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("Exam")
    public static class Exam {
        private Long id;
//        private Boolean isChild;
        private String option1;
        private String option2;
        private String option3;
        private String option4;
        private String question;
        private Integer lines;
        private ParameterValueDTO.TupleInfo questionType;
        private ParameterValueDTO.TupleInfo displayType;
        private List<QuestionBankDTO.Exam> childs;
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
        private Set<GroupQuestionDto> groupQuestions;
        private Set<Long> groupQuestionIds;

    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("QuestionBank-UpdateRq")
    public static class Update extends FullInfo {
        private Set<GroupQuestionDto> groupQuestions;
        private Set<Long> groupQuestionIds;
    }

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("QuestionBank-DeleteRq")
    public static class Delete {
    }
    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("priorityData")
    public static class priorityData {
        private Long id;
        private String childPriority;
//        private  List<Object> objects;

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
    @ApiModel("QuestionBank-SpecRs")
    public static class QuestionBankSpecRsFullInfo {
        private SpecRsFullInfo response;
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
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class SpecRsFullInfo {
        private List<QuestionBankDTO.FullInfo> data;
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
    @Getter
    @Setter
    @Accessors
    public static class IdClass {
        private Long id;
    }
}
