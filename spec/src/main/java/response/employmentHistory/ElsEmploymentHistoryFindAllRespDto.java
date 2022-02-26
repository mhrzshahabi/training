package response.employmentHistory;

import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import response.BaseResponse;

import javax.validation.constraints.NotEmpty;
import java.util.List;

@Setter
@Getter
public class ElsEmploymentHistoryFindAllRespDto extends BaseResponse {
    private Long id;
    @NotEmpty
    @ApiModelProperty(required = true)
    private String jobTitle;
    private String companyName;
    private String collaborationType;
    private Integer collaborationDuration;
    @NotEmpty
    @ApiModelProperty(required = true)
    private List<String> categories;
    @NotEmpty
    @ApiModelProperty(required = true)
    private List<String> subCategories;
}
