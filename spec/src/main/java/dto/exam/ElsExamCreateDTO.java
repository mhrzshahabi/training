package dto.exam;

import com.fasterxml.jackson.annotation.JsonInclude;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;

@Setter
@Getter
@Accessors(chain = true)
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ElsExamCreateDTO {
    @ApiModelProperty(required = true)
    private Long classId;
    @ApiModelProperty
    private Long courseId;
    @ApiModelProperty
    private String courseCode;
    @ApiModelProperty
    private String examCode;
    @ApiModelProperty
    private String name;
    @ApiModelProperty
    private Double finalScore;
    @ApiModelProperty
    private Double minimumAcceptScore;
    @ApiModelProperty
    private Long hDuration;
    @ApiModelProperty
    private String startDate;
    @ApiModelProperty
    private String endDate;

}
