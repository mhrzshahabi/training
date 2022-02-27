package response.teachingHistory;

import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;
import response.academicBK.ElsEducationLevelDto;
import response.question.dto.ElsCategoryDto;
import response.question.dto.ElsSubCategoryDto;

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
    private ElsEducationLevelDto educationLevel;
    private Long studentsLevelId;
    private ElsStudentsLevelDto studentsLevel;
    @NotEmpty
    @ApiModelProperty(required = true)
    private List<Long> categoryIds;
    private List<ElsCategoryDto> categories;
    @NotEmpty
    @ApiModelProperty(required = true)
    private List<Long> subCategoryIds;
    private List<ElsSubCategoryDto> subCategories;
}
