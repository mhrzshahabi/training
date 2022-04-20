package response.teachingHistory;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;
import response.BaseResponse;
import response.academicBK.ElsEducationLevelDto;

import javax.validation.constraints.NotEmpty;
import java.util.List;

@Setter
@Getter
@Accessors(chain = true)
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

    @Setter
    @Getter
    @Accessors(chain = true)
    @ApiModel("ElsTeachingHistoryFindAllRespDto.TeachingHistoryResume")
    public static class TeachingHistoryResume {
        private String courseTitle;
        private String companyName;
        private String durationInHour;
        private String stdLevel;
        private String eduLevel;
        private String from;
        private String to;
    }

}
