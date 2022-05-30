package dto.exam;

import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
public class ImportedQuestionProtocol {
    @ApiModelProperty
    private Long id;
    @ApiModelProperty
    private Double mark;
    @ApiModelProperty
    private Double proposedPointValue;
    @ApiModelProperty
    private Integer time;
    @ApiModelProperty(required = true)
    private String correctAnswerTitle;
    @ApiModelProperty
    private ImportedQuestion question;
    @ApiModelProperty
    private Boolean hasParent;
    @ApiModelProperty
    private ImportedQuestion parent;
}
