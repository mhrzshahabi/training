package response.teachingHistory;

import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;

import javax.validation.constraints.NotEmpty;
import java.util.List;

@Setter
@Getter
public class ElsTeachingHistoryRespDto extends BaseResponse {
    private Long id;
    @NotEmpty
    @ApiModelProperty(required = true)
    private String courseTitle;
    private String companyName;
    private Integer duration;
    @NotEmpty
    @ApiModelProperty(required = true)
    private Long educationLevelId;
    private Long studentsLevelId;
    @NotEmpty
    @ApiModelProperty(required = true)
    private List<Long> categoryIds;
    @NotEmpty
    @ApiModelProperty(required = true)
    private List<Long> subCategoryIds;
}
