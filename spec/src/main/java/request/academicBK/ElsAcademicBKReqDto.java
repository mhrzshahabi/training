package request.academicBK;

import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;

import javax.validation.constraints.NotEmpty;

@Getter
@Setter
public class ElsAcademicBKReqDto {
    private Long id;
    @NotEmpty
    @ApiModelProperty(required = true)
    private Long educationLevelId;
    @NotEmpty
    @ApiModelProperty(required = true)
    private Long educationMajorId;
    private Long educationOrientationId;
    private String collageName;
    private String date;
    private String teacherNationalCode;
}
