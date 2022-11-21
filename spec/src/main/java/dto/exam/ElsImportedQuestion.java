package dto.exam;

import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

import java.util.List;

@Getter
@Setter
@Accessors(chain = true)
public class ElsImportedQuestion {
    @ApiModelProperty
    private Long id;
    @ApiModelProperty(required = true)
    private String title;
    @ApiModelProperty
    private List<ElsImportedQuestionOption> questionOptionDTOS;
    @ApiModelProperty
    private EQuestionType type;
}
