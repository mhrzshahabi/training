package response.academicBK;

import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;

import javax.validation.constraints.NotEmpty;

@Getter
@Setter
public class ElsAcademicBKFindAllRespDto extends BaseResponse {
    private Long id;
    @NotEmpty
    @ApiModelProperty(required = true)
    private Long educationLevelId;
    private ElsEducationLevelDto educationLevel;
    @NotEmpty
    @ApiModelProperty(required = true)
    private Long educationMajorId;
    private ElsEducationMajorDto educationMajor;
    private Long educationOrientationId;
    private ElsEducationOrientationDto educationOrientation;
    private Long universityId;
    private ElsUniversityDto university;
    private String date;
    private String academicGrade;
    private String duration;
}
