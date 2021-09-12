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

}
