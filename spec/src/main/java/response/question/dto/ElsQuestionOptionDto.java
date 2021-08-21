package response.question.dto;

import io.swagger.annotations.ApiModelProperty;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
public class ElsQuestionOptionDto {

    @ApiModelProperty(required = true, hidden = false)
    private String title;
    private Integer optionNumber;
    private Boolean hasAttachment;

}
