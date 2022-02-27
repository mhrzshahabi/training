package response.employmentHistory;

import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;
import response.question.dto.ElsCategoryDto;
import response.question.dto.ElsSubCategoryDto;

import javax.validation.constraints.NotEmpty;
import java.util.List;

@Setter
@Getter
public class ElsEmploymentHistoryRespDto extends BaseResponse {
    private Long id;
    @NotEmpty
    @ApiModelProperty(required = true)
    private String jobTitle;
    private String companyName;
    private Long collaborationTypeId;
    private ElsCollaborationTypeDto collaborationType;
    private Integer collaborationDuration;
    @NotEmpty
    @ApiModelProperty(required = true)
    private List<Long> categoryIds;
    private List<ElsCategoryDto> categories;
    @NotEmpty
    @ApiModelProperty(required = true)
    private List<Long> subCategoryIds;
    private List<ElsSubCategoryDto> subCategories;
}
