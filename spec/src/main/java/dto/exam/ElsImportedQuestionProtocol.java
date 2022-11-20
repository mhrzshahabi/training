package dto.exam;

import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
public class ElsImportedQuestionProtocol {
    @ApiModelProperty
    private Long id;
    @ApiModelProperty
    private Double mark;
    @ApiModelProperty
    private Double proposedPointValue;
    @ApiModelProperty
    private Double proposedTimeValue;
    @ApiModelProperty
    private Integer time;
    @ApiModelProperty(required = true)
    private String correctAnswerTitle;
    @ApiModelProperty
    private ElsImportedQuestion question;
    @ApiModelProperty
    private Boolean hasParent;
    @ApiModelProperty
    private ElsImportedQuestion parent;
    @ApiModelProperty
    private Boolean isChild;
    @ApiModelProperty
    private String childPriority;
    @ApiModelProperty
    private Long questionId;
    @ApiModelProperty
    private Long examId;
    @ApiModelProperty
    private String questionTitle;
    @ApiModelProperty
    private String questionType;
}
