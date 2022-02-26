package request.teachingHistory;

import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;

import javax.validation.constraints.NotEmpty;
import java.util.List;

@Setter
@Getter
public class ElsTeachingHistoryReqDto {
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
    private String teacherNationalCode;
    @NotEmpty
    @ApiModelProperty(required = true)
    private List<Long> categoryIds;
    @NotEmpty
    @ApiModelProperty(required = true)
    private List<Long> subCategoryIds;
}
