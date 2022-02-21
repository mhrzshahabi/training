package request.employmentHistory;

import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;

import javax.validation.constraints.NotEmpty;
import java.util.List;

@Setter
@Getter
public class ElsEmploymentHistoryReqDto {
    private Long id;
    @NotEmpty
    @ApiModelProperty(required = true)
    private String jobTitle;
    private String companyName;
    private Long collaborationTypeId;
    private String teacherNationalCode;
    private Integer collaborationDurationYear;
    private Integer collaborationDurationMonth;
    @NotEmpty
    @ApiModelProperty(required = true)
    private List<Long> categoryIds;
    @NotEmpty
    @ApiModelProperty(required = true)
    private List<Long> subCategoryIds;
}
