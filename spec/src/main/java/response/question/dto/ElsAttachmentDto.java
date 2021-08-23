package response.question.dto;

import io.swagger.annotations.ApiModelProperty;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class ElsAttachmentDto {

    @ApiModelProperty
    private String attachment;
    @ApiModelProperty
    private String groupId;
    @ApiModelProperty
    private String fileName;

}
