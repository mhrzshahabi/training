package dto.exam;

import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;
import response.question.dto.ElsAttachmentDto;
import response.question.dto.ElsAttachmentDto2;

import java.util.List;
import java.util.Map;

@Getter
@Setter
@Accessors(chain = true)
public class ElsImportedQuestionOption {
    @ApiModelProperty(hidden = true)
    private Long id;
    @ApiModelProperty(required = true)
    private String title;
    @ApiModelProperty
    private String label;
    @ApiModelProperty
    private boolean checked;
    @ApiModelProperty
    private List<ElsAttachmentDto2> attachments;
}
