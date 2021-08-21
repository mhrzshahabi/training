package response.question.dto;

import dto.exam.EQuestionType;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;


import java.util.List;

@Getter
@Setter
public class ElsQuestionDto {

    @ApiModelProperty(required = true)
    private String title;
    @ApiModelProperty(required = false)
    private String description;
    @ApiModelProperty(required = true)
    private EQuestionType type;
    @ApiModelProperty
    private ElsQuestionLevel questionLevel;
    @ApiModelProperty
    private Long categoryId;
    @ApiModelProperty
    private  Long subCategory;
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
