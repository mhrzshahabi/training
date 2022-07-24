package response.question.dto;

import io.swagger.annotations.ApiModelProperty;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class ElsQuestionOptionDto {
    private Long id;
    @ApiModelProperty(required = true, hidden = false)
    private String title;
    private Integer optionNumber;
    private Boolean hasAttachment;
    private List<ElsAttachmentDto> optionFiles;
}
