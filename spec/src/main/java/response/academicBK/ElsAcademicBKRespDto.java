package response.academicBK;

import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;

import javax.validation.constraints.NotEmpty;

@Getter
@Setter
public class ElsAcademicBKRespDto extends BaseResponse {
    private Long id;
    @NotEmpty
    @ApiModelProperty(required = true)
    private Long educationLevelId;
    @NotEmpty
    @ApiModelProperty(required = true)
    private Long educationMajorId;
    private Long educationOrientationId;
    private Long universityId;
    private Long date;
}