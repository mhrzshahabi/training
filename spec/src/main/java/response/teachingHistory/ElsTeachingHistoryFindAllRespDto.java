package response.teachingHistory;

import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;
import response.academicBK.ElsEducationLevelDto;

import javax.validation.constraints.NotEmpty;
import java.util.List;

@Setter
@Getter
public class ElsTeachingHistoryFindAllRespDto extends BaseResponse {
    private Long id;
    @NotEmpty
    @ApiModelProperty(required = true)
    private String courseTitle;
    private String companyName;
    private Integer duration;
    @NotEmpty
    @ApiModelProperty(required = true)
    private Long educationLevelId;
    private ElsEducationLevelDto educationLevel;
    private Long studentsLevelId;
    private ElsStudentsLevelDto studentsLevel;
    @NotEmpty
    @ApiModelProperty(required = true)
    private List<String> categories;
    @NotEmpty
    @ApiModelProperty(required = true)
    private List<String> subCategories;
}