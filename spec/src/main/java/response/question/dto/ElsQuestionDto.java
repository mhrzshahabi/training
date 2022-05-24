package response.question.dto;

import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;


import java.io.Serializable;
import java.util.List;

@Getter
@Setter
public class ElsQuestionDto extends BaseResponse implements Serializable {
    @ApiModelProperty
    private Long questionId;
    @ApiModelProperty(required = true)
    private String title;
    @ApiModelProperty(required = false)
    private String description;
    @ApiModelProperty(required = true)
    private String type;
    @ApiModelProperty
    private String questionLevel;
    @ApiModelProperty
    private Long categoryId;
    @ApiModelProperty
    private String categoryName;
    @ApiModelProperty
    private Long subCategory;
    @ApiModelProperty
    private String subCategoryName;
    @ApiModelProperty
    private List<ElsQuestionOptionDto> optionList;
    @ApiModelProperty
    private Integer correctOption;
    @ApiModelProperty
    private String correctAnswer;
    @ApiModelProperty
    private Boolean hasAttachment;
    @ApiModelProperty
    private List<ElsAttachmentDto> files;
    @ApiModelProperty
    private Integer answerTime;
    @ApiModelProperty
    private List<Integer> questionTargetIds;
    @ApiModelProperty
    private List<Long> readingQuestionsIds;
    @ApiModelProperty
    private String questionCode;
    @ApiModelProperty
    private String displayType;
    @ApiModelProperty
    private String  teacherFullName;
    @ApiModelProperty
    private String  courseName;
    @ApiModelProperty
    private String  className;
    @ApiModelProperty
    private String classCode;
    @ApiModelProperty
    private String startDate;
    @ApiModelProperty
    private String finishDate;
    @ApiModelProperty
    private String createdBy;
    @ApiModelProperty
    private String createdDate;
    @ApiModelProperty
    private Double proposedPointValue;
}
