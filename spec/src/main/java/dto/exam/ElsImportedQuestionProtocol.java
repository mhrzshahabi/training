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
    @ApiModelProperty
    private ElsImportedQuestion question;
}
