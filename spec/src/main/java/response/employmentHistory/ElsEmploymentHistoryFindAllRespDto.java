package response.employmentHistory;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;
import response.BaseResponse;

import javax.validation.constraints.NotEmpty;
import java.util.List;

@Setter
@Getter
@Accessors(chain = true)
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

    @Getter
    @Setter
    @Accessors(chain = true)
    @ApiModel("ElsEmploymentHistoryFindAllRespDto.Resume")
    public static class Resume {
        private String jobTitle;
        private String companyName;
        private String collaborationType;
        private String collaborationDurationInMonth;
        private String collaborationDurationInYear;
    }
}
